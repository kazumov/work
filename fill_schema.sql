

# Fill the data
# Clients
call create_client("Alu Justec", "ALU", "Corn producer and seller", "alu.justec@gmail.com", 1, 0);
call create_client ("Moosca F. Belledone", "DONE", "Helicopters Development", "mfbelledone@gmail.com", 0, 1);
call create_client ("Huma B. Mallore", "HUMA", "Machinery", "hauma@icloud.com", null, null);
call create_client ("Helena G. Erricson", "HELE", "Software and pluming", "helger@msn.com", 0, 1);
call create_client ("William Joser", "WJ", "Recreation", "william@yahoo.ca", 0, 1);
call create_client ("M Sonner", "SON", "Landscaping", "munson@comcast.net", 0, 1);
call create_client ("Oliver S. Russel", "OLI", "Lamp Designer", "osaru@comcast.net", 0, 1);
call create_client ("Generald Lowe", "GL", "Concrete and patios", "gerlo@gmail.com", 0, 1);
call create_client ("Tolead Itman", "T2", "Bike rental", "treit@live.com", 0, 1);
call create_client ("Veller Fert Rest", "REST", "Fitness", "vlefevre@att.net", 0, 1);
call create_client ("S Rihan", "ROMEO", "Aerospace", "sriha@yahoo.com", 0, 1);
call show_all_clients();
call show_client_with_alias('ROMEO');

# Projects
set @client = (select client_id_with_alias('HUMA'));
call create_project (@client, 'Bird of prey', 'Helicopter engine disassembling', null, 0, 1);
call create_project (@client, 'Yellow monkey', 'Power plant drafting', '2019-02-01', 0, 1);
call create_project (@client, 'Big boom', 'A cannon sound historical reconstruction', '2018-05-04', 1, 0);
call find_projects_with_client(@client);

set @client = (select client_id_with_alias('ROMEO'));
call create_project (@client, 'Lovely Space', 'Scrapyard exploration', '2018-05-11', 0, 1);
call create_project (@client, 'Milky Way', 'Magnifier on a satellite', '2019-12-06', 0, 1);
call create_project (@client, 'Orbit A', 'Measure the orbit parameters', '2020-08-13', 1, 0);
call find_projects_with_client(@client);

call show_all_projects();

# Contracts

# Contract Items

# 
