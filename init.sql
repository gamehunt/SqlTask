create sequence medals_id_seq;

create table medals(
	id bigint not null default nextval('medals_id_seq'::regclass),
	city      	  text,
    edition   	  integer,
	sport         text,
	discipline    text,
	athlete       text,
	noc           text,
	gender        text,
	event         text,
	event_gender  text,
	medal         text,
	constraint medals_pkey primary key(id)
		not deferrable initially immediate
);

copy medals(city,edition,sport,discipline,athlete,noc,gender,event,event_gender,medal) from '/var/lib/postgresql/csvs/olimpic_medals.csv' delimiter ',' csv header;
