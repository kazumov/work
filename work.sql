drop schema if exists work;
create schema work character set utf8mb4 collate utf8mb4_bin;
use work;

drop table if exists client;
create table client (
	client_id int unsigned primary key not null auto_increment comment 'Identifier of the client',
	name tinytext not null comment 'Name or title of the client',
    client_alias varchar(50) not null comment 'Nicname for the client',
	description text comment 'Information about the client',
	email varchar(255) not null comment 'E-mail for the cummunication purposes', 
	unique key client_email_k (email) comment 'Unique value for the e-mail',
    unique key client_alias_k (client_alias) comment 'Unique value for the nicname'
) comment 'The clients table' engine = InnoDB;

drop table if exists client_notes;
create table client_notes (
	client_note_id int unsigned primary key not null auto_increment comment 'Note identifier',
    client_id int unsigned not null,
	client_note text not null comment 'The note text',
	foreign key (client_id) references client(client_id) on delete cascade
) comment 'Notes about the client' engine=InnoDB;

drop table if exists project;
create table project (
	project_id int unsigned primary key not null auto_increment comment 'Project identifier',
    project_alias varchar(255) comment 'Project unique verbose identifier',
	client_id int unsigned not null comment 'Client, associated with the project',
	project_details text null comment 'The short description of the project',
    project_created datetime default current_timestamp not null comment 'The record creation date',
    project_finished datetime default null comment 'The project finising date',
    project_is_active tinyint default 0 not null comment 'Project is currently in active phase',
    project_is_suspended tinyint default 0 not null comment 'Project is currently suspended',
    project_is_sketch tinyint default 0 not null comment 'The project created for the budget planning purposes',
	foreign key (client_id) references client(client_id) on delete cascade,
    unique key project_alias_k (project_alias) comment 'Unique project alias'
) comment 'The projects' engine=InnoDB;

#foreign key (project_id) references 
drop table if exists project_note;
create table project_note (
	project_note_id int unsigned primary key not null auto_increment comment 'Note identifier',
    project_id int unsigned not null comment 'The project ID',
    project_note text not null comment 'The note text',
    foreign key (project_id) references project(project_id) on delete cascade
) comment '' engine=InnoDB;


drop table if exists ledger;
create table ledger (
	entry_id int unsigned primary key not null auto_increment comment 'The ledger entry identifier',
    project_id int unsigned null comment 'Reference to the project',
    #
    #
    #
    #
    #
    foreign key (project_id) references project(project_id) on delete cascade
) comment 'The main ledger' engine=InnoDB;


describe ledger;
show full columns from ledger;
describe client;
show full columns from client;
describe project;
show full columns from project;
show indexes from project;
