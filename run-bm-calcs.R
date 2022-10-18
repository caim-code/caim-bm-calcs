library(caim)
library(lubridate)

config <- fread(ifelse(file.exists("./config/config.csv"), "./config/config.csv", "./config/config_default.csv"))
prefs <- list()
for (x in 1:nrow(config)) {
  prefs[[config[x, parameter]]] <- config[x, value]
}

WORKING_DIR <- prefs$working_dir
setwd(WORKING_DIR)

dt_1d_ago <- Sys.Date() - 1
if (wday(dt_1d_ago) == 1){
  dt_1d_ago <- dt_1d_ago - 2
} else if (wday(dt_1d_ago) == 7) {
  dt_1d_ago <- dt_1d_ago - 1
}

dt_2d_ago <- dt_1d_ago - 1
if (wday(dt_2d_ago) == 1){
  dt_2d_ago <- dt_2d_ago - 2
} else if (wday(dt_2d_ago) == 7) {
  dt_2d_ago <- dt_2d_ago - 1
}

dt_list <- c(dt_2d_ago, dt_1d_ago)

for (dt_eff in dt_list) {
  print(format(as.Date(dt_eff),"%Y-%m-%d"))
  
  xfun::Rscript_call(
    rmarkdown::render,
    list(input = 'caim-bm-calcs.Rmd', params = list(dt_eff = dt_eff)))
}
