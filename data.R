
# Initial formatting of the data
library(icesTAF)
library(icesFO)
library(icesFO)
library(dplyr)

mkdir("data")

# load species list
species_list <- read.taf("bootstrap/initial/data/FAO_ASFIS_species/species_list.csv")
sid <- read.taf("bootstrap/initial/data/ICES_StockInformation/sid.csv")

# 1: ICES official cath statistics

hist <- read.taf("bootstrap/initial/data/ICES_nominal_catches/ICES_historical_catches.csv")
official <- read.taf("bootstrap/initial/data/ICES_nominal_catches/ICES_2006_2019_catches.csv")
prelim <- read.taf("bootstrap/initial/data/ICES_nominal_catches/ICES_preliminary_catches.csv")

catch_dat <- 
  format_catches(2021, "Greenland Sea", 
    hist, official, preliminary = NULL, species_list, sid)

write.taf(catch_dat, dir = "data", quote = TRUE)

# 2: STECF effort and landings

effort <- read.taf("bootstrap/data/STECF_effort_data.csv", check.names = TRUE)

landings <- read.taf("bootstrap/initial/data/STECF_landings_data.csv", check.names = TRUE)

frmt_effort <- format_stecf_effort(effort)
effort <- effort %>% rename('regulated.area' = 'regulated area')
effort <- effort %>% rename('regulated.gear' = 'regulated gear')
frmt_effort <- format_stecf_effort(effort)
frmt_landings <- format_stecf_landings(landings)
landings <- landings %>% rename('regulated.area' = 'regulated area')
landings <- landings %>% rename('regulated.gear' = 'regulated gear')
frmt_landings <- format_stecf_landings(landings)

write.taf(frmt_effort, dir = "data", quote = TRUE)
write.taf(frmt_landings, dir = "data", quote = TRUE)


# 3: SAG
sag_sum <- read.taf("bootstrap/initial/data/SAG_data/SAG_summary.csv")
sag_refpts <- read.taf("bootstrap/initial/data/SAG_data/SAG_refpts.csv")
sag_status <- read.taf("bootstrap/initial/data/SAG_data/SAG_status.csv")

clean_sag <- format_sag(summary, refpts, 2021, "Greenland")
clean_status <- format_sag_status(sag_status, 2021, "Greenland")

# list of stocks
GS_stocks <-  c("aru.27.5a14",
                "usk.27.5a14",
                "her.27.1-24a514a",
                "rng.27.1245a8914ab",
                "cod.2127.1f14",
                "rhg.27.nea",
                "cap.27.2a514",
                # "whb.27.1-91214",
                "bli.27.5a14",
                # "pra.27.1-2",
                "ghl.27.561214",
                "mac.27.nea",
                "reb.2127.dp",
                "reb.2127.sp",
                "reb.27.14b",
                "reg.27.561214"
)
clean_sag <- dplyr::filter(clean_sag, StockKeyLabel %in% GS_stocks)
clean_status <- dplyr::filter(clean_status, StockKeyLabel %in% GS_stocks)
             
write.taf(clean_sag, dir = "data")
write.taf(clean_status, dir = "data", quote = TRUE)
