-- !preview conn=DBI::dbConnect(RSQLite::SQLite())

create table rds_t_material_input (
	[FUseOrgName] [varchar](200) NULL,
	[FNumber] [varchar](200) NULL,
	[F_SZSP_MNGRCOST] [float] NULL,
	[FUploadDate] [date] NULL
)


create table rds_t_material_del (
	[FUseOrgName] [varchar](200) NULL,
	[FNumber] [varchar](200) NULL,
	[F_SZSP_MNGRCOST] [float] NULL,
	[FUploadDate] [date] NULL
)

create table rds_t_orgnization(FOrgId int,FOrgName varchar(200))

select * from rds_t_orgnization
insert into rds_t_orgnization values (1,'苏州赛普生物科技有限公司')



create view rds_vw_material_input
as
select	a.*,b.FOrgId from rds_t_material_input a
inner join rds_t_orgnization b
on a.FUseOrgName = b.FOrgName
