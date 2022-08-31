nidx <- length(index_data$index_code)
nacidx <- length(acidx_data$account_id)

if (nacidx > 0) {
  nac <- 1
  mtd_rtn <- 0
  mtd_rtn_yest <- 0
  old_ac <- acidx_data$account_id[1]
  ac_data <- data.frame(matrix(nrow=0,ncol=4))
  names(ac_data)<-c("index_code","mtd_rtn","mtd_rtn_yest","day_rtn")
  
  for (iacidx in 1:nacidx) {
    iidx <- GetiIdx(acidx_data$index_code[iacidx], index_data, nidx)
    if (acidx_data$account_id[iacidx] != old_ac) {
      day_rtn = 100 * ((1 + mtd_rtn/100)/(1 + mtd_rtn_yest/100) - 1)
      ac_data[nac,] <- c(acidx_data$account_id[iacidx-1], mtd_rtn, mtd_rtn_yest, day_rtn)
      nac <- nac + 1
      old_ac <- acidx_data$account_id[iacidx]
      if (iidx < 0) {
        mtd_rtn <- 0
        mtd_rtn_yest <- 0
      } else {
        mtd_rtn <- acidx_data$index_wt[iacidx] * as.numeric(index_data$mtd_rtn[iidx])
        mtd_rtn_yest <- acidx_data$index_wt[iacidx] * as.numeric(index_data$mtd_rtn_yest[iidx])
      }
    } else {
      if (iidx > 0) {
        mtd_rtn <- mtd_rtn + acidx_data$index_wt[iacidx] * as.numeric(index_data$mtd_rtn[iidx])
        mtd_rtn_yest <- mtd_rtn_yest + acidx_data$index_wt[iacidx] * as.numeric(index_data$mtd_rtn_yest[iidx])
      }
    }
  }
  day_rtn = 100 * ((1 + mtd_rtn/100)/(1 + mtd_rtn_yest/100) - 1)
  ac_data[nac,] <- c(acidx_data$account_id[nacidx], mtd_rtn, mtd_rtn_yest, day_rtn)
}
