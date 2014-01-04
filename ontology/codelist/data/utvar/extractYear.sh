#! /bin/sh

# nacti si aktualni adresar
baseDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

# nacti vstupni parametry
year=$1;

# nastav promenne
dbName="${year}ku";
baseDirSqlPath="${baseDir}/sql";
yearPath="${baseDir}/${year}";
yearSqlPath="${yearPath}/sql";
extractOkresyFilePath="${baseDirSqlPath}/extractOkresy.sql";
extractRestFilePath="${baseDirSqlPath}/extractRest.sql";
writeResultsFilePath="${baseDirSqlPath}/writeResults.sql";
selectMissingUtvarySqlFilePath="${baseDirSqlPath}/selectMissingUtvary.sql";
okresyDirPath="${yearPath}/okresy";
okresyOutputFilePath="${okresyDirPath}/okresy_actual.csv" ;
okresyMissingFilePath="${baseDir}/okresy_missing.txt";
utvarExtractorFilePath="${baseDir}/utvarExtractor.exe";
utvaryPath="${yearPath}/utvary";
utvaryXLSSourcePath="${utvaryPath}/source/xls";
utvaryOutputFilePath="${utvaryPath}/utvary_actual.csv";
utvaryExtractionLogPath="${utvaryPath}/utvary_error_log.txt";
utvaryFinalOutputFilePath="${yearPath}/utvary.txt";
utvaryTTLOutputFilePath="${yearPath}/ttl";
utvaryDefinitionOutputFilePath="${utvaryTTLOutputFilePath}/utvary_definition.ttl";
utvaryHierarchyOutputFilePath="${utvaryTTLOutputFilePath}//utvary_hierarchy.ttl";
utvarYearDependentTemplatePath="${baseDir}/utvar_template.ttl";
utvaryMissingDataFilePath="${utvaryPath}/utvary_missingData.txt";
okresyMissingDataFilePath="${okresyDirPath}/okresy_missingData.txt";

# extrahuj okresy
echo "Extrahuji okresy...${okresyOutputFilePath}"
rm "${okresyOutputFilePath}" 2> /dev/null;
sed 's/$year/'"$year"'/gI' "${extractOkresyFilePath}" | mysql --user=tom --password=tom123 "${dbName}";
echo "...hotovo."

while true
do
	echo "Zahajuji extrakci utvaru..."
	# split files
	okresySplitFileMask="${okresyDirPath}/okresy_actual_split_";
	split -l 80 "${okresyOutputFilePath}" "${okresySplitFileMask}";

	# delete output files and log file
	rm "${utvaryOutputFilePath}" "${utvaryExtractionLogPath}"  2> /dev/null;
	
	# run extraction
	for okresy_splitFilePath in "${okresySplitFileMask}"*
	do
		"${utvarExtractorFilePath}" "${okresy_splitFilePath}" "${utvaryXLSSourcePath}" >> "${utvaryOutputFilePath}" 2> "${utvaryExtractionLogPath}";
	done
	
	echo "...hotovo."
	rm "${utvaryMissingDataFilePath}" "${okresyMissingDataFilePath}" 2> /dev/null;
	sed -nr '/^a[0-9]{4}__\.xls$/s/^a([0-9]{4})__\.xls$/\1/gIp' "${utvaryExtractionLogPath}" | xargs -I {} bash -c 'if ! grep -Fq {} "'"${okresyMissingFilePath}"'"; then echo {} >> "'"${utvaryMissingDataFilePath}"'"; fi';
	sed -nr '/nezn/s/^.*nezn[^0-9]*([0-9]{4})#.*$/\1/gIp' "${okresyOutputFilePath}" | xargs -I {} bash -c 'if ! grep -Fq {} "'"${okresyMissingFilePath}"'"; then echo {} >> "'"${okresyMissingDataFilePath}"'"; fi';
	pspad "${utvaryMissingDataFilePath}" "${okresyMissingDataFilePath}";
	echo "Extrahovat utvary znovu? (y/n)";
	read continueYesNo;
	
	if [ $continueYesNo == "n" ]
	then
		break;
	else
		echo "Yesno: '${continueYesNo}'";
	fi;
done;

# Nyni se pokracuje v extrakci utvaru v databazi
echo "Vytvarim utvary podle extrahovanych dat..."

# odstran aktualni soubory s vysledky
find "${yearPath}" -name *final.csv |
xargs -I finalFile rm finalFile 2> /dev/null;

rm "${utvaryFinalOutputFilePath}" 2> /dev/null;

# Pripoj se k DB a nechej data extrahovat.
sed 's/$year/'"$year"'/gI' "${extractRestFilePath}" | mysql --user=tom --password=tom123 "${dbName}";
echo "...hotovo."

# Pripoj se k DB a nechej si vypsat pripadne chybejici utvary.
echo "Zjistuji, jestli nektere utvary nechybeji...";
mysql --user=tom --password=tom123 "${dbName}" < "${selectMissingUtvarySqlFilePath}";
echo "...hotovo."

echo "Write down the results? (y/n)";
read doWriteResults;

if [ $doWriteResults == "y" ]
then
	# Vysledky zapis do souboru
	sed 's/$year/'"$year"'/gI' "${writeResultsFilePath}" | mysql --user=tom --password=tom123 "${dbName}";
	echo "Vysledky zapsany.";
else
	echo "Nektere utvary nebyly spravne extrahovany!";
	exit 1;
fi;

# Vysledky spoj do jedineho souboru
find "$yearPath" -name *final.csv -print0 |
xargs -0 -I file cat file >> "${utvaryFinalOutputFilePath}";

# Vytvor soubor s definicemi utvaru.
sed 's/year/'"$year"'/gI' "${utvarYearDependentTemplatePath}" > "${utvaryDefinitionOutputFilePath}";
echo "" >> "${utvaryDefinitionOutputFilePath}";
echo "" >> "${utvaryDefinitionOutputFilePath}"; 
"${baseDir}/createUtvary.awk" -v year="${year}" < "${utvaryFinalOutputFilePath}" >> "${utvaryDefinitionOutputFilePath}";

# Vytvor soubor s definici hierarchie utvaru.
sed 's/year/'"$year"'/gI' "${utvarYearDependentTemplatePath}" > "${utvaryHierarchyOutputFilePath}";
echo "" >> "${utvaryHierarchyOutputFilePath}";
echo "" >> "${utvaryHierarchyOutputFilePath}";
"${baseDir}/linkUtvary.awk" < "${utvaryFinalOutputFilePath}" >> "${utvaryHierarchyOutputFilePath}";

echo "Utvary byly uspesne extrahovany.";