#' 新增提成规则
#'
#' @param config_file 配置文件
#' @param FName 规则名称
#' @param FParam_x 参数1
#' @param FParam_y 参数2
#' @param FParam_z 参数3
#' @param FStartDate 日期1
#' @param FEndDate 日期2
#'
#' @return 返回值
#' @export
#'
#' @examples
#' outstock_performance_rule_new()
outstock_performance_rule_new <- function(config_file = 'data-raw/config/conn_erp.R',
                                      FName ='销售提成规则4',
                                      FParam_x =0.04,
                                      FParam_y=0.005,
                                      FParam_z=0.75,
                                      FStartDate ='2021-04-01',
                                      FEndDate ='2100-12-31'){
  config_info = tsda::conn_config(config_file = config_file)
  conn = tsda::conn_open(conn_config_info = config_info)

  sql_sel = paste0("select * from rds_outStock_performance_rule
where fname ='",FName,"'")
  data_sel = tsda::sql_select(conn,sql_sel)
  ncount_sel = nrow(data_sel)
  if(ncount_sel == 0){
    #可以新增数据
    res =  TRUE
    sql_ins = paste0("insert into rds_outStock_performance_rule (FName,FParam_x,FParam_y,FParam_z,FStartDate,FEndDate)
values('",FName,"',",FParam_x,",",FParam_y,",",FParam_z,",'",FStartDate,"','",FEndDate,"')")
    tsda::sql_update(conn,sql_ins)

  }else{
    res = FALSE
  }
  tsda::conn_close(conn)
  return(res)


}



#' 规则查询
#'
#' @param config_file 配置文件
#' @param FName  规则名称
#' @param lang  语言
#'
#' @return 查询结果
#' @export
#'
#' @examples
#' outstock_performance_rule_query()
outstock_performance_rule_query <- function(config_file = 'data-raw/config/conn_erp.R',
                                          FName ='',
                                          lang ='cn'
                                         ){
  config_info = tsda::conn_config(config_file = config_file)
  conn = tsda::conn_open(conn_config_info = config_info)
  if(FName == ''){
    sql_sel = paste0("select FName,FParam_x,FParam_y,FParam_z,FStartDate,FEndDate  from rds_outStock_performance_rule ")
  }else{
    sql_sel = paste0("select FName,FParam_x,FParam_y,FParam_z,FStartDate,FEndDate  from rds_outStock_performance_rule
where fname ='",FName,"'")
  }

  data = tsda::sql_select(conn,sql_sel)
  tsda::conn_close(conn)
  ncount = nrow(data)
  if(ncount > 0){

    if(lang == 'cn'){
      names(data) <-c('规则名称','x-提成系数','y-止损系数','z-类别系数','生效日期','失效日期')

    }


  }else{
    data <-data.frame('查询结果' ='未查到结果,请检查规则名称',stringsAsFactors  = F)
  }

  return(data)


}



#' 规则名称参数
#'
#' @param config_file 配置文件
#'
#' @return 返回值
#' @export
#'
#' @examples
#' outstock_performance_rule_names()
outstock_performance_rule_names <- function(config_file = 'data-raw/config/conn_erp.R'

){
  config_info = tsda::conn_config(config_file = config_file)
  conn = tsda::conn_open(conn_config_info = config_info)

  sql_sel = paste0("select FName from rds_outStock_performance_rule ")

  data = tsda::sql_select(conn,sql_sel)
  ncount = nrow(data)
  if(ncount > 0){

    res = tsdo::vect_as_list(data$FName)
  }
  tsda::conn_close(conn)
  return(res)


}



#' 更新处理规则
#'
#' @param config_file 配置
#' @param FRuleName  规则名
#' @param FStartDate 开始日期
#' @param FEndDate 结束日期
#'
#' @return 返回值
#' @export
#'
#' @examples
#' outstock_performance_calc()
outstock_performance_calc <- function(config_file = 'data-raw/config/conn_erp.R',
                                            FRuleName = '赛普生物默认销售提成规则',
                                            FStartDate ='',
                                            FEndDate =''){
  rule_info = outstock_performance_rule_query(config_file = config_file,FName = FRuleName,lang = 'en')
  rule_stat = dim(rule_info)
  config_info = tsda::conn_config(config_file = config_file)
  conn = tsda::conn_open(conn_config_info = config_info)
  if(rule_stat[1] == 1 & rule_stat[2] ==6){
    FParam_x = rule_info$FParam_x
    FParam_y =  rule_info$FParam_y
    FParam_z = rule_info$FParam_z
    if(FStartDate == ''){
      FStartDate = rule_info$FStartDate
    }
    if(FEndDate ==''){
      FEndDate = rule_info$FEndDate
    }
    #备份数据
    sql_bak <- paste0("insert into rds_outstock_calc_performance_del
    select * from rds_outstock_calc_performance
    where  FRuleName ='",FRuleName,"' and FStartDate ='",FStartDate,"' and FEndDate ='",FEndDate,"'")
    tsda::sql_update(conn,sql_bak)
    #删除数据
    sql_del <- paste0("delete  from rds_outstock_calc_performance
    where  FRuleName ='",FRuleName,"' and FStartDate ='",FStartDate,"' and FEndDate ='",FEndDate,"'")
    tsda::sql_update(conn,sql_del)

    #进行正式的数据处理
    sql_ins  = paste0("insert into rds_outstock_calc_performance
select  c.FDATE, c.FBILLNO,d.FCustomerCategory,
d.FNUMBER as FCustomerNumber,d.FNAME as  FCustomerName,
d.FDeptName,d.FSaleGroupName,d.FSalesName,

a.FENTRYID,a.FSEQ,f.FNUMBER as FProdNumber,f.FNAME as FProdName,f.FModel as FProdModel,

a.FREALQTY,b.FALLAMOUNT_LC,

round(b.FALLAMOUNT_LC/a.FREALQTY,2) as FTaxPrice_LC,

e.F_SZSP_MNGRCOST,

case b.FALLAMOUNT_LC  when 0 then -99

else round(1-e.F_SZSP_MNGRCOST/(b.FALLAMOUNT_LC/a.FREALQTY),2) end as FProfitRate,

round((b.FALLAMOUNT_LC - e.F_SZSP_MNGRCOST*a.FREALQTY) * ",FParam_x,",2) as FIndex1,

round(b.FALLAMOUNT_LC* ",FParam_y,",2) as FIndex2,

round((-1)* e.F_SZSP_MNGRCOST*a.FREALQTY*( ",FParam_y,"),2) as FIndex3,
0 as FIndex,
'' as FType,
'",FRuleName,"' as FRuleName,
",FParam_x," as FParam_x,
",FParam_y," as FParam_y,
",FParam_z," as FParam_z,
'",FStartDate,"' as FStartDate,
'",FEndDate,"' as FEndDate

 from T_SAL_OUTSTOCKENTRY a

inner join T_SAL_OUTSTOCKENTRY_F b

on a.FENTRYID = b.FENTRYID

inner join T_SAL_OUTSTOCK c

on a.FID =c.FID

left join rds_customer d

on c.FCUSTOMERID = d.FCUSTID

left join t_bd_material  e

on a.FMATERIALID = e.FMATERIALID
left join takewiki_t_material f
on a.FMATERIALID = f.FMATERIALID
where c.FDATE >= '",FStartDate,"' and c.FDATE <= '",FEndDate,"'
")

    tsda::sql_update(conn,sql_ins)

    sql_a1 = paste0("update rds_outstock_calc_performance set FIndex = round(FIndex1 * ",FParam_z,",2),FType  =  'A1'
 where FCustomerCategory like '公司%'  and FProfitRate >=0.1 and FProfitRate <1
 and FRuleName ='",FRuleName,"' and FStartDate ='",FStartDate,"' and FEndDate ='",FEndDate,"'")
    sql_a2 = paste0(" update rds_outstock_calc_performance set FIndex = FIndex2,FType  =  'A2'
 where FCustomerCategory like '公司%'   and FProfitRate >(-99)  and FProfitRate <0.1
and FRuleName ='",FRuleName,"' and FStartDate ='",FStartDate,"' and FEndDate ='",FEndDate,"'")
    sql_a3 = paste0("  update rds_outstock_calc_performance set FIndex = FIndex3,FType  =  'A3'
 where FCustomerCategory like '公司%'   and FProfitRate = (-99)  and F_SZSP_MNGRCOST <>0
 and FRuleName ='",FRuleName,"' and FStartDate ='",FStartDate,"' and FEndDate ='",FEndDate,"'")

    sql_b1 = paste0("  update rds_outstock_calc_performance set FIndex = round(FIndex1 *1,2),FType  =  'B1'
 where FCustomerCategory like '个人%'    and FProfitRate >=0.1 and FProfitRate <1
 and FRuleName ='",FRuleName,"' and FStartDate ='",FStartDate,"' and FEndDate ='",FEndDate,"'")
    sql_b2 = paste0("   update rds_outstock_calc_performance set FIndex = FIndex2,FType  =  'B2'
 where FCustomerCategory like '个人%'    and FProfitRate >(-99)  and FProfitRate <0.1
 and FRuleName ='",FRuleName,"' and FStartDate ='",FStartDate,"' and FEndDate ='",FEndDate,"'")
    sql_b3 = paste0("    update rds_outstock_calc_performance set FIndex = FIndex3,FType  =  'B3'
 where FCustomerCategory like '个人%'    and FProfitRate = (-99)  and F_SZSP_MNGRCOST <>0
 and FRuleName ='",FRuleName,"' and FStartDate ='",FStartDate,"' and FEndDate ='",FEndDate,"'")
    sql_z = paste0("     update rds_outstock_calc_performance set FIndex = 0,FType  =  'Z'
 where isnull(F_SZSP_MNGRCOST,0)  = 0
 and FRuleName ='",FRuleName,"' and FStartDate ='",FStartDate,"' and FEndDate ='",FEndDate,"'")
    tsda::sql_update(conn,sql_a1)
    tsda::sql_update(conn,sql_a2)
    tsda::sql_update(conn,sql_a3)
    tsda::sql_update(conn,sql_b1)
    tsda::sql_update(conn,sql_b2)
    tsda::sql_update(conn,sql_b3)
    tsda::sql_update(conn,sql_z)




  }







}



#' 奖金提成查询
#'
#' @param config_file  配置文件
#' @param FRuleName 规则
#' @param FStartDate 开始日期
#' @param FEndDate 结束日期
#'
#' @return 返回值
#' @export
#'
#' @examples
#' outstock_performance_query()
outstock_performance_query <- function(config_file = 'data-raw/config/conn_erp.R',
                                      FRuleName = '赛普生物默认销售提成规则',
                                      FStartDate ='2022-01-01',
                                      FEndDate ='2022-01-31'){
  config_info = tsda::conn_config(config_file = config_file)
  conn = tsda::conn_open(conn_config_info = config_info)
sql <- paste0("select   * from [rds_vw_outstock_performance]
where 提成规则 = '",FRuleName,"'
and 出库日期 >='",FStartDate,"' and 出库日期 <='",FEndDate,"'
order by 单据编号,行号")
data = tsda::sql_select(conn,sql)
tsda::conn_close(conn)
return(data)
}



