require(stringr, quietly = TRUE)
require(knitr, quietly = TRUE)



purl_and_source <- function(filename,no_warnings=TRUE){
  rfilename <- 
    paste0(str_sub(filename,1,nchar(filename)-4),".R")
  if(!str_detect(str_to_lower(filename),".rmd$"))
    filename=paste0(filename,".Rmd")
  knit(filename,output=rfilename,tangle=TRUE,quiet=TRUE)
  
if(no_warnings){  
 suppressWarnings(source(rfilename))
  } else {
    source(rfilename)  
  }
#  unlink(rfilename)
}  
