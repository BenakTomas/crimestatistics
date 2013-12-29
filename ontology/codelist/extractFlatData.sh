#!/bin/sh
# get the current directory
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# set up the variables
solutionRootPath=$dir
outputFilePath="${solutionRootPath}"/data/"$1"_data.ttl
if [ $# -eq 1 ]; then
	extractionScriptName="extractCodelistConceptsGeneric"
else
	extractionScriptName="$2"
fi
# run extraction
sed  's/\$codeListName/'$1'/g' < "${solutionRootPath}"/templates/codeListHeader.ttl.template > "$outputFilePath"
echo "" >> "$outputFilePath"
echo "" >> "$outputFilePath"
"${solutionRootPath}"/scripts/extractionScripts/"${extractionScriptName}".awk --re-interval  -v codeListName="$1" < "${solutionRootPath}"/source/"$1".csv >> "$outputFilePath"