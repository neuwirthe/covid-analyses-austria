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
  "https://info.gesundheitsministerium.gv.at/data/COVID19_vaccination_doses_timeline.csv")) |>
  mutate(Datum=as.Date(date) + 1, .before=1) |>
  select(-date) |>
  rename(BundeslandID=state_id) |>
  rename(Bundesland=state_name) |>
  mutate(Bundesland=str_replace(Bundesland,"NoState","Unbekannt")) |>
  rename(Impfstoff=vaccine) |>
  rename(Dosis_nr=dose_number) |>
  rename(Dosen=doses_administered_cumulative) |>
  mutate_if(is.numeric,as.integer) ->
  impfdosen_data


## -----------------------------------------------------
save(impfdosen_data,
     file=path(save_path,"impfdosen_data.RData"))


## -----------------------------------------------------
file_template <- 
  "https://info.gesundheitsministerium.gv.at/data/archiv/COVID19_vaccination_doses_agegroups_xxxxxxxx.csv"

seq(from=as.Date("2021-10-29"),to=Sys.Date(),by="1 day") |>
  as.character() |>
  str_remove_all("-") ->
  date_seq

str_replace(file_template,"xxxxxxxx",date_seq) ->
  files_to_get


## -----------------------------------------------------
map(files_to_get,
    \(f)read_carefully(f)
    ) |>
  reduce(bind_rows) ->
  vac_age_doses_data 


## -----------------------------------------------------
vac_age_doses_data |>
  mutate(Datum=as.Date(date)+1,.before=1) |>
  select(-date) |>
  rename(BundeslandID=state_id) |>
  rename(Bundesland=state_name) |>
  mutate(Bundesland=str_replace(Bundesland,"NoState","Unbekannt")) |>
  rename(Alter=age_group) |>
  mutate(Alter=str_replace(Alter,fixed("85+"),"85-")) |>
  mutate(Alter=str_replace(Alter,"00-","0-")) |>
  mutate(Alter=str_replace(Alter,"NotAssigned","Unbekannt")) |>
  rename(Geschlecht=gender) |>
  mutate(Geschlecht=str_replace(Geschlecht,"Female","w")) |>
  mutate(Geschlecht=str_replace(Geschlecht,"Male","m")) |>
  mutate(Geschlecht=str_replace(Geschlecht,"NonBinary","d")) |>
  mutate(Geschlecht=str_replace(Geschlecht,"NotAssigned","u")) |>
  rename(Impfstoff=vaccine) |>
  rename(Dosis_nr=dose_number) |>
  rename(Dosen=doses_administered_cumulative) |>
  mutate_if(is.numeric,as.integer) ->
  impfdosen_age_gender_data


## -----------------------------------------------------
rm(vac_age_doses_data)
save(impfdosen_age_gender_data,
     file=path(save_path,"impfdosen_age_gender_data.RData"))


## -----------------------------------------------------
file_template <- 
  "https://info.gesundheitsministerium.gv.at/data/archiv/COVID19_vaccination_certificates_xxxxxxxx.csv"

seq(from=as.Date("2021-10-24"),to=Sys.Date(),by="1 day") |>
  as.character() |>
  str_remove_all("-") ->
  date_seq

str_replace(file_template,"xxxxxxxx",date_seq) ->
  files_to_get


## -----------------------------------------------------
map(files_to_get,
    \(f)read_carefully(f)
    ) |>
  reduce(bind_rows) ->
  vac_cert_data 


## -----------------------------------------------------
vac_cert_data |>
  mutate(Datum=as.Date(date)+1,.before=1) |>
  select(-date) |>
  rename(BundeslandID=state_id) |>
  rename(Bundesland=state_name) |>
  mutate(Bundesland=str_replace(Bundesland,"NoState","Unbekannt")) |>
  rename(Alter=age_group) |>
  rename(Geschlecht=gender) |>
  mutate(Geschlecht=str_replace(Geschlecht,"Female","w")) |>
  mutate(Geschlecht=str_replace(Geschlecht,"Male","m")) |>
  mutate(Geschlecht=str_replace(Geschlecht,"NonBinary","d")) |>
  mutate(Geschlecht=str_replace(Geschlecht,"NotAssigned","u")) |>
  rename(pop=population) |>
  rename(Zert=valid_certificates) |>
  select(-valid_certificates_percent) |>
  mutate_if(is.numeric,as.integer) ->
  impf_zert_data


## -----------------------------------------------------
rm(vac_cert_data)
save(impf_zert_data,
     file=path(save_path,"impf_zert_data.RData"))


## -----------------------------------------------------
read_carefully(
  "https://info.gesundheitsministerium.gv.at/data/timeline-bbg.csv") |>
  mutate(Datum=as.Date(Datum) + 1) |>
  rename(pop=Bevölkerung) |>
  select(-BestellungenPro100) |>
  rename(Bundesland=Name) |>
  mutate(Auslieferungen=ifelse(is.na(Auslieferungen),0,Auslieferungen)) |>
  mutate(Bestellungen=ifelse(is.na(Bestellungen),0,Bestellungen)) |>
  select(-AuslieferungenPro100) ->
  impf_bestellt_geliefert_data


## -----------------------------------------------------
save(impf_bestellt_geliefert_data,
     file=path(save_path,"impf_bestellt_geliefert_data.RData"))


## -----------------------------------------------------
read_carefully(path(here(),"data","old_data",
                    "timeline-eimpfpass.csv")) |>
  mutate(Datum=as.Date(Datum)) |> 
  select(-ends_with("Pro100")) |>
  rename(Bundesland=Name) |>
  mutate(Bundesland=str_replace(Bundesland,
                                     "KeineZuordnung","Unbekannt")) ->
  eimpfpass_raw


## -----------------------------------------------------
eimpfpass_raw |>
  select(-contains("Gruppe")) |>
  select(Datum:Bundesland,EingetrageneImpfungen,Teilgeimpfte,
         ends_with("_1")) |>
  rename(Pfizer=EingetrageneImpfungenBioNTechPfizer_1) |>
  rename(Moderna=EingetrageneImpfungenModerna_1) |>
  rename(AstraZeneca=EingetrageneImpfungenAstraZeneca_1) |>
  rename(Unbekannt=ImpfstoffNichtZugeordnet_1) |>
  mutate(Dosis=1,.before=Teilgeimpfte) |>
  rename(Geimpft=Teilgeimpfte) |>
  select(-EingetrageneImpfungen) ->
  eimpfpass_1


## -----------------------------------------------------
eimpfpass_raw |>
  select(-contains("Gruppe")) |>
  select(Datum:Bundesland,EingetrageneImpfungen,Teilgeimpfte,
         ends_with("_2"),EingetrageneImpfungenJanssen) |>
  rename(Impfungen=EingetrageneImpfungen) |>
  rename(Pfizer=EingetrageneImpfungenBioNTechPfizer_2) |>
  rename(Moderna=EingetrageneImpfungenModerna_2) |>
  rename(AstraZeneca=EingetrageneImpfungenAstraZeneca_2) |>
  rename(Unbekannt=ImpfstoffNichtZugeordnet_2) |>
  rename(Janssen=EingetrageneImpfungenJanssen) |>
  mutate(Dosis=2,.before=Teilgeimpfte) |>
  select(Datum:AstraZeneca,Janssen,Unbekannt) |>
  mutate(Geimpft=Impfungen-Teilgeimpfte) |>
  select(-Impfungen,-Teilgeimpfte) |>
  select(Datum:Dosis,Geimpft,everything()) ->
  eimpfpass_2

## -----------------------------------------------------
eimpfpass_1 |>
  bind_rows(eimpfpass_2) ->
  eimpfpass_data


## -----------------------------------------------------
remove(eimpfpass_1,eimpfpass_2)
save(eimpfpass_data,
     file=path(save_path,"eimpfpass_data.RData"))


## -----------------------------------------------------
if(exists("remove_data")){
if(remove_data){
  remove(
    bundesland_permanent_df,
    eimpfpass_data,
    eimpfpass_raw,
    impf_bestellt_geliefert_data,
    impf_zert_data,
    impfdosen_age_gender_data,
    impfdosen_data,vac_age_doses_data)
  remove(remove_data)
}}  

