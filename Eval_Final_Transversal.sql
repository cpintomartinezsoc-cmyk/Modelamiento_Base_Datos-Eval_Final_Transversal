DROP TABLE JUGADOR_CLUB          CASCADE CONSTRAINTS PURGE;
DROP TABLE JUGADOR_IDIOMA        CASCADE CONSTRAINTS PURGE;
DROP TABLE JUGADOR_NACIONALIDAD  CASCADE CONSTRAINTS PURGE;
DROP TABLE PERSONAL_PLANTA       CASCADE CONSTRAINTS PURGE;
DROP TABLE JUGADOR               CASCADE CONSTRAINTS PURGE;
DROP TABLE TRABAJADOR            CASCADE CONSTRAINTS PURGE;
DROP TABLE CLUB_FUTBOL           CASCADE CONSTRAINTS PURGE;
DROP TABLE ESCUELA_FUTBOL        CASCADE CONSTRAINTS PURGE;
DROP TABLE ASOCIACION            CASCADE CONSTRAINTS PURGE;
DROP TABLE IDIOMA                CASCADE CONSTRAINTS PURGE;
DROP TABLE NACIONALIDAD          CASCADE CONSTRAINTS PURGE;
DROP TABLE COMUNA                CASCADE CONSTRAINTS PURGE;
DROP TABLE REGION                CASCADE CONSTRAINTS PURGE;

DROP SEQUENCE SEQ_CLUB_FUTBOL;

CREATE TABLE REGION (
    id_region NUMBER(2)    NOT NULL,
    nombre    VARCHAR2(50) NOT NULL,
    CONSTRAINT REGION_PK PRIMARY KEY (id_region)
);

CREATE TABLE NACIONALIDAD (
    id_nacion   NUMBER(3) GENERATED ALWAYS AS IDENTITY (START WITH 210 INCREMENT BY 2),
    descripcion VARCHAR2(30) NOT NULL,
    CONSTRAINT NACIONALIDAD_PK PRIMARY KEY (id_nacion)
);

CREATE TABLE IDIOMA (
    id_idioma     NUMBER(3)    NOT NULL,
    nombre_idioma VARCHAR2(30) NOT NULL,
    CONSTRAINT IDIOMA_PK PRIMARY KEY (id_idioma)
);

CREATE TABLE ASOCIACION (
    id_asociacion     NUMBER(3)    NOT NULL,
    nombre_asociacion VARCHAR2(60) NOT NULL,
    fecha_creacion    DATE         NOT NULL,
    tipo_asociacion   CHAR(1)      NOT NULL,
    CONSTRAINT ASOCIACION_PK PRIMARY KEY (id_asociacion),
    CONSTRAINT ASOCIACION_CK_FECHA CHECK (fecha_creacion >= DATE '1980-12-31'),
    CONSTRAINT ASOCIACION_CK_TIPO CHECK (tipo_asociacion IN ('P','A'))
);

CREATE TABLE ESCUELA_FUTBOL (
    id_escuela      NUMBER(3)    NOT NULL,
    nombre_escuela  VARCHAR2(50) NOT NULL,
    capacidad       NUMBER(5)    NOT NULL,
    fecha_fundacion DATE         NOT NULL,
    CONSTRAINT ESCUELA_FUTBOL_PK PRIMARY KEY (id_escuela)
);

CREATE TABLE CLUB_FUTBOL (
    id_club         NUMBER(5)    NOT NULL,
    nombre_club     VARCHAR2(30) NOT NULL,
    patrimonio      NUMBER(12)   NOT NULL,
    ubicacion_calle VARCHAR2(60) NOT NULL,
    tipo_club       VARCHAR2(20) NOT NULL,
    CONSTRAINT CLUB_FUTBOL_PK PRIMARY KEY (id_club),
    CONSTRAINT CLUB_FUTBOL_UN_NOMBRE UNIQUE (nombre_club),
    CONSTRAINT CLUB_FUTBOL_CK_TIPO CHECK (tipo_club IN ('Profesional','Amateur'))
);


CREATE TABLE COMUNA (
    id_comuna        NUMBER(3)    NOT NULL,
    nombre           VARCHAR2(50) NOT NULL,
    REGION_id_region NUMBER(2)    NOT NULL,
    CONSTRAINT COMUNA_PK PRIMARY KEY (id_comuna),
    CONSTRAINT COMUNA_REGION_FK FOREIGN KEY (REGION_id_region) REFERENCES REGION (id_region)
);


CREATE TABLE TRABAJADOR (
    numero_inscripcion NUMBER(9)    NOT NULL,
    run                NUMBER(8)    NOT NULL,
    dv                 CHAR(1)      NOT NULL,
    pnombre            VARCHAR2(25) NOT NULL,
    snombre            VARCHAR2(25),
    apaterno           VARCHAR2(25) NOT NULL,
    amaterno           VARCHAR2(25),
    sueldo_base        NUMBER(10)   NOT NULL,
    fecha_nacimiento   DATE         NOT NULL,
    genero             CHAR(1)      NOT NULL,
    estado_civil       VARCHAR2(15) NOT NULL,
    telefono_movil     VARCHAR2(12) NOT NULL,
    direccion          VARCHAR2(60) NOT NULL,
    COMUNA_id_comuna   NUMBER(3)    NOT NULL,
    CONSTRAINT TRABAJADOR_PK PRIMARY KEY (numero_inscripcion),
    CONSTRAINT TRABAJADOR_UN_RUN UNIQUE (run),
    CONSTRAINT TRABAJADOR_COMUNA_FK FOREIGN KEY (COMUNA_id_comuna) REFERENCES COMUNA (id_comuna),
    CONSTRAINT TRABAJADOR_CK_DV CHECK (dv IN ('0','1','2','3','4','5','6','7','8','9','K')),
    CONSTRAINT TRABAJADOR_CK_GENERO CHECK (genero IN ('M','F')),
    CONSTRAINT TRABAJADOR_CK_SUELDO CHECK (sueldo_base >= 0)
);

CREATE TABLE JUGADOR (
    numero_inscripcion        NUMBER(9)    NOT NULL,
    puesto                    VARCHAR2(30) NOT NULL,
    monto_premios             NUMBER(12)   DEFAULT 0 NOT NULL,
    anio_fin                  NUMBER(4),
    ASOCIACION_id_asociacion  NUMBER(3)    NOT NULL,
    ESCUELA_FUTBOL_id_escuela NUMBER(3),
    CONSTRAINT JUGADOR_PK PRIMARY KEY (numero_inscripcion),
    CONSTRAINT JUGADOR_TRABAJADOR_FK FOREIGN KEY (numero_inscripcion) REFERENCES TRABAJADOR (numero_inscripcion),
    CONSTRAINT JUGADOR_ASOCIACION_FK FOREIGN KEY (ASOCIACION_id_asociacion) REFERENCES ASOCIACION (id_asociacion),
    CONSTRAINT JUGADOR_ESCUELA_FUTBOL_FK FOREIGN KEY (ESCUELA_FUTBOL_id_escuela) REFERENCES ESCUELA_FUTBOL (id_escuela)
);

CREATE TABLE PERSONAL_PLANTA (
    numero_inscripcion  NUMBER(9) NOT NULL,
    horas_trabajadas    NUMBER(4),
    valor_horas_extras  NUMBER(8),
    CLUB_FUTBOL_id_club NUMBER(5) NOT NULL,
    CONSTRAINT PERSONAL_PLANTA_PK PRIMARY KEY (numero_inscripcion),
    CONSTRAINT PERSONAL_PLANTA_TRABAJADOR_FK FOREIGN KEY (numero_inscripcion) REFERENCES TRABAJADOR (numero_inscripcion),
    CONSTRAINT PERSONAL_PLANTA_CLUB_FUTBOL_FK FOREIGN KEY (CLUB_FUTBOL_id_club) REFERENCES CLUB_FUTBOL (id_club)
);


CREATE TABLE JUGADOR_NACIONALIDAD (
    NACIONALIDAD_id_nacion     NUMBER(3) NOT NULL,
    JUGADOR_numero_inscripcion NUMBER(9) NOT NULL,
    CONSTRAINT JUGADOR_NACIONALIDAD_PK PRIMARY KEY (NACIONALIDAD_id_nacion, JUGADOR_numero_inscripcion),
    CONSTRAINT JUGADOR_NACIONALIDAD_NACIONALIDAD_FK FOREIGN KEY (NACIONALIDAD_id_nacion) REFERENCES NACIONALIDAD (id_nacion),
    CONSTRAINT JUGADOR_NACIONALIDAD_JUGADOR_FK FOREIGN KEY (JUGADOR_numero_inscripcion) REFERENCES JUGADOR (numero_inscripcion)
);

CREATE TABLE JUGADOR_IDIOMA (
    IDIOMA_id_idioma           NUMBER(3)    NOT NULL,
    JUGADOR_numero_inscripcion NUMBER(9)    NOT NULL,
    nivel_dominio              VARCHAR2(20) NOT NULL,
    CONSTRAINT JUGADOR_IDIOMA_PK PRIMARY KEY (IDIOMA_id_idioma, JUGADOR_numero_inscripcion),
    CONSTRAINT JUGADOR_IDIOMA_IDIOMA_FK FOREIGN KEY (IDIOMA_id_idioma) REFERENCES IDIOMA (id_idioma),
    CONSTRAINT JUGADOR_IDIOMA_JUGADOR_FK FOREIGN KEY (JUGADOR_numero_inscripcion) REFERENCES JUGADOR (numero_inscripcion)
);

CREATE TABLE JUGADOR_CLUB (
    CLUB_FUTBOL_id_club        NUMBER(5) NOT NULL,
    JUGADOR_numero_inscripcion NUMBER(9) NOT NULL,
    fecha_incorporacion        DATE      NOT NULL,
    fecha_fin_contrato         DATE,
    CONSTRAINT JUGADOR_CLUB_PK PRIMARY KEY (CLUB_FUTBOL_id_club, JUGADOR_numero_inscripcion, fecha_incorporacion),
    CONSTRAINT JUGADOR_CLUB_CLUB_FUTBOL_FK FOREIGN KEY (CLUB_FUTBOL_id_club) REFERENCES CLUB_FUTBOL (id_club),
    CONSTRAINT JUGADOR_CLUB_JUGADOR_FK FOREIGN KEY (JUGADOR_numero_inscripcion) REFERENCES JUGADOR (numero_inscripcion),
    CONSTRAINT JUGADOR_CLUB_CK_FECHAS CHECK (fecha_fin_contrato IS NULL OR fecha_fin_contrato >= fecha_incorporacion)
);


CREATE SEQUENCE SEQ_CLUB_FUTBOL
    START WITH 703
    INCREMENT BY 4
    NOCACHE;
    
    SELECT table_name FROM user_tables ORDER BY table_name;
    
    
    
    INSERT INTO REGION (id_region, nombre) VALUES (1,  'ARICA Y PARINACOTA Y TARAPACA');
INSERT INTO REGION (id_region, nombre) VALUES (2,  'ANTOFAGASTA');
INSERT INTO REGION (id_region, nombre) VALUES (3,  'ATACAMA Y COQUIMBO');
INSERT INTO REGION (id_region, nombre) VALUES (5,  'VALPARAISO');
INSERT INTO REGION (id_region, nombre) VALUES (8,  'BIOBIO');  
INSERT INTO REGION (id_region, nombre) VALUES (13, 'METROPOLITANA');
INSERT INTO REGION (id_region, nombre) VALUES (16, 'NUBLE');   

INSERT INTO COMUNA (id_comuna, nombre, REGION_id_region) VALUES (101, 'Santiago',    13);
INSERT INTO COMUNA (id_comuna, nombre, REGION_id_region) VALUES (102, 'Valparaíso',   5);
INSERT INTO COMUNA (id_comuna, nombre, REGION_id_region) VALUES (103, 'Concepción',   8);
INSERT INTO COMUNA (id_comuna, nombre, REGION_id_region) VALUES (104, 'Antofagasta',  2);
INSERT INTO COMUNA (id_comuna, nombre, REGION_id_region) VALUES (105, 'Chillán',     16);


INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
VALUES (25, 'Asociación de Fútbol de Santiago',   TO_DATE('15-05-2001','DD-MM-YYYY'), 'P');
INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
VALUES (26, 'Asociación Nacional de Fútbol Amateur', TO_DATE('10-03-1998','DD-MM-YYYY'), 'A');
INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
VALUES (27, 'Asociación de Fútbol de Valparaíso', TO_DATE('21-07-1987','DD-MM-YYYY'), 'P');
INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
VALUES (28, 'Asociación de Fútbol de Concepción', TO_DATE('30-11-1995','DD-MM-YYYY'), 'A');
INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
VALUES (29, 'Asociación de Fútbol de Antofagasta', TO_DATE('25-06-2003','DD-MM-YYYY'), 'P');
INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
VALUES (30, 'Asociación de Fútbol de Temuco',     TO_DATE('12-01-2010','DD-MM-YYYY'), 'A');
INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
VALUES (31, 'Asociación de Fútbol de Rancagua',   TO_DATE('08-09-1999','DD-MM-YYYY'), 'P');
INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
VALUES (32, 'Asociación de Fútbol de Puerto Montt', TO_DATE('20-04-2005','DD-MM-YYYY'), 'A');
INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
VALUES (33, 'Asociación de Fútbol de La Serena',  TO_DATE('14-08-2012','DD-MM-YYYY'), 'P');
INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
VALUES (34, 'Asociación de Fútbol de Chillán',    TO_DATE('01-12-2018','DD-MM-YYYY'), 'A');


INSERT INTO NACIONALIDAD (descripcion) VALUES ('Chilena');     
INSERT INTO NACIONALIDAD (descripcion) VALUES ('Argentina');  
INSERT INTO NACIONALIDAD (descripcion) VALUES ('Peruana');    
INSERT INTO NACIONALIDAD (descripcion) VALUES ('Boliviana');   
INSERT INTO NACIONALIDAD (descripcion) VALUES ('Brasileña');

INSERT INTO CLUB_FUTBOL (id_club, nombre_club, patrimonio, ubicacion_calle, tipo_club)
VALUES (SEQ_CLUB_FUTBOL.NEXTVAL, 'Colo-Colo',           500000000, 'Av. macul 400',                'Profesional');
INSERT INTO CLUB_FUTBOL (id_club, nombre_club, patrimonio, ubicacion_calle, tipo_club)
VALUES (SEQ_CLUB_FUTBOL.NEXTVAL, 'Universidad de Chile', 450000000, 'Av. nuble 0931',              'Profesional');
INSERT INTO CLUB_FUTBOL (id_club, nombre_club, patrimonio, ubicacion_calle, tipo_club)
VALUES (SEQ_CLUB_FUTBOL.NEXTVAL, 'Deportes Antofagasta', 180000000, 'Avenida consistorial 01606',           'Profesional');
INSERT INTO CLUB_FUTBOL (id_club, nombre_club, patrimonio, ubicacion_calle, tipo_club)
VALUES (SEQ_CLUB_FUTBOL.NEXTVAL, 'Huachipato',          220000000, 'Avenida Hierro 909',     'Profesional');
INSERT INTO CLUB_FUTBOL (id_club, nombre_club, patrimonio, ubicacion_calle, tipo_club)
VALUES (SEQ_CLUB_FUTBOL.NEXTVAL, 'Ñublense',            170000000, 'Avenida Pedro Aguirre Cerda 1003', 'Profesional');

COMMIT;

SELECT * FROM REGION ORDER BY id_region;
SELECT * FROM COMUNA ORDER BY id_comuna;
SELECT * FROM ASOCIACION ORDER BY id_asociacion;
SELECT * FROM NACIONALIDAD ORDER BY id_nacion;
SELECT * FROM CLUB_FUTBOL ORDER BY id_club;



 ---INFORME 1---
 
 SELECT *
FROM ASOCIACION
WHERE tipo_asociacion = 'P'
  AND EXTRACT(YEAR FROM fecha_creacion) > 2000;
  
  SELECT 'ID:' || id_asociacion || ' * ' || nombre_asociacion AS "ASOCIACION",
       TO_CHAR(fecha_creacion, 'DD-MM-YYYY')                AS "CREADA",
       tipo_asociacion                                       AS "TIPO"
FROM ASOCIACION
WHERE tipo_asociacion = 'P'
  AND EXTRACT(YEAR FROM fecha_creacion) > 2000;
  
  
  SELECT 'ID:' || id_asociacion || ' * ' || nombre_asociacion AS "ASOCIACION",
       TO_CHAR(fecha_creacion, 'DD-MM-YYYY')                AS "CREADA",
       tipo_asociacion                                       AS "TIPO"
FROM ASOCIACION
WHERE tipo_asociacion = 'P'
  AND EXTRACT(YEAR FROM fecha_creacion) > 2000
ORDER BY fecha_creacion DESC;



 ---INFORME 2---
 
 
 SELECT *
FROM CLUB_FUTBOL
WHERE LOWER(nombre_club) LIKE '%a%'
  AND patrimonio > 200000000
  AND tipo_club = 'Profesional';
  
  
  SELECT id_club         AS "CLUB",
       nombre_club     AS "NOMBRE CLUB",
       patrimonio      AS "PATRIMONIO EN PESOS",
       patrimonio / 955 AS "PATRIMONIO EN DOLARES"
FROM CLUB_FUTBOL
WHERE LOWER(nombre_club) LIKE '%a%'
  AND patrimonio > 200000000
  AND tipo_club = 'Profesional';
  
  
  SELECT id_club         AS "CLUB",
       nombre_club     AS "NOMBRE CLUB",
       patrimonio      AS "PATRIMONIO EN PESOS",
       patrimonio / 955 AS "PATRIMONIO EN DOLARES"
FROM CLUB_FUTBOL
WHERE LOWER(nombre_club) LIKE '%a%'
  AND patrimonio > 200000000
  AND tipo_club = 'Profesional'
ORDER BY id_club DESC;
