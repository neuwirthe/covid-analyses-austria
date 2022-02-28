## ----setup, include=FALSE-------------------------------
knitr::opts_chunk$set(echo = TRUE)


## -------------------------------------------------------
suppressPackageStartupMessages({
  library(here)
  library(fs)
})  
source(path(here(),"utils","purl_and_source.R"))
purl_and_source(path(here(),"utils","base_utils.Rmd"))


## -------------------------------------------------------
bundesland_permanent_df <-
tribble(
~BundeslandID, ~Kurzbezeichnung, ~Bundesland, ~pop,
  0, "U", "Unbekannt", NA,
 1, "B", "Burgenland", 296010,
 2, "K", "Kärnten", 562089,
 3, "N", "Niederösterreich", 1690879,
 4, "O", "Oberösterreich", 1495608,
 5, "Sa", "Salzburg", 560710,
 6, "St", "Steiermark", 1247077,
 7, "T", "Tirol", 760105,
 8, "V", "Vorarlberg", 399237,
 9, "W", "Wien", 1920949,
 10, "Ö", "Österreich", 8932664 
) 


## -------------------------------------------------------
read_carefully <- function(filename){
  try(read_file(filename),silent=TRUE) ->
        f
  if("try-error" %in% class(f)) {
    return(tibble())
  } else {
  first_line <- read_lines(f,n_max=1)
   if(Encoding(f) != "UTF-8"){
     f <- iconv(f,from="latin1",to="utf8")
   }
   if(str_detect(first_line,"\t")){
     f <- read_tsv(f)
   } else if (str_detect(first_line,";")) {
     f <- suppressMessages(read_delim(f,delim=";"))
   } else {
     f <- read_csv(f)
   }
  f
  }
}

