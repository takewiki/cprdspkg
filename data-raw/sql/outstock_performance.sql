

create table rds_t_performanceLevel(FNumber varchar(50),FName varchar(200))


insert into rds_t_performanceLevel values('A1','')
insert into rds_t_performanceLevel values('A2','')
insert into rds_t_performanceLevel values('A3','')
insert into rds_t_performanceLevel values('B1','')
insert into rds_t_performanceLevel values('B2','')
insert into rds_t_performanceLevel values('B3','')
insert into rds_t_performanceLevel values('Z','')


CREATE TABLE [dbo].[rds_outstock_calc_performance](
	[FDATE] [datetime] NOT NULL,
	[FBILLNO] [nvarchar](100) NOT NULL,
	[FCustomerCategory] [nvarchar](255) NULL,
	[FCustomerNumber] [nvarchar](100) NULL,
	[FCustomerName] [nvarchar](255) NULL,
	[FDeptName] [nvarchar](255) NULL,
	[FSaleGroupName] [nvarchar](100) NULL,
	[FSalesName] [nvarchar](255) NULL,
	[FENTRYID] [int] NOT NULL,
	[FSEQ] [int] NOT NULL,
	[FProdNumber] [nvarchar](100) NULL,
	[FProdName] [nvarchar](255) NULL,
	[FProdModel] [nvarchar](510) NULL,
	[FREALQTY] [decimal](23, 10) NOT NULL,
	[FALLAMOUNT_LC] [decimal](23, 10) NOT NULL,
	[FTaxPrice_LC] [decimal](38, 15) NULL,
	[F_SZSP_MNGRCOST] [decimal](23, 10) NULL,
	[FProfitRate] [decimal](38, 10) NULL,
	[FIndex1] [numeric](38, 10) NULL,
	[FIndex2] [numeric](38, 10) NULL,
	[FIndex3] [numeric](38, 10) NULL,
	[FIndex][numeric](38, 10)  NOT NULL,
	[FType] [varchar](50) NOT NULL,
	FRuleName varchar(200),
	[FParam_x] [numeric](10, 4) NOT NULL,
	[FParam_y] [numeric](10, 4) NOT NULL,
	[FParam_z] [numeric](10, 4) NOT NULL,
	FStartDate date,
	FEndDate date
) ON [PRIMARY]
GO


select * from [rds_outstock_calc_performance]




CREATE TABLE [dbo].[rds_outstock_calc_performance_del](
	[FDATE] [datetime] NOT NULL,
	[FBILLNO] [nvarchar](100) NOT NULL,
	[FCustomerCategory] [nvarchar](255) NULL,
	[FCustomerNumber] [nvarchar](100) NULL,
	[FCustomerName] [nvarchar](255) NULL,
	[FDeptName] [nvarchar](255) NULL,
	[FSaleGroupName] [nvarchar](100) NULL,
	[FSalesName] [nvarchar](255) NULL,
	[FENTRYID] [int] NOT NULL,
	[FSEQ] [int] NOT NULL,
	[FProdNumber] [nvarchar](100) NULL,
	[FProdName] [nvarchar](255) NULL,
	[FProdModel] [nvarchar](510) NULL,
	[FREALQTY] [decimal](23, 10) NOT NULL,
	[FALLAMOUNT_LC] [decimal](23, 10) NOT NULL,
	[FTaxPrice_LC] [decimal](38, 15) NULL,
	[F_SZSP_MNGRCOST] [decimal](23, 10) NULL,
	[FProfitRate] [decimal](38, 10) NULL,
	[FIndex1] [numeric](38, 10) NULL,
	[FIndex2] [numeric](38, 10) NULL,
	[FIndex3] [numeric](38, 10) NULL,
	[FIndex][numeric](38, 10)  NOT NULL,
	[FType] [varchar](50) NOT NULL,
	FRuleName varchar(200),
	[FParam_x] [numeric](10, 4) NOT NULL,
	[FParam_y] [numeric](10, 4) NOT NULL,
	[FParam_z] [numeric](10, 4) NOT NULL,
	FStartDate date,
	FEndDate date
) ON [PRIMARY]
GO


create table rds_outStock_performance_rule(FInterId int identity(1,1),FName  varchar(100),[FParam_x] [numeric](10, 4) NOT NULL,
	[FParam_y] [numeric](10, 4) NOT NULL,
	[FParam_z] [numeric](10, 4) NOT NULL,
	FStartDate date,FEndDate date )


insert into rds_outStock_performance_rule (FName,FParam_x,FParam_y,FParam_z,FStartDate,FEndDate)
values('赛普生物默认销售提成规则',0.045,0.005,0.75,'2020-04-01','2100-12-31')







alter  view [rds_vw_outstock_performance]
as
SELECT [FDATE]  出库日期
      ,[FBILLNO]  单据编号
	   ,[FSEQ]  行号
      ,[FCustomerCategory] 客户类别
      ,[FCustomerNumber] 客户代码
      ,[FCustomerName] 客户名称
      ,[FDeptName]   销售部门
      ,[FSaleGroupName] 销售组
      ,[FSalesName] 销售员
      ,[FProdNumber] 产品代码
      ,[FProdName] 产品名称
      ,[FProdModel] 规格型号
      ,[FREALQTY] 出库数量
	   ,[FTaxPrice_LC] 含税单价
      ,[FALLAMOUNT_LC] 价税合计
      ,[F_SZSP_MNGRCOST] '管理成本(单价)'
      ,[FProfitRate] 毛利率
      ,[FIndex] 提成金额
      ,[FType] 提成类型
      ,[FRuleName] 提成规则
      ,[FParam_x]  系数1
      ,[FParam_y]  系数2
      ,[FParam_z]  系数3
      ,[FStartDate] 开始日期
      ,[FEndDate] 结束日期
  FROM [dbo].[rds_outstock_calc_performance]
GO

select   * from [rds_vw_outstock_performance]
where 提成规则 = '赛普生物默认销售提成规则'
and 出库日期 >='2022-01-01' and 出库日期 <='2022-01-31'
order by 单据编号,行号


