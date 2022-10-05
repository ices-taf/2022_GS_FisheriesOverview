library(icesTAF)
library(icesFO)
library(sf)
library(ggplot2)
library(tidyr)


## Run utilies
source("bootstrap/utilities.r")

# set values for automatic naming of files:
cap_year <- 2021
cap_month <- "October"
ecoreg_code <- "GS"

##########
#Load data
##########
catch_dat <- read.taf("data/catch_dat.csv")

#################################################
##1: ICES nominal catches and historical catches#
#################################################

#~~~~~~~~~~~~~~~#
# By common name
#~~~~~~~~~~~~~~~#
#Plot
plot_catch_trends(catch_dat, type = "COMMON_NAME", line_count = 7, plot_type = "line")

#Huge other category
catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "European pilchard(=Sardine)")] <- "Sardine"
catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Scomber mackerels nei")] <- "Mackerels"
catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Mackerels nei")] <- "Mackerels"
catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Atlantic chub mackerel")] <- "Chub mackerel"
catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Mackerels")] <- "pelagic"
catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Chub mackerel")] <- "pelagic"
catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Jack and horse mackerels nei")] <- "Jack and horse mackerels"
catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Atlantic horse mackerel")] <- "Jack and horse mackerels"
catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Atlantic mackerel")] <- "mackerel"
catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Jack and horse mackerels")] <- "pelagic"
catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Monkfishes nei")] <- "Anglerfishes nei"
catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Anglerfishes nei")] <- "benthic"
catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Pelagic fishes nei")] <- "pelagic"
catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Raja rays nei")] <- "elasmobranch"
catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Bathyraja rays nei")] <- "elasmobranch"
catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Albacore")] <- "pelagic"
# catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Blue mussel")] <- "crustacean"
# catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Sea mussels nei")] <- "crustacean"
# catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Cockles nei")] <- "crustacean"
# catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Common edible cockle")] <- "crustacean"
# catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Tuberculate cockle")] <- "crustacean"
catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Pouting(=Bib)")] <- "demersal"
catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Gadiformes nei")] <- "demersal"
# catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Cupped oysters nei")] <- "crustacean"
# catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Pacific cupped oyster")] <- "crustacean"
catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Octopuses, etc. nei")] <- "Octopuses"
unique(catch_dat$GUILD)
catch_dat$GUILD <- tolower(catch_dat$GUILD)
unique(catch_dat$GUILD)
catch_dat <- catch_dat %>% filter(COMMON_NAME != "Capelin")
catch_dat <- catch_dat %>% filter(COMMON_NAME != "Northern prawn")
catch_dat <- catch_dat %>% filter(COMMON_NAME != "Blue whiting")



plot_catch_trends(catch_dat, type = "COMMON_NAME", line_count = 6, plot_type = "line")
ggplot2::ggsave(file_name(cap_year,ecoreg_code,"Catches_species", ext = "png"), path = "report/", width = 200, height = 130.5, units = "mm", dpi = 300)

#data
dat <- plot_catch_trends(catch_dat, type = "COMMON_NAME", line_count = 9, plot_type = "line", return_data = TRUE)
write.taf(dat, file_name(cap_year,ecoreg_code,"Catches_species", ext = "csv"), dir = "report")


#~~~~~~~~~~~~~~~#
# By country
#~~~~~~~~~~~~~~~#
catch_dat$COUNTRY[which(catch_dat$COUNTRY == "Russian Federation")] <- "Russia"
#Plot
plot_catch_trends(catch_dat, type = "COUNTRY", line_count = 6, plot_type = "area")
ggplot2::ggsave(file_name(cap_year,ecoreg_code,"Catches_country", ext = "png"), path = "report/", width = 200, height = 130.5, units = "mm", dpi = 300)

#data
dat <- plot_catch_trends(catch_dat, type = "COUNTRY", line_count = 10, plot_type = "area", return_data = TRUE)
write.taf(dat, file= file_name(cap_year,ecoreg_code,"Catches_country", ext = "csv"), dir = "report")

#~~~~~~~~~~~~~~~#
# By guild
#~~~~~~~~~~~~~~~#

#Plot
plot_catch_trends(catch_dat, type = "GUILD", line_count = 3, plot_type = "line")
# Undefined is too big, will try to assign guild to the biggest ones

check <- catch_dat %>% filter (GUILD == "undefined")
unique(check$COMMON_NAME)
#need to work a bit on this


ggplot2::ggsave(file_name(cap_year,ecoreg_code,"Catches_guild", ext = "png"), path = "report/", width = 200, height = 130.5, units = "mm", dpi = 300)

#data
dat <- plot_catch_trends(catch_dat, type = "GUILD", line_count = 5, plot_type = "line", return_data = TRUE)
write.taf(dat, file= file_name(cap_year,ecoreg_code,"Catches_guild", ext = "csv"), dir = "report")
