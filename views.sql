USE master;
-- SCRIPT REALIZADO PARA LA VERSION MSSQL Local (2/3)
USE TenantDB;
GO

-- VISTAS USUARIO
CREATE VIEW vw_Usuario AS
SELECT int_codUser, int_codExte,int_tipoUser,
CASE
	WHEN int_tipoUser = 0 THEN 'SISTEMA'
	WHEN int_tipoUser = 1 THEN 'ADMINISTRADOR'
	WHEN int_tipoUser = 2 THEN 'PROPIETARIO'
	WHEN int_tipoUser = 3 THEN 'CLIENTE'
	ELSE 'NO DEFINIDO'
END AS str_desctipoUser,
str_correo,str_nombre 
FROM Tb_Usuario WHERE bit_estado = 1;
GO

CREATE VIEW vw_UsuarioInactivo AS
SELECT int_codUser, int_codExte, int_tipoUser, str_correo, str_nombre 
FROM Tb_Usuario WHERE bit_estado = 0;
GO

-- VISTAS INQUILINO
CREATE VIEW vw_Inquilino_Grid AS
SELECT i.int_codInq, i.str_nroDocmt, i.str_apellidos+', '+ i.str_nombres AS str_apenom, 
CASE 
	WHEN i.int_tipo = 0 THEN 'DOMESTICO'
	WHEN i.int_tipo = 1 THEN 'COMERCIAL'
	ELSE 'NO DEFINIDO'
END AS str_descTipo FROM Tb_Inquilino i
WHERE bit_estado = 1; 
GO

CREATE VIEW vw_Inquilino_Grid_Inactive AS
SELECT i.int_codInq, i.str_nroDocmt, i.str_apellidos+', '+ i.str_nombres AS str_apenom, 
CASE 
	WHEN i.int_tipo = 0 THEN 'DOMESTICO'
	WHEN i.int_tipo = 1 THEN 'COMERCIAL'
	ELSE 'NO DEFINIDO'
END AS str_descTipo FROM Tb_Inquilino i
WHERE bit_estado = 0; 
GO

CREATE VIEW vw_Inquilino AS
SELECT i.int_codInq, i.str_apellidos+', '+ i.str_nombres AS str_apenom, i.str_apellidos, i.str_nombres,
d.str_descrCorta, d.str_descrLarga, i.str_nroDocmt, i.str_prefijoPais + i.str_telefono AS str_longtelefono,
i.str_prefijoPais, i.str_telefono, i.str_direccion, i.int_tipo, 
CASE 
	WHEN i.int_tipo = 0 THEN 'DOMESTICO'
	WHEN i.int_tipo = 1 THEN 'COMERCIAL'
	ELSE 'NO DEFINIDO'
END AS str_descTipo,
i.img_foto, i.bin_document
FROM Tb_Inquilino i 
INNER JOIN Tb_Documento d ON i.int_tipoDocmt = d.int_codDoc
WHERE bit_estado = 1;
GO

CREATE VIEW vw_Inquilino_Inactive AS
SELECT i.int_codInq, i.str_apellidos+', '+ i.str_nombres AS str_apenom, i.str_apellidos, i.str_nombres,
d.str_descrCorta, d.str_descrLarga, i.str_nroDocmt, i.str_prefijoPais + i.str_telefono AS str_longtelefono,
i.str_prefijoPais, i.str_telefono, i.str_direccion, i.int_tipo, 
CASE 
	WHEN i.int_tipo = 0 THEN 'DOMESTICO'
	WHEN i.int_tipo = 1 THEN 'COMERCIAL'
	ELSE 'NO DEFINIDO'
END AS str_descTipo,
i.img_foto, i.bin_document
FROM Tb_Inquilino i 
INNER JOIN Tb_Documento d ON i.int_tipoDocmt = d.int_codDoc
WHERE bit_estado = 0;
GO


-- VISTAS PROPIETARIO
CREATE VIEW vw_Propietario AS
SELECT p.int_codProp, p.str_apellidos +', '+ p.str_nombres AS str_apenom, p.str_apellidos, p.str_nombres,
d.str_descrCorta, d.str_descrLarga, p.str_nroDocmt, p.str_prefijoPais + p.str_telefono AS str_longtelefono,
p.str_prefijoPais, p.str_telefono, p.str_direccion, p.str_direccionExt, p.img_foto, p.bin_document
FROM Tb_Propietario p
INNER JOIN Tb_Documento d ON p.int_tipoDocmt = d.int_codDoc
WHERE bit_estado = 1;
GO

CREATE VIEW vw_PropietarioInactivo AS
SELECT p.int_codProp, p.str_apellidos +', '+ p.str_nombres AS str_apenom, p.str_apellidos, p.str_nombres,
d.str_descrCorta, d.str_descrLarga, p.str_nroDocmt, p.str_prefijoPais + p.str_telefono AS str_longtelefono,
p.str_prefijoPais, p.str_telefono, p.str_direccion, p.str_direccionExt, p.img_foto, p.bin_document
FROM Tb_Propietario p
INNER JOIN Tb_Documento d ON p.int_tipoDocmt = d.int_codDoc
WHERE bit_estado = 0;
GO


-- VISTAS INMUEBLES
CREATE VIEW vw_Inmueble AS
SELECT i.int_codInmub, i.int_codProp, p.str_apellidos +', '+ p.str_nombres AS str_apenom, p.str_apellidos, p.str_nombres,
i.str_tipoInmueble, i.str_nombre, i.str_descrip, i.str_direccion, i.str_ubigeo, d.str_nombre AS str_distrito,
o.str_nombre AS str_provincia, t.str_nombre AS str_departamento, str_cords, dou_area, str_unid, int_espcTotales, 
int_espcDisponi
FROM Tb_Inmueble i 
INNER JOIN Tb_Propietario p ON i.int_codProp = p.int_codProp
JOIN Tb_Distrito d ON i.str_ubigeo = d.str_codDistri
JOIN Tb_Provincia o ON d.str_codProvin = o.str_codProvin
JOIN Tb_Departamento t ON d.str_codDepart = t.str_codDepart 
WHERE i.bit_estado = 1;
GO

/*
SELECT d.str_codDistri as UBIGEO, d.str_nombre as DISTRITO, p.str_nombre AS PROVINCIA ,t.str_nombre AS DEPARTAMENTO
FROM Tb_Distrito d JOIN Tb_Provincia p ON d.str_codProvin = p.str_codProvin 
JOIN Tb_Departamento t ON d.str_codDepart = t.str_codDepart
WHERE d.str_codDistri LIKE '%06';
*/