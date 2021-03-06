USE [master]
GO
/****** Object:  Database [EZOrder]    Script Date: 28.1.2018. 15:12:41 ******/
CREATE DATABASE [EZOrder]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'EZOrder', FILENAME = N/*'Your DB adress'*/ , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'EZOrder_log', FILENAME = N/*'Your DB log adress'*/ , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [EZOrder] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [EZOrder].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [EZOrder] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [EZOrder] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [EZOrder] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [EZOrder] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [EZOrder] SET ARITHABORT OFF 
GO
ALTER DATABASE [EZOrder] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [EZOrder] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [EZOrder] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [EZOrder] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [EZOrder] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [EZOrder] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [EZOrder] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [EZOrder] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [EZOrder] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [EZOrder] SET  DISABLE_BROKER 
GO
ALTER DATABASE [EZOrder] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [EZOrder] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [EZOrder] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [EZOrder] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [EZOrder] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [EZOrder] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [EZOrder] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [EZOrder] SET RECOVERY FULL 
GO
ALTER DATABASE [EZOrder] SET  MULTI_USER 
GO
ALTER DATABASE [EZOrder] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [EZOrder] SET DB_CHAINING OFF 
GO
ALTER DATABASE [EZOrder] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [EZOrder] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [EZOrder] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'EZOrder', N'ON'
GO
ALTER DATABASE [EZOrder] SET QUERY_STORE = OFF
GO
USE [EZOrder]
GO
ALTER DATABASE SCOPED CONFIGURATION SET IDENTITY_CACHE = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [EZOrder]
GO
/****** Object:  Table [dbo].[FoodItems]    Script Date: 28.1.2018. 15:12:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FoodItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FoodCategoryId] [int] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Price] [money] NOT NULL,
 CONSTRAINT [PK_FoodItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderItems]    Script Date: 28.1.2018. 15:12:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NOT NULL,
	[FoodItemId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
 CONSTRAINT [PK_OrderItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[ViewOrderItems]    Script Date: 28.1.2018. 15:12:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[ViewOrderItems] AS

SELECT 
	oi.[OrderId]
	,oi.[FoodItemId]
    ,fi.[Name]
    ,fi.[Price]
	,COUNT (*) AS [Quantity]
	,COUNT (*) * fi.[Price] As [TotalPrice]
FROM 
	[dbo].[OrderItems] AS oi
	INNER JOIN [dbo].[FoodItems] AS fi ON fi.[Id] = oi.[FoodItemId]
GROUP BY
	oi.[OrderId]
	,oi.[FoodItemId]
    ,fi.[Name]
    ,fi.[Price]

GO
/****** Object:  Table [dbo].[Orders]    Script Date: 28.1.2018. 15:12:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TableId] [int] NOT NULL,
	[Remark] [nvarchar](1024) NULL,
	[Ordered] [datetime] NULL,
	[Processed] [bit] NOT NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[ViewOrders]    Script Date: 28.1.2018. 15:12:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[ViewOrders] AS

SELECT 
	o.[Id]
    ,o.[TableId]
    ,o.[Remark]
    ,o.[Ordered]
    ,o.[Processed]
	,ISNULL(SUM([TotalPrice]),0) AS [OrderTotalPrice]
FROM 
	[dbo].[Orders] AS o
	LEFT OUTER JOIN [dbo].[ViewOrderItems] AS ov ON o.[Id] = ov.[OrderId]
GROUP BY
	o.[Id]
    ,o.[TableId]
    ,o.[Remark]
    ,o.[Ordered]
    ,o.[Processed]
	,ov.[OrderId]


GO
/****** Object:  Table [dbo].[FoodCategories]    Script Date: 28.1.2018. 15:12:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FoodCategories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_FoodCategories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[FoodCategories] ON 

INSERT [dbo].[FoodCategories] ([Id], [Name]) VALUES (1, N'Entrees')
INSERT [dbo].[FoodCategories] ([Id], [Name]) VALUES (2, N'Pizza')
INSERT [dbo].[FoodCategories] ([Id], [Name]) VALUES (3, N'Dessert')
INSERT [dbo].[FoodCategories] ([Id], [Name]) VALUES (4, N'Drink')
SET IDENTITY_INSERT [dbo].[FoodCategories] OFF
SET IDENTITY_INSERT [dbo].[FoodItems] ON 

INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (2, 1, N'The Ghostie Sandwich', 5.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (3, 1, N'Short Rib RaguL', 7.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (4, 1, N'Braised Onion Sauce', 3.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (5, 1, N'Creamy Mushroom Soup', 4.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (6, 1, N'Beef Bourguignon', 10.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (7, 1, N'Eggplant Parmesan', 4.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (8, 1, N'Chicken Kiev', 5.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (9, 1, N'Chicken Tamale Pie', 5.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (10, 1, N'Beans and Greens Soup', 4.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (11, 1, N'Rib Chili', 7.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (12, 1, N'"Greek" Lamb with Orzo', 8.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (13, 1, N'Linguine with Sardines, Fennel & Tomato', 10.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (14, 2, N'Balado Pizza', 12.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (15, 2, N'Satay Pizza', 12.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (16, 2, N'Tikka Chicken Pizza', 15.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (17, 2, N'Pizza Margherita', 10.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (18, 2, N'Pizza quattro stagioni', 20.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (19, 2, N'Pizza Alla Napoletana (Napoli)', 15.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (20, 2, N'Liguria Pizza', 13.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (21, 2, N'Pizza Marinara', 15.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (22, 2, N'Pizza Ai Quattro Formagi', 17.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (23, 2, N'Pomodoro Pachina and Rughetta', 13.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (24, 2, N'Pizza Romana', 15.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (25, 2, N'Hawaiian Pizza (pineapple)', 25.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (26, 3, N'Million Dollar Pound Cake (doesn''t cost million dollars)', 999999.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (27, 3, N'All-Time Favorite Chocolate Chip Cookies', 7.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (28, 3, N'Classic Chess Pie', 8.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (29, 3, N'Best Carrot Cake', 8.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (30, 3, N'Pecan-Peach Cobbler', 10.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (31, 3, N'Mom''s Pecan Pie', 7.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (32, 3, N'Summertime Peach Ice Cream', 5.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (33, 3, N'Heavenly Key Lime Pie', 7.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (34, 3, N'Chocolate-Red Velvet Layer Cake', 15.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (35, 3, N'Classic Strawberry Shortcake', 7.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (36, 3, N'Mississippi Mud Brownies (doesn''t contain mud)', 10.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (37, 3, N'Chocolate-Peanut Butter Mousse Cake', 15.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (39, 4, N'Coca-Cola', 3.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (40, 4, N'Sprite', 3.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (41, 4, N'Fanta', 3.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (42, 4, N'7-UP', 7.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (43, 4, N'Mineral water', 2.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (44, 4, N'Black tea', 3.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (45, 4, N'Mint tea', 3.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (46, 4, N'Green tea', 3.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (47, 4, N'Espresso', 4.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (48, 4, N'Americano', 4.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (49, 4, N'Latte', 4.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (50, 4, N'Ice tea', 3.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (51, 2, N'Pizza Capricciosa (Jumbo)', 17.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (52, 4, N'Coca-Cola Zero', 4.0000)
INSERT [dbo].[FoodItems] ([Id], [FoodCategoryId], [Name], [Price]) VALUES (53, 3, N'Legendary Hazelnut Cake', 13.0000)
SET IDENTITY_INSERT [dbo].[FoodItems] OFF
SET IDENTITY_INSERT [dbo].[OrderItems] ON 

INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (1, 13, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (2, 14, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (3, 14, 5, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (4, 14, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (5, 14, 11, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (6, 14, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (7, 14, 4, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (8, 14, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (9, 14, 20, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (10, 14, 23, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (11, 14, 17, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (12, 14, 33, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (13, 14, 30, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (14, 14, 36, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (15, 14, 42, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (16, 14, 47, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (17, 14, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (18, 14, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (62, 42, 6, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (63, 42, 7, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (64, 42, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (65, 42, 9, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (66, 42, 12, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (67, 43, 29, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (68, 43, 30, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (69, 43, 31, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (70, 45, 31, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (71, 45, 32, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (72, 45, 33, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (73, 47, 30, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (74, 47, 31, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (75, 47, 32, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (76, 50, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (77, 50, 3, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (78, 50, 4, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (79, 51, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (80, 51, 3, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (81, 51, 4, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (82, 51, 5, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (83, 52, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (84, 53, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (85, 53, 3, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (86, 53, 4, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (87, 53, 5, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (88, 53, 6, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (89, 53, 7, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (90, 53, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (91, 54, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (92, 54, 40, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (93, 54, 41, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (94, 55, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (95, 55, 40, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (96, 55, 41, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (97, 56, 15, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (98, 56, 17, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (99, 56, 20, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (100, 56, 23, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (101, 57, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (102, 57, 40, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (103, 57, 41, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (104, 58, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (105, 58, 40, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (106, 58, 41, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (107, 59, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (108, 59, 40, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (109, 59, 41, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (110, 59, 42, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (111, 60, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (112, 60, 3, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (113, 60, 4, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (114, 60, 5, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (115, 61, 6, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (116, 61, 7, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (117, 61, 15, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (118, 61, 16, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (119, 61, 32, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (120, 62, 6, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (121, 62, 7, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (122, 62, 17, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (123, 62, 18, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (124, 62, 31, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (125, 62, 32, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (126, 62, 48, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (127, 63, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (128, 63, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (129, 63, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (130, 63, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (131, 63, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (132, 63, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (133, 64, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (134, 64, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (135, 64, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (136, 64, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (137, 64, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (138, 65, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (139, 65, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (140, 65, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (141, 65, 6, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (142, 65, 6, 1)
GO
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (143, 65, 9, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (144, 65, 9, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (145, 66, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (146, 66, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (147, 66, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (148, 66, 9, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (149, 66, 18, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (150, 66, 18, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (151, 66, 31, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (152, 66, 34, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (153, 66, 44, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (154, 66, 45, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (155, 66, 46, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (156, 67, 4, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (157, 67, 5, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (158, 67, 6, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (159, 67, 7, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (160, 68, 4, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (161, 68, 5, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (162, 68, 7, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (163, 68, 7, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (164, 68, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (165, 69, 29, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (166, 69, 29, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (167, 69, 31, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (168, 69, 32, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (169, 70, 7, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (170, 70, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (171, 71, 28, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (172, 71, 28, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (173, 71, 34, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (174, 72, 21, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (175, 72, 22, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (176, 72, 31, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (177, 72, 32, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (178, 72, 34, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (179, 72, 34, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (180, 73, 6, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (181, 73, 7, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (182, 73, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (183, 73, 9, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (184, 73, 10, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (185, 73, 10, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (186, 73, 11, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (187, 73, 11, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (188, 74, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (189, 74, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (190, 74, 11, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (191, 74, 32, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (192, 74, 34, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (193, 75, 29, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (194, 75, 30, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (195, 75, 31, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (196, 75, 32, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (197, 76, 7, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (198, 76, 7, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (199, 76, 20, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (200, 76, 22, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (201, 77, 41, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (202, 77, 42, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (203, 77, 43, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (204, 77, 44, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (205, 77, 46, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (206, 78, 19, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (207, 78, 20, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (208, 78, 21, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (209, 78, 33, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (210, 78, 34, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (211, 78, 46, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (212, 78, 47, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (213, 79, 17, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (214, 79, 18, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (215, 79, 19, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (216, 79, 20, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (217, 79, 19, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (218, 80, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (219, 80, 3, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (220, 80, 4, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (221, 80, 21, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (222, 80, 22, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (223, 80, 33, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (224, 80, 34, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (225, 80, 35, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (226, 80, 35, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (227, 81, 3, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (228, 81, 3, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (229, 81, 6, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (230, 81, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (231, 82, 3, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (232, 82, 5, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (233, 82, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (234, 82, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (235, 82, 19, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (236, 83, 6, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (237, 83, 7, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (238, 83, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (239, 83, 9, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (240, 83, 9, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (241, 84, 3, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (242, 84, 8, 1)
GO
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (243, 84, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (244, 84, 11, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (245, 84, 21, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (246, 84, 22, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (247, 85, 10, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (248, 85, 9, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (249, 85, 9, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (250, 85, 7, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (251, 86, 7, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (252, 86, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (253, 86, 10, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (254, 86, 10, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (255, 86, 11, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (256, 87, 7, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (257, 87, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (258, 87, 9, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (259, 87, 9, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (260, 87, 10, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (261, 88, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (262, 88, 6, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (263, 88, 9, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (264, 89, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (265, 89, 5, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (266, 89, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (267, 90, 9, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (268, 90, 10, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (269, 90, 11, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (270, 91, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (271, 91, 4, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (272, 91, 6, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (273, 92, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (274, 92, 5, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (275, 92, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (276, 93, 17, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (277, 93, 19, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (278, 93, 21, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (279, 94, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (280, 94, 10, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (281, 94, 12, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (282, 94, 20, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (283, 94, 22, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (284, 95, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (285, 95, 20, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (286, 95, 33, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (287, 95, 45, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (288, 96, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (289, 96, 10, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (290, 96, 10, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (291, 96, 19, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (292, 96, 21, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (293, 96, 32, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (294, 96, 33, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (295, 97, 7, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (296, 97, 9, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (297, 97, 11, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (298, 97, 17, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (299, 97, 20, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (300, 97, 21, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (301, 97, 21, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (302, 98, 6, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (303, 98, 7, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (304, 98, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (305, 98, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (306, 98, 10, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (307, 98, 17, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (308, 98, 19, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (309, 98, 21, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (310, 98, 31, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (311, 98, 32, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (312, 98, 33, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (313, 98, 43, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (314, 98, 43, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (315, 99, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (316, 99, 9, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (317, 99, 12, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (318, 99, 17, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (319, 99, 17, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (320, 99, 32, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (321, 99, 42, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (322, 101, 5, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (323, 101, 5, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (324, 101, 5, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (325, 101, 5, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (326, 101, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (327, 101, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (328, 101, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (329, 101, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (330, 101, 20, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (331, 101, 20, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (332, 101, 20, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (333, 101, 18, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (334, 101, 18, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (335, 101, 18, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (336, 101, 17, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (337, 101, 17, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (338, 101, 17, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (339, 101, 24, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (340, 101, 24, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (341, 101, 24, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (342, 101, 24, 1)
GO
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (343, 101, 24, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (344, 101, 28, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (345, 101, 30, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (346, 101, 31, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (347, 101, 32, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (348, 101, 33, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (349, 101, 35, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (350, 101, 33, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (351, 101, 27, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (352, 101, 28, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (353, 101, 27, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (354, 101, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (355, 101, 40, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (356, 101, 41, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (357, 101, 42, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (358, 101, 41, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (359, 101, 40, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (360, 101, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (361, 101, 40, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (362, 101, 41, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (363, 101, 42, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (364, 103, 6, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (365, 103, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (366, 103, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (367, 103, 17, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (368, 103, 17, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (369, 103, 17, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (370, 103, 36, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (371, 103, 36, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (372, 103, 29, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (373, 103, 42, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (374, 103, 42, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (375, 103, 42, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (376, 104, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (377, 104, 51, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (378, 104, 53, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (379, 104, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (380, 104, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (381, 104, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (382, 104, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (383, 104, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (384, 104, 52, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (385, 105, 7, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (386, 105, 9, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (387, 105, 11, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (388, 105, 12, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (389, 107, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (390, 107, 51, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (391, 107, 53, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (392, 107, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (393, 107, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (394, 107, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (395, 107, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (396, 107, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (397, 107, 52, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (398, 108, 9, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (399, 108, 10, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (400, 108, 11, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (401, 108, 19, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (402, 108, 19, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (403, 112, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (404, 112, 7, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (405, 112, 10, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (406, 112, 19, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (407, 112, 20, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (408, 112, 21, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (409, 112, 21, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (410, 112, 32, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (411, 112, 33, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (412, 113, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (413, 113, 51, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (414, 113, 53, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (415, 113, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (416, 113, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (417, 113, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (418, 113, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (419, 113, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (420, 113, 52, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (421, 114, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (422, 114, 7, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (423, 114, 11, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (424, 114, 19, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (425, 114, 19, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (426, 114, 32, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (427, 114, 33, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (428, 115, 7, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (429, 115, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (430, 115, 9, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (431, 115, 10, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (432, 115, 19, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (433, 115, 20, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (434, 115, 21, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (435, 115, 34, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (436, 115, 35, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (437, 115, 45, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (438, 115, 45, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (439, 116, 51, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (440, 116, 53, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (441, 116, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (442, 116, 39, 1)
GO
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (443, 116, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (444, 116, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (445, 116, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (446, 116, 52, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (447, 118, 51, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (448, 118, 53, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (449, 118, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (450, 118, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (451, 118, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (452, 118, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (453, 118, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (454, 118, 52, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (455, 119, 51, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (456, 119, 53, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (457, 119, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (458, 119, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (459, 119, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (460, 119, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (461, 119, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (462, 119, 52, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (463, 120, 5, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (464, 120, 7, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (465, 120, 9, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (466, 121, 28, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (467, 121, 29, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (468, 121, 32, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (469, 121, 34, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (470, 122, 18, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (471, 122, 19, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (472, 122, 20, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (473, 123, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (474, 123, 3, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (475, 123, 6, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (476, 123, 6, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (477, 123, 7, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (478, 123, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (479, 123, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (480, 124, 6, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (481, 124, 7, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (482, 124, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (483, 124, 19, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (484, 124, 20, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (485, 124, 21, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (486, 124, 21, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (487, 124, 45, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (488, 124, 45, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [FoodItemId], [Quantity]) VALUES (489, 124, 45, 1)
SET IDENTITY_INSERT [dbo].[OrderItems] OFF
SET IDENTITY_INSERT [dbo].[Orders] ON 

INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (1, 1, N'', NULL, 1)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (2, 1, N'', NULL, 1)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (3, 1, N'', NULL, 1)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (4, 1, N'', NULL, 1)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (5, 1, N'', NULL, 1)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (6, 1, N'', NULL, 1)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (7, 1, N'', NULL, 1)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (8, 1, N'', NULL, 1)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (9, 1, N'', NULL, 1)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (10, 1, N'', NULL, 1)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (11, 1, N'', NULL, 1)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (12, 1, N'', NULL, 1)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (13, 1, N'', NULL, 1)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (14, 1, N'', CAST(N'2018-01-24T01:12:09.943' AS DateTime), 1)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (41, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (42, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (43, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (44, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (45, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (46, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (47, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (48, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (49, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (50, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (51, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (52, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (53, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (54, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (55, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (56, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (57, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (58, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (59, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (60, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (61, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (62, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (63, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (64, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (65, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (66, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (67, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (68, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (69, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (70, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (71, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (72, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (73, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (74, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (75, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (76, 1, N'', CAST(N'2018-01-24T01:17:12.967' AS DateTime), 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (77, 1, N'', CAST(N'2018-01-24T01:20:03.917' AS DateTime), 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (78, 1, N'alergican sam na ljesnjake', CAST(N'2018-01-24T01:30:42.540' AS DateTime), 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (79, 1, N'ja sam duje', CAST(N'2018-01-24T02:10:08.550' AS DateTime), 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (80, 1, N'remark', CAST(N'2018-01-24T02:21:46.260' AS DateTime), 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (81, 1, N'', CAST(N'2018-01-24T02:24:54.170' AS DateTime), 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (82, 1, N'napomena', CAST(N'2018-01-24T02:30:00.463' AS DateTime), 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (83, 1, N'y you do this', CAST(N'2018-01-24T02:39:21.737' AS DateTime), 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (84, 1, N'aaa', CAST(N'2018-01-24T02:47:01.360' AS DateTime), 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (85, 1, N'pls', CAST(N'2018-01-24T02:48:33.940' AS DateTime), 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (86, 1, N'duje', CAST(N'2018-01-24T02:49:55.147' AS DateTime), 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (87, 1, N'remmark', CAST(N'2018-01-24T02:52:30.553' AS DateTime), 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (88, 1, N'r', CAST(N'2018-01-24T03:05:27.693' AS DateTime), 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (89, 1, N'y', CAST(N'2018-01-24T03:07:26.093' AS DateTime), 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (90, 1, N'n', CAST(N'2018-01-24T03:09:51.170' AS DateTime), 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (91, 1, N'm', CAST(N'2018-01-24T03:12:27.353' AS DateTime), 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (92, 1, N'h', CAST(N'2018-01-24T03:19:51.420' AS DateTime), 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (93, 1, N'j', CAST(N'2018-01-24T03:20:52.673' AS DateTime), 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (94, 1, N'dfg', CAST(N'2018-01-24T03:30:01.233' AS DateTime), 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (95, 1, N'btn', CAST(N'2018-01-24T04:16:19.013' AS DateTime), 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (96, 1, N'mmoarr lime in pie', CAST(N'2018-01-24T08:26:06.197' AS DateTime), 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (97, 1, N'this', CAST(N'2018-01-24T08:43:45.200' AS DateTime), 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (98, 1, N'my remark', CAST(N'2018-01-24T08:47:36.750' AS DateTime), 1)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (99, 1, N'I  like PIZZA', CAST(N'2018-01-24T12:51:23.223' AS DateTime), 1)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (100, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (101, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (102, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (103, 1, N'Meri hoce sprite', CAST(N'2018-01-24T14:44:51.147' AS DateTime), 1)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (104, 1, N'I am allergic to hazelnuts', CAST(N'2018-01-25T08:41:52.800' AS DateTime), 1)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (105, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (106, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (107, 1, N'I want my hazelnut cake withouth hazenuts couse I''m alergic to hazels.', CAST(N'2018-01-25T08:51:19.830' AS DateTime), 1)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (108, 1, N'', CAST(N'2018-01-25T09:06:41.480' AS DateTime), 1)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (109, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (110, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (111, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (112, 1, N'Pls give me discount', CAST(N'2018-01-25T09:18:48.100' AS DateTime), 1)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (113, 1, N'I am allergic to hazelnuts.', CAST(N'2018-01-25T09:24:51.067' AS DateTime), 1)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (114, 1, N'I am allergic to hazelnuts.', CAST(N'2018-01-25T10:45:50.120' AS DateTime), 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (115, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (116, 1, N'I am allergic to hazelnuts', CAST(N'2018-01-25T11:24:49.743' AS DateTime), 1)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (117, 1, N'', NULL, 0)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (118, 1, N'I am allergic to hazelnuts', CAST(N'2018-01-25T12:47:43.050' AS DateTime), 1)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (119, 1, N'I am allergic to hazelnuts', CAST(N'2018-01-25T13:11:14.243' AS DateTime), 1)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (120, 1, N'My remark', CAST(N'2018-01-28T13:39:25.373' AS DateTime), 1)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (121, 1, N'I like my sweets', CAST(N'2018-01-28T14:05:46.733' AS DateTime), 1)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (122, 1, N'thanks', CAST(N'2018-01-28T14:29:06.653' AS DateTime), 1)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (123, 1, N'test123', CAST(N'2018-01-28T14:37:07.617' AS DateTime), 1)
INSERT [dbo].[Orders] ([Id], [TableId], [Remark], [Ordered], [Processed]) VALUES (124, 1, N'Is this GitHubReady?', CAST(N'2018-01-28T14:41:42.933' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[Orders] OFF
GO
ALTER TABLE [dbo].[OrderItems] ADD  CONSTRAINT [DF_OrderItems_Quantity]  DEFAULT ((1)) FOR [Quantity]
GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_Remark]  DEFAULT ('') FOR [Remark]
GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_Processed]  DEFAULT ((0)) FOR [Processed]
GO
ALTER TABLE [dbo].[FoodItems]  WITH CHECK ADD  CONSTRAINT [FK_FoodItems_FoodCategories] FOREIGN KEY([FoodCategoryId])
REFERENCES [dbo].[FoodCategories] ([Id])
GO
ALTER TABLE [dbo].[FoodItems] CHECK CONSTRAINT [FK_FoodItems_FoodCategories]
GO
ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD  CONSTRAINT [FK_OrderItems_FoodItems] FOREIGN KEY([FoodItemId])
REFERENCES [dbo].[FoodItems] ([Id])
GO
ALTER TABLE [dbo].[OrderItems] CHECK CONSTRAINT [FK_OrderItems_FoodItems]
GO
ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD  CONSTRAINT [FK_OrderItems_Orders] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Orders] ([Id])
GO
ALTER TABLE [dbo].[OrderItems] CHECK CONSTRAINT [FK_OrderItems_Orders]
GO
USE [master]
GO
ALTER DATABASE [EZOrder] SET  READ_WRITE 
GO
