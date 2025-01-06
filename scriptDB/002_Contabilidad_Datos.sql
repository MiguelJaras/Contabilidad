
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
---  Aplicacion:  PM.                                                      ---
---  RBDMS:       Miscrosoft SQL Server 2005.                               ---
---  Archivo:     002_PM_Datos.sql                                         ---
---  Descripcion: Script para carga inicial de informacion.                 ---
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
---                                                                         ---
---  001.- noCount                                                          ---
---                                                                         ---
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


-- Cambie el nombre la de base de datos
use dbDigitalizacion
go


SET IDENTITY_INSERT [tbRol] ON
GO


INSERT INTO [tbRol] ([intRol], [strNombre], [bActivo])
VALUES (1, 'Administrador', 1)
GO

INSERT INTO [tbRol] ([intRol], [strNombre], [bActivo])
VALUES (2, 'Operacion', 1)
GO


SET IDENTITY_INSERT [tbRol] OFF
GO


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

--INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
--VALUES (65, 'Empresas', '~/Pages/Contabilidad/Catalogos/Empresas.aspx?page=65', 10, 1, '~/Controls/ImgMenu/Folders.jpg')
--GO
--
--INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
--VALUES (66, 'Estados Financieros', '~/Pages/Contabilidad/Catalogos/EdoFinancieroRubros.aspx?page=66', 10, 1, '~/Controls/ImgMenu/Folders.jpg')
--GO
--
--INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
--VALUES (67, 'Contabilización Insumo', '~/Pages/Contabilidad/Catalogos/CuentasRet.aspx?page=67', 10, 1, '~/Controls/ImgMenu/Folders.jpg')
--GO

INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (68, 'Auxiliar Orden Compra', '~/Pages/Reportes/SaldoClientes/SaldoClientes.aspx?page=68', 12, 1, '~/Controls/ImgMenu/Folders.jpg')
GO

INSERT INTO [tbMenuConta] ([intMenu], [strNombre], [strPagina], [intParentMenu], [SortOrder], [Icon])
VALUES (69, 'Auxiliar de Movimientos', '~/Pages/Reportes/Auxiliar/Auxiliar.aspx?page=69', 12, 1, '~/Controls/ImgMenu/Folders.jpg')
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
INSERT INTO [tbMenuRol] ([intMenu], [intRol])
VALUES (1, 1)
GO

INSERT INTO [tbMenuRol] ([intMenu], [intRol])
VALUES (2, 1)
GO

INSERT INTO [tbMenuRol] ([intMenu], [intRol])
VALUES (3, 1)
GO

INSERT INTO [tbMenuRol] ([intMenu], [intRol])
VALUES (20, 1)
GO

INSERT INTO [tbMenuRol] ([intMenu], [intRol])
VALUES (21, 1)
GO

INSERT INTO [tbMenuRol] ([intMenu], [intRol])
VALUES (22, 1)
GO

INSERT INTO [tbMenuRol] ([intMenu], [intRol])
VALUES (23, 1)
GO

INSERT INTO [tbMenuRol] ([intMenu], [intRol])
VALUES (24, 1)
GO

INSERT INTO [tbMenuRol] ([intMenu], [intRol])
VALUES (25, 1)
GO

INSERT INTO [tbMenuRol] ([intMenu], [intRol])
VALUES (26, 1)
GO

INSERT INTO [tbMenuRol] ([intMenu], [intRol])
VALUES (27, 1)
GO

INSERT INTO [tbMenuRol] ([intMenu], [intRol])
VALUES (100, 1)
GO

INSERT INTO [tbMenuRol] ([intMenu], [intRol])
VALUES (101, 1)
GO

INSERT INTO [tbMenuRol] ([intMenu], [intRol])
VALUES (150, 1)
GO

INSERT INTO [tbMenuRol] ([intMenu], [intRol])
VALUES (151, 1)
GO

INSERT INTO [tbMenuRol] ([intMenu], [intRol])
VALUES (152, 1)
GO

INSERT INTO [tbMenuRol] ([intMenu], [intRol])
VALUES (153, 1)
GO

INSERT INTO [tbMenuRol] ([intMenu], [intRol])
VALUES (300, 1)
GO

INSERT INTO [tbMenuRol] ([intMenu], [intRol])
VALUES (350, 1)
GO

INSERT INTO [tbMenuRol] ([intMenu], [intRol])
VALUES (351, 1)
GO

INSERT INTO [tbMenuRol] ([intMenu], [intRol])
VALUES (352, 1)
GO

SET IDENTITY_INSERT [tbUsuarios] ON
GO

INSERT INTO dbo.tbUsuarios (intUsuario, strClave, strNombre, strEmail, intRol, bActivo)
Values
(1, '141', 'Cesar Leal', 'cesarleal@marfil.com', 1, 1)
GO

SET IDENTITY_INSERT [tbUsuarios] OFF
GO