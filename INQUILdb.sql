USE master;
-- SCRIPT REALIZADO PARA LA VERSION MSSQL
IF EXISTS ( SELECT name FROM sysdatabases WHERE name ='TenantDB')
	DROP DATABASE TenantDB;
GO

CREATE DATABASE TenantDB;
GO

USE TenantDB;
GO

CREATE TABLE Tb_Usuario(
	int_codUser INTEGER IDENTITY(10001,1) PRIMARY KEY,
	int_codExte INTEGER DEFAULT 0 NOT NULL, 
	int_tipoUser INTEGER DEFAULT 0 NOT NULL,
	str_correo VARCHAR(200) NULL,
	str_nombre VARCHAR(40) NOT NULL,
	str_pass VARCHAR(250) NOT NULL,

	date_registro DATETIME NULL,
	int_registroUser INTEGER NULL,
	date_modifica DATETIME NULL,
	int_modificaUser INTEGER NULL,
	bit_estado BIT NOT NULL DEFAULT 1,
);
GO
-- Tipo Usuario 
-- 0 : SYSTEM
-- 1 : ADMIN
-- 2 : PROPTR
-- 3 : COMUN

INSERT INTO Tb_Usuario(int_tipoUser,str_correo,str_nombre,str_pass,date_registro,int_registroUser,bit_estado)
VALUES
(0,0,'sys@s.com','sys','sunsetchild',GETDATE(),10001,1);

GO
CREATE TABLE Tb_Documento(
	int_codDoc INTEGER IDENTITY(1,1) PRIMARY KEY,
	str_descrCorta VARCHAR(15) NOT NULL,
	str_descrLarga VARCHAR(70) NOT NULL,
	int_long INTEGER NOT NULL DEFAULT 0,
	int_tipo INTEGER NOT NULL DEFAULT 0,
	int_tipoContrib INTEGER NULL DEFAULT 0,
	int_longExact INTEGER NULL DEFAULT 0,
);
GO

INSERT INTO Tb_Documento (str_descrCorta,str_descrLarga,int_long,int_tipo,int_tipoContrib,int_longExact)
VALUES
('DNI','DNI',08,5,0,1),
('CARNET EXT.','CARNET DE EXTRANJERIA',12,0,2,0),
('RUC','REG. UNICO DE CONTRIBUYENTES',11,5,0,1),
('PASAPORTE','PASAPORTE',12,0,2,0),
('P.NAC.','PART. DE NACIMIENTO-IDENTIDAD',15,0,0,0),
('OTROS','OTROS',15,0,1,0);

-- Leyenda Docs

--LO:Longitud (int_long)

--T :Tipo (int_tipo)
--	5 :Num�rico
--	0 :Alfanum�rico

--C:Indicador de tipo de contribuyente (int_tipoContrib)
--	0:Documento para nacionales solamente
--	1:Documento para extranjeros solamente
--	2:Documento para nacionales y extranjeros

--E:Indicador de longitud exacta (int_longExact)
--	1:Longitud exacta
--	0:Longitud m�xima


CREATE TABLE Tb_Inquilino(
	int_codInq INTEGER IDENTITY(20001,1) PRIMARY KEY,
	str_apellidos VARCHAR(60) NOT NULL,
	str_nombres VARCHAR(60) NOT NULL,
	int_tipoDocmt INTEGER NOT NULL DEFAULT 1 FOREIGN KEY REFERENCES Tb_Documento(int_codDoc),
	str_nroDocmt VARCHAR(20) NOT NULL,
	str_telefono VARCHAR(15) NULL,
	str_prefijoPais VARCHAR(10) NULL,
	str_direccion VARCHAR(200) NULL,
	int_tipo INTEGER NOT NULL DEFAULT 0,
	img_foto IMAGE NULL,
	img_docmt IMAGE NULL,

	date_registro DATETIME NULL,
	int_registroUser INTEGER NULL,
	date_modifica DATETIME NULL,
	int_modificaUser INTEGER NULL,
	bit_estado BIT NOT NULL DEFAULT 1, 
);
GO

CREATE TABLE Tb_Propietario(
	int_codProp INTEGER IDENTITY(30001,1) PRIMARY KEY,
	str_apellidos VARCHAR(60) NOT NULL,
	str_nombres VARCHAR(60) NOT NULL,
	int_tipoDocmt INTEGER NOT NULL DEFAULT 1 FOREIGN KEY REFERENCES Tb_Documento(int_codDoc),
	str_nroDocmt VARCHAR(20) NOT NULL,
	str_telefono VARCHAR(15) NULL,
	str_prefijoPais VARCHAR(10) NULL,
	str_direccion VARCHAR(200) NULL,
	str_direccionExt VARCHAR(200) NULL,
	img_foto IMAGE NULL,
	img_docmt IMAGE NULL,

	date_registro DATETIME NULL,
	int_registroUser INTEGER NULL,
	date_modifica DATETIME NULL,
	int_modificaUser INTEGER NULL,
	bit_estado BIT NOT NULL DEFAULT 1,
);
GO

CREATE TABLE  Tb_Inmueble(
	int_codInmub INTEGER IDENTITY (40001,1) PRIMARY KEY,
	int_codProp INTEGER NOT NULL FOREIGN KEY REFERENCES Tb_Propietario(int_codProp),
	str_nombre VARCHAR(60) NOT NULL,
	str_descrip VARCHAR(200) NULL,
	str_direccion VARCHAR(200) NULL,
	str_departamento VARCHAR(100) NULL,
	str_provincia VARCHAR(100) NULL,
	str_distrito VARCHAR(100) NULL,
	str_cords VARCHAR(100) NULL,
	dou_area FLOAT DEFAULT 0 NOT NULL, 
	str_unid VARCHAR(5) NULL,
	int_espacios INTEGER NOT NULL DEFAULT 1,
	
);
GO