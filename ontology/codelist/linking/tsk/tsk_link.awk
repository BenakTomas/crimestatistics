#!/bin/gawk -f
BEGIN {
	FS="#";
}
{
	tsk=$1;
	lawReferencesSection=$3;
	
	if(lawReferencesSection ~ /^[[:space:]]*$/) next;
	
	numberOfReferences=split(lawReferencesSection, lawReferences, ",");
	
	if(numberOfReferences == 0) next;

	printf "crimestatistics-code-codelist-hash:%s ", tsk;
	
	if(numberOfReferences == 1)
	{
		lawReference = lawReferences[1];
    sub(/^[[:space:]]*/, "", lawReference);
		sub(/[[:space:]]*$/, "", lawReference);
		printf "crimestatistics-property-zakony:kvalifikacePodleUsekuZakona <http://linked.opendata.cz/resource/legislation/cz/act/%s/section/%s> .\n", trestniZakon, lawReference;
	}
	else
	{
		lawReference=lawReferences[1];
		sub(/^[[:space:]]*/, "", lawReference);
		sub(/[[:space:]]*$/, "", lawReference);
		
		sourceOfLawCollectionMemberFormatString="crimestatistics-class-zakony-SourceOfLawSectionCollection-property:member <http://linked.opendata.cz/resource/legislation/cz/act/%s/section/%s>";
		printf "crimestatistics-property-zakony:kvalifikaceNekterymZUsekuZakonu [ \n";
		printf sourceOfLawCollectionMemberFormatString, trestniZakon, lawReference;
		
		for(i=2; i <= numberOfReferences; i++)
		{
			lawReference=lawReferences[i];
			sub(/^[[:space:]]*/, "", lawReference);
			sub(/[[:space:]]*$/, "", lawReference);
			
			printf ";\n";
			printf sourceOfLawCollectionMemberFormatString, trestniZakon, lawReference;
		}
		
		printf " ] .\n"
	}
}