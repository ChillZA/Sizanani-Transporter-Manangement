CREATE DATABASE [Sizanani Transporter Management]
GO

USE [Sizanani Transporter Management]
GO
/****** Object:  Table [dbo].[Contractor]    Script Date: 28/09/2026 13:31:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contractor](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](100) NOT NULL,
	[email] [varchar](100) NOT NULL,
	[phone] [varchar](10) NULL,
 CONSTRAINT [PK_Contractor] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Vehicle]    Script Date: 28/09/2026 13:31:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicle](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[type_id] [int] NOT NULL,
	[reg_number] [varchar](10) NOT NULL,
	[model] [varchar](100) NOT NULL,
	[weight] [int] NOT NULL,
	[contractor_id] [int] NULL,
 CONSTRAINT [PK_Vehicle] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VehicleType]    Script Date: 28/09/2026 13:31:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VehicleType](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[type_name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_VehicleType] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[VehicleType] ON 
GO
INSERT [dbo].[VehicleType] ([id], [type_name]) VALUES (1, N'Truck')
GO
INSERT [dbo].[VehicleType] ([id], [type_name]) VALUES (2, N'Trailer')
GO
SET IDENTITY_INSERT [dbo].[VehicleType] OFF
GO
ALTER TABLE [dbo].[Vehicle]  WITH CHECK ADD  CONSTRAINT [FK_Contractor_Vehicle] FOREIGN KEY([contractor_id])
REFERENCES [dbo].[Contractor] ([id])
GO
ALTER TABLE [dbo].[Vehicle] CHECK CONSTRAINT [FK_Contractor_Vehicle]
GO
ALTER TABLE [dbo].[Vehicle]  WITH CHECK ADD  CONSTRAINT [FK_Vehicle_VehicleType] FOREIGN KEY([type_id])
REFERENCES [dbo].[VehicleType] ([id])
GO
ALTER TABLE [dbo].[Vehicle] CHECK CONSTRAINT [FK_Vehicle_VehicleType]
GO
/****** Object:  StoredProcedure [dbo].[ContractorSummary]    Script Date: 28/09/2026 13:31:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ContractorSummary]
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT c.name, COUNT(v.id) AS [No of Vehicles], SUM(v.[weight]) AS [Total Tons]
	FROM Contractor c
	INNER JOIN Vehicle v
		ON c.id = v.contractor_id
	GROUP BY c.name

END
GO
/****** Object:  StoredProcedure [dbo].[GetContractors]    Script Date: 28/09/2026 13:31:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetContractors]
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT c.id, c.name
	FROM Contractor c

END
GO
/****** Object:  StoredProcedure [dbo].[GetContractorVehicles]    Script Date: 28/09/2026 13:31:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetContractorVehicles]
	@contractor_id int
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT vt.type_name, v.reg_number, v.model, v.weight
	FROM dbo.Vehicle v
	INNER JOIN dbo.VehicleType vt
		ON v.type_id = vt.id
	WHERE v.contractor_id = @contractor_id

END
GO
/****** Object:  StoredProcedure [dbo].[LinkVehicle]    Script Date: 28/09/2026 13:31:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LinkVehicle]
	@v_id int,
	@c_id int
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE dbo.Vehicle
	SET [contractor_id] = @c_id
	WHERE [id] = @v_id

END
GO
/****** Object:  StoredProcedure [dbo].[RegisterContractor]    Script Date: 28/09/2026 13:31:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RegisterContractor]
	@name varchar(100),
	@email varchar(100),
	@phone varchar(10)
AS 
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [Contractor] (name, email, phone)
	VALUES (@name, @email, @phone);

END
GO
/****** Object:  StoredProcedure [dbo].[RegisterVehicle]    Script Date: 28/09/2026 13:31:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RegisterVehicle]
	@type_id int,
	@reg_nr varchar(10),
	@model varchar(100),
	@weight int
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO dbo.Vehicle (type_id, reg_number, model, weight)
	VALUES (@type_id, @reg_nr, @model, @weight)

END
GO
/****** Object:  StoredProcedure [dbo].[UnlinkVehicle]    Script Date: 28/09/2026 13:31:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UnlinkVehicle]
	@v_id int,
	@c_id int
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE dbo.Vehicle
	SET [contractor_id] = NULL
	WHERE [id] = @v_id

END
GO
/****** Object:  StoredProcedure [dbo].[UpdateVehicle]    Script Date: 28/09/2026 13:31:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateVehicle]
	@id int,
	@reg_nr varchar(10),
	@model varchar(100),
	@weight int
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE dbo.Vehicle
	SET reg_number = @reg_nr, [model] = @model, [weight] = @weight
	WHERE [id] = @id

END
GO
