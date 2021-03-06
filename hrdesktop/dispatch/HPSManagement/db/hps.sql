USE [HPS]
GO
/****** Object:  StoredProcedure [dbo].[GetDataList]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
 *--------------------------------------------------------------------------
 * データ一覧取得機能
 *--------------------------------------------------------------------------
 */
CREATE PROCEDURE [dbo].[GetDataList]
    @iOPID   	int,       	--オペレーターID、NULL不可
    @iCIP  	int,       	--IPアドレース
    @iDATAID 	int,         	--情報ID、新規の場合はNULLで固定する
    @iFLDL   	varchar(1000),  --フィールドリスト
    @iTBLNM  	varchar(30),    --テーブル名
    @iWSQL   	varchar(1000),  --検索条件文
    @iOSQL   	varchar(100),   --並び替え文
    @oRCD    	int   out          --実行結果コード
AS 
	
	BEGIN
		declare @ERR int
		declare @str varchar(3000)
		declare @FLDL varchar(1000)
		select 	@FLDL = RTRIM(LTRIM(@iFLDL))
		declare @TBLNM varchar(30)
		select 	@TBLNM = RTRIM(LTRIM(@iTBLNM))
		declare @WSQL varchar(1000)
		select 	@WSQL = RTRIM(LTRIM(@iWSQL))
		declare @OSQL varchar(100)
		select 	@OSQL = RTRIM(LTRIM(@iOSQL))
		select 	@oRCD = 0
		set @str='SELECT ' + @FLDL + ' FROM ' + @TBLNM + ' WHERE 1=1'
    		IF @WSQL IS NOT NULL AND LEN(@WSQL) > 0 
		BEGIN
        		set @str = @str + ' AND ' + @WSQL;
    		END
    		IF @OSQL IS NOT NULL AND LEN(@OSQL) > 0
		BEGIN
		        set @str = @str + ' ORDER BY ' + @OSQL;
    		END
		exec(@str)
		Select @ERR = @@ERROR
		IF @ERR <> 0
		BEGIN
			Select @oRCD = -1
		END
		ELSE
		BEGIN
			Select @oRCD = 0
		END
		
	END


GO
/****** Object:  StoredProcedure [dbo].[SetData]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
 *--------------------------------------------------------------------------
 * データの追加／更新/削除
 *--------------------------------------------------------------------------
 */
CREATE PROCEDURE [dbo].[SetData]
    @iOPID   	int,       	--オペレーターID、NULL不可
    @iCIP  	int,       	--IPアドレース
    @iDATAID 	int,         	--情報ID、新規の場合はNULLで固定する
    @iFLDL   	varchar(1000),  --フィールドリスト
    @iTBLNM  	varchar(30),    --テーブル名
    @iWSQL   	varchar(1000),  --検索条件文
    @iVSQL   	varchar(2000),  --値文
    @oRCD    	int     out     --実行結果コード
AS 
	
	BEGIN
		declare @str varchar(3000)
		declare @FLDL varchar(1000)
		select 	@FLDL = RTRIM(LTRIM(@iFLDL))
		declare @TBLNM varchar(30)
		select 	@TBLNM = RTRIM(LTRIM(@iTBLNM))
		declare @WSQL varchar(1000)
		select 	@WSQL = RTRIM(LTRIM(@iWSQL))
		declare @VSQL varchar(2000)
		select 	@VSQL = RTRIM(LTRIM(@iVSQL))
		select	@oRCD = 0 
    		IF @iDATAID = 0 
		BEGIN
			set @str = ' INSERT INTO ' + @TBLNM + '(' + @FLDL + ') VALUES(' + @VSQL + ')'
			exec(@str)
			select @oRCD = @@IDENTITY
    		END
		ELSE IF @iDATAID = 1
		BEGIN
			set @str = ' UPDATE ' + @TBLNM + ' SET ' + @VSQL + ' WHERE ' + @WSQL
			exec(@str)
			select @oRCD = @iDATAID
		END
		ELSE
		BEGIN
			set @str = ' DELETE FROM ' + @TBLNM + ' WHERE ' + @WSQL
			exec(@str)
			select @oRCD = @iDATAID
		END

	END


GO
/****** Object:  Table [dbo].[FTP上传]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FTP上传](
	[上传编号] [int] IDENTITY(1,1) NOT NULL,
	[FTP编号] [int] NOT NULL,
	[期刊编号] [int] NOT NULL,
	[发行编号] [int] NOT NULL,
	[上传状态] [nchar](10) NULL,
	[上传名称] [nvarchar](250) NULL,
	[UserID] [varchar](20) NULL,
 CONSTRAINT [PK_FTP上传] PRIMARY KEY CLUSTERED 
(
	[上传编号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FTP上传历史]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FTP上传历史](
	[上传编号] [int] NOT NULL,
	[FTP编号] [int] NOT NULL,
	[期刊编号] [int] NOT NULL,
	[发行编号] [int] NOT NULL,
	[上传状态] [nchar](10) NULL,
	[上传名称] [nvarchar](50) NULL,
	[UserID] [varchar](20) NULL,
 CONSTRAINT [PK_FTP上传历史] PRIMARY KEY CLUSTERED 
(
	[上传编号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FTP服务器]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FTP服务器](
	[编号] [int] IDENTITY(1,1) NOT NULL,
	[名称] [nvarchar](50) NOT NULL,
	[地址] [nvarchar](50) NOT NULL,
	[文件夹] [nvarchar](50) NULL,
	[端口] [numeric](18, 0) NOT NULL,
	[用户] [nvarchar](50) NOT NULL,
	[密码] [nvarchar](50) NOT NULL,
	[UserID] [varchar](20) NULL,
 CONSTRAINT [PK_FTP服务器] PRIMARY KEY CLUSTERED 
(
	[编号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[S用户]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[S用户](
	[UserID] [varchar](20) NOT NULL,
	[UserName] [varchar](20) NULL,
	[UserPwd] [varchar](32) NULL,
	[UserMail] [varchar](250) NULL,
	[UpperUserID] [varchar](20) NULL,
 CONSTRAINT [PK_tb_Users] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[S期刊]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[S期刊](
	[S期刊编号] [nvarchar](50) NOT NULL,
	[编号] [int] NOT NULL,
	[名称] [nvarchar](50) NOT NULL,
	[主编] [nvarchar](50) NULL,
	[发行周期] [nchar](10) NULL,
	[发行地点] [nvarchar](50) NULL,
	[大分类] [nvarchar](50) NULL,
	[中分类] [nvarchar](50) NULL,
	[小分类] [nvarchar](50) NULL,
	[是否加密] [nchar](1) NULL,
	[密码] [nvarchar](20) NULL,
	[是否收费] [nchar](1) NULL,
	[每期金额] [numeric](18, 0) NULL,
	[货币类型] [nvarchar](3) NULL,
	[主编信箱] [varchar](100) NULL,
	[是否本机] [nchar](1) NULL,
	[UserID] [varchar](20) NOT NULL,
 CONSTRAINT [PK_S期刊] PRIMARY KEY CLUSTERED 
(
	[S期刊编号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[S期刊订阅]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[S期刊订阅](
	[S订阅编号] [nvarchar](50) NOT NULL,
	[S期刊编号] [nvarchar](50) NOT NULL,
	[期刊编号] [int] NOT NULL,
	[开始日期] [smalldatetime] NULL,
	[结束日期] [smalldatetime] NULL,
	[订阅文书] [nvarchar](250) NULL,
	[许可编号] [nvarchar](250) NULL,
	[UserID] [varchar](20) NULL,
 CONSTRAINT [PK_S期刊订阅] PRIMARY KEY CLUSTERED 
(
	[S订阅编号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[S期刊发行]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[S期刊发行](
	[S发行编号] [nvarchar](50) NOT NULL,
	[S期刊编号] [nvarchar](50) NOT NULL,
	[发行编号] [int] NOT NULL,
	[期刊编号] [int] NOT NULL,
	[发行期号] [nvarchar](50) NOT NULL,
	[发行日期] [smalldatetime] NULL,
	[文件链接] [nvarchar](250) NULL,
	[图片链接] [nvarchar](250) NULL,
	[文本内容] [nvarchar](max) NULL,
	[邮件内容] [nvarchar](max) NULL,
	[期刊状态] [nchar](10) NULL,
	[本地文件] [nvarchar](250) NULL,
	[FTP文件] [nvarchar](250) NULL,
	[本地图片] [nvarchar](250) NULL,
	[FTP图片] [nvarchar](250) NULL,
	[UserID] [varchar](20) NULL,
 CONSTRAINT [PK_S期刊发行_1] PRIMARY KEY CLUSTERED 
(
	[S发行编号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[工具设置]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[工具设置](
	[ToolID] [int] IDENTITY(1,1) NOT NULL,
	[ToolName] [nvarchar](50) NULL,
	[ToolLanguange] [nvarchar](10) NULL,
	[ToolFile] [nvarchar](250) NULL,
	[ToolComment] [nvarchar](250) NULL,
	[ToolSerialNo] [nvarchar](50) NULL,
	[UserID] [varchar](20) NULL,
 CONSTRAINT [PK_工具设置] PRIMARY KEY CLUSTERED 
(
	[ToolID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[无效客户]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[无效客户](
	[ID] [varchar](50) NULL,
	[邮件地址] [varchar](250) NULL,
	[状况] [varchar](50) NULL,
	[消息] [nvarchar](2000) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[用户]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[用户](
	[UserID] [varchar](20) NOT NULL,
	[UserName] [varchar](20) NULL,
	[UserPwd] [varchar](32) NULL,
	[UserRight] [varchar](10) NULL,
	[UpperUserID] [varchar](20) NULL,
 CONSTRAINT [PK_tb_User] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[邮件服务器]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[邮件服务器](
	[编号] [int] IDENTITY(1,1) NOT NULL,
	[名称] [nvarchar](50) NOT NULL,
	[地址] [nvarchar](50) NOT NULL,
	[端口] [numeric](18, 0) NOT NULL,
	[用户] [nvarchar](50) NOT NULL,
	[密码] [nvarchar](50) NOT NULL,
	[送信人地址] [nvarchar](250) NOT NULL,
	[服务器类型] [nchar](10) NOT NULL,
	[UserID] [varchar](20) NULL,
	[添付文件] [varchar](1) NULL,
	[HTML] [varchar](1) NULL,
 CONSTRAINT [PK_邮件服务器] PRIMARY KEY CLUSTERED 
(
	[编号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[客户]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[客户](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Cname] [nvarchar](255) NULL,
	[name] [nvarchar](50) NULL,
	[postcode] [nvarchar](8) NULL,
	[address] [nvarchar](100) NULL,
	[tel] [nvarchar](50) NULL,
	[FAX] [nvarchar](255) NULL,
	[kind] [nvarchar](255) NULL,
	[FORMAT] [nvarchar](255) NULL,
	[scale] [nvarchar](50) NULL,
	[CYMD] [datetime] NULL,
	[other] [nvarchar](255) NULL,
	[mail] [nvarchar](100) NULL,
	[web] [nvarchar](255) NULL,
	[jCNAME] [nvarchar](255) NULL,
	[createtime] [datetime] NULL,
	[subscripted] [nvarchar](1) NULL,
	[UserID] [varchar](20) NULL,
 CONSTRAINT [aaaaacustomer_PK] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[客户同步]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[客户同步](
	[同步编号] [int] IDENTITY(1,1) NOT NULL,
	[客户数据库编号] [int] NOT NULL,
	[同步状态] [nchar](10) NULL,
	[同步名称] [nvarchar](50) NULL,
	[UserID] [varchar](20) NULL,
 CONSTRAINT [PK_客户同步] PRIMARY KEY CLUSTERED 
(
	[同步编号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[客户同步历史]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[客户同步历史](
	[同步编号] [int] NOT NULL,
	[客户数据库编号] [int] NOT NULL,
	[同步状态] [nchar](10) NULL,
	[同步名称] [nvarchar](50) NULL,
	[UserID] [varchar](20) NULL,
 CONSTRAINT [PK_客户同步历史] PRIMARY KEY CLUSTERED 
(
	[同步编号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[客户数据库]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[客户数据库](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[DBType] [nvarchar](20) NULL,
	[DBServer] [nvarchar](20) NULL,
	[DBUser] [nvarchar](20) NULL,
	[DBPassword] [nvarchar](20) NULL,
	[DBName] [nvarchar](20) NULL,
	[DBTableName] [nvarchar](20) NULL,
	[Cname] [nvarchar](20) NULL,
	[name] [nvarchar](20) NULL,
	[postcode] [nvarchar](20) NULL,
	[address] [nvarchar](20) NULL,
	[tel] [nvarchar](20) NULL,
	[FAX] [nvarchar](20) NULL,
	[kind] [nvarchar](20) NULL,
	[FORMAT] [nvarchar](20) NULL,
	[scale] [nvarchar](20) NULL,
	[CYMD] [nvarchar](20) NULL,
	[other] [nvarchar](20) NULL,
	[mail] [nvarchar](100) NULL,
	[web] [nvarchar](20) NULL,
	[jCNAME] [nvarchar](20) NULL,
	[createtime] [datetime] NULL,
	[subscripted] [nvarchar](1) NULL,
	[UserID] [varchar](20) NULL,
 CONSTRAINT [aaaaadbserver_PK] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[媒体]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[媒体](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[MediaType] [nvarchar](20) NULL,
	[MediaURL] [nvarchar](200) NULL,
	[MediaUser] [nvarchar](50) NULL,
	[MediaPassword] [nvarchar](50) NULL,
	[other] [nvarchar](200) NULL,
	[createtime] [datetime] NULL,
	[published] [nvarchar](1) NULL,
	[UserID] [varchar](20) NULL,
	[MediaAppKey] [nvarchar](50) NULL,
	[MediaAppPassword] [nvarchar](50) NULL,
 CONSTRAINT [aaaaamedia_PK] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[媒体发布]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[媒体发布](
	[发布编号] [int] IDENTITY(1,1) NOT NULL,
	[媒体编号] [int] NOT NULL,
	[期刊编号] [int] NOT NULL,
	[发行编号] [int] NOT NULL,
	[发行状态] [nchar](10) NULL,
	[媒体名称] [nvarchar](50) NULL,
	[信息编号] [nvarchar](50) NULL,
	[UserID] [varchar](20) NULL,
 CONSTRAINT [PK_媒体发布] PRIMARY KEY CLUSTERED 
(
	[发布编号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[媒体发布历史]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[媒体发布历史](
	[发布编号] [int] NOT NULL,
	[媒体编号] [int] NOT NULL,
	[期刊编号] [int] NOT NULL,
	[发行编号] [int] NOT NULL,
	[发行状态] [nchar](10) NULL,
	[媒体名称] [nvarchar](50) NULL,
	[信息编号] [nvarchar](50) NULL,
	[UserID] [varchar](20) NULL,
 CONSTRAINT [PK_媒体发布历史] PRIMARY KEY CLUSTERED 
(
	[发布编号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[期刊]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[期刊](
	[编号] [int] IDENTITY(1,1) NOT NULL,
	[名称] [nvarchar](50) NOT NULL,
	[主编] [nvarchar](50) NULL,
	[发行周期] [nchar](10) NULL,
	[发行地点] [nvarchar](50) NULL,
	[大分类] [nvarchar](50) NULL,
	[中分类] [nvarchar](50) NULL,
	[小分类] [nvarchar](50) NULL,
	[是否加密] [nchar](1) NULL,
	[密码] [nvarchar](20) NULL,
	[是否收费] [nchar](1) NULL,
	[每期金额] [numeric](18, 0) NULL,
	[货币类型] [nvarchar](3) NULL,
	[主编信箱] [varchar](100) NULL,
	[是否本机] [nchar](1) NULL,
	[UserID] [varchar](20) NOT NULL,
	[S期刊编号] [nvarchar](50) NULL,
 CONSTRAINT [PK_期刊] PRIMARY KEY CLUSTERED 
(
	[编号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[期刊文件]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[期刊文件](
	[文件编号] [int] IDENTITY(1,1) NOT NULL,
	[期刊编号] [int] NOT NULL,
	[发行编号] [int] NOT NULL,
	[文件序号] [int] NOT NULL,
	[文件栏目] [nvarchar](20) NULL,
	[文件名称] [nvarchar](250) NULL,
	[文件页数] [int] NULL,
	[UserID] [varchar](20) NULL,
 CONSTRAINT [PK_期刊文件] PRIMARY KEY CLUSTERED 
(
	[文件编号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[期刊发行]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[期刊发行](
	[发行编号] [int] IDENTITY(1,1) NOT NULL,
	[期刊编号] [int] NOT NULL,
	[发行期号] [nvarchar](50) NOT NULL,
	[发行日期] [smalldatetime] NULL,
	[文件链接] [nvarchar](250) NULL,
	[图片链接] [nvarchar](250) NULL,
	[文本内容] [nvarchar](max) NULL,
	[邮件内容] [nvarchar](max) NULL,
	[期刊状态] [nchar](10) NULL,
	[本地文件] [nvarchar](250) NULL,
	[FTP文件] [nvarchar](250) NULL,
	[本地图片] [nvarchar](250) NULL,
	[FTP图片] [nvarchar](250) NULL,
	[UserID] [varchar](20) NULL,
	[S期刊编号] [nvarchar](50) NULL,
	[S发行编号] [nvarchar](50) NULL,
 CONSTRAINT [PK_期刊发行_1] PRIMARY KEY CLUSTERED 
(
	[发行编号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[期刊送信]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[期刊送信](
	[送信编号] [int] IDENTITY(1,1) NOT NULL,
	[客户编号] [int] NOT NULL,
	[期刊编号] [int] NOT NULL,
	[发行编号] [int] NOT NULL,
	[送信状态] [nchar](10) NULL,
	[服务器名称] [nvarchar](50) NULL,
	[信息编号] [nvarchar](50) NULL,
	[UserID] [varchar](20) NULL,
 CONSTRAINT [PK_期刊送信] PRIMARY KEY CLUSTERED 
(
	[送信编号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[期刊送信历史]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[期刊送信历史](
	[送信编号] [int] NOT NULL,
	[客户编号] [int] NOT NULL,
	[期刊编号] [int] NOT NULL,
	[发行编号] [int] NOT NULL,
	[送信状态] [nchar](10) NULL,
	[服务器名称] [nvarchar](50) NULL,
	[信息编号] [nvarchar](50) NULL,
	[UserID] [varchar](20) NULL,
 CONSTRAINT [PK_期刊送信历史] PRIMARY KEY CLUSTERED 
(
	[送信编号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[FTP上传历史视图]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[FTP上传历史视图]
AS
SELECT     dbo.FTP上传历史.上传编号, dbo.FTP上传历史.FTP编号, dbo.FTP上传历史.期刊编号, dbo.FTP上传历史.发行编号, dbo.FTP上传历史.上传状态, 
                      dbo.FTP上传历史.上传名称, dbo.FTP上传历史.UserID, dbo.期刊发行.发行期号, dbo.期刊.名称 AS 期刊名称, dbo.期刊发行.文件链接, dbo.FTP服务器.名称 AS FTP名称, 
                      dbo.FTP服务器.地址, dbo.FTP服务器.端口, dbo.FTP服务器.用户, dbo.FTP服务器.密码, dbo.FTP服务器.文件夹, dbo.期刊发行.FTP文件
FROM         dbo.FTP服务器 INNER JOIN
                      dbo.期刊发行 INNER JOIN
                      dbo.FTP上传历史 ON dbo.期刊发行.发行编号 = dbo.FTP上传历史.发行编号 INNER JOIN
                      dbo.期刊 ON dbo.期刊发行.期刊编号 = dbo.期刊.编号 ON dbo.FTP服务器.编号 = dbo.FTP上传历史.FTP编号


GO
/****** Object:  View [dbo].[FTP上传视图]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[FTP上传视图]
AS
SELECT     dbo.期刊发行.文件链接, dbo.期刊发行.发行期号, dbo.期刊.名称 AS 期刊名称, dbo.FTP上传.上传编号, dbo.FTP上传.FTP编号, dbo.FTP上传.期刊编号, 
                      dbo.FTP上传.发行编号, dbo.FTP上传.上传状态, dbo.FTP上传.上传名称, dbo.FTP上传.UserID, dbo.FTP服务器.名称 AS FTP名称, dbo.FTP服务器.地址, 
                      dbo.FTP服务器.端口, dbo.FTP服务器.用户, dbo.FTP服务器.密码, dbo.FTP服务器.文件夹, dbo.期刊发行.FTP文件
FROM         dbo.FTP服务器 INNER JOIN
                      dbo.期刊发行 INNER JOIN
                      dbo.FTP上传 ON dbo.期刊发行.发行编号 = dbo.FTP上传.发行编号 INNER JOIN
                      dbo.期刊 ON dbo.FTP上传.期刊编号 = dbo.期刊.编号 ON dbo.FTP服务器.编号 = dbo.FTP上传.FTP编号


GO
/****** Object:  View [dbo].[客户同步历史视图]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[客户同步历史视图]
AS
SELECT     dbo.客户同步历史.同步编号, dbo.客户同步历史.客户数据库编号, dbo.客户同步历史.同步状态, dbo.客户同步历史.同步名称, dbo.客户同步历史.UserID, 
                      dbo.客户数据库.DBType, dbo.客户数据库.DBServer, dbo.客户数据库.DBUser, dbo.客户数据库.DBPassword, dbo.客户数据库.DBTableName, dbo.客户数据库.Cname, 
                      dbo.客户数据库.name, dbo.客户数据库.postcode, dbo.客户数据库.address, dbo.客户数据库.tel, dbo.客户数据库.FAX, dbo.客户数据库.kind, dbo.客户数据库.FORMAT, 
                      dbo.客户数据库.scale, dbo.客户数据库.CYMD, dbo.客户数据库.other, dbo.客户数据库.mail, dbo.客户数据库.web, dbo.客户数据库.jCNAME, 
                      dbo.客户数据库.createtime, dbo.客户数据库.subscripted, dbo.客户数据库.DBName
FROM         dbo.客户数据库 INNER JOIN
                      dbo.客户同步历史 ON dbo.客户数据库.id = dbo.客户同步历史.客户数据库编号


GO
/****** Object:  View [dbo].[客户同步视图]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[客户同步视图]
AS
SELECT     dbo.客户同步.同步编号, dbo.客户同步.客户数据库编号, dbo.客户同步.同步状态, dbo.客户同步.同步名称, dbo.客户同步.UserID, dbo.客户数据库.DBType, 
                      dbo.客户数据库.DBServer, dbo.客户数据库.DBPassword, dbo.客户数据库.DBUser, dbo.客户数据库.DBTableName, dbo.客户数据库.Cname, dbo.客户数据库.name, 
                      dbo.客户数据库.postcode, dbo.客户数据库.address, dbo.客户数据库.tel, dbo.客户数据库.FAX, dbo.客户数据库.kind, dbo.客户数据库.FORMAT, dbo.客户数据库.scale, 
                      dbo.客户数据库.CYMD, dbo.客户数据库.other, dbo.客户数据库.mail, dbo.客户数据库.web, dbo.客户数据库.createtime, dbo.客户数据库.jCNAME, 
                      dbo.客户数据库.subscripted, dbo.客户数据库.DBName
FROM         dbo.客户数据库 INNER JOIN
                      dbo.客户同步 ON dbo.客户数据库.id = dbo.客户同步.客户数据库编号


GO
/****** Object:  View [dbo].[媒体发布历史视图]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[媒体发布历史视图]
AS
SELECT     dbo.媒体发布历史.发布编号, dbo.媒体发布历史.媒体编号, dbo.媒体发布历史.期刊编号, dbo.媒体发布历史.发行编号, dbo.媒体发布历史.发行状态, 
                      dbo.媒体发布历史.媒体名称, dbo.媒体发布历史.信息编号, dbo.媒体发布历史.UserID, dbo.期刊发行.发行期号, dbo.期刊发行.发行日期, dbo.期刊发行.文件链接, 
                      dbo.期刊发行.图片链接, dbo.期刊发行.文本内容, dbo.期刊发行.邮件内容, dbo.期刊.名称, dbo.媒体.MediaType, dbo.媒体.MediaURL, dbo.媒体.MediaUser, 
                      dbo.媒体.MediaPassword, dbo.媒体.published, dbo.媒体.other, dbo.媒体.createtime
FROM         dbo.媒体发布历史 INNER JOIN
                      dbo.期刊发行 ON dbo.媒体发布历史.发行编号 = dbo.期刊发行.发行编号 INNER JOIN
                      dbo.媒体 ON dbo.媒体发布历史.媒体编号 = dbo.媒体.id INNER JOIN
                      dbo.期刊 ON dbo.期刊发行.期刊编号 = dbo.期刊.编号


GO
/****** Object:  View [dbo].[媒体发布视图]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[媒体发布视图]
AS
SELECT     dbo.媒体发布.媒体编号, dbo.媒体发布.期刊编号, dbo.媒体发布.发布编号, dbo.媒体发布.发行编号, dbo.媒体发布.发行状态, dbo.媒体发布.媒体名称, 
                      dbo.媒体发布.信息编号, dbo.媒体发布.UserID, dbo.期刊.名称, dbo.期刊发行.发行期号, dbo.期刊发行.发行日期, dbo.期刊发行.文件链接, dbo.期刊发行.图片链接, 
                      dbo.期刊发行.文本内容, dbo.期刊发行.邮件内容, dbo.媒体.MediaType, dbo.媒体.MediaURL, dbo.媒体.MediaUser, dbo.媒体.MediaPassword, dbo.媒体.published, 
                      dbo.媒体.other, dbo.媒体.createtime, dbo.期刊发行.本地图片
FROM         dbo.期刊发行 INNER JOIN
                      dbo.媒体发布 ON dbo.期刊发行.发行编号 = dbo.媒体发布.发行编号 INNER JOIN
                      dbo.期刊 ON dbo.期刊发行.期刊编号 = dbo.期刊.编号 INNER JOIN
                      dbo.媒体 ON dbo.媒体发布.媒体编号 = dbo.媒体.id


GO
/****** Object:  View [dbo].[期刊订阅视图]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[期刊订阅视图]
AS
SELECT     dbo.S期刊订阅.S订阅编号, dbo.S期刊订阅.S期刊编号, dbo.S期刊订阅.期刊编号, dbo.S期刊订阅.开始日期, dbo.S期刊订阅.结束日期, dbo.S期刊订阅.订阅文书, 
                      dbo.S期刊订阅.许可编号, dbo.S期刊订阅.UserID, dbo.S期刊.编号, dbo.S期刊.名称, dbo.S期刊.主编, dbo.S期刊.发行周期, dbo.S期刊.发行地点, dbo.S期刊.大分类, 
                      dbo.S期刊.中分类, dbo.S期刊.小分类, dbo.S期刊.是否加密, dbo.S期刊.密码, dbo.S期刊.是否收费, dbo.S期刊.每期金额, dbo.S期刊.货币类型, dbo.S期刊.主编信箱, 
                      dbo.S期刊.是否本机, dbo.S期刊.UserID AS OwnerID, dbo.S用户.UserMail
FROM         dbo.S期刊 LEFT OUTER JOIN
                      dbo.S期刊订阅 ON dbo.S期刊.S期刊编号 = dbo.S期刊订阅.S期刊编号 LEFT OUTER JOIN
                      dbo.S用户 ON dbo.S期刊订阅.UserID = dbo.S用户.UserID


GO
/****** Object:  View [dbo].[期刊发行历史视图]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[期刊发行历史视图]
AS
SELECT     dbo.期刊送信历史.送信编号, dbo.期刊送信历史.客户编号, dbo.期刊送信历史.期刊编号, dbo.期刊送信历史.发行编号, dbo.期刊送信历史.送信状态, 
                      dbo.期刊送信历史.服务器名称, dbo.期刊送信历史.信息编号, dbo.期刊送信历史.UserID, dbo.客户.Cname, dbo.客户.name, dbo.客户.mail, dbo.期刊.名称, 
                      dbo.期刊发行.发行期号, dbo.期刊发行.发行日期, dbo.期刊发行.文件链接, dbo.期刊发行.图片链接, dbo.期刊发行.文本内容, dbo.期刊发行.邮件内容
FROM         dbo.期刊送信历史 INNER JOIN
                      dbo.期刊发行 ON dbo.期刊送信历史.发行编号 = dbo.期刊发行.发行编号 INNER JOIN
                      dbo.客户 ON dbo.期刊送信历史.客户编号 = dbo.客户.id INNER JOIN
                      dbo.期刊 ON dbo.期刊送信历史.期刊编号 = dbo.期刊.编号


GO
/****** Object:  View [dbo].[期刊发行视图]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[期刊发行视图]
AS
SELECT     dbo.期刊送信.送信编号, dbo.期刊送信.客户编号, dbo.期刊送信.期刊编号, dbo.期刊送信.发行编号, dbo.期刊送信.送信状态, dbo.期刊送信.服务器名称, 
                      dbo.期刊送信.信息编号, dbo.期刊送信.UserID, dbo.客户.Cname, dbo.客户.name, dbo.客户.mail, dbo.期刊.名称, dbo.期刊发行.发行期号, dbo.期刊发行.发行日期, 
                      dbo.期刊发行.文件链接, dbo.期刊发行.图片链接, dbo.期刊发行.文本内容, dbo.期刊发行.邮件内容
FROM         dbo.期刊送信 INNER JOIN
                      dbo.期刊发行 ON dbo.期刊送信.发行编号 = dbo.期刊发行.发行编号 INNER JOIN
                      dbo.客户 ON dbo.期刊送信.客户编号 = dbo.客户.id INNER JOIN
                      dbo.期刊 ON dbo.期刊送信.期刊编号 = dbo.期刊.编号


GO
/****** Object:  View [dbo].[期刊阅览视图]    Script Date: 2015/04/02 22:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[期刊阅览视图]
AS
SELECT                  dbo.S期刊.S期刊编号, dbo.S期刊.编号, dbo.S期刊.名称, dbo.S期刊.主编, dbo.S期刊.发行周期, dbo.S期刊.发行地点, dbo.S期刊.大分类, dbo.S期刊.中分类, dbo.S期刊.小分类, 
                                  dbo.S期刊.是否加密, dbo.S期刊.密码, dbo.S期刊.是否收费, dbo.S期刊.每期金额, dbo.S期刊.货币类型, dbo.S期刊.主编信箱, dbo.S期刊.是否本机, dbo.S期刊.UserID AS Owner, 
                                  dbo.S期刊订阅.S订阅编号, dbo.S期刊订阅.开始日期, dbo.S期刊订阅.结束日期, dbo.S期刊订阅.订阅文书, dbo.S期刊订阅.许可编号, dbo.S期刊订阅.UserID AS SubscriptID, dbo.S期刊发行.发行期号, 
                                  dbo.S期刊发行.发行日期, dbo.S期刊发行.文件链接, dbo.S期刊发行.图片链接, dbo.S期刊发行.文本内容, dbo.S期刊发行.邮件内容, dbo.S期刊发行.期刊状态, dbo.S期刊发行.FTP文件, 
                                  dbo.S期刊发行.本地文件, dbo.S期刊发行.本地图片, dbo.S期刊发行.FTP图片, dbo.S期刊发行.S发行编号
FROM                     dbo.S期刊 LEFT OUTER JOIN
                                  dbo.S期刊订阅 ON dbo.S期刊.S期刊编号 = dbo.S期刊订阅.S期刊编号 LEFT OUTER JOIN
                                  dbo.S期刊发行 ON dbo.S期刊.S期刊编号 = dbo.S期刊发行.S期刊编号


GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'17' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1041' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'customer_local' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'Cname'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'Cname'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'Cname'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'Cname'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1041' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'Cname'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'Cname'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'Cname'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'3960' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'Cname'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'Cname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'Cname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'Cname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'Cname'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'Cname' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'Cname'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'Cname'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'Cname'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'Cname'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'Cname' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'Cname'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'customer_local' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'Cname'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'Cname'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'Cname'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'Cname'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1041' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'50' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'customer_local' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'postcode'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'postcode'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'postcode'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'postcode'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1041' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'postcode'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'postcode'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'postcode'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'postcode'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'postcode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'postcode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'postcode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'postcode'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'postcode' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'postcode'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'postcode'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'postcode'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'8' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'postcode'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'postcode' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'postcode'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'customer_local' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'postcode'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'postcode'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'postcode'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'postcode'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'address'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'address'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'address'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'address'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1041' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'address'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'address'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'address'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'3990' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'address'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'address'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'address'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'address'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'address'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'address' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'address'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'address'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'address'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'100' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'address'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'address' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'address'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'customer_local' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'address'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'address'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'address'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'address'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'tel'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'tel'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'tel'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'tel'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1041' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'tel'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'tel'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'tel'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'tel'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'tel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'tel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'tel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'tel'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'tel' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'tel'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'5' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'tel'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'tel'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'50' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'tel'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'tel' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'tel'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'customer_local' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'tel'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'tel'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'tel'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'tel'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FAX'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FAX'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FAX'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FAX'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1041' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FAX'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FAX'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FAX'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FAX'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FAX'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FAX'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FAX'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FAX'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'FAX' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FAX'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'6' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FAX'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FAX'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FAX'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'FAX' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FAX'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'customer_local' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FAX'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FAX'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FAX'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FAX'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'kind'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'kind'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'kind'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'kind'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1041' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'kind'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'kind'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'kind'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'kind'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'kind'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'kind'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'kind'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'kind'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'kind' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'kind'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'7' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'kind'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'kind'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'kind'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'kind' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'kind'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'customer_local' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'kind'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'kind'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'kind'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'kind'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FORMAT'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FORMAT'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FORMAT'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FORMAT'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1041' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FORMAT'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FORMAT'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FORMAT'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FORMAT'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FORMAT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FORMAT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FORMAT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FORMAT'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'FORMAT' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FORMAT'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'8' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FORMAT'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FORMAT'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FORMAT'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'FORMAT' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FORMAT'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'customer_local' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FORMAT'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FORMAT'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FORMAT'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'FORMAT'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'scale'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'scale'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'scale'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'scale'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1041' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'scale'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'scale'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'scale'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'scale'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'scale'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'scale'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'scale'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'scale'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'scale' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'scale'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'9' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'scale'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'scale'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'50' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'scale'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'scale' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'scale'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'customer_local' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'scale'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'scale'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'scale'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'scale'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'CYMD'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'CYMD'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'CYMD'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'CYMD'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1041' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'CYMD'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'CYMD'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'CYMD'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'CYMD'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'CYMD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'CYMD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'CYMD'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'CYMD' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'CYMD'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'CYMD'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'CYMD'
GO
EXEC sys.sp_addextendedproperty @name=N'ShowDatePicker', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'CYMD'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'8' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'CYMD'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'CYMD' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'CYMD'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'customer_local' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'CYMD'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'CYMD'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'8' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'CYMD'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'other'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'other'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'other'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'other'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1041' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'other'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'other'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'other'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'other'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'other'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'other'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'other'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'other'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'other' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'other'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'11' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'other'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'other'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'other'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'other' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'other'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'customer_local' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'other'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'other'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'other'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'other'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'mail'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'mail'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'mail'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'mail'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1041' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'mail'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'mail'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'mail'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'mail'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'mail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'mail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'mail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'mail'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'mail' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'mail'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'12' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'mail'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'mail'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'100' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'mail'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'mail' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'mail'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'customer_local' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'mail'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'mail'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'mail'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'mail'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'web'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'web'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'web'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'web'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1041' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'web'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'web'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'web'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'web'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'web'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'web'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'web'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'web'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'web' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'web'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'13' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'web'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'web'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'web'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'web' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'web'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'customer_local' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'web'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'web'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'web'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'web'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'jCNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'jCNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'jCNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'jCNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1041' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'jCNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'jCNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'jCNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'jCNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'jCNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'jCNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'jCNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'jCNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'jCNAME' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'jCNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'14' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'jCNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'jCNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'jCNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'jCNAME' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'jCNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'customer_local' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'jCNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'jCNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'jCNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'jCNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'createtime'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'createtime'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'createtime'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'createtime'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1041' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'createtime'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'createtime'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'createtime'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'createtime'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'createtime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'createtime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'createtime'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'createtime' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'createtime'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'15' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'createtime'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'createtime'
GO
EXEC sys.sp_addextendedproperty @name=N'ShowDatePicker', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'createtime'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'8' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'createtime'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'createtime' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'createtime'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'customer_local' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'createtime'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'createtime'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'8' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户', @level2type=N'COLUMN',@level2name=N'createtime'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户'
GO
EXEC sys.sp_addextendedproperty @name=N'DateCreated', @value=N'2007/4/3 16:37:53' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户'
GO
EXEC sys.sp_addextendedproperty @name=N'DisplayViewsOnSharePointSite', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户'
GO
EXEC sys.sp_addextendedproperty @name=N'FilterOnLoad', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户'
GO
EXEC sys.sp_addextendedproperty @name=N'HideNewField', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户'
GO
EXEC sys.sp_addextendedproperty @name=N'LastUpdated', @value=N'2013/8/3 21:57:24' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DefaultView', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOn', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Orientation', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'customer_local' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户'
GO
EXEC sys.sp_addextendedproperty @name=N'OrderByOnLoad', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户'
GO
EXEC sys.sp_addextendedproperty @name=N'RecordCount', @value=N'18696' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户'
GO
EXEC sys.sp_addextendedproperty @name=N'TotalsRow', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户'
GO
EXEC sys.sp_addextendedproperty @name=N'Updatable', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'客户'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "FTP服务器"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 225
               Right = 177
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "期刊发行"
            Begin Extent = 
               Top = 8
               Left = 408
               Bottom = 206
               Right = 547
            End
            DisplayFlags = 280
            TopColumn = 5
         End
         Begin Table = "FTP上传历史"
            Begin Extent = 
               Top = 6
               Left = 215
               Bottom = 218
               Right = 354
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "期刊"
            Begin Extent = 
               Top = 17
               Left = 577
               Bottom = 136
               Right = 716
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'FTP上传历史视图'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'FTP上传历史视图'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[47] 2[5] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "FTP服务器"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 188
               Right = 177
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "期刊发行"
            Begin Extent = 
               Top = 14
               Left = 429
               Bottom = 214
               Right = 568
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "FTP上传"
            Begin Extent = 
               Top = 6
               Left = 215
               Bottom = 185
               Right = 354
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "期刊"
            Begin Extent = 
               Top = 10
               Left = 604
               Bottom = 129
               Right = 743
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'FTP上传视图'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'FTP上传视图'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "客户数据库"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 212
               Right = 193
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "客户同步历史"
            Begin Extent = 
               Top = 6
               Left = 231
               Bottom = 213
               Right = 404
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'客户同步历史视图'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'客户同步历史视图'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -307
         Left = 0
      End
      Begin Tables = 
         Begin Table = "客户数据库"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 231
               Right = 193
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "客户同步"
            Begin Extent = 
               Top = 6
               Left = 231
               Bottom = 196
               Right = 404
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'客户同步视图'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'客户同步视图'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[10] 2[31] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "期刊发行"
            Begin Extent = 
               Top = 26
               Left = 411
               Bottom = 209
               Right = 550
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "媒体"
            Begin Extent = 
               Top = 44
               Left = 31
               Bottom = 231
               Right = 194
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "期刊"
            Begin Extent = 
               Top = 23
               Left = 584
               Bottom = 211
               Right = 723
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "媒体发布历史"
            Begin Extent = 
               Top = 6
               Left = 232
               Bottom = 125
               Right = 371
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'媒体发布历史视图'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'媒体发布历史视图'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "期刊发行"
            Begin Extent = 
               Top = 7
               Left = 415
               Bottom = 194
               Right = 554
            End
            DisplayFlags = 280
            TopColumn = 6
         End
         Begin Table = "媒体发布"
            Begin Extent = 
               Top = 6
               Left = 239
               Bottom = 215
               Right = 378
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "期刊"
            Begin Extent = 
               Top = 6
               Left = 585
               Bottom = 181
               Right = 724
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "媒体"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 219
               Right = 201
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'媒体发布视图'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'媒体发布视图'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[47] 4[18] 2[25] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "S期刊"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 173
               Right = 181
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "S期刊订阅"
            Begin Extent = 
               Top = 6
               Left = 219
               Bottom = 173
               Right = 362
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "S用户"
            Begin Extent = 
               Top = 6
               Left = 400
               Bottom = 125
               Right = 551
            End
            DisplayFlags = 280
            TopColumn = 1
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'期刊订阅视图'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'期刊订阅视图'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[42] 4[7] 2[34] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "期刊送信历史"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 201
               Right = 187
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "期刊发行"
            Begin Extent = 
               Top = 6
               Left = 584
               Bottom = 212
               Right = 723
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "期刊"
            Begin Extent = 
               Top = 91
               Left = 427
               Bottom = 210
               Right = 566
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "客户"
            Begin Extent = 
               Top = 6
               Left = 225
               Bottom = 125
               Right = 369
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'期刊发行历史视图'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'期刊发行历史视图'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[43] 4[7] 2[19] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "期刊送信"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 201
               Right = 187
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "期刊发行"
            Begin Extent = 
               Top = 6
               Left = 584
               Bottom = 212
               Right = 723
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "期刊"
            Begin Extent = 
               Top = 91
               Left = 427
               Bottom = 210
               Right = 566
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "客户"
            Begin Extent = 
               Top = 6
               Left = 225
               Bottom = 125
               Right = 369
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'期刊发行视图'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'期刊发行视图'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[42] 4[22] 2[16] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "S期刊"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 181
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "S期刊订阅"
            Begin Extent = 
               Top = 6
               Left = 219
               Bottom = 125
               Right = 362
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "S期刊发行"
            Begin Extent = 
               Top = 6
               Left = 400
               Bottom = 125
               Right = 543
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 35
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWid' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'期刊阅览视图'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'ths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'期刊阅览视图'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'期刊阅览视图'
GO
