
------------------------------------------------------------------------------------
---   Aplicacion: Digitalizacion                                                 ---
---       Nombre: dbDigitalizacion                                               ---
---  Descripcion: Script para la creacion de la base de datos que utilizara      ---
---               la herramienta.                                                ---
---        Autor: Ruben Mora Martinez / RMM			                             ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  2013-04-12  RMM    Creacion                                                 ---
------------------------------------------------------------------------------------

USE master
GO

-- Creacion de la Base de Datos.
if not exists (select name from master.dbo.sysdatabases where name = N'dbDigitalizacion')
begin
	CREATE DATABASE dbDigitalizacion
		ON (NAME = N'dbDigitalizacion_Data',
			FILENAME = N'E:\Archivo de Programas\Microsoft SQL Server\MSSQL.1\MSSQL\dbDigitalizacion_Data.MDF',
			SIZE = 10,
			MAXSIZE = 500,
			FILEGROWTH = 20)
		LOG ON (NAME = N'dbDigitalizacion_Log',
			FILENAME = N'E:\Archivo de Programas\Microsoft SQL Server\MSSQL.1\MSSQL\dbDigitalizacion_Log.LDF',
			SIZE = 5,
			MAXSIZE = 500,
			FILEGROWTH = 5)
end
GO

-- Asignacion de opciones a la base de datos.
exec sp_dboption N'dbDigitalizacion', N'autoclose', N'false'
GO

exec sp_dboption N'dbDigitalizacion', N'bulkcopy', N'false'
GO

exec sp_dboption N'dbDigitalizacion', N'trunc. log', N'true'
GO

exec sp_dboption N'dbDigitalizacion', N'torn page detection', N'true'
GO

exec sp_dboption N'dbDigitalizacion', N'read only', N'false'
GO

exec sp_dboption N'dbDigitalizacion', N'dbo use', N'false'
GO

exec sp_dboption N'dbDigitalizacion', N'single', N'false'
GO

exec sp_dboption N'dbDigitalizacion', N'autoshrink', N'false'
GO

exec sp_dboption N'dbDigitalizacion', N'ANSI null default', N'false'
GO

exec sp_dboption N'dbDigitalizacion', N'recursive triggers', N'false'
GO

exec sp_dboption N'dbDigitalizacion', N'ANSI nulls', N'false'
GO

exec sp_dboption N'dbDigitalizacion', N'concat null yields null', N'false'
GO

exec sp_dboption N'dbDigitalizacion', N'cursor close on commit', N'false'
GO

exec sp_dboption N'dbDigitalizacion', N'default to local cursor', N'false'
GO

exec sp_dboption N'dbDigitalizacion', N'quoted identifier', N'false'
GO

exec sp_dboption N'dbDigitalizacion', N'ANSI warnings', N'false'
GO

exec sp_dboption N'dbDigitalizacion', N'auto create statistics', N'true'
GO

exec sp_dboption N'dbDigitalizacion', N'auto update statistics', N'true'
GO

if( (@@microsoftversion / power(2, 24) = 8) and (@@microsoftversion & 0xffff >= 724) )
	exec sp_dboption N'dbDigitalizacion', N'db chaining', N'false'
GO

--IF EXISTS (SELECT * FROM sys.server_principals WHERE name = N'usrPM')
--BEGIN
--	PRINT 'Ya existe el login "usrPM", en el servidor de BD'
--END
--ELSE
--BEGIN
--	CREATE LOGIN usrPM
--		WITH PASSWORD=N'pwdPM',
--		DEFAULT_DATABASE=dbDigitalizacion
--
--	PRINT 'Se agrego el login "usrPM", al servidor de BD'
--END
--GO
--
--USE dbDigitalizacion
--GO
--
---- Crea el usuario que utilizara la aplicacion.
--IF EXISTS (SELECT * FROM sys.database_principals WHERE name = N'usrPM')
--BEGIN
--	PRINT 'Ya existe el usuario "usrPM", en la BD'
--END
--ELSE
--BEGIN
--	CREATE USER usrPM
--		FOR LOGIN usrPM
--		WITH DEFAULT_SCHEMA = dbo
--
--	PRINT 'Se agrego al usuario "usrPM", a la BD'
--END
--GO
--
---- Se crea un rol para manejar la seguridad.
--IF EXISTS (SELECT * FROM sys.database_principals WHERE name = N'PM_Role' AND type = 'R')
--BEGIN
--	PRINT 'Ya existe el rol "PM_Role", en la BD'
--END
--ELSE
--BEGIN
--	CREATE ROLE PM_Role
--
--	PRINT 'Se agrego el rol "PM_Role", a la BD'
--END
--GO
--
---- Se asigna el rol al usuario que utilizara la aplicacion.
--EXEC sp_addrolemember 'PM_Role', 'usrPM'
--GO


