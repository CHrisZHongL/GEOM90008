--mock_data

BEGIN;

-- operator
INSERT INTO group05.operator
VALUES(1,'peter','peter1@gmail.com','0410111111'
  ,TRUE,'2023/04/28 10:10:00',10.1,'2024/04/28 10:10:00',FALSE, NULL);
INSERT INTO group05.operator
VALUES(2,'albert','albert@gmail.com','0410222333'
  ,TRUE,'2023/03/20 10:13:00',49.3,'2024/03/20 10:13:00',FALSE, 10123);-- 0.7 h left
INSERT INTO group05.operator
VALUES(3,'bill','bill@gmail.com','0410123456'
  ,FALSE,'2022/06/20 16:00:00',20.9,'2023/06/20 16:00:00',TRUE, NULL); --within 1 month
INSERT INTO group05.operator
VALUES(4,'peter','peter1@gmail.com','0410654321'
  ,FALSE,'2023/02/12 13:00:00',22.8,'2024/02/12 13:00:00',FALSE, NULL);


--batter model - model,weight,totcap
INSERT INTO group05.battery_model
VALUES(1,20,20);
INSERT INTO group05.battery_model
VALUES(2,35,40);

--battery -- id,rema,s_date,mod
INSERT INTO group05.battery
VALUES(1,0.8,'2023/01/01',1);
INSERT INTO group05.battery
VALUES(2,0.6,'2023/01/01',1);
INSERT INTO group05.battery
VALUES(3,1,'2023/02/01', 2);

--sensor model
INSERT INTO group05.sensor_model
VALUES(1, 10, 150);
INSERT INTO group05.sensor_model
VALUES(2, 25, 90);

--sensor
INSERT INTO group05.sensor
VALUES(1,'2023/04/01', 1);
INSERT INTO group05.sensor
VALUES(2,'2023/03/28', 2);

--drone model
INSERT INTO group05.drone_model
VALUES(1,150,'{1,2}','{1}');
INSERT INTO group05.drone_model
VALUES(2,200,'{1}','{2}');


-- drone
INSERT INTO group05.drone
VALUES(1, 1, NULL);
INSERT INTO group05.drone
VALUES(2, 1, 201);
INSERT INTO group05.drone
VALUES(3, 2, NULL);
INSERT INTO group05.drone
VALUES(4, 2, NULL);



-- dronelog
INSERT INTO group05.dronelog
VALUES(1,
1,1,1,
2,180,1);
INSERT INTO group05.dronelog
VALUES(2,
1,1,1,
1.6,180,0.8);
INSERT INTO group05.dronelog
VALUES(3,
4,2,2,
1.6,260,0.8);
INSERT INTO group05.dronelog
VALUES(4,
2,2,2,
2.4,195,0.8);

--route

INSERT INTO group05.route
VALUES(1,
(SELECT "path" FROM group05.flight_paths where id = 3),
(SELECT st_startpoint("path") FROM group05.flight_paths where id = 3),
( with pgr_table as 
  ( SELECT * FROM pgr_Dijkstra(
  'select "OBJECTID" as id, source, target, st_length(geom) as cost, st_length(geom) as reverse_cost from spatial.victoria_roads2023',
    (select spatial.victoria_roads2023_vertices_pgr.id from group05.flight_paths, spatial.victoria_roads2023_vertices_pgr
       where group05.flight_paths.id = 3
       order by st_distance(st_transform(the_geom,4326),st_startpoint("path")) asc
       Limit 1)
  , 438610, false)
)

  Select ST_Union(geom) FROM spatial.victoria_roads2023, pgr_table 
  WHERE "OBJECTID" = pgr_table.edge
  )
);

INSERT INTO group05.route
VALUES(2,
(SELECT "path" FROM group05.flight_paths where id = 4),
(SELECT st_startpoint("path") FROM group05.flight_paths where id = 4),
( with pgr_table as 
  ( SELECT * FROM pgr_Dijkstra(
  'select "OBJECTID" as id, source, target, st_length(geom) as cost, st_length(geom) as reverse_cost from spatial.victoria_roads2023',
    (select spatial.victoria_roads2023_vertices_pgr.id from group05.flight_paths, spatial.victoria_roads2023_vertices_pgr
       where group05.flight_paths.id = 4
       order by st_distance(st_transform(the_geom,4326),st_startpoint("path")) asc
       Limit 1)
  , 438610, false)
)

  Select ST_Union(geom) FROM spatial.victoria_roads2023, pgr_table 
  WHERE "OBJECTID" = pgr_table.edge
  )
);

INSERT INTO group05.route
VALUES(3,
(SELECT "path" FROM group05.flight_paths where id = 5),
(SELECT st_startpoint("path") FROM group05.flight_paths where id = 5),
( with pgr_table as 
  ( SELECT * FROM pgr_Dijkstra(
  'select "OBJECTID" as id, source, target, st_length(geom) as cost, st_length(geom) as reverse_cost from spatial.victoria_roads2023',
    (select spatial.victoria_roads2023_vertices_pgr.id from group05.flight_paths, spatial.victoria_roads2023_vertices_pgr
       where group05.flight_paths.id = 5
       order by st_distance(st_transform(the_geom,4326),st_startpoint("path")) asc
       Limit 1)
  , 438610, false)
)

  Select ST_Union(geom) FROM spatial.victoria_roads2023, pgr_table 
  WHERE "OBJECTID" = pgr_table.edge
  )
);

INSERT INTO group05.route
VALUES(4,
(SELECT "path" FROM group05.flight_paths where id = 1),
(SELECT st_startpoint("path") FROM group05.flight_paths where id = 1),
( with pgr_table as 
  ( SELECT * FROM pgr_Dijkstra(
  'select "OBJECTID" as id, source, target, st_length(geom) as cost, st_length(geom) as reverse_cost from spatial.victoria_roads2023',
    (select spatial.victoria_roads2023_vertices_pgr.id from group05.flight_paths, spatial.victoria_roads2023_vertices_pgr
       where group05.flight_paths.id = 1
       order by st_distance(st_transform(the_geom,4326),st_startpoint("path")) asc
       Limit 1)
  , 438610, false)
)

  Select ST_Union(geom) FROM spatial.victoria_roads2023, pgr_table 
  WHERE "OBJECTID" = pgr_table.edge
  )
);


INSERT INTO group05.flight_plan
VALUES(1,2,
  1,
  '2023/01/06 10:25:00', 1, 120, 
  (SELECT ST_Length(route_to_uni) FROM group05.route where route_id = 1),
  1, TRUE); ---dronlog id

INSERT INTO group05.flight_plan
VALUES(2,1,
  2,
  '2023/06/06 10:00:00', 1, 120, 
  (SELECT ST_Length(route_to_uni) FROM group05.route where route_id = 2),
  4, FALSE); ---dronlog id

INSERT INTO group05.flight_plan
VALUES(3,1,
  3,
  '2023/06/08 14:50:00', 1.2, 90, 
  (SELECT ST_Length(route_to_uni) FROM group05.route where route_id = 3),
  2, FALSE); ---dronlog id

INSERT INTO group05.flight_plan
VALUES(4,4,
  4,
  '2023/06/25 11:00:00', 1.5, 120, 
  (SELECT ST_Length(route_to_uni) FROM group05.route where route_id = 4),
  1, FALSE); ---dronlog id


END;