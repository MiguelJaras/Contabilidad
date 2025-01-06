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

