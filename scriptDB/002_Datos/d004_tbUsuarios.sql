SET IDENTITY_INSERT [tbUsuarios] ON
GO

INSERT INTO dbo.tbUsuarios (intUsuario, strClave, strNombre, strEmail, intRol, bActivo)
Values
(1, '141', 'Cesar Leal', 'cesarleal@marfil.com', 1, 1)
GO

SET IDENTITY_INSERT [tbUsuarios] OFF
GO