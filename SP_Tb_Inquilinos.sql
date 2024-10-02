USE master;
/*
	PROCEDIMIENTOS ALMACENADOS DE INQUILINOS
	SCRIPT REALIZADO PARA LA VERSION MSSQL Local (3/5)
*/

USE TenantDB;
GO
CREATE OR ALTER PROCEDURE SP_LIST_INQUILINO_GRID
	AS
	BEGIN
	SELECT v.int_codInq, v.str_nroDocmt, v.str_apenom, v.str_descTipo FROM vw_Inquilino_Grid v;
END;
-- EXEC SP_LIST_INQUILINO_GRID;

GO
CREATE OR ALTER PROCEDURE SP_COUNT_INQUILINO_ACTIVE
	AS 
	BEGIN 
	SELECT COUNT(*) AS int_InquilTotalActive FROM vw_Inquilino;
END;

GO
--CREATE OR ALTER PROCEDURE SP_COUNT_INQUILINO_
-- SELECT ISNULL(CAST(v.int_tipo AS VARCHAR(2)),'3') AS int_tipo, COUNT(*) AS int_Total FROM vw_Inquilino v GROUP BY v.int_Tipo WITH ROLLUP;

GO
CREATE OR ALTER PROCEDURE SP_INSERT_INQUILINO
	@str_apellidos VARCHAR(60),
	@str_nombres VARCHAR(60),
	@int_tipoDocmt INTEGER,
	@str_nroDocmt VARCHAR(20),
	@str_telefono VARCHAR(15),
	@str_prefijoPais VARCHAR(10),
	@str_direccion VARCHAR(200),
	@int_tipo INTEGER,
	@img_foto IMAGE,
	@bin_document VARBINARY(MAX)
	AS
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION;

			-- Verifica si existe un inquilino con el mismo número de documento
			IF NOT EXISTS (SELECT 1 FROM vw_Inquilino WHERE str_nroDocmt = @str_nroDocmt)
			BEGIN
				INSERT INTO Tb_Inquilino
				(str_apellidos, str_nombres, int_tipoDocmt, str_nroDocmt, str_telefono, str_prefijoPais, 
				 str_direccion, int_tipo, img_foto, bin_document, date_registro, bit_estado)
				VALUES
				(@str_apellidos, @str_nombres, @int_tipoDocmt, @str_nroDocmt, @str_telefono, @str_prefijoPais,
				 @str_direccion, @int_tipo, @img_foto, @bin_document, GETDATE(), 1);
            
				COMMIT TRANSACTION;

				RETURN 0; -- Insercion realizada
			END
			ELSE
			BEGIN
				ROLLBACK TRANSACTION;
				RETURN -1; -- Número de documento ya existe
			END
		END TRY
		BEGIN CATCH
			-- Si ocurre un error, deshacer la transacción
			IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION;
			END

			-- Manejo de errores
			-- Muesta mucha informacion de los errores como 
			-- ERROR_MESSAGE() : el codigo del error, 
			-- ERROR_SEVERITY() : el nivel critico de error de 1 - 25 aprox,
			-- Y se podrian agregar mas errores, pero que se pierden en el traspaso de C# en la manera que
			-- se esta manejando el proyecto.

			DECLARE @ErrorMessage NVARCHAR(4000);
			DECLARE @ErrorSeverity INT;
			DECLARE @ErrorState INT;

			SELECT 
				@ErrorMessage = ERROR_MESSAGE(),
				@ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE();

			RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
       
			RETURN -2; -- Error disparado por el catch
		END CATCH
END;