# Evaluación Final Transversal - Modelamiento Base de Datos

* Nombre: Camilo Andrés Pinto Martinez
* Carrera: Analista Programador
* Fecha de entrega: 11/10/2026
* Sección: 004A
* Sede: Campus Virtual

## Descripción general del sistema
Este repositorio contiene el diseño y la implementación en lenguaje SQL de la base de datos para la Asociación Nacional de Fútbol Profesional (ANFP). El sistema centraliza la información de los trabajadores de los clubes (jugadores de fútbol y personal de planta), los clubes, las escuelas de fútbol, las asociaciones, las nacionalidades, los idiomas y la ubicación geográfica (comuna y región), junto con el historial de permanencia de cada jugador en los distintos clubes, con el fin de facilitar la gestión de contratos y la toma de decisiones.

## Contenido del Repositorio

* `Modelo_Entidad_Relacion.png`: Modelo Entidad-Relación Extendido (MER-E) en notación Barker, desarrollado en Oracle SQL Developer Data Modeler.
* `Modelo_Relacional.png`: Modelo Relacional (MR) normalizado obtenido a partir del MER-E.
* `Evaluacion_Final_Transversal.SQL`: Script DDL y DML que contiene el borrado previo de objetos, la creación de las tablas del modelo relacional con sus restricciones (PK, FK, UN, CK), la generación de identificadores mediante columna IDENTITY (NACIONALIDAD) y secuencia (CLUB_FUTBOL), el poblamiento de las tablas REGION, COMUNA, ASOCIACION, NACIONALIDAD y CLUB_FUTBOL, y las consultas SQL para la generación de los informes de asociaciones de fútbol profesional y de patrimonio de los clubes.
