DROP TABLE  transport;
drop table schedule;
drop table vehicle;
drop table station;

/*  2. Create Tables */ 
CREATE TABLE transport
(
    transport_id NUMERIC(10) NOT NULL,
    ttype VARCHAR(50) UNIQUE, --'Train','Bus'
    CONSTRAINT  transport_pk PRIMARY KEY(transport_id)
);

CREATE TABLE vehicle
(
    vehicle_id NUMERIC(10) NOT NULL,
    vnumber VARCHAR2(10) UNIQUE, --'ES899'
    transport_id NUMERIC(10),  -- Foreign key ('Train', 'Bus')
    CONSTRAINT vehicle_pk PRIMARY KEY(vehicle_id),
    CONSTRAINT vehicle_fk FOREIGN KEY(transport_id) REFERENCES transport(transport_id)
);

CREATE TABLE station
(
    station_id NUMERIC(10) NOT NULL,
    station_name VARCHAR2(50) NOT NULL,
    address VARCHAR2(100) NOT NULL,
    --stype VARCHAR2(5),
    stype NUMBER(5),
    CONSTRAINT station_pk PRIMARY KEY(station_id),
    --CONSTRAINT stype_check CHECK (stype IN ('Bus', 'Train') )
    CONSTRAINT vehiclee_fk FOREIGN KEY(stype) REFERENCES transport(transport_id)
);

CREATE TABLE schedule
(
    schedule_id NUMERIC(10) NOT NULL,
    vehicle_id NUMERIC(10) NOT NULL,
    departure_station_id NUMERIC(10) NOT NULL,
    arrival_station_id NUMERIC(10) NOT NULL,    
    departure_time DATE NOT NULL,  
    arrival_time DATE NOT NULL,
    CONSTRAINT schedule_pk PRIMARY KEY(schedule_id),
    CONSTRAINT vehicle_fk3  FOREIGN KEY(vehicle_id) REFERENCES vehicle(vehicle_id),
    CONSTRAINT departure_station_fk  FOREIGN KEY(departure_station_id) REFERENCES station(station_id),
    CONSTRAINT arrival_station_fk  FOREIGN KEY(arrival_station_id) REFERENCES station(station_id)
);


/* 3. Irasymas i lentel?. .
*/

/* Vechicles */
CREATE SEQUENCE vehicle_sequence
  MINVALUE 1
  MAXVALUE 9999999
  START WITH 1
  INCREMENT BY 1
  CACHE 20;

DROP SEQUENCE vehicle_seq;

--select vehicle_seq.nextval from dual;
/*  Galima panaudoti triger? generuoti id*/
CREATE OR REPLACE TRIGGER vehicle_on_insert
  BEFORE INSERT ON vehicle
  FOR EACH ROW
BEGIN
  SELECT vehicle_sequence.nextval
  INTO :new.vehicle_id
  FROM dual;
END;



select * from vehicle;

INSERT ALL
    INTO vehicle( transport_id, vnumber) VALUES((SELECT transport_id from transport WHERE ttype='Train'), 'ES523')
    INTO vehicle( transport_id, vnumber) VALUES((SELECT transport_id from transport WHERE ttype='Bus'), '75')
    INTO vehicle( transport_id, vnumber) VALUES((SELECT transport_id from transport WHERE ttype='Train'), 'EK888')
    INTO vehicle( transport_id, vnumber) VALUES((SELECT transport_id from transport WHERE ttype='Train'), '879')
    INTO vehicle( transport_id, vnumber) VALUES((SELECT transport_id from transport WHERE ttype='Bus'), 'SHUT154')
    INTO vehicle( transport_id, vnumber) VALUES((SELECT transport_id from transport WHERE ttype='Train'), 'ES899')
    INTO vehicle( transport_id, vnumber) VALUES((SELECT transport_id from transport WHERE ttype='Bus'), '17568')
SELECT 1 FROM DUAL;


/* Stations */
CREATE SEQUENCE station_sequence;

INSERT INTO station(station_id, station_name, address, stype) VALUES(station_sequence.NEXTVAL, 'Vilnius train station', 'GeleÃ¾inkelio g. 16, Vilnius',
                                                                    (SELECT transport_id from transport WHERE ttype='Train'));
INSERT INTO station(station_id, station_name, address, stype) VALUES(station_sequence.NEXTVAL, 'Ã?iauliai train station', 'Dubijos g. 42A, Ã?iauliai', (SELECT transport_id from transport WHERE ttype='Train'));
INSERT INTO station(station_id, station_name, address, stype) VALUES(station_sequence.NEXTVAL, 'Kaunas bus station', 'Vytauto pr. 124, Kaunas', (SELECT transport_id from transport WHERE ttype='Bus'));
INSERT INTO station(station_id, station_name, address, stype) VALUES(station_sequence.NEXTVAL, 'Vilnius bus station', 'SodÃ¸ g. 22, Vilnius', (SELECT transport_id from transport WHERE ttype='Bus'));        
INSERT INTO station(station_id, station_name, address, stype) VALUES(station_sequence.NEXTVAL, 'KlaipÃ«da train station', 'PriestoÃ¨io g. 1, KlaipÃ«da', (SELECT transport_id from transport WHERE ttype='Train'));
INSERT INTO station(station_id, station_name, address, stype) VALUES(station_sequence.NEXTVAL, 'Kaunas train station', 'M. K. Ãˆiurlionio g. 16, Kaunas', (SELECT transport_id from transport WHERE ttype='Train'));



select * from station;

/* Schedules.   */
CREATE SEQUENCE schedule_sequence;

/* 1 */
INSERT INTO schedule(schedule_id, vehicle_id, departure_station_id, arrival_station_id, departure_time, arrival_time)
    VALUES(schedule_sequence.NEXTVAL, (SELECT vehicle_id FROM vehicle WHERE vnumber='ES523'), 
              (SELECT station_id FROM station WHERE station_name='Vilnius train station'),
              (SELECT station_id FROM station WHERE station_name='Ã?iauliai train station'),
              TO_DATE('2018-05-02 12:40','yyyy-mm-dd hh24:mi'),
              TO_DATE('2018-05-02 15:08','yyyy-mm-dd hh24:mi')
              );
/*  2*/
INSERT INTO schedule(schedule_id, vehicle_id, departure_station_id, arrival_station_id, departure_time, arrival_time)
    VALUES(schedule_sequence.NEXTVAL, (SELECT vehicle_id FROM vehicle WHERE vnumber='75'), 
              (SELECT station_id FROM station WHERE station_name='Kaunas bus station'),
              (SELECT station_id FROM station WHERE station_name='Vilnius bus station'),
              TO_DATE('2018-05-04 23:52','yyyy-mm-dd hh24:mi'),
              TO_DATE('2018-05-05 01:04','yyyy-mm-dd hh24:mi')
              );              

/* 3 */              
INSERT INTO schedule(schedule_id, vehicle_id, departure_station_id, arrival_station_id, departure_time, arrival_time)
    VALUES(schedule_sequence.NEXTVAL, (SELECT vehicle_id FROM vehicle WHERE vnumber='EK888'), 
              (SELECT station_id FROM station WHERE station_name='Ã?iauliai train station'),
              (SELECT station_id FROM station WHERE station_name='Vilnius train station'),
              TO_DATE('2018-05-08 06:34','yyyy-mm-dd hh24:mi'),
              TO_DATE('2018-05-08 09:36','yyyy-mm-dd hh24:mi')
              );        
              
/* 4 */              
INSERT INTO schedule(schedule_id, vehicle_id, departure_station_id, arrival_station_id, departure_time, arrival_time)
    VALUES(schedule_sequence.NEXTVAL, (SELECT vehicle_id FROM vehicle WHERE vnumber='879'), 
              (SELECT station_id FROM station WHERE station_name='KlaipÃ«da train station'),
              (SELECT station_id FROM station WHERE station_name='Vilnius train station'),
              TO_DATE('2018-05-10 14:14','yyyy-mm-dd hh24:mi'),
              TO_DATE('2018-05-10 18:23','yyyy-mm-dd hh24:mi')
              );                  

/* 5 */              
INSERT INTO schedule(schedule_id, vehicle_id, departure_station_id, arrival_station_id, departure_time, arrival_time)
    VALUES(schedule_sequence.NEXTVAL, (SELECT vehicle_id FROM vehicle WHERE vnumber='SHUT154'), 
              (SELECT station_id FROM station WHERE station_name='Vilnius bus station'),
              (SELECT station_id FROM station WHERE station_name='Kaunas bus station'),
              TO_DATE('2018-05-09 12:36','yyyy-mm-dd hh24:mi'),
              TO_DATE('2018-05-09 13:28','yyyy-mm-dd hh24:mi')
              );     

/* 6 */              
INSERT INTO schedule(schedule_id, vehicle_id, departure_station_id, arrival_station_id, departure_time, arrival_time)
    VALUES(schedule_sequence.NEXTVAL, (SELECT vehicle_id FROM vehicle WHERE vnumber='ES899'), 
              (SELECT station_id FROM station WHERE station_name='Kaunas train station'),
              (SELECT station_id FROM station WHERE station_name='Vilnius train station'),
              TO_DATE('2018-05-29 17:01','yyyy-mm-dd hh24:mi'),
              TO_DATE('2018-05-29 18:50','yyyy-mm-dd hh24:mi')
              );     
             
/* 7 */              
INSERT INTO schedule(schedule_id, vehicle_id, departure_station_id, arrival_station_id, departure_time, arrival_time)
    VALUES(schedule_sequence.NEXTVAL, (SELECT vehicle_id FROM vehicle WHERE vnumber='17568'), 
              (SELECT station_id FROM station WHERE station_name='Vilnius bus station'),
              (SELECT station_id FROM station WHERE station_name='Kaunas bus station'),
              TO_DATE('2018-05-28 19:45','yyyy-mm-dd hh24:mi'),
              TO_DATE('2018-05-28 20:58','yyyy-mm-dd hh24:mi')
              );                
              
/* 8 */              
INSERT INTO schedule(schedule_id, vehicle_id, departure_station_id, arrival_station_id, departure_time, arrival_time)
    VALUES(schedule_sequence.NEXTVAL, (SELECT vehicle_id FROM vehicle WHERE vnumber='ES523'), 
              (SELECT station_id FROM station WHERE station_name='Vilnius train station'),
              (SELECT station_id FROM station WHERE station_name='KlaipÃ«da train station'),
              TO_DATE('2018-05-25 10:03','yyyy-mm-dd hh24:mi'),
              TO_DATE('2018-05-25 15:22','yyyy-mm-dd hh24:mi')
              );                
  
COMMIT;              

select * from schedule;
            

/* 4.a */
/* isveda lentele, su duomenimis, kokie buvo uzduotyje */
SELECT /* s.schedule_id, s.departure_station_id, s.arrival_station_id, */
       t.TTYPE AS "Vehicle type", v.vnumber AS "Vehicle number", 
       dep_st.station_name as "Departure station name", dep_st.address AS "Departure station address",
       arr_st.station_name as "Arrival station name", arr_st.address AS "Arrival station address",
       TO_CHAR(s.departure_time, 'yyyy.mm.dd hh24:mi') AS "Departure time", 
       TO_CHAR(s.arrival_time, 'yyyy.mm.dd hh24:mi') AS "Arrival time"
       FROM vehicle v
       JOIN schedule s ON (v.vehicle_id=s.vehicle_id)
       JOIN station dep_st ON (dep_st.station_id=s.departure_station_id)
       JOIN station arr_st ON (arr_st.station_id=s.arrival_station_id)
       JOIN transport t ON (t.transport_id=v.transport_id)  --nauja eilute       
       ORDER BY schedule_id;
       
/* 4.b. Užklausa, kuri gr?žins transporto priemon?s numer?, išvykimo / atvykimo stot?¡ bei kelion?s trukm?¦
valand?¸ ir minu?i?¸ tikslumu.  */

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
ORDER BY schedule_id
;

/* 4.c. Užklaus? , kuri gr?žint?¸ suplanuot?¸ išvykim? skai?i?¸ iš kiekvienos stoties per vis?  laikotarp?. Gr?žinti
stoties pavadinim? , bei per vis?  laikotarp? suplanuot?¸ kelioni? skai?i? */

SELECT  st.station_name AS "Departure station", COUNT(*) as "Number of departures"
FROM schedule s
JOIN station st ON (s.departure_station_id=st.station_id) 
GROUP BY st.station_name;


/* 4.d. Užklaus?, kuri gr?žina tuos pa?ius laukus kaip ir 4.a, ta?iau turi atrinkti tik tuos maršrut? grafikus, kuri? išvykimo laikas v?lesnis nei 2018-05-25 00:00. 
e. Duomen? trynimo sakin?/-ius, kuriais s?kmingai pašalintum?te vis? susijusi? informacij? apie traukin?, kurio numeris ES523.   */


SELECT /* s.schedule_id, s.departure_station_id, s.arrival_station_id, */
       t.ttype AS "Vehicle type", v.vnumber AS "Vehicle number", 
       dep_st.station_name as "Departure station name", dep_st.address AS "Departure station address",
       arr_st.station_name as "Arrival station name", arr_st.address AS "Arrival station address",
       TO_CHAR(s.departure_time, 'yyyy.mm.dd hh24:mi') AS "Departure time", 
       TO_CHAR(s.arrival_time, 'yyyy.mm.dd hh24:mi') AS "Arrival time"
       FROM vehicle v
       JOIN schedule s ON (v.vehicle_id=s.vehicle_id)
       JOIN station dep_st ON (dep_st.station_id=s.departure_station_id)
       JOIN station arr_st ON (arr_st.station_id=s.arrival_station_id)
       JOIN transport t ON (t.transport_id=v.transport_id)  --nauja eilute
       WHERE s.departure_time > TO_DATE('2018.05.25 00:00', 'yyyy.mm.dd hh24:mi')
       ORDER BY schedule_id;


/* 4.e. Duomen? trynimo sakin?/-ius, kuriais s?kmingai pašalintum?te vis? susijusi? informacij? apie traukin?, kurio numeris ES523. */

/* istrinti visus irasus schedule lenteleje, kur vehicle number yra ES523 */
DELETE FROM  schedule 
WHERE vehicle_id=(SELECT vehicle_id FROM vehicle WHERE vnumber='ES523');

/* istrinti irasa vehicles lenteleje, kur vehicle number yra ES523 */ 
DELETE FROM  vehicle WHERE vnumber='ES523';



