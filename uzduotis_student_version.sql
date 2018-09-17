drop table schedule;
drop table vehicle;
drop table station;

/*  2. Create Tables */ 
CREATE TABLE vehicle
(
    vehicle_id NUMERIC(10) NOT NULL,
    vnumber VARCHAR2(10) UNIQUE,
    vtype VARCHAR2(5),
    CONSTRAINT vehicle_pk PRIMARY KEY(vehicle_id),
    CONSTRAINT type_check CHECK (vtype IN ('Bus', 'Train') )
);

CREATE TABLE station
(
    station_id NUMERIC(10) NOT NULL,
    station_name VARCHAR2(50) NOT NULL,
    address VARCHAR2(100) NOT NULL,
    stype VARCHAR2(5),
    CONSTRAINT station_pk PRIMARY KEY(station_id),
    CONSTRAINT stype_check CHECK (stype IN ('Bus', 'Train') )
);

CREATE TABLE schedule
(
    schedule_id NUMERIC(10) NOT NULL,
    vehicle_id NUMERIC(10) NOT NULL,
    departure_station_id NUMERIC(10) NOT NULL,
    arrival_station_id NUMERIC(10) NOT NULL,    
    departure_time DATE NOT NULL,  /* geresnis variantas butu Timestamp (nereiketu konvertuoti)  */
    arrival_time DATE NOT NULL,
    CONSTRAINT schedule_pk PRIMARY KEY(schedule_id),
    CONSTRAINT vehicle_fk  FOREIGN KEY(vehicle_id) REFERENCES vehicle(vehicle_id),
    CONSTRAINT departure_station_fk  FOREIGN KEY(departure_station_id) REFERENCES station(station_id),
    CONSTRAINT arrival_station_fk  FOREIGN KEY(arrival_station_id) REFERENCES station(station_id)
);

/* 3. Irasymas i lentele. Galima rasyti 7 atskirus sakinius, vienu sakiniu siek tiek elegantiskiau
Production versijoje reiktu naudoti ID generatori?.
*/

/* Vechicles */
INSERT ALL
    INTO vehicle(vehicle_id, vtype, vnumber) VALUES(1, 'Train', 'ES523')
    INTO vehicle(vehicle_id, vtype, vnumber) VALUES(2, 'Bus', '75')
    INTO vehicle(vehicle_id, vtype, vnumber) VALUES(3, 'Train', 'EK888')
    INTO vehicle(vehicle_id, vtype, vnumber) VALUES(4, 'Train', '879')
    INTO vehicle(vehicle_id, vtype, vnumber) VALUES(5, 'Bus', 'SHUT154')
    INTO vehicle(vehicle_id, vtype, vnumber) VALUES(6, 'Train', 'ES899')
    INTO vehicle(vehicle_id, vtype, vnumber) VALUES(7, 'Bus', '17568')
SELECT 1 FROM DUAL;


/* Stations */
INSERT ALL
    INTO station(station_id, station_name, address, stype) VALUES(1, 'Vilnius train station', 'Geleþinkelio g. 16, Vilnius','Train')
    INTO station(station_id, station_name, address, stype) VALUES(2, 'Ðiauliai train station', 'Dubijos g. 42A, Ðiauliai', 'Train')
    INTO station(station_id, station_name, address, stype) VALUES(3, 'Kaunas bus station', 'Vytauto pr. 124, Kaunas', 'Bus')
    INTO station(station_id, station_name, address, stype) VALUES(4, 'Vilnius bus station', 'Sodø g. 22, Vilnius', 'Bus')        
    INTO station(station_id, station_name, address, stype) VALUES(5, 'Klaipëda train station', 'Priestoèio g. 1, Klaipëda', 'Train')     
    INTO station(station_id, station_name, address, stype) VALUES(6, 'Kaunas train station', 'M. K. Èiurlionio g. 16, Kaunas', 'Train')
SELECT 1 FROM DUAL;

/* Schedules. Naudoju subqueries, del patogumo - kad nereiketu atsiminti id. Be to,taip panasiau i production versija  */

/* 1 */
INSERT INTO schedule(schedule_id, vehicle_id, departure_station_id, arrival_station_id, departure_time, arrival_time)
    VALUES(1, (SELECT vehicle_id FROM vehicle WHERE vnumber='ES523'), 
              (SELECT station_id FROM station WHERE station_name='Vilnius train station'),
              (SELECT station_id FROM station WHERE station_name='Ðiauliai train station'),
              TO_DATE('2018-05-02 12:40','yyyy-mm-dd hh24:mi'),
              TO_DATE('2018-05-02 15:08','yyyy-mm-dd hh24:mi')
              );
/*  2*/
INSERT INTO schedule(schedule_id, vehicle_id, departure_station_id, arrival_station_id, departure_time, arrival_time)
    VALUES(2, (SELECT vehicle_id FROM vehicle WHERE vnumber='75'), 
              (SELECT station_id FROM station WHERE station_name='Kaunas bus station'),
              (SELECT station_id FROM station WHERE station_name='Vilnius bus station'),
              TO_DATE('2018-05-04 23:52','yyyy-mm-dd hh24:mi'),
              TO_DATE('2018-05-05 01:04','yyyy-mm-dd hh24:mi')
              );              

/* 3 */              
INSERT INTO schedule(schedule_id, vehicle_id, departure_station_id, arrival_station_id, departure_time, arrival_time)
    VALUES(3, (SELECT vehicle_id FROM vehicle WHERE vnumber='EK888'), 
              (SELECT station_id FROM station WHERE station_name='Ðiauliai train station'),
              (SELECT station_id FROM station WHERE station_name='Vilnius train station'),
              TO_DATE('2018-05-08 06:34','yyyy-mm-dd hh24:mi'),
              TO_DATE('2018-05-08 09:36','yyyy-mm-dd hh24:mi')
              );        
              
/* 4 */              
INSERT INTO schedule(schedule_id, vehicle_id, departure_station_id, arrival_station_id, departure_time, arrival_time)
    VALUES(4, (SELECT vehicle_id FROM vehicle WHERE vnumber='879'), 
              (SELECT station_id FROM station WHERE station_name='Klaipëda train station'),
              (SELECT station_id FROM station WHERE station_name='Vilnius train station'),
              TO_DATE('2018-05-10 14:14','yyyy-mm-dd hh24:mi'),
              TO_DATE('2018-05-10 18:23','yyyy-mm-dd hh24:mi')
              );                  

/* 5 */              
INSERT INTO schedule(schedule_id, vehicle_id, departure_station_id, arrival_station_id, departure_time, arrival_time)
    VALUES(5, (SELECT vehicle_id FROM vehicle WHERE vnumber='SHUT154'), 
              (SELECT station_id FROM station WHERE station_name='Vilnius bus station'),
              (SELECT station_id FROM station WHERE station_name='Kaunas bus station'),
              TO_DATE('2018-05-09 12:36','yyyy-mm-dd hh24:mi'),
              TO_DATE('2018-05-09 13:28','yyyy-mm-dd hh24:mi')
              );     

/* 6 */              
INSERT INTO schedule(schedule_id, vehicle_id, departure_station_id, arrival_station_id, departure_time, arrival_time)
    VALUES(6, (SELECT vehicle_id FROM vehicle WHERE vnumber='ES899'), 
              (SELECT station_id FROM station WHERE station_name='Kaunas train station'),
              (SELECT station_id FROM station WHERE station_name='Vilnius train station'),
              TO_DATE('2018-05-29 17:01','yyyy-mm-dd hh24:mi'),
              TO_DATE('2018-05-29 18:50','yyyy-mm-dd hh24:mi')
              );     
             
/* 7 */              
INSERT INTO schedule(schedule_id, vehicle_id, departure_station_id, arrival_station_id, departure_time, arrival_time)
    VALUES(7, (SELECT vehicle_id FROM vehicle WHERE vnumber='17568'), 
              (SELECT station_id FROM station WHERE station_name='Vilnius bus station'),
              (SELECT station_id FROM station WHERE station_name='Kaunas bus station'),
              TO_DATE('2018-05-28 19:45','yyyy-mm-dd hh24:mi'),
              TO_DATE('2018-05-28 20:58','yyyy-mm-dd hh24:mi')
              );                
              
/* 8 */              
INSERT INTO schedule(schedule_id, vehicle_id, departure_station_id, arrival_station_id, departure_time, arrival_time)
    VALUES(8, (SELECT vehicle_id FROM vehicle WHERE vnumber='ES523'), 
              (SELECT station_id FROM station WHERE station_name='Vilnius train station'),
              (SELECT station_id FROM station WHERE station_name='Klaipëda train station'),
              TO_DATE('2018-05-25 10:03','yyyy-mm-dd hh24:mi'),
              TO_DATE('2018-05-25 15:22','yyyy-mm-dd hh24:mi')
              );                
  
COMMIT;              
            

/* 4.a */
/* isveda lentele, su duomenimis, kokie buvo uzduotyje */
SELECT /* s.schedule_id, s.departure_station_id, s.arrival_station_id, */
       v.vtype AS "Vehicle type", v.vnumber AS "Vehicle number", 
       dep_st.station_name as "Departure station name", dep_st.address AS "Departure station address",
       arr_st.station_name as "Arrival station name", arr_st.address AS "Arrival station address",
       TO_CHAR(s.departure_time, 'yyyy.mm.dd hh24:mi') AS "Departure time", 
       TO_CHAR(s.arrival_time, 'yyyy.mm.dd hh24:mi') AS "Arrival time"
       FROM vehicle v
       JOIN schedule s ON (v.vehicle_id=s.vehicle_id)
       JOIN station dep_st ON (dep_st.station_id=s.departure_station_id)
       JOIN station arr_st ON (arr_st.station_id=s.arrival_station_id)
       ORDER BY schedule_id;
       
/* 4.b. Užklausa, kuri gr?žins transporto priemon?s numer?, išvykimo / atvykimo stot? bei kelion?s trukm? valand? ir minu?i? tikslumu.   */

SELECT /* s.departure_station_id as dep_st_id, */
       v.vnumber as "Vehicle number",
       dep_st.station_name AS "Departure station name",
       arr_st.station_name AS "Arrival station name",
       EXTRACT(HOUR FROM CAST(s.arrival_time AS TIMESTAMP) - CAST(s.departure_time AS TIMESTAMP)) || ' h ' ||
       EXTRACT(MINUTE FROM CAST(s.arrival_time AS TIMESTAMP) - CAST(s.departure_time AS TIMESTAMP)) || ' min' as Duration
FROM schedule s
JOIN vehicle v ON (s.vehicle_id=v.vehicle_id )
JOIN station dep_st ON (dep_st.station_id=s.departure_station_id)
JOIN station arr_st ON (arr_st.station_id=s.arrival_station_id)
ORDER bY schedule_id
;

/* 4.c. Užklaus?, kuri gr?žint? suplanuot? išvykim? skai?i? iš kiekvienos stoties per vis? laikotarp?. Gr?žinti stoties pavadinim?, bei per vis? laikotarp? suplanuot? kelioni? skai?i?.  */

SELECT  st.station_name AS "Departure station", COUNT(*) as "Number of departures"
FROM schedule s
JOIN station st ON (s.departure_station_id=st.station_id) 
GROUP BY st.station_name;


/* 4.d.Užklaus?, kuri gr?žina tuos pa?ius laukus kaip ir 4.a, ta?iau turi atrinkti tik tuos maršrut? grafikus, kuri? išvykimo laikas v?lesnis nei 2018-05-25 00:00.   */

SELECT /* s.schedule_id, s.departure_station_id, s.arrival_station_id, */
       v.vtype AS "Vehicle type", v.vnumber AS "Vehicle number", 
       dep_st.station_name as "Departure station name", dep_st.address AS "Departure station address",
       arr_st.station_name as "Arrival station name", arr_st.address AS "Arrival station address",
       TO_CHAR(s.departure_time, 'yyyy.mm.dd hh24:mi') AS "Departure time", 
       TO_CHAR(s.arrival_time, 'yyyy.mm.dd hh24:mi') AS "Arrival time"
       FROM vehicle v
       JOIN schedule s ON (v.vehicle_id=s.vehicle_id)
       JOIN station dep_st ON (dep_st.station_id=s.departure_station_id)
       JOIN station arr_st ON (arr_st.station_id=s.arrival_station_id)
       WHERE s.departure_time > TO_DATE('2018.05.25 00:00', 'yyyy.mm.dd hh24:mi')
       ORDER BY schedule_id;



/* 4.e. Duomen? trynimo sakin?/-ius, kuriais s?kmingai pašalintum?te vis? susijusi? informacij? apie traukin?, kurio numeris ES523.  */

/* istrinti visus irasus schedule lenteleje, kur vehicle number yra ES523 */
DELETE FROM  schedule 
WHERE vehicle_id=(SELECT vehicle_id FROM vehicle WHERE vnumber='ES523');

/* istrinti irasa vehicles lenteleje, kur vehicle number yra ES523 */ 
DELETE FROM  vehicle WHERE vnumber='ES523';



