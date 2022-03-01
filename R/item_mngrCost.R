# 本页面用于维护物料的管理成本


#' 读取物料的管理成本
#'
#' @param file_name 文件名
#'
#' @return 返回值
#' @export
#'
#' @examples
#' item_mngrCost_read()
item_mngrCost_read <- function(file_name = "data-raw/item_mngrCost/物料管理成本维护模板.xlsx") {

  data <- readxl::read_excel(file_name)
  ncount  = nrow(data)
  if(ncount >0){
    data = data[ ,c('使用组织','编码','管理成本')]
  }

  return(data)


}

#' 写入数据
#'
#' @param config_file 数据库配置文件
#' @param file_name 文件名
#' @param table_name 表名
#'
#' @return 返回值
#' @export
#'
#' @examples
#' item_mngrCost_update()
item_mngrCost_update <- function(config_file = 'data-raw/config/conn_erp.R',file_name = "data-raw/item_mngrCost/物料管理成本维护模板.xlsx",table_name ='rds_t_material_input'){

  config_info = tsda::conn_config(config_file = config_file)
  conn = tsda::conn_open(conn_config_info = config_info)
  #计取数据
  data = item_mngrCost_read(file_name = file_name)
  ncount = nrow(data)
  if(ncount >0){
    names(data) <-c('FUseOrgName','FNumber','F_SZSP_MNGRCOST')
    data$FUploadDate <- as.character(Sys.Date())
    #备份数据
    sql_bak <- paste0("insert into rds_t_material_del
select * from rds_t_material_input")
    tsda::sql_update(conn,sql_bak)
    #删除数据
    sql_del = paste0("delete  from rds_t_material_input")
    tsda::sql_update(conn,sql_del)

    #上传数据
    tsda::db_writeTable(conn = conn,table_name = table_name,r_object = data,append = T)
    #更新物料数据
    sql_upd = paste0("update a set  a.F_SZSP_MNGRCOST = b.F_SZSP_MNGRCOST from  T_BD_MATERIAL a
inner join rds_vw_material_input b
on a.FNUMBER = b.FNumber   and a.FUSEORGID = b.FOrgId")
    tsda::sql_update(conn,sql_upd)

  }

  tsda::conn_close(conn)
 return(data)

}


