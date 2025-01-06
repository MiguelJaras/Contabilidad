
--SELECT * FROM tbMenuConta

DELETE FROM tbMenuConta


--*****Header*****---
INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (1, 'Contabilidad', NULL, NULL, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

--*****Conta*****---
INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (10, 'Catálogos', NULL, 1, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (11, 'Opciones', NULL, 1, 2, '~/Controls/ImgMenu/user.PNG')
GO

INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (12, 'Reportes', NULL, 1,3, '~/Controls/ImgMenu/user.PNG')
GO

INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (13, 'SAT', NULL, 1,4, '~/Controls/ImgMenu/user.PNG')
GO

--******Conta - Catalogos
INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (50, 'Admon Polizas', '~/Pages/Contabilidad/Catalogos/AdmonPolizas.aspx?page=50', 10, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

--******Conta - Catalogos
INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (51, 'Estructura de Polizas', '~/Pages/Contabilidad/Catalogos/EstructuraPolizas.aspx?page=51', 10, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

--******Conta - Catalogos
INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (55, 'Cuentas', '~/Pages/Contabilidad/Catalogos/Cuentas.aspx?page=55', 10, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

--******Conta - Catalogos
INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (52, 'Clientes', '~/Pages/Reportes/Clientes/Clientes.aspx?page=52', 12, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

--******Conta - Catalogos
INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (53, 'Conciliaciones', '~/Pages/Reportes/Conciliaciones/Conciliaciones.aspx?page=53', 12, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (54, 'Balanza de Comprobación', '~/Pages/Reportes/Balanza/Balanza.aspx?page=54', 12, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (56, 'Iva', '~/Pages/Reportes/Iva/Iva.aspx?page=56', 12, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

--******Conta - Catalogos
INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (57, 'Afectación de Saldos', '~/Pages/Contabilidad/Opciones/Afectacion.aspx?page=57', 11, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (58, 'Pólizas', '~/Pages/Reportes/Polizas/Polizas.aspx?page=58', 12, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (59, 'Balance General', '~/Pages/Reportes/Balance/BalanceGral.aspx?page=59', 12, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (60, 'Estado de Resultados', '~/Pages/Reportes/EstadoResultados/EstadoResultados.aspx?page=60', 12, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

update tbMenuConta set strNombre = 'Estado de Resultados por Colonia' where intMenu =60

INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (61, 'Calculo de Iva', '~/Pages/Contabilidad/Opciones/CalculoIva.aspx?page=61', 11, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (62, 'Captura de Pólizas', '~/Pages/Contabilidad/Opciones/Polizas.aspx?page=62', 11, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (63, 'Rubros', '~/Pages/Contabilidad/Catalogos/Rubros.aspx?page=63', 10, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (64, 'Rubros Cuentas', '~/Pages/Contabilidad/Catalogos/RubrosCuentas.aspx?page=64', 10, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (65, 'Estado de Resultados', '~/Pages/Reportes/Estado/Estado.aspx?page=65', 12, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

--INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
--VALUES (65, 'Empresas', '~/Pages/Contabilidad/Catalogos/Empresas.aspx?page=65', 10, 1, '~/Controls/ImgMenu/Folders.jpg')
--GO
--
--INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
--VALUES (66, 'Estados Financieros', '~/Pages/Contabilidad/Catalogos/EdoFinancieroRubros.aspx?page=66', 10, 1, '~/Controls/ImgMenu/Folders.jpg')
--GO
--
INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (67, 'Contabilización Insumo', '~/Pages/Contabilidad/Catalogos/CuentasRet.aspx?page=67', 10, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (68, 'Auxiliar Orden Compra', '~/Pages/Reportes/SaldoClientes/SaldoClientes.aspx?page=68', 12, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (69, 'Auxiliar de Movimientos', '~/Pages/Reportes/Auxiliar/AuxiliarMensual.aspx?page=69', 12, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (70, 'Escrituracion', '~/Pages/Contabilidad/Opciones/Escrituracion.aspx?page=70', 11, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (71, 'Polizas Inventario', '~/Pages/Contabilidad/Opciones/PolizaInventario.aspx?page=71', 11, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (72, 'Cierre Periodo', '~/Pages/Contabilidad/Opciones/CerrarPeriodo.aspx?page=72', 11, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (73, 'Carga Poliza', '~/Pages/Contabilidad/Opciones/CargaPoliza.aspx?page=73', 11, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

--INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
--VALUES (73, 'Carga Poliza', '~/Pages/Contabilidad/Opciones/CargaPoliza.aspx?page=73', 11, 1, '~/Controls/ImgMenu/Folders.jpg')
--GO

INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (74, 'Saldos Iniciales', '~/Pages/Contabilidad/Opciones/SaldosIniciales.aspx?page=74', 11, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (77, 'Reemplazo Poliza', '~/Pages/Contabilidad/Opciones/UpdatePoliza.aspx?page=77', 11, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (78, 'Poliza de Iva', '~/Pages/Contabilidad/Opciones/PolizaIva.aspx?page=78', 11, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (81, 'Datos Para Facturación', '~/Pages/Contabilidad/Opciones/Facturacion.aspx?page=81', 11, 1, '~/Controls/ImgMenu/Folders.jpg')
GO


select * from tbMenuConta WHERE INTMENU = 102


--******Conta - Catalogos
INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (75, 'Saldo Clientes', '~/Pages/Reportes/Clientes/Saldos.aspx?page=76', 12, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (76, 'Libro Mayor', '~/Pages/Reportes/LibroMayor/Libro.aspx?page=75', 12, 2, '~/Controls/ImgMenu/Folders.jpg')
GO

INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (80, 'Relacion OC Factura', '~/Pages/Reportes/RelacionOCF/RelacionOCFactura.aspx?page=80', 12, 2, '~/Controls/ImgMenu/Folders.jpg')
GO


--******XML
INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (100, 'Balanza XML', '~/Pages/Contabilidad/SAT/Balanza.aspx?page=100', 13, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (101, 'Cuentas XML', '~/Pages/Contabilidad/SAT/Cuentas.aspx?page=101', 13, 2, '~/Controls/ImgMenu/Folders.jpg')
GO
