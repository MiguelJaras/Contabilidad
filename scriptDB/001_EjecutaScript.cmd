@echo off

set archivo=000_CreateDB
call runSQL

set archivo=001_COP_Tablas
call runSQL

set archivo=002_COP_Datos
call runSQL

set archivo=003_COP_Funciones
call runSQL

set archivo=004_COP_Procedimientos
call runSQL

set/p pausa=        Press key to finish the process..