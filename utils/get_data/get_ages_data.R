## ----setup, echo=FALSE--------------------------------
knitr::opts_chunk$set(
  echo = FALSE,
  warning = FALSE,
  message = FALSE
) 


## -----------------------------------------------------
remove_dir <- TRUE
remove_data <- FALSE


## -----------------------------------------------------
suppressPackageStartupMessages({
  library(here)
  library(fs)
})  
source(path(here(),"utils","purl_and_source.R"))
purl_and_source(path(here(),"utils","base_utils.Rmd"))


## -----------------------------------------------------
purl_and_source(path(here(),"utils","get_data_utils.Rmd"))


## -----------------------------------------------------
save_path <- path(here(),"data","raw_data")


## -----------------------------------------------------
temp_path <-
  path(here(),"data","temp_data")


## -----------------------------------------------------
if(!dir_exists(temp_path)) dir_create(temp_path)


## -----------------------------------------------------
curl::curl_download(
  "https://covid19-dashboard.ages.at/data/data.zip",
  destfile=path(temp_path,
                 "data.zip"))



## -----------------------------------------------------
unzip(path(temp_path,"data.zip"),
      overwrite=TRUE,
      exdir=temp_path)


## -----------------------------------------------------
char_to_date <- function(s){
  strptime(s,format="%d.%m.%Y") |>
    as.Date()
}


## -----------------------------------------------------
read_carefully(path(temp_path,"CovidFaelleDelta.csv")) |>
  mutate(Datum=char_to_date(Datum) + 1) |>
  rename(cases_AGES_daily=DeltaAnzahlVortag) |>
  rename(Genesen_AGES_daily=DeltaGeheiltVortag) |>
  rename(Tot_AGES_daily=DeltaTotVortag) |>
  rename(Aktiv_AGES_daily=DeltaAktivVortag) |>
  rename(Tests_alle_AGES_daily=DeltaTestGesamtVortag) |>
  mutate_if(is.numeric,as.integer) ->
  ages_daily_data


## -----------------------------------------------------
#save(ages_daily_data,
#     file=path(save_path,"ages_daily_data.RData"))


## -----------------------------------------------------
read_carefully(path(temp_path,
                    "CovidFaelle_Altersgruppe.csv")) |>
  mutate(Datum=char_to_date(Time) + 1, .before=1) |>
  select(-Time) |> 
  rename(pop=AnzEinwohner) |>
  mutate(Geschlecht=tolower(Geschlecht)) |>
  rename(cases_AGES=Anzahl) |>
  rename(Genesen_AGES=AnzahlGeheilt) |>
  rename(Tot_AGES=AnzahlTot) |>
  rename(Alter=Altersgruppe) |>
  mutate(Alter=ifelse(Alter=="<5","0-5",Alter)) |>
  mutate(Alter=ifelse(Alter==">84","85-",Alter)) |>
  select(Datum,BundeslandID,Bundesland,AltersgruppeID,
         Alter,Geschlecht,
         pop,everything()) |>
  mutate_if(is.numeric,as.integer) ->
  ages_age_data 


## -----------------------------------------------------
save(ages_age_data,
     file=path(save_path,"ages_age_data.RData"))


## -----------------------------------------------------
read_carefully(path(temp_path,
                    "CovidFaelle_GKZ.csv")) |>
  rename(pop=AnzEinwohner) |>
  rename(cases_AGES=Anzahl) |>
  rename(Tot_AGES=AnzahlTot) |>
  mutate(Bezirk=str_replace(Bezirk,"\\("," \\(")) |>
  rename(cases_7_AGES=AnzahlFaelle7Tage) |>
  mutate(Datum=Sys.Date(),.before=1) |>
  mutate_if(is.numeric,as.integer) ->
  ages_bez_today_data 


## -----------------------------------------------------
save(ages_bez_today_data,
     file=path(save_path,"ages_bez_today_data.RData"))


## -----------------------------------------------------
read_carefully(path(temp_path,
                    "CovidFaelle_Timeline_GKZ.csv")) |>
  mutate(Datum=char_to_date(Time)+1,.before=1) |>
  select(-Time) |>
  rename(pop=AnzEinwohner) |>
  mutate(Bezirk=str_replace(Bezirk,"\\("," \\(")) |>
  rename(cases_1_AGES=AnzahlFaelle) |>
  rename(cases_7_AGES=AnzahlFaelle7Tage) |>
  rename(cases_AGES=AnzahlFaelleSum) |>
  select(-SiebenTageInzidenzFaelle) |>
  rename(Tot_1_AGES=AnzahlTotTaeglich) |>
  rename(Tot_AGES=AnzahlTotSum) |>
  rename(Genesen_1_AGES=AnzahlGeheiltTaeglich) |>
  rename(Genesen_AGES=AnzahlGeheiltSum) |>
  mutate_if(is.numeric,as.integer) ->
  ages_bez_data



## -----------------------------------------------------
save(ages_bez_data,
     file=path(save_path,"ages_bez_data.RData"))


## -----------------------------------------------------
read_carefully(path(temp_path,
                    "CovidFaelle_Timeline.csv")) |>
  mutate(Datum=char_to_date(Time)+1,.before=1) |>
  select(-Time) |>
  rename(pop=AnzEinwohner) |>
  rename(cases_1_AGES=AnzahlFaelle) |>
  rename(cases_7_AGES=AnzahlFaelle7Tage) |>
  rename(cases_AGES=AnzahlFaelleSum) |>
  select(-SiebenTageInzidenzFaelle) |>
  rename(Tot_1_AGES=AnzahlTotTaeglich) |>
  rename(Tot_AGES=AnzahlTotSum) |>
  rename(Genesen_1_AGES=AnzahlGeheiltTaeglich) |>
  rename(Genesen_AGES=AnzahlGeheiltSum) |>
  mutate_if(is.numeric,as.integer) ->
  ages_data


## -----------------------------------------------------
save(ages_bez_data,
     file=path(save_path,"ages_data.RData"))


## -----------------------------------------------------
read_carefully(path(temp_path,
                    "CovidFallzahlen.csv")) |>
  mutate(Datum=char_to_date(MeldeDatum),.before=1) |>
  select(-Meldedat,-MeldeDatum) |>
  select(Datum,Bundesland,BundeslandID,everything()) |>
  mutate(Bundesland=str_replace(Bundesland,"Alle","Österreich")) |>
  rename(Tests_alle=TestGesamt) |>
  rename(Normalbetten=FZHosp) |>
  rename(Intensiv=FZICU) |>
  rename(Normalbetten_frei=FZHospFree) |>
  rename(Intensiv_frei=FZICUFree) |>
  mutate_if(is.numeric,as.integer) ->
  ages_hospital_tests_data 


## -----------------------------------------------------
save(ages_hospital_tests_data,
     file=path(save_path,"ages_hospital_tests_data.RData"))


## -----------------------------------------------------
read_carefully(path(temp_path,
                    "Hospitalisierung.csv")) |>
  mutate(Datum=char_to_date(Meldedatum),.before=1) |>
  select(-Meldedatum) |>
  rename(Normalbetten=NormalBettenBelCovid19) |>
  rename(Intensiv_total=IntensivBettenKapGes) |>
  rename(Intensiv_covid=IntensivBettenBelCovid19) |>
  rename(Intensiv_sonst=IntensivBettenBelNichtCovid19) |>  
  rename(Intensiv_frei=IntensivBettenFrei) |>  
  rename(Tests_alle=TestGesamt) |>
  mutate_if(is.numeric,as.integer) ->
  ages_hospital_capacity_data


## -----------------------------------------------------
save(ages_hospital_capacity_data,
     file=path(save_path,"ages_hospital_capacity_data.RData"))


## -----------------------------------------------------
if(remove_dir) unlink(temp_path,recursive=TRUE)


## -----------------------------------------------------
if(exists("remove_data")){
if (remove_data){
  ls() |>
    keep(\(x)str_detect(x,"^ages")) -> zzz
  remove(list=zzz)
  remove(zzz)
  remove(bundesland_permanent_df)
  remove(remove_data)
  remove(remove_dir)
}}

