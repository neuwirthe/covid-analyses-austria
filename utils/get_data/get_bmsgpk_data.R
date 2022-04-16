## ----setup, echo=FALSE--------------------------------
knitr::opts_chunk$set(
  echo = FALSE,
  warning = FALSE,
  message = FALSE
) 


## -----------------------------------------------------
suppressPackageStartupMessages({
  library(here)
  library(fs)
})  
source(path(here(),"utils","purl_and_source.R"))
purl_and_source(path(here(),"utils","base_utils.Rmd"))


## -----------------------------------------------------
remove_data <- TRUE


## -----------------------------------------------------
purl_and_source(path(here(),"utils","get_data_utils.Rmd"))


## -----------------------------------------------------
save_path <- path(here(),"data","raw_data")


## -----------------------------------------------------
suppressMessages(
read_carefully(
  "https://info.gesundheitsministerium.gv.at/data/timeline-faelle-bundeslaender.csv")) |>
  mutate(Datum=as.Date(Datum)) |>
  rename(Bundesland=Name) |>
  rename(cases_BMI=BestaetigteFaelleBundeslaender) |>
  rename(Tot_BMI=Todesfaelle) |>
  rename(Genesen_BMI=Genesen) |>
  rename(Hospital_BMI=Hospitalisierung) |>
  rename(Intensiv_BMI=Intensivstation) |>
  rename(Tests_alle_BMI=Testungen) |>
  rename(Tests_PCR_BMI=TestungenPCR) |>
  rename(Tests_AG_BMI=TestungenAntigen) |>
  mutate_if(is.numeric,as.integer)  ->
  bmi_data_raw  


## -----------------------------------------------------
load(path(
  here(),"data","old_data",
  "ems_bmi_data_upto_feb21.RData"
))


## -----------------------------------------------------
ems_bmi_data_upto_feb21 |>
  select(Datum,BundeslandID,Bundesland,ends_with("_BMI")) |>
  select(-Datum_BMI) |>
  mutate_if(is.numeric,as.integer) |>
  bind_rows(bmi_data_raw) ->
  bmi_data 


## -----------------------------------------------------
save(bmi_data,
     file=path(save_path,"bmi_data.RData"))


## -----------------------------------------------------
suppressMessages(
read_carefully(
"https://info.gesundheitsministerium.gv.at/data/timeline-testungen-apotheken-betriebe.csv")) |>
  mutate(Datum=as.Date(Datum)) |>
  rename(Bundesland=Name) |>
  rename(Tests_apo_alle=TestungenApotheken) |>
  rename(Tests_apo_PCR=TestungenApothekenPCR) |>
  rename(Tests_apo_AG=TestungenApothekenAntigen) |>
  rename(Tests_bet=TestungenBetriebe) ->
  apotheken_betriebe_data


## -----------------------------------------------------
save(apotheken_betriebe_data,
     file=path(save_path,"apotheken_betriebe_data.RData"))


## -----------------------------------------------------
#if(remove_dir) unlink(temp_path,recursive=TRUE)


## -----------------------------------------------------
if(exists("remove_data")){
if (remove_data){
  remove(bmi_data,
         bmi_data_raw,
         apotheken_betriebe_data,
         ems_bmi_data_upto_feb21)
  remove(bundesland_permanent_df)
  remove(remove_data)
  remove(remove_dir)
}}

