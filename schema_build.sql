drop schema if exists work;
create schema work character set utf8mb4 collate utf8mb4_bin;
use work;

drop table if exists clients;
create table clients (
	id bigint unsigned primary key not null  comment 'Identifier of the client',
	name tinytext not null comment 'Name or title of the client',
    alias varchar(50) not null comment 'Nicname for the client',
	description text null comment 'Information about the client',
	email varchar(255) not null comment 'E-mail for the cummunication purposes', 
	unique key client_email_k (email) comment 'Unique value for the e-mail',
    unique key client_alias_k (alias) comment 'Unique value for the nicname'
) comment 'The Clients' engine = InnoDB;

drop table if exists client_notes;
create table client_notes (
	id bigint unsigned primary key not null comment 'Note identifier',
    client_id bigint unsigned not null,
	note text not null comment 'The note text',
	foreign key (client_id) references clients(id) on delete cascade
) comment 'Notes to the Client' engine=InnoDB;

drop table if exists projects;
create table projects (
	id bigint unsigned primary key not null comment 'Project identifier',
    alias varchar(255) comment 'Project unique verbose identifier',
	client_id bigint unsigned not null comment 'Client, associated with the project',
	details text null comment 'The short description of the project',
    created datetime default current_timestamp not null comment 'The record creation date',
    finished datetime default null comment 'The project finising date',
    is_active tinyint default 0 not null comment 'Project is currently in active phase',
    is_suspended tinyint default 0 not null comment 'Project is currently suspended',
    is_finished tinyint default 0 not null comment 'Project is successfully finished',
    is_virtual tinyint default 0 not null comment 'The project created for the budget planning purposes',
	foreign key (client_id) references clients(id) on delete cascade,
    unique key project_alias_k (alias) comment 'Unique project alias'
) comment 'The Projects' engine=InnoDB;

drop table if exists project_notes;
create table project_notes (
	id bigint unsigned primary key not null comment 'Note identifier',
    project_id bigint unsigned not null comment 'The project ID',
    note text not null comment 'The note text',
    foreign key (project_id) references projects(id) on delete cascade
) comment 'Notes to the Project' engine=InnoDB;

drop table if exists contracts;
create table contracts(
    id bigint unsigned primary key not null comment 'Contract identifier',
    alias varchar(100) comment 'Contract alias',
    alias_legal varchar(100) comment 'Contract reference number for the citation',
    project_id bigint unsigned not null comment 'The reference to the project',
    base_url varchar(255) comment 'URL to the document storage',
    source_url varchar(255) comment 'URL to the document source',
    is_active tinyint default 0 not null comment 'Contract is currently in active phase',
    is_suspended tinyint default 0 not null comment 'Contract is currently suspended',
    is_finished tinyint default 0 not null comment 'Contract is successfully finished',
    is_virtual tinyint default 0 not null comment 'The contract created for the budget planning purposes',
    foreign key (project_id) references projects(id) on delete cascade,
    unique key contract_alias_k (alias) comment 'Unique contract alias'
) comment 'The Contracts' engine=InnoDB;

# contract service items
drop table if exists contract_service_items;
create table contract_service_items (
    id bigint unsigned primary key not null comment 'Item identifier',
    contract_id bigint unsigned not null comment 'Contract identifier',
    idx int unsigned null default 0 comment 'Index for the list representation',
    caption tinytext not null comment 'Service name',
    code tinytext null comment 'Service code',
    price decimal(11, 2) signed not null default 0.0 comment 'Price for unique service',
    multiplier float unsigned not null default 1.0 comment 'Number or amount of single services',
    tax decimal(11, 2) signed not null default 0.0 comment 'Tax',
    total decimal(11, 2) signed not null default 0.0 comment 'Total sum for the service item',
    notes tinytext null comment 'Additional information for the service',
    foreign key (contract_id) references contracts(id) on delete cascade
) comment 'Contract material items' engine=InnoDB;


# contract material items
drop table if exists contract_material_items;
create table contract_material_items (
    id bigint unsigned primary key not null comment 'Item identifier',
    contract_id bigint unsigned not null comment 'Contract identifier',
    idx int unsigned null default 0 comment 'Index for the list representation',
    caption tinytext not null comment 'Material item name/title/caption',
    code tinytext not null comment 'Material item code',
    url varchar(255) null comment 'Material description',
    price decimal(11, 2) signed comment 'Price for single item',
    multiplier float unsigned not null default 1.0 comment 'Number for countable or amount for non-countable items',
    tax decimal(11, 2) signed not null default 0.0 comment 'Tax',
    total decimal(11, 2) signed not null default 0.0 comment 'Total sum for the material item',
    notes tinytext null comment 'Additiona information for the item',
    foreign key (contract_id) references contracts(id) on delete cascade
) comment 'Contract material items' engine=InnoDB;

# warehouse
drop table if exists warehouse;
#
#
#

# contract-> material items?

drop table if exists accounts;
create table accounts(
    id bigint unsigned primary key not null comment 'Account identifier',
    alias varchar(20) not null comment 'Nicname for the account',
    name tinytext not null comment 'The name of account',
    unique key account_alias_k (alias) comment 'Unique account alias'
) comment 'The Accounts' engine=InnoDB;

drop table if exists ledger;
create table ledger (
	id bigint unsigned primary key not null comment 'The ledger entry identifier',
    contract_id bigint unsigned not null comment 'Reference to the contract',
    created datetime default current_timestamp not null comment "Timestamp at record creation",
    account_id bigint unsigned not null comment 'Account',
    value decimal(11, 2) signed not null comment 'Transaction value',
    foreign key (contract_id) references contracts(id) on delete cascade,
    foreign key (account_id) references accounts(id) on delete cascade
) comment 'The Ledger' engine=InnoDB;

drop table if exists virtual_ledger;
create table virtual_ledger (
    id bigint unsigned primary key not null  comment 'The legder entry identifier',
    contract_id bigint unsigned not null comment 'Reference to the contract',
    created datetime default current_timestamp not null comment "Timestamp at record creation",
    value decimal(11, 2) signed not null comment 'Transaction value',
    description varchar(100) comment 'Information about the transaction',
    foreign key (contract_id) references contracts(id) on delete cascade
) comment 'The Virtual Ledger';


# Stored Procedures:
# show_all_clients()
# show_client_by_alias(client_alias)
#

drop procedure if exists show_all_clients;
delimiter //
create procedure show_all_clients()
begin
	select * from clients order by alias asc;
end //
delimiter ;

drop procedure if exists show_client_with_alias;
delimiter //
create procedure show_client_with_alias(in client_alias varchar(20))
begin
	select * from clients where alias = client_alias order by alias asc;
end //
delimiter ;

drop procedure if exists show_client_with_id;
delimiter //
create procedure show_client_with_id(in client_id bigint)
begin
	select distinct * from clients where id = client_id;
end //
delimiter ;

drop procedure if exists create_client;
delimiter //
create procedure create_client(in name tinytext, 
                                alias varchar(50), 
                                description tinytext, 
                                email varchar(255),
                                return_record_id tinyint,
                                return_record tinyint)
begin
    declare new_id bigint default uuid_short();
    insert into clients (id, name, alias, description, email) values (new_id, name, alias, description, email);
    
    if return_record_id = 1 then
        select new_id as id;
	end if;
    
    if return_record = 1 then
        select * from clients where id = new_id;
	end if;
end //
delimiter ;

drop function if exists client_id_with_alias;
delimiter //
create function client_id_with_alias(client_alias varchar(50))
returns bigint deterministic
begin
	return (select id from clients where alias = client_alias limit 1);
end //
delimiter ;



drop procedure if exists create_project;
delimiter //
create procedure create_project(in client bigint, 
								alias varchar(255),
                                details tinytext,
                                created datetime,
                                return_record_id tinyint,
                                return_record tinyint)
begin
	declare new_id bigint default uuid_short();
    if created is null then
		set created = current_timestamp;
    end if;
    
    insert into projects (id, alias, client_id, details, created, is_finished, is_active, is_suspended, is_virtual) 
        values (new_id, alias, client, details, created, 0, 0, 0, 1);
	
    if return_record_id = 1 then
        select new_id as id;
	end if;
    
	if return_record = 1 then
		select * from projects where id = new_id;
    end if;
end //
delimiter ;


drop procedure if exists find_projects_with_client;
delimiter //
create procedure find_projects_with_client(in client bigint)
begin
	select * from projects where client_id = client;
end //
delimiter ;

show errors;

drop procedure if exists show_all_projects;
delimiter //
create procedure show_all_projects()
begin
	select 
	p.*, 
    c.name as client_name, 
    c.alias as client_alias 
	from projects as p 
	join clients as c 
		on p.client_id = c.id;
end //
delimiter ;

