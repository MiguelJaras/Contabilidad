
USE VetecMarfilAdmin
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.tbConceptosIngreso') AND type in (N'U'))
BEGIN
	DROP TABLE dbo.tbConceptosIngreso

	IF @@Error = 0
	BEGIN
		PRINT 'Drop Table : dbo.tbConceptosIngreso - Succeeded.'
	END
	ELSE
	BEGIN
		PRINT 'Drop Table : dbo.tbConceptosIngreso - Error !!!'
	END
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

------------------------------------------------------------------------------------
---   Aplicacion: Marfil.														 ---
---        Autor: Ruben Mora Martinez											 ---
---  Descripcion: Tabla donde se guardan las familias						     ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  2010-11-21  RMM    Creacion                                                 ---
------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.tbConceptosIngreso') AND type in (N'U'))
BEGIN
	CREATE TABLE tbConceptosIngreso
	(
		intConcepto			int IDENTITY(1,1),
		intEmpresa			int,
		intCuentaBancaria	INT,
		strConcepto			varchar(200),
		strCuentaCargo		varchar(12),
		strCuentaAbono		varchar(12),
		CONSTRAINT PK_tbConceptosIngreso 
		PRIMARY KEY CLUSTERED
		(
			intConcepto ASC
		)
	)
END
GO


IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tbConceptosIngreso', NULL,NULL))
BEGIN
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tabla donde se guardan las conceptos para poliza.' ,
	@level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tbConceptosIngreso'
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.tbConceptosIngreso') AND type in (N'U'))
BEGIN
	PRINT 'Table Creation: dbo.tbConceptosIngreso - Succeeded !!!'
END
ELSE
BEGIN
	PRINT 'Table Creation: dbo.tbConceptosIngreso - Error on Creation'
END
GO

TRUNCATE TABLE tbConceptosIngreso
--cc 1116

---FORUM
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(23,501,'ENTREGA A CTA DE CHEQUES','111000050001','112000050002')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(23,501,'ENTREGA A MESA DE DINERO','112000050002','111000050001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(23,109,'ENTREGA A CTA DE CHEQUES','111000090001','112000090004')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(23,109,'ENTREGA A MESA DE DINERO','112000090004','111000090001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(23,191,'ENTREGA A CTA DE CHEQUES','111000190001','112000190001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(23,191,'ENTREGA A MESA DE DINERO','112000190001','111000190001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(23,191,'TRASPASO','111000190001','1110')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(23,109,'TRASPASO DE FONDOS','111000010001','111000090001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(23,101,'ENTREGA A MESA DE DINERO','112000010001','111000010001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(23,101,'ENTREGA A CTA DE CHEQUES','111000010001','112000010001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(23,901,'ENTREGA A CTA DE CHEQUES','111000200001','112000200001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(23,901,'ENTREGA A MESA DE DINERO','112000200001','111000200001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(23,101,'APORT. CAP. DE ACUERDO A INSTRUCCIÓN DE ASAMBLEA','26000002','111000010001')

---FOMENTO
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(10,101,'ENTREGA A CUENTA DE CHEQUES','11100001','11200001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(10,101,'ENTREGA A MESA DE DINERO','11200001','11100001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(10,101,'BANCA ELECTRONICA','5130','11100001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(10,101,'IVA COM BANCA ELECTRONICA','5130','11100001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(10,101,'COM CHEQUE EXPEDIDO','5130','11100001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(10,101,'IVA COM CHEQUE EXPEDIDO','5130','11100001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(10,101,'DIV.ENGANCHES','11100001','21100001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(10,101,'TRASPASO DE COBRANZA','21100001','11100001')

---RGE
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(24,101,'ENTREGA A CUENTA DE CHEQUES','11100001','11200001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(24,101,'ENTREGA A MESA DE DINERO','11200001','11100001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(24,101,'TRASP DE SERV AGUA ARQ RGB','21100024','11100001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(24,101,'INTERESES','11100001','513000010001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(24,101,'ISR','513000010001','11100001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(24,101,'COM CHEQUE EXPEDIDO','513000010001','11100001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(24,101,'IVA COM CHEQUE EXPEDIDO','11600001','11100001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(24,101,'COM CHEQUE CERTIFIC','513000010001','11100001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(24,101,'IVA COM CHEQUE CERT','11600001','11100001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(24,101,'LIQUIDACION DE FACTURAS','11600001','11100001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(24,101,'APORT. CAP. DE ACUERDO A INSTRUCCIÓN DE ASAMBLEA','111000010001','26000002')

---GRECO
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(4,101,'INTERESES','111000010001','513000010001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(4,101,'ISR','51300000001','111000010001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(4,101,'COMISION POR CHEQUE EXPEDIDO','513000010001','111000010001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(4,101,'IVA X COMISION','11600001','111000010001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(4,101,'LIQUIDACION DE FACTURAS','111000010001','11300004')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(4,101,'ENTREGA A CUENTA DE CHEQUE','111000010001','112000010001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(4,101,'ENTREGA A MESA DE DINERO','112000010001','111000010001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(4,101,'PAGO DE SEGUROS MC','1150','111000010001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(4,101,'CHEQUE CANCELADO','111000010001','210000018700')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(4,101,'TRASP.LIQ. PMO. VENDEDOR','115000010525','111000010001')			
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(4,101,'REVERZA-TRASP. X VTA DE VEHIC.ECO','115000010525','111000010001')		
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(4,101,'TRASP. DEV. SEG.','11500004','111000010001')		
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(4,101,'TRASPASO POR LIQ. DE SEG. INC.','111000010001','115000048719')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(4,101,'TRASP. SEG DE AUTO  VENDEDOR-INC.','1150','111000010001')	

---MAPLE
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,101,'ENTREGA A CTA DE CHEQUES','111000010001','112000010001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,101,'ENTREGA A MESA DE DINERO','112000010001','111000010001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,201,'TRASPASO ENTRE CUENTAS','111000020001','111000010001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,501,'TRASPASO ENTRE CUENTAS','111000080001','111000010001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,502,'TRASPASO ENTRE CUENTAS','11100005','11100005')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,101,'APORTACION FUT AUM DE CAPITAL MAPLE A MUI','11750005','111000010001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,101,'TAPORTACION FUT AUM DE CAPITAL MAPLE A MC','11750005','111000010001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,101,'APORTACION FUT AUM DE CAPITAL MAPLE A MD','11750002','111000010001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,101,'PAGO APORTACIONES FUT AUM DE CAP MC A MAPLE','111000010001','11750001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,501,'DISPOSICION DE CREDITO','1110005','230000050002')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,101,'COMISIONES BANCARIAS','111000010001','513000010002')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,101,'PAGO DE PREDIAL','111000010001','311000020002')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,101,'INTERESES','111000010001','513000010002')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,101,'ISR','513000010001','111000010001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,101,'COMISION POR CHEQUE EXP','513000010001','111000010001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,101,'IVA X COMISION','513000010001','111000010001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,101,'COMISION POR CHEQUE CERTIFICADO','513000010001','111000010001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,901,'COMISION POR CHEQUE CERTIFICADO','513000010001','111000080001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,901,'IVA X COMISION','513000010001','111000080001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,901,'BANCA ELECTRONICA','513000010001','111000080001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,501,'BANCA ELECTRONICA','513000010001','111000050001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,501,'IVA X COMISION','513000010001','1110000 0001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,501,'COM. X SPEI','513000010001','111000050001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,801,'BANCA ELECTRONICA','513000010001','111000070001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,801,'IVA X COMISION','513000010001','111000070001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,801,'COMISION POR BANCA ELECTRONICA','513000010001','111000070001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,101,'TRASPASO ENTRE CUENTAS','111000010001','111000050002')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,101,'CHEQUE CANCELADO','111000010001','211000010003')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,501,'INTERES POR CREDITO BANREGIO','513000050002','111000050001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,501,'DISPOSICION DE CREDITO','111000050001','230000050002')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,101,'LIQUIDACION DE FACTURAS','111000010001','115000050007')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,101,'SOBRANTE DE CH-','111000010001','211000010003')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,101,'TRANSFERENCIA CANCELADA','111000010001','211000010003')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,501,'PAGO CAPITAL BANREGIO','230000050002','111000050002')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,501,'DISPOSICION CAPITAL BANREGIO','111000050002','230000050002')


select * from tbConceptosIngreso where intEmpresa = 3 and intCuentaBancaria = 501


---MD
--bancomer
--SELECT * FROM tbCuentasBancarias WHERE intEmpresa = 2
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'ENTREGA A CTA DE CHEQUES','111000010001','112000010001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'ENTREGA A MESA DE DINERO','112000010001','111000010001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'INTERES','513000010002','111000010001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'INTERESES','111000010001','513000010002')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'ISR','513000010001','111000010001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'COMISION POR BANCA ELECTRONICA','513000010001','111000010001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'COMISION CIE','513000010001','111000010001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'BANCA ELECTRONICA','513000010001','111000010001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'IVA X COMISION','513000010001','111000010001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'COMISION ORDEN DE PAGO','513000010001','111000010001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'IVA','513000010001','111000010001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'SOBRANTE','111000010001','211000010004')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'CH. CANCELADO','111000010001','11000001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'RECUPERACION DE COMISION','111000010001','513000010001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'RECUPERACION DE IVA','111000010001','513000010001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'CONTRATO DE AGUA','111000010001','51200072')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'TRAS X DEPOSITO MAL APLICADO -PREDIALES','111000010001','211000010003')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'TRAS X DEPOSITO MAL APLICADO','111000010001','211000010004')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'CONTRATO DE AGUA','111000010001','51200072')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'CANCELACION DE CH CERTIFICADO','111000010001','211000010004')


INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'PAGO CAPITAL BANCOMER','111000010001','230000010002')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'DISPOSICION CAPITAL BANCOMER','230000010002','111000010001')	


INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'CHEQUE CANCELADO CLIENTES','111000010001','11000001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'CHEQUE CANCELADO PROVEEDORES Y SERVICIOS','111000010001','211000010004')

INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'TRASPASO ENTRE CUENTAS BANCOMER A BANORTE','111000010001','111000060001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'TRASPASO ENTRE CUENTAS BANCOMER A INVERLAT','111000010001','111000040001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'TRASPASO ENTRE CUENTAS BANCOMER A BANAMEX','111000010001','111000020001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,201,'TRASPASO ENTRE CUENTAS BANAMEX A BANCOMER','111000020001','111000040001')

--INVERLAT
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,401,'INTERESES','111000040001','513000010002')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,401,'ISR','513000010001','111000040001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,401,'BANCA ELECTRONICA','513000010001','111000040001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,401,'IVA X COMISION','513000010001','111000040001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,401,'IVA','513000010001','111000040001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,401,'COMISION POR SPEI','513000010001','111000040001')

--banorte
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,601,'COMISION POR SPEI','513000010001','111000060001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,601,'BANCA ELECTRONICA','513000010001','111000060001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,601,'IVA X COMISION','513000010001','111000060001')

--bajio
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,801,'COMISION CHEQUE CERTF','513000010001','111000070001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,801,'COM. CIE','513000010001','111000070001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,801,'BANCA ELECTRONICA','513000010001','111000070001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,801,'IVA X COMISION','513000010001','111000070001')

--banorte
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,601,'COMISION POR SPEI','513000010001','111000060001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,601,'BANCA ELECTRONICA','513000010001','111000060001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,601,'IVA X COMISION','513000010001','111000060001')


INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'APORTACIONES FUT AUM DE CAP MC A MD','11750005','111000010001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'PAGO APORTACIONES FUT AUM DE CAP MC A MD','111000010001','11750005')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'APORTACION A FUT AUM DE CAPITAL MAPLE A MD','111000010001','26100003')	



INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,501,'DISPOSICION DE CREDITO','1110005','230000050002')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'COMISIONES BANCARIAS','111000010001','513000010002')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'PAGO DE PREDIAL','111000010001','311000020002')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'INTERESES','111000010001','513000010002')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'INTERESES BANCOMER','513000010002','111000010001')

INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'COMISION POR CHEQUE EXP','513000010001','111000010001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'IVA X COMISION','513000010001','111000010001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'COMISION POR CHEQUE CERTIFICADO','513000010001','111000010001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,901,'COMISION POR CHEQUE CERTIFICADO','513000010001','111000080001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,901,'IVA X COMISION','513000010001','111000080001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(3,901,'BANCA ELECTRONICA','513000010001','111000080001')	
	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,501,'COM. X SPEI','513000010001','111000050001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,801,'BANCA ELECTRONICA','513000010001','111000070001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,801,'IVA X COMISION','513000010001','111000070001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,801,'COMISION POR BANCA ELECTRONICA','513000010001','111000070001')	
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'TRASPASO ENTRE CUENTAS','111000010001','111000050002')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'CHEQUE CANCELADO','111000010001','211000010003')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,501,'INTERES POR CREDITO BANREGIO','513000050002','111000050001')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,501,'DISPOSICION DE CREDITO','111000050001','230000050002')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'LIQUIDACION DE FACTURAS','111000010001','115000050007')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'SOBRANTE DE CH-','111000010001','211000010003')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,101,'TRANSFERENCIA CANCELADA','111000010001','211000010003')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,501,'ABONO CAPITAL BANREGIO ','230000050002','111000050002')
INSERT INTO tbConceptosIngreso(intEmpresa,intCuentaBancaria,strConcepto,strCuentaCargo,strCuentaAbono) 
VALUES(2,501,'CARGO CAPITAL BANREGIO ','111000050002','230000050002')

PAGO
DISPOSICION
--ENTREGA A CTA DE CHEQUES
--ENTREGA A MESA DE DINERO


select intEmpresa,intCuentaBancaria,strConcepto,'''' + strCuentaCargo,'''' +strCuentaAbono 
from tbConceptosIngreso 
where intEmpresa = 3
ORDER BY intEmpresa,intCuentaBancaria





select * from tbConceptosIngreso where intempresa = 4 AND strConcepto = 'ISR' and intCuentaBancaria = 501 and intConcepto = 242


UPDATE tbConceptosIngreso SET strCuentaCargo= '11100001'  where intempresa = 24 AND strCuentaCargo = '111000010001'
5130000010001
51300000001

select * from tbConceptosIngreso where intempresa = 24 AND strCuentaAbono NOT IN(SELECT strCuenta FROM tbCuentas WHERE intEmpresa = 24)
select * from tbConceptosIngreso where intempresa = 24 AND strCuentaCargo NOT IN(SELECT strCuenta FROM tbCuentas WHERE intEmpresa = 24)








http://192.168.100.10/Contabilidad/Utils/CRViewer.aspx?type=pdf&report=Pages/Reportes/Polizas/Poliza.rpt&db=VetecMarfilAdmin&parameters=1[--]2017[--]11[--]0[--]0[--]0[--]0[--]1[--]1[--]1[--]1[--]0&Titulos=Reporte de Pólizas|