#!/bin/sh
baseDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
year=$1;
rmPath="${baseDir}/${year}";

if [ $# -ne 1 ]
then
	echo "Usage: clean.sh year"
	exit 1
fi

find "$rmPath" -name *final.csv |
xargs -I finalFile rm finalFile;

rm "${rmPath}/utvary.txt"