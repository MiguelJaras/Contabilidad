
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
---  Aplicacion:  PM.                                                      ---
---  RBDMS:       Miscrosoft SQL Server 2005.                               ---
---  Archivo:     004_PM_Procedimientos.sql                                ---
---  Descripcion: Script para la creacion de los procedimientos             ---
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
---                                                                         ---
---  020.-                                                                  ---
---                                                                         ---
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


-- Cambie el nombre la de base de datos
use VetecMarfil
go


 

/****** Object:  StoredProcedure [dbo.usp_tbUsuarios_Login]    Script Date: 12/8/2009 12:30:06 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbUsuarios_Login')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbUsuarios_Login
	PRINT N'Drop Procedure : dbo.usp_tbUsuarios_Login - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---  Aplicacion:  PM.															 ---
---        Autor: Ruben Mora Martinez/ RMM										 ---
---  Descripcion: Return number of week in current month                         ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  2011-07-29  RMM    Creacion                                                 ---
------------------------------------------------------------------------------------

CREATE PROCEDURE dbo.usp_tbUsuarios_Login
(
	@p_Login nvarchar(50)	
)
AS
BEGIN
	SET NOCOUNT ON
	
	DECLARE	@Err			int,
			@MsgErr		varchar(512)

	SELECT	A.intUsuario,
			A.strClave,
			A.strNombre,
			A.strEmail,
			A.intRol,
			B.strNombre AS StrNombreRol,
			A.bActivo,
			0 AS iTotalRecords,
		    0 AS iTotalPages
	FROM	tbUsuarios A
	INNER JOIN tbRol B ON B.intRol = A.intRol
	where A.strClave = @p_Login

	SET @Err = @@Error

	IF (@Err > 0)
	BEGIN
		SELECT @MsgErr = 'Ocurrio un error no reconocido!',
				@Err = 1000000

		GOTO ExistsError
	END

	SET NOCOUNT OFF

	RETURN @Err

ExistsError:
	IF (@@TRANCOUNT > 0)
		ROLLBACK

	SET NOCOUNT OFF

	RAISERROR (@MsgErr, 16, 1)

	RETURN @Err

END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbUsuarios_Login Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbUsuarios_Login Error on Creation'
END
GO



/****** Object:  StoredProcedure [dbo.usp_tblParameters_upd]    Script Date: 12/3/2009 12:51:03 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbMenuConta_Create')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbMenuConta_Create
	PRINT N'Drop Procedure : dbo.usp_tbMenuConta_Create - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---  Aplicacion:  PM.															 ---
---        Autor: Ruben Mora Martinez/ RMM										 ---
---  Descripcion: Return number of week in current month                         ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  2011-07-29  RMM    Creacion                                                 ---
------------------------------------------------------------------------------------

CREATE PROCEDURE dbo.usp_tbMenuConta_Create
(
	@ParentId int,
	@intRol	  int = 0
)
AS
BEGIN

	SET NOCOUNT ON

      IF @ParentId = 0
      BEGIN
            SELECT A.intMenu,A.strPagina,A.strNombre,A.Icon,1 as HasChildren  
            FROM  tbMenuConta A 
            WHERE IsNull(A.intParentMenu,0) = 0  
      END   
      ELSE
      BEGIN
            SELECT DISTINCT intMenu,strPagina,strNombre,Icon,IsNull(intParentMenu,0) As intParentMenu,SortOrder,
                    Convert(Bit,Case When Exists(Select 1 From tbMenuConta R Where R.intParentMenu = A.intMenu) Then 1 Else 0 End) AS HasChildren
            FROM  tbMenuConta A     
            WHERE intParentMenu = @ParentId    
            ORDER BY SortOrder,intMenu,intParentMenu
      END

	SET NOCOUNT OFF
END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbMenuConta_Create Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbMenuConta_Create Error on Creation'
END
GO



IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbClientes_Cartera')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbClientes_Cartera
	PRINT N'Drop Procedure : dbo.usp_tbClientes_Cartera - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: RMM.		                                                     ---
---        Autor: Ruben Mora Martinez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  tbCotizacion                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  22/08/2011  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE dbo.usp_tbClientes_Cartera
(	
	@intEmpresa			int,
	@intSucursal		int,
	@intColonia			int = 0,		
	@intTipoCredito		int = 0,
	@datFechaInicial	datetime,
	@datFechaFinal		datetime
)
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON

		SELECT P.intProspecto, P.strNombreCliente + ' ' + P.strApellidoPaterno + ' ' + P.strApellidoMaterno AS Nombre,		
		ISNULL((SELECT SUM(M.dblImporte) FROM tbCarteraMovimientoDet M WHERE M.intCarteraDet = CD.intCarteraDet AND M.dblImporte > 0),0) AS Cobrar,
		ISNULL(ABS((SELECT SUM(M.dblImporte) FROM tbCarteraMovimientoDet M WHERE M.intCarteraDet = CD.intCarteraDet AND M.dblImporte < 0)),0) AS Pagado,
		SUM(CDM.dblImporte) as Saldo--,
		--ISNULL((SELECT * FROM VetecMarfilAdmin.dbo.tbPolizasDet WHERE intEmpresa = 3 AND strTipoPoliza = '09' AND ),'')
		FROM tbProspecto P
		INNER JOIN tbClientes CLI ON CLI.intProspecto = P.intProspecto
		INNER JOIN tbCarteraDet CD ON CD.intCliente = CLI.intCliente
		INNER JOIN tbCarteraMovimientoDet CDM ON CDM.intCarteraDet = CD.intCarteraDet
		LEFT JOIN tbColonia C ON C.intColonia = P.intColonia		
		LEFT JOIN tbTipoCredito T ON T.intTipoCredito = P.intTipoCredito
		WHERE ((@intColonia = 0) OR (P.intColonia = @intColonia))
		AND   ((@intTipoCredito = 0) OR (P.intTipoCredito = @intTipoCredito))
		AND	  CD.intEmpresa = @intEmpresa	
		GROUP BY P.intProspecto,P.strNombreCliente,P.strApellidoPaterno,P.strApellidoMaterno,CD.intCarteraDet
		HAVING SUM(CDM.dblImporte) > 0
		ORDER BY P.intProspecto

	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbClientes_Cartera Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbClientes_Cartera Error on Creation'
END
GO




IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbObra_List')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbObra_List
	PRINT N'Drop Procedure : dbo.usp_tbObra_List - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: RMM.		                                                     ---
---        Autor: Ruben Mora Martinez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  tbCotizacion                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  22/08/2011  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[usp_tbObra_List]     
(        
	@intEmpresa int      
)  
AS  
BEGIN
				
	SELECT intEmpresa,intObra,strClave,strNombre
	FROM tbObra
	WHERE intEmpresa = @intEmpresa

END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbObra_List Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbObra_List Error on Creation'
END
GO





IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbOrdenCompraDet_Del')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbOrdenCompraDet_Del
	PRINT N'Drop Procedure : dbo.usp_tbOrdenCompraDet_Del - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: RMM.		                                                     ---
---        Autor: Ruben Mora Martinez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  tbCotizacion                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  22/08/2011  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[usp_tbOrdenCompraDet_Del]     
(        
	@intEmpresa INT,        
	@intSucursal INT,               
	@intOrdenCompraEnc INT,
	@intOrdenCompraDet int        
)  
AS  
BEGIN
	
	DECLARE @intObra int
	DECLARE @intArticulo int
	DECLARE @dblCantidad decimal(18,6)

	SELECT @intObra = intObra 
	FROM tbOrdenCompraEnc WHERE intEmpresa = @intEmpresa and intOrdenCompraEnc = @intOrdenCompraEnc

	SELECT @intArticulo = intArticulo, @dblCantidad = dblCantidad 
	FROM tbOrdenCompraDet 
	WHERE intEmpresa=@intEmpresa 
	AND intSucursal=@intSucursal       
	AND intOrdenCompraEnc=@intOrdenCompraEnc 
	AND intOrdenCompraDet = @intOrdenCompraDet

	UPDATE tbControlObra_Compras 
	SET Cantidad_Comprada = Cantidad_Comprada - @dblCantidad 
	WHERE intEmpresa=@intEmpresa and intObra=@intObra and intArticulo=@intArticulo	

	IF(@@Error = 0)
	BEGIN
		DELETE FROM tbOrdenCompraDet  
		WHERE intEmpresa=@intEmpresa 
		AND intSucursal=@intSucursal       
		AND intOrdenCompraEnc=@intOrdenCompraEnc 
		AND intOrdenCompraDet = @intOrdenCompraDet
	END

END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbOrdenCompraDet_Del Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbOrdenCompraDet_Del Error on Creation'
END
GO





/****** Object:  StoredProcedure [dbo.usp_tbPUTarjetas_RepDet]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbOrdenCompraDet_FillById')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbOrdenCompraDet_FillById
	PRINT N'Drop Procedure : dbo.usp_tbOrdenCompraDet_FillById - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Marfil.		                                                 ---
---        Autor: Rubén Mora Martínez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  Tareas	                     ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  12/11/2010  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE dbo.usp_tbOrdenCompraDet_FillById
(          
	@intEmpresa INT,          	                
	@intOrdenCompraEnc INT,
	@intOrdenCompraDet int
)          
AS          
BEGIN
	
	SELECT RD.intOrdenCompraDet, RD.intPartida,RD.intArticulo,A.strNombreCorto,ISNULL(RD.strComentario,'') AS strNombre,
	RD.dblCantidad,M.strNombre AS Unidad,CONVERT(varchar,RD.datFechaEntrega,103) AS datFechaEntrega, dblPrecio	
	FROM tbOrdenCompraDet RD
	INNER JOIN tbArticulo A ON A.intArticulo = RD.intArticulo AND A.intEmpresa = RD.intEmpresa
	INNER JOIN tbUnidadMedida M ON M.intUnidadMedida = A.intUnidadMedidaCompra
	WHERE RD.intEmpresa = @intEmpresa
	AND RD.intOrdenCompraEnc = @intOrdenCompraEnc
	AND RD.intOrdenCompraDet = @intOrdenCompraDet
	ORDER BY RD.intPartida

END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbOrdenCompraDet_FillById Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbOrdenCompraDet_FillById Error on Creation'
END
GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbOrdenCompraDet_List')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbOrdenCompraDet_List
	PRINT N'Drop Procedure : dbo.usp_tbOrdenCompraDet_List - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: RMM.		                                                     ---
---        Autor: Ruben Mora Martinez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  tbCotizacion                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  22/08/2011  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[usp_tbOrdenCompraDet_List]     
(        
	@intEmpresa int,                    
	@intOrdenCompraEnc int      
)  
AS  
BEGIN
	
	DECLARE @intObra int
	DECLARE @intTipoObra int
	DECLARE @intType int
	DECLARE @strObra varchar(50)

	SET @intType = 0
	SELECT @intObra = intObra FROM tbOrdenCompraEnc WHERE intOrdenCompraEnc = @intOrdenCompraEnc

	SELECT @intTipoObra = intTipoObra, @strObra = SUBSTRING(strClave,1,2) FROM tbObra WHERE intObra = @intObra

	IF(@intTipoObra = 11)
		SET @intType = 1

	IF(@intType <> 1)
	BEGIN
		IF (@strObra='04' or @strObra='07' or @strObra='05' or @strObra='08' or @strObra='09' or @strObra='20')
			SET @intType = 1
	END
		
	SELECT OD.intOrdenCompraEnc, OD.intOrdenCompraDet,OD.intPartida,A.intArticulo,A.strNombreCorto,
	A.strNombre + '<br />' + ISNULL(OD.strComentario,'')  AS strNombre,OD.dblCantidad,M.strNombre AS NomUnidad,
	OD.dblPrecio, Convert(varchar,OD.datFechaEntrega,103) AS datFechaEntrega,R.intEstatus,
	CASE WHEN @intType = 1 THEN 0 ELSE ISNULL((SELECT CO.Precio + ISNULL(Monto_Aditiva,0) FROM tbControlObra_Compras CO WHERE CO.intEmpresa = R.intEmpresa AND CO.intObra = @intObra AND CO.intArticulo = OD.intArticulo),0) END AS PrecioPermitido,
	dbo.fn_tbEntradaCompras_Entrada(OD.intOrdenCompraEnc,OD.intOrdenCompraDet) AS Entrada
	FROM tbOrdenCompraDet OD
	INNER JOIN tbOrdenCompraEnc R ON  R.intOrdenCompraEnc = OD.intOrdenCompraEnc
	INNER JOIN tbArticulo A ON A.intArticulo = OD.intArticulo AND A.intEmpresa = OD.intEmpresa
	INNER JOIN tbUnidadMedida M ON M.intUnidadMedida = A.intUnidadMedidaCompra
	WHERE OD.intEmpresa = @intEmpresa
	AND OD.intOrdenCompraEnc = @intOrdenCompraEnc
	ORDER BY OD.intPartida

END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbOrdenCompraDet_List Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbOrdenCompraDet_List Error on Creation'
END
GO




IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbOrdenCompraDet_Save')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbOrdenCompraDet_Save
	PRINT N'Drop Procedure : dbo.usp_tbOrdenCompraDet_Save - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: RMM.		                                                     ---
---        Autor: Ruben Mora Martinez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  tbCotizacion                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  22/08/2011  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE usp_tbOrdenCompraDet_Save
(          
	@intEmpresa INT,          
	@intSucursal INT,                 
	@intOrdenCompraEnc INT,          
	@intOrdenCompraDet INT,          
	@intArticulo INT,                   
	@datFechaEntrega varchar(20),          
	@dblCantidad decimal(18,6), 
	@dblPrecio decimal(18,6), 
	@strDescripcion varchar(1000)='',
	@strUsuario VARCHAR(50),
	@strMaquina VARCHAR(50)      
)          
AS          
BEGIN
			 
	DECLARE @dblCantidadN numeric(18,6)      	        
	DECLARE @strNombreArticulo Varchar (1000)
	DECLARE @strArticulo varchar(50)       
    DECLARE @dblTotal decimal(18,2)
	DECLARE @intObra int
	DECLARE @intFamilia INT
	DECLARE @intFamiliaReq INT
	DECLARE @intPartida INT
	DECLARE @intUnidadMedida INT
	DECLARE @intInventariado INT
	DECLARE @intAuto INT
	DECLARE @intOrden int
	DECLARE @intRequisicion int
	DECLARE @intRequisicionDet int
	DECLARE @dblCantidadReq decimal(18,4)
	DECLARE @dblCantidadEnt decimal(18,4)
	DECLARE @dblCantidadOC decimal(18,4)
	DECLARE @dblCantidadRel decimal(18,4)
	DECLARE @TotalOC DECIMAL(18,2)
	DECLARE @msg VARCHAR(100)

	BEGIN TRY		
	BEGIN TRANSACTION OrdenCompraDet

		SET @dblCantidadN =replace(@dblCantidad,',','')  	  

		SELECT TOP 1 @intFamiliaReq = A.intFamilia 
		FROM tbOrdenCompraDet RD
		INNER JOIN tbArticulo A ON A.intArticulo = RD.intArticulo WHERE intOrdenCompraEnc = @intOrdenCompraEnc

		SELECT @intObra = intObra, @intAuto = intAutoRecepcionable 
		FROM tbOrdenCompraEnc WHERE intEmpresa = @intEmpresa and intOrdenCompraEnc = @intOrdenCompraEnc
	                          
		SELECT @strArticulo = strNombreCorto, @intFamilia = intFamilia, @intUnidadMedida = intUnidadMedidaCompra 
		FROM tbArticulo 
		WHERE intArticulo=@intArticulo and intEmpresa=@intEmpresa 

		SET @dblTotal  = @dblCantidadN * @dblPrecio                      		                   

		IF(@intOrdenCompraDet = 0)
		BEGIN
			IF(@intFamiliaReq IS NOT NULL AND @intFamiliaReq <> @intFamilia)
			BEGIN
				RAISERROR('Solo se pueden agregar insumos del mismo tipo.', 16, 1)            
				RETURN   
			END         
		                 
			IF @dblCantidadN is null          
			BEGIN            
				RAISERROR('Se debe indicar una cantidad. No se insertaron datos.', 16, 1)            
				RETURN            
			END 			

			SELECT @intPartida = ISNULL(MAX(intPartida) + 1,1) 
			FROM tbOrdenCompraDet WHERE intEmpresa = @intEmpresa AND intOrdenCompraEnc = @intOrdenCompraEnc
		                               
			UPDATE tbControlObra_Compras 
			SET Cantidad_Comprada = ISNULL(Cantidad_Comprada,0) + ISNULL(@dblCantidadN,0),
				Monto_Comprado = ISNULL(Monto_Comprado,0) + ISNULL(@dblTotal,0)
			WHERE intEmpresa=@intEmpresa and intObra=@intObra and intArticulo=@intArticulo

			IF(@@Error = 0)
			BEGIN                    
				INSERT INTO tbOrdenCompraDet(intEmpresa,intSucursal,intOrdenCompraEnc,intPartida,intArticulo,strArticulO,dblCantidad,dblPrecio,dblTotal,
				datFechaEntrega, strUsuarioAlta,strMaquinaAlta,datFechaAlta, strComentario)
				VALUES(@intEmpresa,@intSucursal,@intOrdenCompraEnc,@intPartida,@intArticulo,@strArticulo,@dblCantidad,@dblPrecio,@dblTotal,
				@datFechaEntrega, @strUsuario,@strMaquina,GETDATE(),@strDescripcion)						

				SET @intOrdenCompraDet = @@Identity
			END
		END
		ELSE
		BEGIN
			SELECT @dblCantidadOC = SUM(dblCantidad), @TotalOC = SUM(ISNULL(dblTotal,0)) FROM tbOrdenCompraDet WHERE intOrdenCompraEnc = @intOrdenCompraEnc
			AND intOrdenCompraDet = @intOrdenCompraDet

			SELECT @dblCantidadEnt = SUM(dblCantidad) FROM tbEntradaCompras WHERE intOrdenCompraEnc = @intOrdenCompraEnc
			AND intOrdenCompraDet = @intOrdenCompraDet
			AND intEstatus <> 9

			IF(ISNULL(@dblCantidadEnt,0) = @dblCantidadOC)
			BEGIN				
				SET @msg = 'No se puede modificar, la entrada esta completa.'
				RAISERROR(@msg,16,1)
				RETURN
			END

			IF(ISNULL(@dblCantidadN,0) < @dblCantidadEnt)
			BEGIN				
				SET @msg = 'No se puede modificar, cantidad menor ala entrada registrada.'
				RAISERROR(@msg,16,1)
				RETURN
			END

			SELECT @intRequisicion = intRequisicionEnc FROM tbTempOrdenCompra WHERE inrOrdenCompra = @intOrdenCompraEnc--@intOrden

			IF(@intRequisicion IS NOT NULL)
			BEGIN
				SELECT @dblCantidadReq = dblCantidad, @intRequisicionDet = intRequisicionDet
				FROM tbRequisicionDet WHERE intEmpresa = @intEmpresa AND intRequisicionEnc = @intRequisicion 
				AND intArticulo = @intArticulo

				IF(@dblCantidad > @dblCantidadReq)
				BEGIN
					SET @msg = 'Cantidad Superior ala requerida' + CHAR(13) + CHAR(10) + ' Cantidad Requerida : ' + CONVERT(VARCHAR,@dblCantidadReq) + ', cantidad solicitada : ' + CONVERT(VARCHAR,@dblCantidad)
					RAISERROR(@msg,16,1)
					RETURN
				END
				ELSE
				BEGIN
--					UPDATE tbRequisicionDet 
--					SET dblCantidad = @dblCantidad 
--					WHERE intRequisicionEnc = @intRequisicion AND intRequisicionDet = @intRequisicionDet

					UPDATE tbTempOrdenCompra
					SET dblColocado = @dblCantidad
					WHERE intRequisicionEnc = @intRequisicion AND intRequisicionDet = @intRequisicionDet
				END
			END

			UPDATE tbControlObra_Compras 
			SET Cantidad_Comprada = ISNULL(Cantidad_Comprada,0) - ISNULL(@dblCantidadOC,0),
				Monto_Comprado = ISNULL(Monto_Comprado,0) - ISNULL(@TotalOC,0)
			WHERE intEmpresa=@intEmpresa and intObra=@intObra and intArticulo=@intArticulo			

			UPDATE tbControlObra_Compras 
			SET Cantidad_Comprada = ISNULL(Cantidad_Comprada,0) + ISNULL(@dblCantidad,0),
				Monto_Comprado = ISNULL(Monto_Comprado,0) + ISNULL(@dblTotal,0)
			WHERE intEmpresa=@intEmpresa and intObra=@intObra and intArticulo=@intArticulo


			IF(@@Error = 0)
			BEGIN 
				DECLARE @intPartidaBit int
		
				SELECT @intPartidaBit = ISNULL(MAX(intPartida) + 1,1) FROM tbOrdenCompraBit WHERE intEmpresa = @intEmpresa
				AND intSucursal = @intSucursal AND intOrdenCompraDet = @intOrdenCompraDet
		
				INSERT INTO dbo.tbOrdenCompraBit(intEmpresa,intSucursal,intOrdenCompraDet,intPartida,intArticulo,
				datFechaEntrega,dblCantidad, dblPrecio)
				SELECT intEmpresa,intSucursal,intOrdenCompraDet,@intPartidaBit,intArticulo,datFechaEntrega,dblCantidad, dblPrecio
				FROM tbOrdenCompraDet			
				WHERE intEmpresa = @intEmpresa
				AND intOrdenCompraEnc = @intOrdenCompraEnc
				AND intOrdenCompraDet = @intOrdenCompraDet
		            
				UPDATE tbOrdenCompraDet
				SET	intOrdenCompraEnc=@intOrdenCompraEnc,
					intArticulo=@intArticulo,
					strArticulo=@strArticulo,
					dblCantidad=@dblCantidad,
					dblPrecio=@dblPrecio,
					dblTotal=@dblTotal,		
					datFechaEntrega=@datFechaEntrega,
					strUsuarioMod=@strUsuario,
					strMaquinaMod=@strMaquina,
					datFechaMod=GETDATE(),
					strComentario = @strDescripcion
				WHERE intEmpresa=@intEmpresa AND intOrdenCompraDet=@intOrdenCompraDet AND intOrdenCompraEnc = @intOrdenCompraEnc
			END		
		END

		UPDATE E
		SET dblSubTotal = ISNULL((SELECT SUM(D.dblTotal) FROM tbOrdenCompraDet D WHERE intOrdenCompraEnc=E.intOrdenCompraEnc),0)
		FROM tbOrdenCompraEnc E
		WHERE E.intOrdenCompraEnc=@intOrdenCompraEnc
			
		UPDATE E
		SET dblTotal = dblSubTotal + ISNULL((ISNULL(dblSubTotal,0)*(E.dblPorcentajeIVA/100)),0)
		FROM tbOrdenCompraEnc E
		WHERE E.intOrdenCompraEnc=@intOrdenCompraEnc
			
		SELECT @intInventariado = intInventariado FROM tbArticulo WHERE intEmpresa = @intEmpresa AND intArticulo = @intArticulo

		IF(@intAuto = 1 AND @intInventariado = 0)
		BEGIN
			DECLARE @intFolio INT
		
			IF NOT EXISTS(SELECT * FROM tbEntradaCompras WHERE intEmpresa = @intEmpresa AND intOrdenCompraDet = @intOrdenCompraDet)
			BEGIN
				SELECT @intFolio = ISNULL(MAX(intNumero),0) + 1
				FROM tbEntradaCompras
				WHERE intEmpresa = @intEmpresa	
				
				INSERT INTO tbEntradaCompras
				SELECT @intFolio, @intObra, @intOrdenCompraEnc, @strUsuario,'AUTO RECEPCIONABLE', NULL, GETDATE(), @dblCantidad, GETDATE(), @intEmpresa, 3, @intArticulo,@intOrdenCompraDet, @dblPrecio, @dblTotal,''		
			END
			ELSE
			BEGIN
				UPDATE tbEntradaCompras
				SET	dblCantidad = @dblCantidad, strUsuarioRecibe = @strUsuario, datFechaModifica = GETDATE(),intEstatus = 3
				WHERE intEmpresa = @intEmpresa
				AND intOrdenCompraDet = @intOrdenCompraDet
			END
				
			UPDATE OCD 
			SET OCD.dblRecibido = CONVERT(NUMERIC(18,6),@dblCantidad)
			FROM tbOrdenCompraDet OCD			
			WHERE OCD.intEmpresa = @intEmpresa
			AND OCD.intOrdenCompraDet = @intOrdenCompraDet
				
			EXEC usp_tbOrdenCompra_AppInsumosEntrada_Save_Enc @intEmpresa,@intOrdenCompraEnc
		END

	COMMIT TRANSACTION OrdenCompraDet
	END TRY
	BEGIN CATCH	
		ROLLBACK TRANSACTION OrdenCompraDet
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		SELECT @ErrMsg = ERROR_MESSAGE(),
		@ErrSeverity = ERROR_SEVERITY()

		RAISERROR(@ErrMsg, @ErrSeverity, 1)
		RETURN 0
	END CATCH

END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbOrdenCompraDet_Save Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbOrdenCompraDet_Save Error on Creation'
END
GO






IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbOrdenCompraEnc_AnalisisCompra')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbOrdenCompraEnc_AnalisisCompra
	PRINT N'Drop Procedure : dbo.usp_tbOrdenCompraEnc_AnalisisCompra - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: RMM.		                                                     ---
---        Autor: Ruben Mora Martinez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  tbCotizacion                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  22/08/2011  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[usp_tbOrdenCompraEnc_AnalisisCompra]
(
	@intEmpresa			int, 
	@datFechaIni		VARCHAR(12),
	@datFechaFin		VARCHAR(12),
	@strObraIni			VARCHAR(50),
	@strObraFin			VARCHAR(50),
	@intProveedor		int,
	@intProveedorFin	int,
	@strInsumo			VARCHAR(10),
	@strInsumoFin		VARCHAR(10)
)
AS
BEGIN
		
	SET NOCOUNT ON
		
		DECLARE @strEmpresa VARCHAR(150)	
		CREATE TABLE #Obras(intObra int)
		CREATE TABLE #Insumos(intArticulo int)

		CREATE TABLE #Data(strObra varchar(200), strNombreObra varchar(200),OrdenCompra int, datFecha datetime,
		intProveedor int, Proveedor varchar(200), intInsumo int, Insumo varchar(200), Cantidad decimal(18,4), UnidadMedida varchar(200),
		dblImporte decimal(18,2), dblPrecio decimal(18,2), intObra INT)

		INSERT INTO #Obras(intObra)
		SELECT intObra
		FROM tbObra
		WHERE intEmpresa = @intEmpresa
		AND ((@strObraIni = '0') OR (strClave BETWEEN @strObraIni AND @strObraFin))

		INSERT INTO #Insumos(intArticulo)
		SELECT intArticulo
		FROM tbArticulo
		WHERE intEmpresa = @intEmpresa
		AND ((@strInsumo = '0') OR (strNombreCorto BETWEEN @strInsumo AND @strInsumoFin))

		INSERT INTO #Data(strObra,strNombreObra,OrdenCompra,datFecha,intProveedor,Proveedor,intInsumo,Insumo,Cantidad,
		UnidadMedida,dblImporte, dblPrecio, intObra)
		SELECT O.strClave, O.strNombre,OC.intFolio,OC.datFecha,OC.intProveedor,P.strNombre,A.strNombreCorto,A.strNombre,
		OCD.dblCantidad,U.strNombre, OCD.dblTotal, OCD.dblPrecio, OC.intObra
		FROM tbOrdenCompraENC OC
		INNER JOIN tbOrdenCompraDet OCD ON OCD.intOrdenCompraEnc = OC.intOrdenCompraEnc
		INNER JOIN tbArticulo A ON A.intArticulo = OCD.intArticulo AND A.intEmpresa = OC.intEmpresa
		INNER JOIN tbFamilia F ON F.intFamilia = A.intFamilia AND F.intEmpresa = OC.intEmpresa
		INNER JOIN tbUnidadMedida U ON U.intUnidadMedida = A.intUnidadMedidaCompra 
		INNER JOIN VetecMarfilAdmin..tbProveedores P ON P.intProveedor = OC.intProveedor AND P.intEmpresa = OC.intEmpresa
		LEFT JOIN tbObra O ON O.intEmpresa = OC.intEmpresa AND O.intObra = OC.intObra
		WHERE OC.intEmpresa = @intEmpresa
		AND OC.intObra IN(SELECT intObra FROM #Obras)
		AND OCD.intArticulo IN(SELECT intArticulo FROM #Insumos)
		AND ((@intProveedor = 0) OR (OC.intProveedor BETWEEN @intProveedor AND @intProveedorFin))
		AND OC.datFecha BETWEEN @datFechaIni AND @datFechaFin
		AND OC.intEstatus <> 9
			
		SELECT @strEmpresa = E.strNombre FROM VetecMarfilAdmin.dbo.tbEmpresas E WHERE E.intEmpresa = @intEmpresa

		SELECT strObra,strNombreObra,OrdenCompra,datFecha,intProveedor,Proveedor,intInsumo,Insumo,Cantidad,
		UnidadMedida,dblImporte, dblPrecio,
		datFechaIni = @datFechaIni,
		datFechaFin = @datFechaFin,		
		strEmpresa = @strEmpresa,
		intObra
		FROM #Data

		DROP TABLE #Data
		DROP TABLE #Obras
		DROP TABLE #Insumos


	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbOrdenCompraEnc_AnalisisCompra Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbOrdenCompraEnc_AnalisisCompra Error on Creation'
END
GO




IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbOrdenCompraEnc_AnaliticoComprasInsumo')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbOrdenCompraEnc_AnaliticoComprasInsumo
	PRINT N'Drop Procedure : dbo.usp_tbOrdenCompraEnc_AnaliticoComprasInsumo - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: RMM.		                                                     ---
---        Autor: Ruben Mora Martinez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  tbCotizacion                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  22/08/2011  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[usp_tbOrdenCompraEnc_AnaliticoComprasInsumo]
(
	@intEmpresa			INT, 
	@datFechaIni		VARCHAR(12),
	@datFechaFin		VARCHAR(12),
	@strObraIni			VARCHAR(50),
	@strObraFin			VARCHAR(50),
	@intProveedor		int,
	@intProveedorFin	int,
	@strInsumo			VARCHAR(10),
	@strInsumoFin		VARCHAR(10)
)
AS
BEGIN
		
	SET NOCOUNT ON

		CREATE TABLE #Obras(intObra int)
		CREATE TABLE #Insumos(intArticulo int)

		INSERT INTO #Obras(intObra)
		SELECT intObra
		FROM tbObra
		WHERE intEmpresa = @intEmpresa
		AND ((@strObraIni = '0') OR (strClave BETWEEN @strObraIni AND @strObraFin))

		INSERT INTO #Insumos(intArticulo)
		SELECT intArticulo
		FROM tbArticulo
		WHERE intEmpresa = @intEmpresa
		AND ((@strInsumo = '0') OR (strNombreCorto BETWEEN @strInsumo AND @strInsumoFin))
	
		SELECT	strEmpresa = E.strNombre,intObra = OC.intObra,strObra = O.strNombre,strClaveObra = O.strClave,
		datFechaIni = @datFechaIni,datFechaFin = @datFechaFin,strInsumo = OCD.strArticulo,strNombreInsumo = A.strNombre,
		datFecha = OC.datFecha,	intFolio = OC.intFolio,intProveedor = OC.intProveedor,
		strProveedor = P.strNombre,dblCantidadComprada = OCD.dblCantidad,dblPrecio = OCD.dblPrecio,intTipoCambio = 1,
		dblImporte = OCD.dblTotal,dblCantidadRecibir = 0,strUnidadMedida = U.strNombre
		FROM tbOrdenCompraEnc OC
		LEFT JOIN tbOrdenCompraDet OCD ON OCD.intOrdenCompraEnc = OC.intOrdenCompraEnc
		INNER JOIN tbArticulo A ON A.strNombreCorto = OCD.strArticulo COLLATE Traditional_Spanish_CI_AS AND A.intEmpresa = OC.intEmpresa		
		INNER JOIN tbUnidadMedida U ON U.intUnidadMedida = OCD.intUnidadMedida
		LEFT JOIN tbObra O ON O.intObra = OC.intObra AND O.intEmpresa = OC.intEmpresa
		INNER JOIN VetecMarfilAdmin.dbo.tbEmpresas E ON E.intEmpresa = OC.intEmpresa
		INNER JOIN VetecMarfilAdmin.dbo.tbProveedores P ON P.intProveedor = OC.intProveedor AND P.intEmpresa = OC.intEmpresa
		WHERE OC.intEmpresa = @intEmpresa
		AND OC.intObra IN(SELECT intObra FROM #Obras)
		AND OCD.intArticulo IN(SELECT intArticulo FROM #Insumos)
		AND ((@intProveedor = 0) OR (OC.intProveedor BETWEEN @intProveedor AND @intProveedorFin))
		AND OC.datFecha BETWEEN @datFechaIni AND @datFechaFin
		AND OC.intEstatus <> 9

		DROP TABLE #Obras
		DROP TABLE #Insumos

	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbOrdenCompraEnc_AnaliticoComprasInsumo Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbOrdenCompraEnc_AnaliticoComprasInsumo Error on Creation'
END
GO








set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


------------------------------------------------------------------------------------
---   Aplicacion: MARFIL						                                 ---
---        Autor: Ruben Mora Martinez                                            ---
---  Descripcion: Reporte Movimientos Conciliados	                             ---

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbOrdenCompraEnc_AnaliticoComprasProveedor')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbOrdenCompraEnc_AnaliticoComprasProveedor
	PRINT N'Drop Procedure : dbo.usp_tbOrdenCompraEnc_AnaliticoComprasProveedor - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: RMM.		                                                     ---
---        Autor: Ruben Mora Martinez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  tbCotizacion                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  22/08/2011  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[usp_tbOrdenCompraEnc_AnaliticoComprasProveedor]
(
	@intEmpresa			INT, 
	@datFechaIni		VARCHAR(12),
	@datFechaFin		VARCHAR(12),
	@strObraIni			VARCHAR(50),
	@strObraFin			VARCHAR(50),
	@intProveedor		int,
	@intProveedorFin	int,
	@strInsumo			VARCHAR(10),
	@strInsumoFin		VARCHAR(10)
)
AS
BEGIN
		
	SET NOCOUNT ON

		CREATE TABLE #Obras(intObra int)
		CREATE TABLE #Insumos(intArticulo int)

		INSERT INTO #Obras(intObra)
		SELECT intObra
		FROM tbObra
		WHERE intEmpresa = @intEmpresa
		AND ((@strObraIni = '0') OR (strClave BETWEEN @strObraIni AND @strObraFin))

		INSERT INTO #Insumos(intArticulo)
		SELECT intArticulo
		FROM tbArticulo
		WHERE intEmpresa = @intEmpresa
		AND ((@strInsumo = '0') OR (strNombreCorto BETWEEN @strInsumo AND @strInsumoFin))
	
		SELECT	strEmpresa = E.strNombre,intObra = OC.intObra,strObra = O.strNombre,strClaveObra = O.strClave,
				strInsumo = OCD.strArticulo,strNombreInsumo = A.strNombre,datFecha = OC.datFecha,intFolio = OC.intFolio,
				intProveedor = OC.intProveedor,strProveedor = P.strNombre,dblCantidadComprada = OCD.dblCantidad,
				dblPrecio = OCD.dblPrecio,intTipoCambio = 1,dblImporte = OCD.dblTotal,dblCantidadRecibir = 0,
				strUnidadMedida = U.strNombre,dblCantidadRecibida = 0,dblCantidadPendientes = 0,dblDiasAtraso = 0
		FROM tbOrdenCompraEnc OC
		LEFT JOIN tbOrdenCompraDet OCD ON OCD.intOrdenCompraEnc = OC.intOrdenCompraEnc
		INNER JOIN tbArticulo A ON A.strNombreCorto = OCD.strArticulo COLLATE Traditional_Spanish_CI_AS AND A.intEmpresa = OC.intEmpresa		
		INNER JOIN tbUnidadMedida U ON U.intUnidadMedida = OCD.intUnidadMedida
		LEFT JOIN tbObra O ON O.intObra = OC.intObra AND O.intEmpresa = OC.intEmpresa
		INNER JOIN VetecMarfilAdmin.dbo.tbEmpresas E ON E.intEmpresa = OC.intEmpresa
		INNER JOIN VetecMarfilAdmin.dbo.tbProveedores P ON P.intProveedor = OC.intProveedor AND P.intEmpresa = OC.intEmpresa
		WHERE OC.intEmpresa = @intEmpresa
		AND OC.intObra IN(SELECT intObra FROM #Obras)
		AND OCD.intArticulo IN(SELECT intArticulo FROM #Insumos)
		AND ((@intProveedor = 0) OR (OC.intProveedor BETWEEN @intProveedor AND @intProveedorFin))
		AND OC.datFecha BETWEEN @datFechaIni AND @datFechaFin
		AND OC.intEstatus <> 9


		DROP TABLE #Obras
		DROP TABLE #Insumos

	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbOrdenCompraEnc_AnaliticoComprasProveedor Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbOrdenCompraEnc_AnaliticoComprasProveedor Error on Creation'
END
GO





/****** Object:  StoredProcedure [dbo.usp_tbFacXP_Fill]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbTempConciliacionEjercicio_Sel')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbTempConciliacionEjercicio_Sel
	PRINT N'Drop Procedure : dbo.usp_tbTempConciliacionEjercicio_Sel - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Marfil.		                                                 ---
---        Autor: Ingrid Alexis Soto Dimas                                       ---
---  Descripcion: Obtiene intEjercicio:  tbTempConciliacion	                     ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  19/08/2013  IASD   Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE dbo.usp_tbTempConciliacionEjercicio_Sel
(      
	@intEmpresa				int
)
WITH ENCRYPTION 
AS
BEGIN
		
	SET NOCOUNT ON

	SELECT DISTINCT intEjercicio 
		FROM VetecMarfilAdmin.dbo.tbTempConciliacion 
		WHERE intEmpresa =@intEmpresa
		ORDER BY intEjercicio DESC
	
	SET NOCOUNT OFF
	
END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTempConciliacionEjercicio_Sel Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTempConciliacionEjercicio_Sel Error on Creation'
END
GO

