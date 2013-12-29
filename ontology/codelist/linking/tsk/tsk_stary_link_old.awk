#!/bin/gawk -f
BEGIN {
	FS="#";
	activeTSK="";
	originalRS="";
	originalRecord="";
	readingLawRefs=0;
}
{
	if(readingLawRefs == 0)
	{
		print "not reading law refs";
		
		activeTSK=$1;
		lawReferencesSection=$3;
		originalRS=RS;
		originalRecord=$0;
		RS=",";
		$0=lawReferencesSection;
		readingLawRefs=1;
		
		printf "Law reference section: %s \n", lawReferencesSection
		printf "Active TSK: %s \n", activeTSK
		next;
	}
	else
	{
		printf "reading law refs for tsk %s", activeTSK
		sub(/^[[:space:]]*/, "", $0);
		
		if($0=="@")
		{
			print "finished reading law references"
			RS=originalRS;
			readingLawRefs=0;
			next;
		}
		else
		{
			lawReference=$0;
			printf "reading law reference %s", lawReference;
			printf "crimestatistics-code-codelist-hash:%s crimestatistics-property-zakony:jeKvalifikovanZakonem http://linked.opendata.cz/resource/legislation/cz/act/1961/140/section/%s ;\n", activeTSK, lawReference;
		}
	}
}