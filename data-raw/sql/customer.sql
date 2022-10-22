alter  view rds_customer
as
select a.F_SZSP_KHFL,a.FNUMBER,a.FCUSTID,b.FDATAVALUE as FCustomerCategory,al.FNAME,c.FName as FDeptName,e.FNAME as FSaleGroupName,d.FSalesName from T_BD_CUSTOMER  a
left join T_BAS_ASSISTANTDATAENTRY_L b
on a.F_SZSP_KHFL = b.FENTRYID
left  join T_BD_CUSTOMER_l al
on a.FCUSTID = al.FCUSTID
left  join rds_bd_department c
on a.FSALDEPTID = c.FDEPTID
left  join takewiki_t_sales d
on a.FSELLER = d.FENTRYID
left  join  [takewiki_t_saleGroup] e
on a.FSALGROUPID = e.FENTRYID
go

select * from  rds_customer
