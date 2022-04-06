## ----setup, echo=FALSE---------------------------------
knitr::opts_chunk$set(
  echo = FALSE,
  warning = FALSE,
  message = FALSE
) 


## ------------------------------------------------------
suppressPackageStartupMessages({
  library(here)
  library(fs)
  library(readxl)
})  
source(path(here(),"utils","purl_and_source.R"))
purl_and_source(path(here(),"utils","base_utils.Rmd"))


## ------------------------------------------------------
remove_data <- TRUE


## ------------------------------------------------------
purl_and_source(path(here(),"utils","get_data_utils.Rmd"))


## ------------------------------------------------------
save_path <- path(here(),"data","raw_data")


## ------------------------------------------------------
#read_excel(path(here(),"data","old_data",
#                "Laender_Namen.xlsx")) ->
#  laender_namen


## ------------------------------------------------------
load(path(here(),"data","old_data",
                 "country_names_data.RData"))


## ------------------------------------------------------
read_carefully(
  "https://covid.ourworldindata.org/data/owid-covid-data.csv") |>
#  left_join(
#    laender_namen |>
#      select(Land,alpha_3) |>
#      rename(iso_code=alpha_3)
#  ) |>
  left_join(country_names_data) |>
  select(iso_code:location,country,Land,everything()) ->
  owid_data


## ------------------------------------------------------
#owid_data |>
#  select(iso_code,location,Land) |>
#  distinct() |>
#  rename(country=location) ->
#  country_names_data
#save(country_names_data,
#     file=path(here(),"data","old_data",
#              "country_names_data.Rdata")) 


## ------------------------------------------------------
save(owid_data,
     file=path(save_path,"owid_data.RData"))


## ------------------------------------------------------
if(exists("remove_data")){
if(remove_data){
remove(owid_data,
   country_names_data,
   bundesland_permanent_df,
   remove_data)
}}  

