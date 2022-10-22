#' 更新对账单期初数据
#'
#' @param config_file 连接
#' @param FOrgNumber 组织代码
#' @param FCustName 客户名称
#' @param Fdate 日期
#' @param FARBal 应收余额
#' @param FUnInvBal 未票余额
#'
#' @return 返回值
#' @export
#'
#' @examples
#' dzd_initData_updateOne()
dzd_initData_updateOne <- function(config_file = 'data-raw/config/conn_erp.R',
                 FOrgNumber ='100',
                 FCustName ='上海药明康德新药开发有限公司',
                 Fdate ='2021-12-31',
                 FARBal = 1,
                 FUnInvBal = 1

                 ) {
  config_info = tsda::conn_config(config_file = config_file)
  conn = tsda::conn_open(conn_config_info = config_info)

sql <- paste0("update a   set FARBal = ",FARBal,",FUnInvBal = ",FUnInvBal,"   from rds_init_data a
where  FOrgNumber ='",FOrgNumber,"' and FCustName ='",FCustName,"' and Fdate ='",Fdate,"'")
print(sql)
#更新数据
tsda::sql_update(conn,sql)
tsda::conn_close(conn)

}



#' 更新对账单期初数据
#'
#' @param FOrgNumber 组织代码
#' @param FCustName 客户名称
#' @param Fdate 日期
#' @param FARBal 应收余额
#' @param FUnInvBal 未票余额
#' @param erp_token ERP口令
#'
#' @return 返回值
#' @export
#'
#' @examples
#' dzd_initData_updateOne()
dzd_initData_updateOne2 <- function(erp_token='4D181CAB-4CE3-47A3-8F2B-8AB11BB6A227',
                                   FOrgNumber ='100',
                                   FCustName ='上海药明康德新药开发有限公司',
                                   Fdate ='2021-12-31',
                                   FARBal = 1,
                                   FUnInvBal = 1

) {


  sql <- paste0("update a   set FARBal = ",FARBal,",FUnInvBal = ",FUnInvBal,"   from rds_init_data a
where  FOrgNumber ='",FOrgNumber,"' and FCustName ='",FCustName,"' and Fdate ='",Fdate,"'")
  print(sql)
  #更新数据
  tsda::sql_update2(token = erp_token,sql_str = sql)

}









#' 更新对账单年初数据
#'
#' @param config_file 配置文件
#' @param data 数据
#'
#' @return 返回值
#' @export
#'
#' @examples
#' dzd_initData_updateAll()
dzd_initData_updateAll <- function(config_file = 'data-raw/config/conn_erp.R',
                                   data



){
  ncount = nrow(data)
  if(ncount >0){
    lapply(1:ncount, function(i){
      FOrgNumber = data$FOrgNumber[i]
      FCustName = data$FCustName[i]
      Fdate = data$Fdate[i]
      FARBal = data$FARBal[i]
      FUnInvBal = data$FUnInvBal[i]
      dzd_initData_updateOne(config_file = config_file,
                             FOrgNumber =FOrgNumber ,
                             FCustName = FCustName,
                             Fdate =Fdate ,
                             FARBal = FARBal,
                             FUnInvBal = FUnInvBal)
    })
  }

}


#' 更新对账单年初数据
#'
#' @param data 数据
#' @param erp_token  ERP口令
#'
#' @return 返回值
#' @export
#'
#' @examples
#' dzd_initData_updateAll()
dzd_initData_updateAll2 <- function(erp_token='4D181CAB-4CE3-47A3-8F2B-8AB11BB6A227',
                                    data



){
  ncount = nrow(data)
  if(ncount >0){
    lapply(1:ncount, function(i){
      FOrgNumber = data$FOrgNumber[i]
      FCustName = data$FCustName[i]
      Fdate = data$Fdate[i]
      FARBal = data$FARBal[i]
      FUnInvBal = data$FUnInvBal[i]
      dzd_initData_updateOne2(erp_token = erp_token,
                             FOrgNumber =FOrgNumber ,
                             FCustName = FCustName,
                             Fdate =Fdate ,
                             FARBal = FARBal,
                             FUnInvBal = FUnInvBal)
    })
  }

}




#' 读取对账单数据
#'
#' @param file_name 文件名
#' @param lang 语言
#'
#' @return 返回值
#' @export
#'
#' @examples
#' dzd_initData_read()
dzd_initData_read <- function(file_name = "data-raw/dzd_initData/赛普对账单期初数修改模板.xlsx",
                              lang = 'en') {

  data <- readxl::read_excel(file_name)
  ncount = nrow(data)
  if(ncount >0){
    if(lang == 'en'){
      names(data) <-c('FOrgNumber','Fdate','FCustName','FARBal','FUnInvBal')
    }

  }
  return(data)


}


