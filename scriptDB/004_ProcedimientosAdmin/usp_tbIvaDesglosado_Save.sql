
USE VetecMarfilAdmin

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

------------------------------------------------------------------------------------
---                     														 ---
---        Autor: Ramon Rios Hernandez                                           ---
---  Descripcion: Inserta en EstructuraDet           							 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  28/06/2013  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[usp_tbIvaDesglosado_Save]
(
	@intEmpresa     int,
	@intEjercicio	int,
	@intMes			int,
	@strPoliza		VARCHAR(50),
	@intCheque		INT
) 
AS
BEGIN
    SET NOCOUNT ON

	DECLARE @intChequeIVA INT
	DECLARE @datFechaInicial datetime
	DECLARE @datFechaFinal DATETIME
	DECLARE @datFecha DATETIME

	DECLARE @intCuentaBancaria INT

	SELECT @intCheque = intFolioPoliza FROM tbPolizasEnc WHERE intEmpresa = @intEmpresa AND strPoliza = @strPoliza

	SELECT @intCuentaBancaria = intCuentaBancaria FROM tbChequesEnc WHERE intEmpresa = @intEmpresa AND intCheque = @intCheque

	SET @datFechaInicial = '01' + '/' + convert(varchar,@intMes) + '/' + convert(varchar,@intEjercicio)  
	SET @datFechaFinal= DATEADD(MONTH,1,@datFechaInicial) -1

	SET @datFecha = GETDATE() 

	IF NOT EXISTS(SELECT 1 FROM tbIvaDesglosado WHERE intEmpresa = @intEmpresa AND intCheque = @intCheque AND CONVERT(VARCHAR,intEjercicio) + CONVERT(VARCHAR,intMes) <> CONVERT(VARCHAR,@intEjercicio) + CONVERT(VARCHAR,@intMes))
	BEGIN
		DELETE FROM tbIvaDesglosado WHERE intEmpresa = @intEmpresa and intEjercicio = @intEjercicio AND intMes = @intMes AND intCheque = @intCheque
	
		IF NOT EXISTS(SELECT 1 FROM dbo.tbControlIva WHERE intEmpresa = @intEmpresa and intEjercicio = @intEjercicio AND intMes = @intMes)
		BEGIN
			INSERT INTO dbo.tbControlIva(intEmpresa,intSistema,datFecha,datFechaFin,intEjercicio,intMes,
			intTipoPoliza,strPoliza,datFechaPoliza,intEstatus,datFechaProc,strUsuarioAlta,strMaquinaAlta,datFechaAlta)
			VALUES(@intEmpresa,1,@datFechaInicial,@datFechaFinal,@intEjercicio,@intMes,3,NULL,NULL,1,NULL,'160','Local',@datFecha)

			SELECT @intChequeIVA = @@Identity
		END
		ELSE
		BEGIN
			SELECT @intChequeIVA = intFolio FROM dbo.tbControlIva WHERE intEmpresa = @intEmpresa and intEjercicio = @intEjercicio AND intMes = @intMes
		END

		IF(RIGHT(LEFT(@strPoliza,5),2) = '01')
		BEGIN
			SELECT 1
			--Polizas de Ingreso
		END
		ELSE
		BEGIN
			--Cheques / Transferencia
			DECLARE @strPolizaBanco VARCHAR(50)
			DECLARE @strPolizaFac VARCHAR(50)
			DECLARE @Rows int
			DECLARE @Count int
			DECLARE @intProveedor int
			DECLARE @strFactura VARCHAR(50)
	
			DECLARE @dblImporteFactura VARCHAR(50)
			DECLARE @dblImporteIva DECIMAL(18,2)
			DECLARE @dblImporteNC DECIMAL(18,2)
			DECLARE @datFechaFac DATETIME
			DECLARE @datFechaCheque DATETIME
			DECLARE @intTM int
			DECLARE @intObra int
			DECLARE @intOrdenCompra INT
			DECLARE @dblImporte DECIMAL(18,2)
			DECLARE @intEjercicioPol INT
			DECLARE @strCuenta VARCHAR(12)

			DECLARE @Facturas AS TABLE(id int identity(1,1),intEmpresa int,intCheque int,strPoliza varchar(50),
			intProveedor int,strFactura varchar(50), dblImporte decimal(18,2))

			INSERT INTO @Facturas(intEmpresa,intCheque,strPoliza,intProveedor,strFactura,dblImporte)
			SELECT CD.intEmpresa,CD.intCheque,C.strPoliza,CASE WHEN isnull(CD.strClasifDP,'') = '' THEN C.intProveedor ELSE CD.strClasifDP END,CD.strReferencia,(dblDebe + dblHaber)
			FROM tbChequesDet CD 
			INNER JOIN tbChequesEnc C ON C.intEmpresa = CD.intEmpresa AND C.intCheque = CD.intCheque
			WHERE CD.intEmpresa = @intEmpresa
			AND CD.intCheque = @intCheque
			AND CD.strCuenta = '21000001'
			AND (dblDebe + dblHaber) > 0

			SELECT @datFechaCheque = datFechaCheque FROM tbChequesEnc WHERE intEmpresa = @intEmpresa AND intCheque = @intCheque

			SELECT @Rows = COUNT(*) FROM @Facturas
			SET @Count = 0

			--PROVEEDORES
			WHILE (@Rows > @Count)
			BEGIN
				SET @Count = @Count + 1

				SELECT @intProveedor = intProveedor,@strFactura = strFactura,@strPolizaBanco = strPoliza,
				@dblImporte = dblImporte 
				FROM @Facturas WHERE id = @Count

				SELECT @strPolizaFac = strPolProv, @dblImporteFactura = dblTotal,@intTM = intMovto,@intObra = strClasifDS,
				@datFechaFac = datFechaFac,@intOrdenCompra = strFolio,@intEjercicioPol = YEAR(datFechaFac)
				FROM tbFacXP WHERE intEmpresa = @intEmpresa AND intProveedor = @intProveedor AND strFactura = @strFactura

				IF(ISNULL(@intTM,0) > 0)
				BEGIN
					IF(@intTM NOT IN(4,14) AND @intProveedor NOT IN(1797))
					BEGIN
						IF EXISTS(SELECT 1 FROM tbPolizasDet WHERE intEmpresa = @intEmpresa AND intEjercicio = @intEjercicioPol 
						AND strPoliza = @strPolizaFac AND LEFT(strCuenta,4) = '1160')
						BEGIN
							INSERT INTO dbo.tbIvaDesglosado(intEmpresa,intEjercicio,intMes,intSistema,intFolio,datFecha,intTM,intCheque,
							strPoliza,strPolizaBanco,strCuenta,intProveedor,intObra,strFactura,datFechaFactura,strCuentaIva,
							dblPorcentajeIva,strUsuarioAlta,strMaquinaAlta,datFechaAlta,intOrdenCompra,intEjercicioRef, intCuentaBancaria,
							dblMontoIva,dblTotal)	
							SELECT @intEmpresa,@intEjercicio,@intMes,1,@intChequeIVA,datFecha,@intTM,@intCheque,
							@strPolizaFac,@strPolizaBanco,'21000001',@intProveedor,@intObra,@strFactura,@datFechaFac,strCuenta,
							VetecMarfil.dbo.fnObtenerIva(0),'141','local',getdate(),@intOrdenCompra,@intEjercicioPol,@intCuentaBancaria,
							CASE WHEN dblImporte = 0 THEN 0 ELSE dbo.fn_IVA_TipoMovimiento(@intEmpresa,@intTM,strCuenta,@dblImporte) end,@dblImporte
							FROM tbPolizasDet 
							WHERE intEmpresa = @intEmpresa AND intEjercicio = @intEjercicioPol AND strPoliza = @strPolizaFac 
							AND LEFT(strCuenta,4) = '1160'
						END
						ELSE
						BEGIN
							INSERT INTO dbo.tbIvaDesglosado(intEmpresa,intEjercicio,intMes,intSistema,intFolio,datFecha,intTM,intCheque,
							strPoliza,strPolizaBanco,strCuenta,intProveedor,intObra,strFactura,datFechaFactura,strCuentaIva,
							dblPorcentajeIva,strUsuarioAlta,strMaquinaAlta,datFechaAlta,intOrdenCompra,intEjercicioRef, intCuentaBancaria,
							dblMontoIva,dblTotal)	
							SELECT @intEmpresa,@intEjercicio,@intMes,1,@intChequeIVA,datFecha,@intTM,@intCheque,
							@strPolizaFac,@strPolizaBanco,'21000001',@intProveedor,@intObra,@strFactura,@datFechaFac,strCuenta,
							VetecMarfil.dbo.fnObtenerIva(0),'141','local',getdate(),@intOrdenCompra,@intEjercicioPol,@intCuentaBancaria,
							0,@dblImporte
							FROM tbPolizasDet 
							WHERE intEmpresa = @intEmpresa AND intEjercicio = @intEjercicioPol AND strPoliza = @strPolizaFac 
							AND LEFT(strCuenta,8) = '21000001'
						END
			
						IF EXISTS(SELECT 1 FROM tbIvaDesglosado I INNER JOIN tbPolizasDet P ON P.intEmpresa = I.intEmpresa AND P.intEjercicio = I.intEjercicio AND P.strPoliza = I.strPoliza
						WHERE P.strPoliza = @strPolizaFac AND P.intEjercicio = @intEjercicio AND P.intEmpresa = @intEmpresa
						AND LEFT(P.strCuenta,4) = '2120')
						BEGIN
							UPDATE I
							SET dblMontoIva = P.dblImporte 
							FROM tbIvaDesglosado I
							INNER JOIN tbPolizasDet P ON P.intEmpresa = I.intEmpresa AND P.intEjercicio = I.intEjercicio AND P.strPoliza = I.strPoliza
							WHERE P.strPoliza = @strPolizaFac
							AND P.intEjercicio = @intEjercicioPol
							AND P.intEmpresa = @intEmpresa
							AND LEFT(P.strCuenta,4) = '1160'
						END
					END
					ELSE
					BEGIN
						----***Directo Polizas										
						SELECT @dblImporteIva = SUM(dblImporte),@strCuenta = MIN(strCuenta)				   
						FROM tbPolizasDet 
						WHERE intEmpresa = @intEmpresa AND intEjercicio = @intEjercicioPol AND strPoliza = @strPolizaFac 
						AND LEFT(strCuenta,4) = '1160'

						SELECT @dblImporteNC = SUM(dblImporte)
						FROM tbPolizasDet 
						WHERE intEmpresa = @intEmpresa AND intProveedor = @intProveedor AND strClaveRef = @strFactura
						AND LEFT(strCuenta,4) = '1160'
						AND intTipoMovto = 0

						IF(@intProveedor IN(1797))
						BEGIN
							SET @dblImporteIva = @dblImporteIva
						END
						ELSE
						BEGIN
							IF(ISNULL(@dblImporteNC,0) > 0)
								SET @dblImporteIva = @dblImporteIva - ISNULL(@dblImporteNC,0)
							ELSE
								SET @dblImporteIva = dbo.fn_IVA_TipoMovimiento(@intEmpresa,@intTM,@strCuenta,@dblImporte)-- - dbo.fn_IVA_TipoMovimiento(@intEmpresa,@intTM,'21810003',@dblImporte)
						END

						INSERT INTO dbo.tbIvaDesglosado(intEmpresa,intEjercicio,intMes,intSistema,intFolio,datFecha,intTM,intCheque,
						strPoliza,strPolizaBanco,strCuenta,intProveedor,intObra,strFactura,datFechaFactura,strCuentaIva,
						dblPorcentajeIva,strUsuarioAlta,strMaquinaAlta,datFechaAlta,intOrdenCompra,intEjercicioRef, intCuentaBancaria,
						dblMontoIva,dblTotal)	
						VALUES(@intEmpresa,@intEjercicio,@intMes,1,@intChequeIVA,@datFechaCheque,@intTM,@intCheque,
						@strPolizaFac,@strPolizaBanco,'21000001',@intProveedor,@intObra,@strFactura,@datFechaFac,@strCuenta,
						VetecMarfil.dbo.fnObtenerIva(0),'141','local',getdate(),@intOrdenCompra,@intEjercicioPol,@intCuentaBancaria,
						ISNULL(@dblImporteIva,0),@dblImporte)
					END
					
					----***Directo Polizas

					--IF NOT EXISTS(SELECT 1 FROM tbPolizasDet WHERE intEmpresa = @intEmpresa AND intEjercicio = @intEjercicioPol AND strPoliza = @strPolizaFac AND LEFT(strCuenta,4) IN('1160','2110','1170'))
					--BEGIN
					--	INSERT INTO dbo.tbIvaDesglosado(intEmpresa,intEjercicio,intMes,intSistema,intFolio,datFecha,intTM,intCheque,
					--	strPoliza,strPolizaBanco,strCuenta,intProveedor,intObra,strFactura,datFechaFactura,strCuentaIva,
					--	dblPorcentajeIva,strUsuarioAlta,strMaquinaAlta,datFechaAlta,intOrdenCompra,intEjercicioRef, intCuentaBancaria,
					--	dblMontoIva,dblTotal)	
					--	VALUES(@intEmpresa,@intEjercicio,@intMes,1,@intChequeIVA,@datFechaFac,@intTM,@intCheque,
					--	@strPolizaFac,@strPolizaBanco,'21000001',@intProveedor,@intObra,@strFactura,@datFechaFac,'21000001',
					--	VetecMarfil.dbo.fnObtenerIva(0),'141','local',getdate(),@intOrdenCompra,@intEjercicioPol,@intCuentaBancaria,
					--	0,@dblImporte)				
					--END				
				END					

				SET @intTM = 0
				SET @strPoliza = ''
				SET @strFactura =''
				SET @datFechaFac = NULL
				SET @intOrdenCompra = 0
				SET @dblImporte = 0
				SET @intEjercicioPol = 0
				SET @dblImporteIva = 0
				SET @strCuenta = NULL
				SET @dblImporteNC = 0
			END

			SELECT @intEjercicioPol = YEAR(datFechaCheque) FROM tbChequesEnc 
			WHERE intEmpresa = @intEmpresa and intCheque = @intCheque		

			--Anticipados
			INSERT INTO dbo.tbIvaDesglosado(intEmpresa,intEjercicio,intMes,intSistema,intFolio,datFecha,intTM,intCheque,
			strPoliza,strPolizaBanco,strCuenta,intProveedor,intObra,strFactura,datFechaFactura,strCuentaIva,
			dblPorcentajeIva,strUsuarioAlta,strMaquinaAlta,datFechaAlta,intOrdenCompra,intEjercicioRef, intCuentaBancaria,
			dblMontoIva,dblTotal)	
			SELECT @intEmpresa,@intEjercicio,@intMes,1,@intChequeIVA,datFecha,0,@intCheque,
			@strPoliza,@strPoliza,strCuenta,strClasifDP,strClasifDS,strReferencia,datFecha,strCuenta,
			0,'141','local',getdate(),0,@intEjercicio,@intCuentaBancaria,0,dblImporte
			FROM tbPolizasDet 
			WHERE intEmpresa = @intEmpresa AND intEjercicio = @intEjercicioPol AND strPoliza = @strPoliza 
			AND LEFT(strCuenta,8) in('11700001','21100001','21100003')	
		END
	END
	--SELECT * FROM tbIvaDesglosado WHERE INTEMPRESA = 1 AND INTEJERCICIO = 2014 AND INTMES = 10 AND LEFT(strCuentaIva,8) = '11700001'
						
	SET NOCOUNT OFF
END 

