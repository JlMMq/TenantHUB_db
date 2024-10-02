USE master;
/*
	PROCEDIMIENTOS ALMACENADOS DE DOCUMENTOS
	SCRIPT REALIZADO PARA LA VERSION MSSQL Local (4/5)
*/

USE TenantDB;

GO
CREATE OR ALTER PROCEDURE SP_LIST_DOCUMENTO_GEN
	AS
	BEGIN
	SELECT t.int_codDoc,t.str_descrCorta,t.str_descrLarga,t.int_long,t.int_tipo,t.int_tipoContrib,t.int_longExact FROM Tb_Documento t;
END;

-- EXEC SP_LIST_DOCUMENTO_GEN;

