-- Vypis vysledku
-- Zapis do souboru kraje.
select sql_cache k.kr, '00', '', k.nazev, '0', ''
from kraje k
into outfile 'C:/Documents and Settings/Tom/Dokumenty/crimestatistics/ontology/codelist/data/utvar/$year/kraje/kraje_final.csv'
character set utf8
fields terminated by '#'
lines terminated by '\n';

-- Zapis do souboru centralni utvary.
select sql_cache cua.kr, cua.ok, '', cua.nazev, 0, ''
from crimestatistics.centralni_utvary_actual cua
into outfile 'C:/Documents and Settings/Tom/Dokumenty/crimestatistics/ontology/codelist/data/utvar/$year/centralni_utvary_final.csv'
character set utf8
fields terminated by '#'
lines terminated by '\n';

-- Zapis do souboru okresy.
select sql_cache oa.kr, oa.ok, '', oa.nazev, 1, ''
from okresy_actual oa
into outfile 'C:/Documents and Settings/Tom/Dokumenty/crimestatistics/ontology/codelist/data/utvar/$year/okresy/okresy_final.csv'
character set utf8
fields terminated by '#'
lines terminated by '\n';

-- Do souboru zapis utvary linkovane primo na okresy.
select sql_cache uto.kr, uto.ok, uto.ut, uto.nazev, 1, ''
from utvary_toOkresy uto
into outfile 'C:/Documents and Settings/Tom/Dokumenty/crimestatistics/ontology/codelist/data/utvar/$year/utvary/utvary_toOkresy_final.csv'
character set utf8
fields terminated by '#'
lines terminated by '\n';

-- Do souboru nyni zapis utvary linkovane primo na kraje.
select sql_cache utk.kr, utk.ok, utk.ut, utk.nazev, 1, CONCAT('00', utk.kr)
from utvary_toKraje utk
into outfile 'C:/Documents and Settings/Tom/Dokumenty/crimestatistics/ontology/codelist/data/utvar/$year/utvary/utvary_toKraje_final.csv'
character set utf8
fields terminated by '#'
lines terminated by '\n';

-- Do souboru nyni zapis utvary linkovane na centralni utvary.
select sql_cache utcu.kr, utcu.ok, utcu.ut, utcu.nazev, 1, ''
from utvary_toCentralniUtvary utcu
into outfile 'C:/Documents and Settings/Tom/Dokumenty/crimestatistics/ontology/codelist/data/utvar/$year/utvary/utvary_toCentralniUtvary_final.csv'
character set utf8
fields terminated by '#'
lines terminated by '\n';