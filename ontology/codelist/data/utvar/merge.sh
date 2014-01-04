#!/bin/sh
baseDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
year=$1;
joinPath="${baseDir}/${year}";

find "$joinPath" -name *final.csv -print0 |
xargs -0 -I file cat file >> "${baseDir}/${year}/utvary.txt";