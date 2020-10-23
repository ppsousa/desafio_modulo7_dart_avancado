create database ibge;

use ibge;

create table regiao(
    id int not null,
	sigla varchar(10),
	nome varchar(50)
);

create index idx_regiao on regiao(id);

create table mesorregiao(
    id int not null,
	nome varchar(50)
);

create index idx_mesorregiao on mesorregiao(id);

create table microrregiao(
     id int not null,
	 nome varchar(50),
	 mesorregiaoId int not null,
     foreign key (mesorregiaoId) references mesorregiao(id)
);

create index idx_microrregiao on microrregiao(id);

create table estado(
    id int not null,
    nome varchar(50),
    sigla varchar(10),
    regiaoId int not null,
    foreign key (regiaoId) references regiao(id)
);

create index idx_estado on estado(id);

create table municipio(
   id int not null,
   nome varchar(50),
   microrregiaoId int not null,
   estadoId int not null,
   foreign key (microrregiaoId) references microrregiao(id),
   foreign key (estadoId) references estado(id)   
);

create index idx_municipio on municipio(id);