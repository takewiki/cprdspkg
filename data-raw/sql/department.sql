create view rds_bd_department
as
select a.FDEPTID,a.FNUMBER,b.FNAME   from T_BD_DEPARTMENT a
inner join T_BD_DEPARTMENT_L  b
on a.FDEPTID = b.FDEPTID
go
