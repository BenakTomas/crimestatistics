#!/bin/sh
baseDir="$1";
year=$2;
rmPath="${baseDir}/${year}";

find "$rmPath" -name *final.csv |
xargs -I finalFile rm finalFile;