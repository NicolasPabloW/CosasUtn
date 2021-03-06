USE GD1C2020
GO

/* Se verifica si existe el esquema y sino lo crea  */

DECLARE @grupo VARCHAR(50)= 'THUNDERCATS'
IF NOT EXISTS (SELECT * FROM sys.schemas AS sc WHERE sc.name=@grupo)
BEGIN
	PRINT 'Creando esquema... '+@grupo
	EXEC('CREATE SCHEMA '+@grupo)
	END
ELSE
	PRINT 'esquema '+@grupo+' YA EXISTE'
GO

/* Se verifica si existe procedimiento checkProced y lo borra */

IF EXISTS (SELECT * FROM sysobjects AS so WHERE so.id = object_id(N'[dbo].[checkProced]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
BEGIN
	PRINT 'Eliminando procedure... checkProced'
	EXEC('DROP PROCEDURE [dbo].[checkProced]')
END
GO

/* Se verifica si existe determinado procedimiento en un esquema y lo borra */

CREATE PROCEDURE checkProced(@esquema VARCHAR(50), @proc VARCHAR(50))
AS
IF EXISTS (SELECT * FROM sysobjects AS so where so.id = object_id(@esquema+'.'+@proc) and OBJECTPROPERTY(id, N'IsProcedure') = 1)
BEGIN
	PRINT 'Eliminando procedure... '+@proc
	EXEC('DROP PROCEDURE '+@esquema+'.'+@proc)
END
ELSE
	PRINT 'procedure '+@esquema+'.'+@proc+' NO EXISTE';
GO

/*Se verifica la existencia del procedimiento checkTabla */

DECLARE @grupo VARCHAR(50)= 'THUNDERCATS'
EXEC checkProced @grupo,'checkTabla'
GO

/*Se define este procedimiento , el cual verifica la existencia de una tabla en un esquema  */

CREATE PROCEDURE THUNDERCATS.checkTabla(@esquema VARCHAR(50), @tabla VARCHAR(50))
AS
IF EXISTS (SELECT * FROM sys.objects AS so WHERE so.object_id = OBJECT_ID(@esquema+'.'+@tabla) AND type IN (N'U'))
	BEGIN
		PRINT 'Eliminando tabla '+@esquema+'.'+@tabla;
		EXEC('DROP TABLE '+@esquema+'.'+@tabla);
	END
ELSE
	PRINT 'tabla '+@esquema+'.'+@tabla+' NO EXISTE';
GO

/* Se verifica la existencia del procedimiento crearEntidades*/

DECLARE @grupo VARCHAR(50)= 'THUNDERCATS'
EXEC checkProced @grupo,'crearEntidades'
GO

/*Se define este procedimiento , el cual crea las tablas de nuestro modelo con sus atributos y define , en cada una , cual es su PK */

CREATE PROCEDURE THUNDERCATS.crearEntidades(@sch VARCHAR(50))
AS
BEGIN
/*Crea e inicializa un string corto donde se cargara el nombre de la tabla a crear para usarlo en la sentencia que la crea y en el mensaje que se imprime*/
DECLARE @tab VARCHAR(50) = 'Ciudad';
/*Crea un string en el que se cargaran las sentencias SQL que crearan las tablas*/
DECLARE @SQL NVARCHAR(MAX);
/*1*/ /*Copia en el string la sentencia que crea la tabla Ciudad , sus atributos y define uno como su PK*/
SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
  CIUDAD_ID NVARCHAR(255) PRIMARY KEY
  );';
/*Avisa que se creara la tabla Ciudad*/
PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/
/*Carga el String corto con el nombre de la siguiente tabla a crear */
SELECT @tab = 'Compra';
/* Copia en el string la sentencia que crea la tabla Compra  , sus atributos y define uno como su PK*/
SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
  COMPRA_NUMERO DECIMAL(18, 0) PRIMARY KEY,
  COMPRA_FECHA DATETIME2(3) NULL
  );';
/*Avisa que se creara la tabla Compra*/
PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/
/*Carga el String corto con el nombre de la siguiente tabla a crear */
SELECT @tab = 'Empresa';
/*Copia en el string la sentencia que crea la tabla Empresa  , sus atributos y define uno como su PK*/
SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
  EMPRESA_ID INT PRIMARY KEY IDENTITY(1,1),
  EMPRESA_RAZON_SOCIAL NVARCHAR(255) NULL
  );';
/*Avisa que se creara la tabla Empresa*/
PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/
/*Carga el String corto con el nombre de la siguiente tabla a crear */
SELECT @tab = 'Butaca';
/*Copia en el string la sentencia que crea la tabla Butaca  , sus atributos y define uno como su PK*/
SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
  BUTACA_NUMERO DECIMAL(18, 0),
  BUTACA_TIPO NVARCHAR(255),
  CONSTRAINT PK_BUTACA PRIMARY KEY (BUTACA_NUMERO,BUTACA_TIPO) 
  );';
/*Avisa que se creara la tabla Butaca*/
PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargado en el string*/
/*Carga el String corto con el nombre de la siguiente tabla a crear */
SELECT @tab = 'Avion';
/*Copia en el string la sentencia que crea la tabla Avion  , sus atributos y define uno como su PK*/
SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
  AVION_IDENTIFICADOR NVARCHAR(50) PRIMARY KEY,
  AVION_MODELO NVARCHAR(50) NULL,
  );';
/*Avisa que se creara la tabla Avion*/
PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/
/*Carga el String corto con el nombre de la siguiente tabla a crear */
SELECT @tab = 'TipoHabitacion';
/*Copia en el string la sentencia que crea la tabla TipoHabitacion  , sus atributos y define uno como su PK*/
SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
  TIPO_HABITACION_CODIGO DECIMAL(18, 0) PRIMARY KEY,
  TIPO_HABITACION_DESC NVARCHAR(50) NULL
  );';
/*Avisa que se creara la tabla TipoHabitacion*/
PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/

/*Carga el String corto con el nombre de la siguiente tabla a crear */
SELECT @tab = 'Sucursal';
/*Copia en el string la sentencia que crea la tabla Sucursal  , sus atributos y define uno como su PK*/
SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
  SUCURSAL_DIR NVARCHAR(255) PRIMARY KEY,
  SUCURSAL_MAIL NVARCHAR(255) NULL,
  SUCURSAL_TELEFONO DECIMAL(18, 0) NULL
  );';
/*Avisa que se creara la tabla Sucursal*/
PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/

/*Carga el String corto con el nombre de la siguiente tabla a crear */
SELECT @tab = 'Cliente';
/*Copia en el string la sentencia que crea la tabla Cliente  , sus atributos y define uno como su PK*/
SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
  CLIENTE_ID INT PRIMARY KEY IDENTITY(1,1),
  CLIENTE_DNI DECIMAL(18, 0) NULL,
  CLIENTE_NOMBRE NVARCHAR(255) NULL,
  CLIENTE_APELLIDO NVARCHAR(255) NULL,
  CLIENTE_MAIL NVARCHAR(255) NULL,
  CLIENTE_FECHA_NAC datetime2(3) NULL,
  CLIENTE_TELEFONO INT NULL
  );';
/*Avisa que se creara la tabla Cliente*/
PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/

/*2*/ /*Carga el String corto con el nombre de la siguiente tabla a crear */
SELECT @tab = 'Factura';
/*Copia en el string la sentencia que crea la tabla Factura , sus atributos y define uno como su PK*/
SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
  FACTURA_NRO DECIMAL(18, 0) PRIMARY KEY,
  FACTURA_FECHA DATETIME2(3) NULL,
  CLIENTE_ID INT REFERENCES '+@sch+'.Cliente,
  SUCURSAL_DIR NVARCHAR(255) REFERENCES '+@sch+'.Sucursal,
  );';
/*Avisa que se creara la tabla Factura*/
PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/

/*Carga el String corto con el nombre de la siguiente tabla a crear */
SELECT @tab = 'Ruta';
/*Copia en el string la sentencia que crea la tabla Ruta , sus atributos y define uno como su PK*/
SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
  RUTA_ID INT PRIMARY KEY IDENTITY(1,1),
  RUTA_AEREA_CODIGO DECIMAL(18, 0) NULL,
  RUTA_AEREA_CIU_ORIG NVARCHAR(255) REFERENCES '+@sch+'.Ciudad,
  RUTA_AEREA_CIU_DEST NVARCHAR(255) REFERENCES '+@sch+'.Ciudad,
  CONSTRAINT CK_DISTINTA_CIU CHECK(RUTA_AEREA_CIU_ORIG <> RUTA_AEREA_CIU_DEST)	
  );';
/*Avisa que se creara la tabla Ruta*/
PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/

/*Carga el String corto con el nombre de la siguiente tabla a crear */
SELECT @tab = 'ButacaAvion';
/*Copia en el string la sentencia que crea la tabla ButacaAvion , sus atributos y define uno como su PK*/
SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
  BUTACA_NUMERO DECIMAL(18, 0),
  BUTACA_TIPO NVARCHAR(255),
  AVION_IDENTIFICADOR NVARCHAR(50),
  CONSTRAINT PK_BUTACA_AVION PRIMARY KEY (BUTACA_NUMERO,BUTACA_TIPO,AVION_IDENTIFICADOR),
  CONSTRAINT FK_BUTACA FOREIGN KEY (BUTACA_NUMERO,BUTACA_TIPO) REFERENCES '+@sch+'.Butaca,
  CONSTRAINT FK_AVION FOREIGN KEY (AVION_IDENTIFICADOR) REFERENCES '+@sch+'.Avion
  );';
/*Avisa que se creara la tabla ButacaAvion */
PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/

/*3*/ /*Carga el String corto con el nombre de la siguiente tabla a crear */
SELECT @tab = 'Vuelo';
/*Copia en el string la sentencia que crea la tabla Vuelo , sus atributos y define uno como su PK*/
SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
  VUELO_CODIGO DECIMAL(19, 0) PRIMARY KEY,
  VUELO_FECHA_SALUDA datetime2(3) NULL,
  VUELO_FECHA_LLEGADA datetime2(3) NULL,
  EMPRESA_ID INT REFERENCES '+@sch+'.Empresa,
  AVION_IDENTIFICADOR NVARCHAR(50) REFERENCES '+@sch+'.Avion,
  RUTA_ID INT REFERENCES '+@sch+'.Ruta,
  );';
/*Avisa que se creara la tabla Vuelo*/
PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/

/*Carga el String corto con el nombre de la siguiente tabla a crear */
SELECT @tab = 'Hotel';
/*Copia en el string la sentencia que crea la tabla Hotel , sus atributos y define uno como su PK*/
SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
  HOTEL_ID INT PRIMARY KEY IDENTITY(1,1),						
  HOTEL_CALLE NVARCHAR(50) NULL,
  HOTEL_NRO_CALLE DECIMAL(18, 0) NULL,
  HOTEL_CANTIDAD_ESTRELLAS DECIMAL(18, 0) NULL,
  EMPRESA_ID INT REFERENCES '+@sch+'.Empresa
  );';
/*Avisa que se creara la Hotel */
PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/

/*4*/ /*Carga el String corto con el nombre de la siguiente tabla a crear */
SELECT @tab = 'Pasaje';
/*Copia en el string la sentencia que crea la tabla Pasaje , sus atributos y define uno como su PK*/
SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
  PASAJE_CODIGO DECIMAL(18, 0) PRIMARY KEY,
  PASAJE_COSTO DECIMAL(18, 2) NULL,
  PASAJE_PRECIO DECIMAL(18, 2) NULL,
  BUTACA_NUMERO DECIMAL(18, 0) NULL,
  BUTACA_TIPO NVARCHAR(255) NULL,
  VUELO_CODIGO DECIMAL(19, 0) REFERENCES '+@sch+'.Vuelo,
  COMPRA_NUMERO DECIMAL(18, 0) REFERENCES '+@sch+'.Compra,
  FACTURA_NRO DECIMAL(18, 0) REFERENCES '+@sch+'.Factura,
  CONSTRAINT FK_BUTACA_PASAJE FOREIGN KEY (BUTACA_NUMERO,BUTACA_TIPO) REFERENCES '+@sch+'.Butaca
  );';
/*Avisa que se creara la tabla Pasaje*/
PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada  en el string*/

/*Carga el String corto con el nombre de la siguiente tabla a crear */
SELECT @tab = 'Detalle';
/*Copia en el string la sentencia que crea la tabla Detalle , sus atributos y define uno como su PK*/
SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
  DETALLE_ID INT PRIMARY KEY IDENTITY(1,1),
  HABITACION_PRECIO DECIMAL(18, 2) NULL,		
  HABITACION_COSTO DECIMAL(18, 2) NULL,				
  HABITACION_NUMERO DECIMAL(18, 0) NULL,		
  HABITACION_FRENTE NVARCHAR(50) NULL,			
  HABITACION_PISO DECIMAL(18, 0) NULL,			
  HOTEL_ID INT REFERENCES '+@sch+'.Hotel,						
  HOTEL_CALLE NVARCHAR(50) NULL,
  HOTEL_NRO_CALLE DECIMAL(18, 0) NULL,
  TIPO_HABITACION_CODIGO DECIMAL(18, 0) REFERENCES '+@sch+'.TipoHabitacion
  );';
/*Avisa que se creara la tabla Detalle*/
PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL; /*Ejecuta la sentencia cargada en el string*/

/*5*/ /*Carga el String corto con el nombre de la siguiente tabla a crear */
SELECT @tab = 'Estadia';
/*Copia en el string la sentencia que crea la tabla Estadia , sus atributos y define uno como su PK*/
SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
  ESTADIA_CODIGO DECIMAL(18, 0) PRIMARY KEY,
  ESTADIA_FECHA_INI DATETIME2(3) NULL,
  ESTADIA_CANTIDAD_NOCHES DECIMAL(18, 0) NULL,
  COMPRA_NUMERO DECIMAL(18, 0) REFERENCES '+@sch+'.Compra,
  DETALLE_ID INT REFERENCES '+@sch+'.Detalle,
  FACTURA_NRO DECIMAL(18, 0) REFERENCES '+@sch+'.Factura
  );';
/*Avisa que se creara la tabla Estadia*/
PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/
END
GO

/* Se verifica la existencia del procedimiento completandoEntidades */

DECLARE @grupo VARCHAR(50)= 'THUNDERCATS'
EXEC checkProced @grupo,'completandoEntidades'
GO

/*Se define este procedimiento , el cual hace un inserts masivos para pasar los datos de la tabla maestra del modelo anterior a las tablas
 de nuestro modelo */

CREATE PROCEDURE THUNDERCATS.completandoEntidades(@sch VARCHAR(50))
AS
BEGIN
/*Crea e inicializa un string corto donde se cargara el nombre de la tabla a cargar para usarlo en la sentencia que la carga y en el mensaje que se imprime*/
DECLARE @tab VARCHAR(50) = 'Ciudad';
DECLARE @SQL NVARCHAR(MAX);/*Crea un string en el que se cargaran las sentencias SQL que cargaran las tablas*/
/********************************/
/************	1	*************/
/********************************/
/*Copia en el string la sentencia que carga la tabla Ciudad con los datos correspondientes obtenidos de la tabla maestra con un SELECT*/
SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (CIUDAD_ID)
   SELECT DISTINCT m.RUTA_AEREA_CIU_DEST AS CIUDAD_ID
   FROM gd_esquema.Maestra m
   WHERE m.RUTA_AEREA_CIU_DEST IS NOT NULL
   UNION
   SELECT DISTINCT m.RUTA_AEREA_CIU_ORIG AS CIUDAD_ID
   FROM gd_esquema.Maestra m
   WHERE m.RUTA_AEREA_CIU_ORIG IS NOT NULL;';
/*Avisa que se esta cargando la tabla Ciudad*/
PRINT 'Completando el cargado de la tabla '+ @tab + '...';
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/
/*Carga el String corto con el nombre de la siguiente tabla a cargar */
SELECT @tab = 'Compra';
/*Copia en el string la sentencia que carga la tabla Compra con los datos correspondientes obtenidos de la tabla maestra con un SELECT*/
SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (COMPRA_NUMERO,COMPRA_FECHA)
	SELECT DISTINCT m.COMPRA_NUMERO, m.COMPRA_FECHA
	FROM gd_esquema.Maestra m
	WHERE m.COMPRA_NUMERO IS NOT NULL;';
/*Avisa que se esta cargando la tabla Compra*/
PRINT 'Completando el cargado de la tabla '+ @tab + '...';
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/
/*Carga el String corto con el nombre de la siguiente tabla a cargar */
SELECT @tab = 'Empresa';
/*Copia en el string la sentencia que carga la tabla Empresa con los datos correspondientes obtenidos de la tabla maestra con un SELECT*/
SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (EMPRESA_RAZON_SOCIAL)
	SELECT DISTINCT sm.EMPRESA_RAZON_SOCIAL
	FROM gd_esquema.Maestra sm
	WHERE sm.EMPRESA_RAZON_SOCIAL IS NOT NULL;';
/*Avisa que se esta cargando la tabla Empresa*/
PRINT 'Completando el cargado de la tabla '+ @tab + '...';
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/
/*Carga el String corto con el nombre de la siguiente tabla a cargar */
SELECT @tab = 'Butaca';
/*Copia en el string la sentencia que carga la tabla Butaca con los datos correspondientes obtenidos de la tabla maestra con un SELECT*/
SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (BUTACA_NUMERO,BUTACA_TIPO)
	SELECT DISTINCT m.BUTACA_NUMERO,m.BUTACA_TIPO
	FROM gd_esquema.Maestra m
	WHERE m.BUTACA_TIPO IS NOT NULL AND m.BUTACA_NUMERO IS NOT NULL;';
/*Avisa que se esta cargando la tabla Butaca*/
PRINT 'Completando el cargado de la tabla '+ @tab + '...';
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/
/*Carga el String corto con el nombre de la siguiente tabla a cargar */
SELECT @tab = 'Avion';
/*Copia en el string la sentencia que carga la tabla Avion con los datos correspondientes obtenidos de la tabla maestra con un SELECT*/
SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (AVION_IDENTIFICADOR,AVION_MODELO)
	SELECT DISTINCT sm.AVION_IDENTIFICADOR, sm.AVION_MODELO
	FROM gd_esquema.Maestra sm 
	WHERE sm.AVION_IDENTIFICADOR IS NOT NULL;';
/*Avisa que se esta cargando la tabla Avion*/
PRINT 'Completando el cargado de la tabla '+ @tab + '...';
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/
/*Carga el String corto con el nombre de la siguiente tabla a cargar */
SELECT @tab = 'TipoHabitacion';
/*Copia en el string la sentencia que carga la tabla TipoHabitacion con los datos correspondientes obtenidos de la tabla maestra con un SELECT*/
SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (TIPO_HABITACION_CODIGO,TIPO_HABITACION_DESC)
	SELECT DISTINCT sm.TIPO_HABITACION_CODIGO, sm.TIPO_HABITACION_DESC
	FROM gd_esquema.Maestra sm
	WHERE sm.TIPO_HABITACION_CODIGO IS NOT NULL AND sm.TIPO_HABITACION_DESC IS NOT NULL
	ORDER BY sm.TIPO_HABITACION_CODIGO;';
/*Avisa que se esta cargando la tabla TipoHabitacion*/
PRINT 'Completando el cargado de la tabla '+ @tab + '...';
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/

/*Carga el String corto con el nombre de la siguiente tabla a cargar */
SELECT @tab = 'Sucursal';
/*Copia en el string la sentencia que carga la tabla Sucursal con los datos correspondientes obtenidos de la tabla maestra con un SELECT*/
SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (SUCURSAL_DIR,SUCURSAL_MAIL,SUCURSAL_TELEFONO)
	SELECT DISTINCT sm.SUCURSAL_DIR, sm.SUCURSAL_MAIL, sm.SUCURSAL_TELEFONO
	FROM gd_esquema.Maestra sm
	WHERE sm.SUCURSAL_DIR IS NOT NULL;';
/*Avisa que se esta cargando la tabla Sucursal*/
PRINT 'Completando el cargado de la tabla '+ @tab + '...';
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/

/*Carga el String corto con el nombre de la siguiente tabla a cargar */
SELECT @tab = 'Cliente';
/*Copia en el string la sentencia que carga la tabla Cliente con los datos correspondientes obtenidos de la tabla maestra con un SELECT*/
SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (CLIENTE_DNI,CLIENTE_NOMBRE,CLIENTE_APELLIDO,CLIENTE_MAIL,CLIENTE_FECHA_NAC,CLIENTE_TELEFONO)
	SELECT DISTINCT sm.CLIENTE_DNI, sm.CLIENTE_NOMBRE, sm.CLIENTE_APELLIDO,sm.CLIENTE_MAIL, sm.CLIENTE_FECHA_NAC, sm.CLIENTE_TELEFONO
	FROM gd_esquema.Maestra sm
	WHERE sm.CLIENTE_DNI IS NOT NULL
	ORDER BY sm.CLIENTE_DNI;';
/*Avisa que se esta cargando la tabla Cliente*/
PRINT 'Completando el cargado de la tabla '+ @tab + '...';
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/

/********************************/
/************	2	*************/
/********************************/
SELECT @tab = 'Factura';/*Carga el String corto con el nombre de la siguiente tabla a cargar */
/*Copia en el string la sentencia que carga la tabla Factura con los datos correspondientes obtenidos de la tabla maestra con un SELECT*/
SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (FACTURA_NRO,FACTURA_FECHA,CLIENTE_ID,SUCURSAL_DIR)
  SELECT m.FACTURA_NRO,m.FACTURA_FECHA, c.CLIENTE_ID,m.SUCURSAL_DIR
  FROM (SELECT DISTINCT m.FACTURA_NRO,m.FACTURA_FECHA, m.CLIENTE_DNI, m.CLIENTE_NOMBRE, m.CLIENTE_APELLIDO,m.CLIENTE_MAIL, m.CLIENTE_FECHA_NAC, m.CLIENTE_TELEFONO,
		m.SUCURSAL_DIR
		FROM gd_esquema.Maestra m
		WHERE m.FACTURA_NRO IS NOT NULL) m
  LEFT JOIN '+@sch+'.Cliente c
  ON c.CLIENTE_DNI=m.CLIENTE_DNI AND c.CLIENTE_NOMBRE=m.CLIENTE_NOMBRE AND c.CLIENTE_APELLIDO=m.CLIENTE_APELLIDO AND c.CLIENTE_MAIL=m.CLIENTE_MAIL 
  AND c.CLIENTE_FECHA_NAC=m.CLIENTE_FECHA_NAC AND c.CLIENTE_TELEFONO=m.CLIENTE_TELEFONO;';
/*Avisa que se esta cargando la tabla Factura*/
PRINT 'Completando el cargado de la tabla '+ @tab + '...';
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/

/*Carga el String corto con el nombre de la siguiente tabla a cargar */
SELECT @tab = 'Ruta';
/*Copia en el string la sentencia que carga la tabla Ruta con los datos correspondientes obtenidos de la tabla maestra con un SELECT*/
SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (RUTA_AEREA_CODIGO,RUTA_AEREA_CIU_ORIG,RUTA_AEREA_CIU_DEST)
	SELECT DISTINCT sm.RUTA_AEREA_CODIGO,sm.RUTA_AEREA_CIU_ORIG,sm.RUTA_AEREA_CIU_DEST
	FROM gd_esquema.Maestra sm
	WHERE sm.RUTA_AEREA_CODIGO IS NOT NULL AND sm.RUTA_AEREA_CIU_ORIG IS NOT NULL AND sm.RUTA_AEREA_CIU_DEST IS NOT NULL;';
/*Avisa que se esta cargando la tabla Ruta*/
PRINT 'Completando el cargado de la tabla '+ @tab + '...';
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/

/*Carga el String corto con el nombre de la siguiente tabla a cargar */
SELECT @tab = 'ButacaAvion';
/*Copia en el string la sentencia que carga la tabla ButacaAvion con los datos correspondientes obtenidos de la tabla maestra con un SELECT*/
SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (BUTACA_NUMERO,BUTACA_TIPO,AVION_IDENTIFICADOR)
	SELECT DISTINCT sm.BUTACA_NUMERO,sm.BUTACA_TIPO,sm.AVION_IDENTIFICADOR
	FROM gd_esquema.Maestra sm
	WHERE sm.FACTURA_NRO IS NULL AND sm.PASAJE_CODIGO IS NOT NULL;';
/*Avisa que se esta cargando la tabla ButacaAvion*/
PRINT 'Completando el cargado de la tabla '+ @tab + '...';
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/

/********************************/
/************	3	*************/
/********************************/
SELECT @tab = 'Vuelo';/*Carga el String corto con el nombre de la siguiente tabla a cargar */
/*Copia en el string la sentencia que carga la tabla Vuelo con los datos correspondientes obtenidos de la tabla maestra con un SELECT*/
SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (VUELO_CODIGO,VUELO_FECHA_SALUDA,VUELO_FECHA_LLEGADA,EMPRESA_ID,/*EMPRESA_RAZON_SOCIAL,*/AVION_IDENTIFICADOR,RUTA_ID/*,RUTA_AEREA_CODIGO,RUTA_AEREA_CIU_ORIG,RUTA_AEREA_CIU_DEST*/)
	SELECT v.VUELO_CODIGO, v.VUELO_FECHA_SALUDA, v.VUELO_FECHA_LLEGADA, e.EMPRESA_ID, /*v.EMPRESA_RAZON_SOCIAL,*/ v.AVION_IDENTIFICADOR, 
	r.RUTA_ID --, v.RUTA_AEREA_CODIGO, v.RUTA_AEREA_CIU_ORIG, v.RUTA_AEREA_CIU_DEST 
	FROM (	SELECT DISTINCT m.VUELO_CODIGO, m.VUELO_FECHA_SALUDA, m.VUELO_FECHA_LLEGADA, m.EMPRESA_RAZON_SOCIAL, m.RUTA_AEREA_CODIGO, m.RUTA_AEREA_CIU_ORIG, m.RUTA_AEREA_CIU_DEST,
			m.AVION_IDENTIFICADOR,m.AVION_MODELO
			FROM gd_esquema.Maestra m
			WHERE m.FACTURA_NRO IS NULL AND m.VUELO_CODIGO IS NOT NULL) v
	LEFT JOIN '+@sch+'.Empresa e
	ON e.EMPRESA_RAZON_SOCIAL = v.EMPRESA_RAZON_SOCIAL
	LEFT JOIN '+@sch+'.Ruta r
	ON r.RUTA_AEREA_CODIGO=v.RUTA_AEREA_CODIGO AND r.RUTA_AEREA_CIU_ORIG=v.RUTA_AEREA_CIU_ORIG AND r.RUTA_AEREA_CIU_DEST=v.RUTA_AEREA_CIU_DEST;';
/*Avisa que se esta cargando la tabla Vuelo*/
PRINT 'Completando el cargado de la tabla '+ @tab + '...';
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/

/*Carga el String corto con el nombre de la siguiente tabla a cargar */
SELECT @tab = 'Hotel';
/*Copia en el string la sentencia que carga la tabla Hotel con los datos correspondientes obtenidos de la tabla maestra con un SELECT*/
SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (HOTEL_CALLE,HOTEL_NRO_CALLE,HOTEL_CANTIDAD_ESTRELLAS,EMPRESA_ID/*,EMPRESA_RAZON_SOCIAL*/)
	SELECT m.HOTEL_CALLE, m.HOTEL_NRO_CALLE, m.HOTEL_CANTIDAD_ESTRELLAS, e.EMPRESA_ID/*, m.EMPRESA_RAZON_SOCIAL*/
	FROM (	SELECT DISTINCT m.HOTEL_CALLE, m.HOTEL_NRO_CALLE,m.HOTEL_CANTIDAD_ESTRELLAS, m.EMPRESA_RAZON_SOCIAL 
			FROM gd_esquema.Maestra m
			WHERE m.FACTURA_NRO IS NULL AND m.HOTEL_CALLE IS NOT NULL ) m
	LEFT JOIN '+@sch+'.Empresa e
	ON e.EMPRESA_RAZON_SOCIAL=m.EMPRESA_RAZON_SOCIAL;';
/*Avisa que se esta cargando la tabla Hotel*/
PRINT 'Completando el cargado de la tabla '+ @tab + '...';
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/

/********************************/
/************	4	*************/
/********************************/
SELECT @tab = 'Pasaje';/*Carga el String corto con el nombre de la siguiente tabla a cargar */
/*Copia en el string la sentencia que carga la tabla Pasaje con los datos correspondientes obtenidos de la tabla maestra con un SELECT*/
SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (PASAJE_CODIGO,PASAJE_COSTO,PASAJE_PRECIO,BUTACA_NUMERO,BUTACA_TIPO,VUELO_CODIGO,COMPRA_NUMERO,FACTURA_NRO)
  SELECT m.PASAJE_CODIGO,m.PASAJE_COSTO,m.PASAJE_PRECIO,m.BUTACA_NUMERO,m.BUTACA_TIPO,m.VUELO_CODIGO,m.COMPRA_NUMERO,f.FACTURA_NRO
  FROM (SELECT DISTINCT m.PASAJE_CODIGO,m.PASAJE_COSTO,m.PASAJE_PRECIO,m.BUTACA_NUMERO,m.BUTACA_TIPO,m.VUELO_CODIGO,m.COMPRA_NUMERO
		FROM gd_esquema.Maestra m
		WHERE m.PASAJE_CODIGO IS NOT NULL AND m.FACTURA_NRO IS NULL) m
  LEFT JOIN(SELECT DISTINCT m.PASAJE_CODIGO,m.FACTURA_NRO
			FROM gd_esquema.Maestra m
			WHERE m.PASAJE_CODIGO IS NOT NULL AND m.FACTURA_NRO IS NOT NULL) f
  ON f.PASAJE_CODIGO=m.PASAJE_CODIGO;';
/*Avisa que se esta cargando la tabla Pasaje*/
PRINT 'Completando el cargado de la tabla '+ @tab + '...';
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/

/*Carga el String corto con el nombre de la siguiente tabla a cargar */
SELECT @tab = 'Detalle';
/*Copia en el string la sentencia que carga la tabla Detalle con los datos correspondientes obtenidos de la tabla maestra con un SELECT*/
SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (HABITACION_PRECIO,HABITACION_COSTO,HABITACION_NUMERO,HABITACION_FRENTE,
  HABITACION_PISO,HOTEL_ID,HOTEL_CALLE,HOTEL_NRO_CALLE,TIPO_HABITACION_CODIGO)
	SELECT m.HABITACION_PRECIO,m.HABITACION_COSTO,m.HABITACION_NUMERO,
	 m.HABITACION_FRENTE,m.HABITACION_PISO,h.HOTEL_ID,m.HOTEL_CALLE,m.HOTEL_NRO_CALLE,
	m.TIPO_HABITACION_CODIGO
	FROM (SELECT DISTINCT m.HABITACION_PRECIO,m.HABITACION_COSTO,m.HABITACION_NUMERO,
		m.HABITACION_FRENTE,m.HABITACION_PISO,m.HOTEL_CALLE,m.HOTEL_NRO_CALLE,
		m.TIPO_HABITACION_CODIGO	 
		FROM gd_esquema.Maestra m
		WHERE m.FACTURA_NRO IS NULL AND m.ESTADIA_CODIGO IS NOT NULL) m
	LEFT JOIN '+@sch+'.Hotel h
	ON h.HOTEL_CALLE=m.HOTEL_CALLE AND h.HOTEL_NRO_CALLE=m.HOTEL_NRO_CALLE;';
/*Avisa que se esta cargando la tabla Detalle*/
PRINT 'Completando el cargado de la tabla '+ @tab + '...';
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/

/*5*/ /*Carga el String corto con el nombre de la siguiente tabla a cargar */
SELECT @tab = 'Estadia';
/*Copia en el string la sentencia que carga la tabla Estadia con los datos correspondientes obtenidos de la tabla maestra con un SELECT*/
SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (ESTADIA_CODIGO,ESTADIA_FECHA_INI,ESTADIA_CANTIDAD_NOCHES,COMPRA_NUMERO,DETALLE_ID,FACTURA_NRO)
  SELECT m.ESTADIA_CODIGO,m.ESTADIA_FECHA_INI,m.ESTADIA_CANTIDAD_NOCHES,m.COMPRA_NUMERO,d.DETALLE_ID,m.FACTURA_NRO
  FROM (SELECT DISTINCT m.ESTADIA_CODIGO, m.ESTADIA_FECHA_INI, m.ESTADIA_CANTIDAD_NOCHES,m.HABITACION_PRECIO,
		m.HABITACION_COSTO,m.HABITACION_NUMERO,m.HABITACION_FRENTE,m.HABITACION_PISO,m.HOTEL_CALLE,m.HOTEL_NRO_CALLE,
		m.TIPO_HABITACION_CODIGO,m.COMPRA_NUMERO, m.FACTURA_NRO
		FROM gd_esquema.Maestra m
		WHERE m.ESTADIA_CODIGO IS NOT NULL AND m.FACTURA_NRO IS NOT NULL) m	/* Se cambio a m.FACTURA_NRO "IS NOT NULL" en lugar IS NULL ya que justo no hay estadia sin vender...*/
  LEFT JOIN '+@sch+'.Detalle d
  ON d.HABITACION_PRECIO=m.HABITACION_PRECIO AND d.HABITACION_COSTO=m.HABITACION_COSTO AND d.HABITACION_NUMERO=m.HABITACION_NUMERO 
  AND d.HABITACION_FRENTE=m.HABITACION_FRENTE AND d.HABITACION_PISO=m.HABITACION_PISO AND d.HOTEL_CALLE=m.HOTEL_CALLE
  AND d.HOTEL_NRO_CALLE=m.HOTEL_NRO_CALLE AND d.TIPO_HABITACION_CODIGO=m.TIPO_HABITACION_CODIGO;';
/*Avisa que se esta cargando la tabla Estadia*/
PRINT 'Completando el cargado de la tabla '+ @tab + '...';
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/
/*Copia en el String sentencia que borra una columna de mas de la tabla Detalle*/
SELECT @SQL = 'ALTER TABLE '+@sch+'.Detalle DROP COLUMN HOTEL_CALLE;';
PRINT 'DROP COLUMN ...'; /*Avisa que esta borrando una columna*/
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/
/*Copia en el String sentencia que borra una columna de mas de la tabla Detalle*/
SELECT @SQL = 'ALTER TABLE '+@sch+'.Detalle DROP COLUMN HOTEL_NRO_CALLE;';
PRINT 'DROP COLUMN ...';/*Avisa que esta borrando una columna*/
EXEC sp_executesql @SQL;/*Ejecuta la sentencia cargada en el string*/
END
GO

/* Se verifica la existencia de cada tabla dentro del esquema   */

DECLARE @grupo VARCHAR(50)= 'THUNDERCATS'
/*5*/
EXEC THUNDERCATS.checkTabla @grupo,'Estadia'
/*4*/
EXEC THUNDERCATS.checkTabla @grupo,'Pasaje'
EXEC THUNDERCATS.checkTabla @grupo ,'Detalle'
/*3*/
EXEC THUNDERCATS.checkTabla @grupo,'Vuelo'
EXEC THUNDERCATS.checkTabla @grupo ,'Hotel'
/*2*/
EXEC THUNDERCATS.checkTabla @grupo,'Ruta'
EXEC THUNDERCATS.checkTabla @grupo ,'Factura'
EXEC THUNDERCATS.checkTabla @grupo ,'ButacaAvion'
/*1*/
EXEC THUNDERCATS.checkTabla @grupo,'Ciudad'
EXEC THUNDERCATS.checkTabla @grupo ,'Compra'
EXEC THUNDERCATS.checkTabla @grupo ,'Empresa'
EXEC THUNDERCATS.checkTabla @grupo ,'Butaca'
EXEC THUNDERCATS.checkTabla @grupo ,'Avion'
EXEC THUNDERCATS.checkTabla @grupo ,'TipoHabitacion'
EXEC THUNDERCATS.checkTabla @grupo ,'Sucursal'
EXEC THUNDERCATS.checkTabla @grupo ,'Cliente'
GO

/* Se ejecuta el procedimiento que crea todas las todas de  nuestro modelo */

DECLARE @grupo VARCHAR(50)= 'THUNDERCATS'
EXEC THUNDERCATS.crearEntidades @grupo
GO

/* Se ejecuta el procedimiento que carga las tablas de nuestro modelo */

DECLARE @grupo VARCHAR(50)= 'THUNDERCATS'
EXEC THUNDERCATS.completandoEntidades @grupo
GO

/* Se eliminan todos los procedimientos creados  */

DECLARE @grupo VARCHAR(50)= 'THUNDERCATS'
EXEC checkProced @grupo,'checkTabla'
EXEC checkProced @grupo,'crearEntidades'
EXEC checkProced @grupo,'completandoEntidades'
DROP PROCEDURE dbo.checkProced;
PRINT ':)'
GO