## ----setup, include=FALSE-----------------------------
knitr::opts_chunk$set(echo = FALSE)


## -----------------------------------------------------
require(lubridate,quietly=TRUE)


## ----u7-----------------------------------------------
ger_date_1_Jan <- function(in_date) {
  Sys.setlocale("LC_TIME", "de_AT")
  as.POSIXct(in_date) %>%
    strftime(format = "%d. %b.", locale = locale("de_AT")) %>%
    ifelse(str_sub(.,1,1)=="0",str_sub(.,2),.)
}


## ----u8-----------------------------------------------
ger_date_long <- function(in_date) {
  Sys.setlocale("LC_TIME", "de_AT")
  as.POSIXct(in_date) %>%
    strftime(format = "%d. %B", locale = locale("de_AT")) %>%
    ifelse(str_sub(., 1, 1) == "0", str_sub(., 2), .)
}


## ----u9-----------------------------------------------
ger_date_full <- function(in_date) {
  Sys.setlocale("LC_TIME", "de_AT")
  as.POSIXct(in_date) %>%
    strftime(format = "%d. %B %Y", locale = locale("de_AT")) %>%
    ifelse(str_sub(., 1, 1) == "0", str_sub(., 2), .) %>%
    str_replace(.,"Februar","Feber")
}


## ----u10----------------------------------------------
ger_date_1_Jan_20 <- function(x){
  paste(ger_date_1_Jan(x),
        paste0("'",str_sub(as.character(year(x)),3,4)))
}


## ----u10a---------------------------------------------
ger_date_num <- function(in_date) {
  Sys.setlocale("LC_TIME", "de_AT")
  as.POSIXct(in_date) %>%
    strftime(format = "%d. %m.", locale = locale("de_AT"))
}


## ----u10b---------------------------------------------
ger_date_month <- function(in_date) {
  Sys.setlocale("LC_TIME", "de_AT")
  as.POSIXct(in_date) %>%
    strftime(format = "%b. %y", locale = locale("de_AT"))
}


