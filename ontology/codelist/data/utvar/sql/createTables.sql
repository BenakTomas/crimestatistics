create table crimestatistics.centralni_utvary_actual(
	kr varchar(2) not null,
	ok varchar(2) not null,
	nazev varchar(200) null
) engine=memory DEFAULT CHARSET=utf8;

truncate table crimestatistics.centralni_utvary_actual;

insert into crimestatistics.centralni_utvary_actual(kr, ok, nazev)
values('20', '01', 'PP ČR ÚSKPV');

insert into crimestatistics.centralni_utvary_actual(kr, ok, nazev)
values('20', '02', 'PČR ÚOKFK SKPV');

insert into crimestatistics.centralni_utvary_actual(kr, ok, nazev)
values('20', '03', 'PČR NPC SKPV');

insert into crimestatistics.centralni_utvary_actual(kr, ok, nazev)
values('20', '04', 'PČR ÚOOZ SKPV');

insert into crimestatistics.centralni_utvary_actual(kr, ok, nazev)
values('20', '05', 'PČR ÚDV SKPV');

insert into crimestatistics.centralni_utvary_actual(kr, ok, nazev)
values('21', '00', 'INSPEKCE PČR');

create index IX_centralni_utvary_actual_kr_ok_hash
on crimestatistics.centralni_utvary_actual(kr, ok) using hash;

select * from crimestatistics.centralni_utvary_actual;