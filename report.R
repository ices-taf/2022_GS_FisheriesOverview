# All plots and data outputs are produced here 

library(icesTAF)
taf.library(icesFO)
library(sf)
library(ggplot2)
library(tidyr)


## Run utilies
source("bootstrap/utilities.r")

# set values for automatic naming of files:
cap_year <- 2021
cap_month <- "October"
ecoreg_code <- "GS"

mkdir("report")

##########
#Load data
##########
catch_dat <- read.taf("data/catch_dat.csv")

trends <- read.taf("model/trends.csv")
catch_current <- read.taf("model/catch_current.csv")
catch_trends <- read.taf("model/catch_trends.csv")

#error with number of columns, to check
clean_status <- read.taf("data/clean_status.csv")

effort_dat <- read.taf("bootstrap/initial/data/vms_effort_data.csv")
landings_dat <- read.taf("bootstrap/initial/data/vms_landings_data.csv")


ices_areas <- 
  sf::st_read("areas.csv", 
              options = "GEOM_POSSIBLE_NAMES=WKT", crs = 4326)
ices_areas <- dplyr::select(ices_areas, -WKT)

ecoregion <- 
  sf::st_read("ecoregion.csv", 
              options = "GEOM_POSSIBLE_NAMES=WKT", crs = 4326)
ecoregion <- dplyr::select(ecoregion, -WKT)

# read vms fishing effort
effort <-
  sf::st_read("bootstrap/data/ICES_vms_effort_map/vms_effort.csv",
               options = "GEOM_POSSIBLE_NAMES=wkt", crs = 4326)
effort <- dplyr::select(effort, -WKT)

# read vms swept area ratio
sar <-
  sf::st_read("bootstrap/data/ICES_vms_sar_map/vms_sar.csv",
               options = "GEOM_POSSIBLE_NAMES=wkt", crs = 4326)
sar <- dplyr::select(sar, -WKT)

###############
##Ecoregion map
###############

plot_ecoregion_map(ecoregion, ices_areas)
ggplot2::ggsave(file_name(cap_year,ecoreg_code,"Figure1", ext = "png"), path = "report", width = 170, height = 200, units = "mm", dpi = 300)

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


plot_catch_trends(catch_dat, type = "COMMON_NAME", line_count = 7, plot_type = "line")
ggplot2::ggsave(file_name(cap_year,ecoreg_code,"Catches_species", ext = "png"), path = "report/", width = 200, height = 130.5, units = "mm", dpi = 300)

#data
dat <- plot_catch_trends(catch_dat, type = "COMMON_NAME", line_count = 7, plot_type = "line", return_data = TRUE)
write.taf(dat, file_name(cap_year,ecoreg_code,"Catches_species", ext = "csv"), dir = "report")


#~~~~~~~~~~~~~~~#
# By country
#~~~~~~~~~~~~~~~#
#Plot
plot_catch_trends(catch_dat, type = "COUNTRY", line_count = 7, plot_type = "area")
ggplot2::ggsave(file_name(cap_year,ecoreg_code,"Catches_country", ext = "png"), path = "report/", width = 200, height = 130.5, units = "mm", dpi = 300)

#data
dat <- plot_catch_trends(catch_dat, type = "COUNTRY", line_count = 7, plot_type = "area", return_data = TRUE)
write.taf(dat, file= file_name(cap_year,ecoreg_code,"Catches_country", ext = "csv"), dir = "report")

#~~~~~~~~~~~~~~~#
# By guild
#~~~~~~~~~~~~~~~#

#Plot
plot_catch_trends(catch_dat, type = "GUILD", line_count = 6, plot_type = "line")
# Undefined is too big, will try to assign guild to the biggest ones

check <- catch_dat %>% filter (GUILD == "undefined")
unique(check$COMMON_NAME)
#need to work a bit on this


ggplot2::ggsave(file_name(cap_year,ecoreg_code,"Catches_guild", ext = "png"), path = "report/", width = 200, height = 130.5, units = "mm", dpi = 300)

#data
dat <- plot_catch_trends(catch_dat, type = "GUILD", line_count = 5, plot_type = "line", return_data = TRUE)
write.taf(dat, file= file_name(cap_year,ecoreg_code,"Catches_guild", ext = "csv"), dir = "report")

################################
## 2: STECF effort and landings#
################################

#~~~~~~~~~~~~~~~#
# Effort by country
#~~~~~~~~~~~~~~~#
#Plot
plot_stecf(frmt_effort,type = "effort", variable= "COUNTRY", "2019","September", 6, "15-23", return_data = FALSE)
ggplot2::ggsave("2019_BI_FO_Figure3.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

#data
dat <- plot_stecf(frmt_effort,type = "effort", variable= "COUNTRY", "2019","September", 9, "15-23", return_data = TRUE)
write.taf(dat, file= "2019_BI_FO_Figure3.csv", dir = "report")


#~~~~~~~~~~~~~~~#
#Effort by gear
#~~~~~~~~~~~~~~~#
#Plot
plot_stecf(frmt_effort,type = "effort", variable= "GEAR", "2019","September", 9, "15-23")
ggplot2::ggsave("2019_BI_FO_Figure8.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

#data
dat<-plot_stecf(frmt_effort,type = "effort", variable= "GEAR", "2019","September", 9, "15-23", return_data = TRUE)
write.taf(dat, file= "B2019_BI_FO_Figure8.csv", dir = "report")

#~~~~~~~~~~~~~~~#
#Landings by country
#~~~~~~~~~~~~~~~#
#Plot
plot_stecf(frmt_landings,type = "landings", variable= "GEAR", "2019","September", 9, "15-23")
ggplot2::ggsave("2019_BI_FO_Figure6.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)
#dat
dat <- plot_stecf(frmt_landings, type = "landings", variable="landings", "2019","September", 9, "15-23", return_data = TRUE)
write.taf(dat, file= "2019_BI_FO_Figure6.csv", dir = "report")



###########
## 3: SAG #
###########

#~~~~~~~~~~~~~~~#
# A. Trends by guild
#~~~~~~~~~~~~~~~#

unique(trends$FisheriesGuild)

# 1. Demersal
#~~~~~~~~~~~
plot_stock_trends(trends, guild="demersal", cap_year , cap_month , return_data = FALSE)
ggplot2::ggsave(file_name(cap_year,ecoreg_code,"SAG_Trends_demersal", ext = "png"), path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

dat <- plot_stock_trends(trends, guild="demersal", cap_year , cap_month , return_data = TRUE)
write.taf(dat, file =file_name(cap_year,ecoreg_code,"SAG_Trends_demersal", ext = "csv"), dir = "report")

# 2. Pelagic
#~~~~~~~~~~~
plot_stock_trends(trends, guild="pelagic", cap_year, cap_month , return_data = FALSE)
ggplot2::ggsave(file_name(cap_year,ecoreg_code,"SAG_Trends_pelagic", ext = "png"), path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

dat <- plot_stock_trends(trends, guild="pelagic", cap_year, cap_month , return_data = TRUE)
write.taf(dat,file =file_name(cap_year,ecoreg_code,"SAG_Trends_pelagic", ext = "csv"), dir = "report")

unique(trends$FisheriesGuild)

# 3. Crustacean
#~~~~~~~~~~~
plot_stock_trends(trends, guild="crustacean", cap_year , cap_month ,return_data = FALSE )
ggplot2::ggsave(file_name(cap_year,ecoreg_code,"SAG_Trends_crustacean", ext = "png"), path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

dat <- plot_stock_trends(trends, guild="crustacean", cap_year , cap_month , return_data = TRUE)
write.taf(dat, file =file_name(cap_year,ecoreg_code,"SAG_Trends_crustacean", ext = "csv"), dir = "report" )


#~~~~~~~~~~~~~~~~~~~~~~~~~#
# Ecosystem Overviews plot
#~~~~~~~~~~~~~~~~~~~~~~~~~#
guild <- read.taf("model/guild.csv")

# For this EO, they need separate plots with all info

guild2 <- guild %>% filter(Metric == "F_FMSY")
plot_guild_trends(guild, cap_year , cap_month ,return_data = FALSE )
ggplot2::ggsave(file_name(cap_year,ecoreg_code,"EO_GuildTrends", ext = "png"), path = "report/", width = 178, height = 130, units = "mm", dpi = 300)
guild2 <- guild2 %>%filter(Year > 1978)
plot_guild_trends(guild2, cap_year , cap_month ,return_data = FALSE )
ggplot2::ggsave(file_name(cap_year,ecoreg_code,"EO_GuildTrends_short", ext = "png"), path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

guild3 <- guild2 %>% filter(FisheriesGuild != "MEAN")
plot_guild_trends(guild3, cap_year, cap_month ,return_data = FALSE )
ggplot2::ggsave(file_name(cap_year,ecoreg_code,"EO_GuildTrends_noMEAN", ext = "png"), path = "report/", width = 178, height = 130, units = "mm", dpi = 300)
guild4 <- guild3 %>%filter(Year > 1978)
plot_guild_trends(guild4, cap_year , cap_month ,return_data = FALSE )
ggplot2::ggsave(file_name(cap_year,ecoreg_code,"EO_GuildTrends_short_noMEAN_F", ext = "png"), path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

guild2 <- guild %>% filter(Metric == "SSB_MSYBtrigger")
guild3 <- guild2 %>% dplyr::filter(FisheriesGuild != "MEAN")
guild4 <- guild3 %>% dplyr::filter(Year > 1978)

plot_guild_trends(guild2, cap_year , cap_month ,return_data = FALSE )
ggplot2::ggsave("2019_BI_EO_GuildTrends_short_noMEAN_SSB.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

plot_guild_trends(guild4, cap_year , cap_month ,return_data = FALSE )
ggplot2::ggsave(file_name(cap_year,ecoreg_code,"EO_GuildTrends_short_noMEAN_SSB", ext = "png"), path = "report/", width = 178, height = 130, units = "mm", dpi = 300)


dat <- plot_guild_trends(guild, cap_year, cap_month ,return_data = TRUE)
write.taf(dat, file =file_name(cap_year,ecoreg_code,"EO_GuildTrends", ext = "csv"), dir = "report" )

dat <- trends[,1:2]
dat <- unique(dat)
dat <- dat %>% filter(StockKeyLabel != "MEAN")
dat2 <- sid %>% select(c(StockKeyLabel, StockKeyDescription))
dat <- left_join(dat,dat2)
write.taf(dat, file =file_name(cap_year,ecoreg_code,"EO_SpeciesGuild_list", ext = "csv"), dir = "report", quote=TRUE )

#~~~~~~~~~~~~~~~#
# B.Current catches
#~~~~~~~~~~~~~~~#
## Bar plots are not in order, check!!


# 1. Demersal
#~~~~~~~~~~~
bar <- plot_CLD_bar(catch_current, guild = "demersal", caption = T, cap_year , cap_month , return_data = FALSE)

# bar <- plot_CLD_bar(catch_current, guild = "demersal", caption = T, cap_year = 2019, cap_month = "September", return_data = FALSE)
bar_dat <- plot_CLD_bar(catch_current, guild = "demersal", caption = T, cap_year , cap_month , return_data = TRUE)
write.taf(bar_dat, file =file_name(cap_year,ecoreg_code,"SAG_Current_demersal", ext = "csv"), dir = "report" )

catch_current <- unique(catch_current)
kobe <- plot_kobe(catch_current, guild = "demersal", caption = T, cap_year , cap_month , return_data = FALSE)
#kobe_dat is just like bar_dat with one less variable
#kobe_dat <- plot_kobe(catch_current, guild = "Demersal", caption = T, cap_year = 2019, cap_month = "September", return_data = TRUE)

png(file_name(cap_year,ecoreg_code,"SAG_Current_demersal", ext = "png"),
    width = 131.32,
    height = 88.9,
    units = "mm",
    res = 300)
p1_plot<-gridExtra::grid.arrange(kobe,
                                 bar, ncol = 2,
                                 respect = TRUE, top = "demersal")
dev.off()

# 2. Pelagic
#~~~~~~~~~~~
bar <- plot_CLD_bar(catch_current, guild = "pelagic", caption = T, cap_year, cap_month , return_data = FALSE)

bar_dat <- plot_CLD_bar(catch_current, guild = "pelagic", caption = T, cap_year , cap_month , return_data = TRUE)
write.taf(bar_dat, file =file_name(cap_year,ecoreg_code,"SAG_Current_pelagic", ext = "csv"), dir = "report")

kobe <- plot_kobe(catch_current, guild = "pelagic", caption = T, cap_year , cap_month, return_data = FALSE)
png(file_name(cap_year,ecoreg_code,"SAG_Current_pelagic", ext = "png"),
    width = 131.32,
    height = 88.9,
    units = "mm",
    res = 300)
p1_plot<-gridExtra::grid.arrange(kobe,
                                 bar, ncol = 2,
                                 respect = TRUE, top = "pelagic")
dev.off()

# 2. Crustacean
#~~~~~~~~~~~
bar <- plot_CLD_bar(catch_current, guild = "crustacean", caption = T, cap_year, cap_month , return_data = FALSE)

bar_dat <- plot_CLD_bar(catch_current, guild = "crustacean", caption = T, cap_year , cap_month , return_data = TRUE)
write.taf(bar_dat, file =file_name(cap_year,ecoreg_code,"SAG_Current_crustacean", ext = "csv"), dir = "report")

kobe <- plot_kobe(catch_current, guild = "crustacean", caption = T, cap_year , cap_month , return_data = FALSE)
png(file_name(cap_year,ecoreg_code,"SAG_Current_crustacean", ext = "png"),
    width = 131.32,
    height = 88.9,
    units = "mm",
    res = 300)
p1_plot<-gridExtra::grid.arrange(kobe,
                                 bar, ncol = 2,
                                 respect = TRUE, top = "pelagic")
dev.off()


# 6. All
#~~~~~~~~~~~
bar <- plot_CLD_bar(catch_current, guild = "All", caption = T, cap_year , cap_month , return_data = FALSE)

bar_dat <- plot_CLD_bar(catch_current, guild = "All", caption = T, cap_year , cap_month , return_data = TRUE)
write.taf(bar_dat, file =file_name(cap_year,ecoreg_code,"SAG_Current_all", ext = "csv"), dir = "report" )

# top_10 <- bar_dat %>% top_n(10, total)
# bar <- plot_CLD_bar(top_10, guild = "All", caption = TRUE, cap_year = 2020, cap_month = "September", return_data = FALSE)

# top_10 <- unique(top_10)
kobe <- plot_kobe(catch_current, guild = "All", caption = T, cap_year = 2020, cap_month = "September", return_data = FALSE)
png(file_name(cap_year,ecoreg_code,"SAG_Current_all", ext = "png"),
    width = 137.32,
    height = 88.9,
    units = "mm",
    res = 300)
p1_plot<-gridExtra::grid.arrange(kobe,
                                 bar, ncol = 2,
                                 respect = TRUE, top = "All stocks")
dev.off()


#~~~~~~~~~~~~~~~#
# C. Discards
#~~~~~~~~~~~~~~~#

# No discards at all        
        
                
discardsA <- plot_discard_trends(catch_trends, 2021, cap_year , cap_month )

dat <- plot_discard_trends(catch_trends, 2021, cap_year , cap_month , return_data = TRUE)
write.taf(dat, file =file_name(cap_year,ecoreg_code,"SAG_Discards_trends", ext = "csv"), dir = "report" )

catch_trends2 <- catch_trends %>% filter(discards > 0)
discardsB <- plot_discard_current(catch_trends2, 2021,position_letter = "b)", cap_year , cap_month , caption = FALSE)

discardsC <- plot_discard_current(catch_trends, 2021,position_letter = "c)", cap_year, cap_month )

dat <- plot_discard_current(catch_trends, 2021, cap_year, cap_month , return_data = TRUE)
write.taf(dat, file =file_name(cap_year,ecoreg_code,"SAG_Discards_current", ext = "csv"), dir = "report" )

cowplot::plot_grid(discardsA,discardsB, discardsC, align = "h", nrow = 1, rel_widths = 1, rel_heights = 1)
ggplot2::ggsave(file_name(cap_year,ecoreg_code,"_FO_SAG_Discards", ext = "png"), path = "report/", width = 220.32, height = 88.9, units = "mm", dpi = 300)


# png("report/2019_BI_FO_Figure7.png",
#     width = 137.32,
#     height = 88.9,
#     units = "mm",
#     res = 300)
# p1_plot<-gridExtra::grid.arrange(discardsA,
#                                  discardsB, ncol = 2,
#                                  respect = TRUE)
# dev.off()

#~~~~~~~~~~~~~~~#
#D. ICES pies
#~~~~~~~~~~~~~~~#

plot_status_prop_pies(clean_status, cap_month,cap_year)

# will make qual_green just green
# unique(clean_status$StockSize)
 
# clean_status$StockSize <- gsub("qual_RED", "RED", clean_status$StockSize)

# plot_status_prop_pies(clean_status, "September", "2019")

ggplot2::ggsave(file_name(cap_year,ecoreg_code,"SAG_ICESpies", ext = "png"), path = "report/", width = 178, height = 178, units = "mm", dpi = 300)

dat <- plot_status_prop_pies(clean_status, cap_month,cap_year, return_data = TRUE)
write.taf(dat, file= file_name(cap_year,ecoreg_code,"SAG_ICESpies", ext = "csv"), dir = "report")

#~~~~~~~~~~~~~~~#
#E. GES pies
#~~~~~~~~~~~~~~~#
#Need to change order and fix numbers
plot_GES_pies(clean_status, catch_current,  cap_month,cap_year)
ggplot2::ggsave(file_name(cap_year,ecoreg_code,"SAG_GESpies", ext = "png"), path = "report/", width = 178, height = 178, units = "mm", dpi = 300)

dat <- plot_GES_pies(clean_status, catch_current, cap_month,cap_year, return_data = TRUE)
write.taf(dat, file= file_name(cap_year,ecoreg_code,"SAG_GESpies", ext = "csv"), dir = "report")

#~~~~~~~~~~~~~~~#
#F. ANNEX TABLE 
#~~~~~~~~~~~~~~~#


dat <- format_annex_table(clean_status, 2021)
html_annex_table(dat,ecoreg_code,cap_year)

write.taf(dat, file = file_name(cap_year,ecoreg_code,"annex_table", ext = "csv"), dir = "report", quote=TRUE)

# This annex table has to be edited by hand,
# For SBL and GES only one values is reported, 
# the one in PA for SBL and the one in MSY for GES 


###########
## 3: VMS #
###########

#~~~~~~~~~~~~~~~#
# A. Effort map
#~~~~~~~~~~~~~~~#

gears <- c("Static", "Midwater", "Otter", "Demersal seine", "Dredge", "Beam")

effort <-
    effort %>%
      dplyr::filter(fishing_category_FO %in% gears) %>%
      dplyr::mutate(
        fishing_category_FO = 
          dplyr::recode(fishing_category_FO,
            Static = "Static gears",
            Midwater = "Pelagic trawls and seines",
            Otter = "Bottom otter trawls",
            `Demersal seine` = "Bottom seines",
            Dredge = "Dredges",
            Beam = "Beam trawls")
        )

plot_effort_map(effort, ecoregion) + 
  ggplot2::ggtitle("Average MW Fishing hours 2015-2018")

ggplot2::ggsave("2019_BI_FO_Figure9.png", path = "report", width = 170, height = 200, units = "mm", dpi = 300)

#~~~~~~~~~~~~~~~#
# B. Swept area map
#~~~~~~~~~~~~~~~#

plot_sar_map(sar, ecoregion, what = "surface") + 
  ggtitle("Average surface swept area ratio 2015-2018")

ggplot2::ggsave("2019_BI_FO_Figure17a.png", path = "report", width = 170, height = 200, units = "mm", dpi = 300)

plot_sar_map(sar, ecoregion, what = "subsurface")+ 
  ggtitle("Average subsurface swept area ratio 2015-2018")

ggplot2::ggsave("2019_BI_FO_Figure17b.png", path = "report", width = 170, height = 200, units = "mm", dpi = 300)


#~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# C. Effort and landings plots
#~~~~~~~~~~~~~~~~~~~~~~~~~~~#


## Effort by country
plot_vms(effort_dat, metric = "country", type = "effort", cap_year= 2019, cap_month= "September", line_count= 6)
# effort_dat$kw_fishing_hours <- effort_dat$kw_fishing_hours/1000
effort_dat <- effort_dat %>% dplyr::mutate(country = dplyr::recode(country,
                                                                   FRA = "France",
                                                                   ESP = "Spain",
                                                                   PRT = "Portugal",
                                                                   BEL = "Belgium",
                                                                   IRL = "Ireland",
                                                                   NLD = "Netherlands"))
effort_dat2 <- effort_dat %>% filter(year > 2013)
plot_vms(effort_dat2, metric = "country", type = "effort", cap_year= 2019, cap_month= "September", line_count= 5)
ggplot2::ggsave("2019_BI_FO_Figure3_vms.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

dat <- plot_vms(effort_dat, metric = "country", type = "effort", cap_year= 2019, cap_month= "September", line_count= 5, return_data = TRUE)
write.taf(dat, file= "2019_BI_FO_Figure3_vms.csv", dir = "report")

## Landings by gear
plot_vms(landings_dat, metric = "gear_category", type = "landings", cap_year= 2019, cap_month= "September", line_count= 4)
landings_dat$totweight <- landings_dat$totweight/1000
landings_dat <- landings_dat %>% dplyr::mutate(gear_category = 
                                                       dplyr::recode(gear_category,
                                                                     Static = "Static gears",
                                                                     Midwater = "Pelagic trawls and seines",
                                                                     Otter = "Bottom otter trawls",
                                                                     `Demersal seine` = "Bottom seines",
                                                                     Dredge = "Dredges",
                                                                     Beam = "Beam trawls",
                                                                     'NA' = "Undefined"))


landings_dat2 <- landings_dat %>% filter(year > 2013)
plot_vms(landings_dat2, metric = "gear_category", type = "landings", cap_year= 2019, cap_month= "September", line_count= 3)
ggplot2::ggsave("2019_BI_FO_Figure6_vms.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

dat <- plot_vms(landings_dat, metric = "gear_category", type = "landings", cap_year= 2019, cap_month= "September", line_count= 3, return_data = TRUE)
write.taf(dat, file= "2019_BI_FO_Figure6_vms.csv", dir = "report")

## Effort by gear
plot_vms(effort_dat2, metric = "gear_category", type = "effort", cap_year= 2019, cap_month= "September", line_count= 5)
effort_dat2 <- effort_dat2 %>% dplyr::mutate(gear_category = 
                                                   dplyr::recode(gear_category,
                                                                 Static = "Static gears",
                                                                 Midwater = "Pelagic trawls and seines",
                                                                 Otter = "Bottom otter trawls",
                                                                 `Demersal seine` = "Bottom seines",
                                                                 Dredge = "Dredges",
                                                                 Beam = "Beam trawls",
                                                                 'NA' = "Undefined"))

plot_vms(effort_dat2, metric = "gear_category", type = "effort", cap_year= 2019, cap_month= "September", line_count= 5)
ggplot2::ggsave("2019_BI_FO_Figure8_vms.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

dat <-plot_vms(effort_dat, metric = "gear_category", type = "effort", cap_year= 2019, cap_month= "September", line_count= 6, return_data = TRUE)
write.taf(dat, file= "2019_BI_FO_Figure8_vms.csv", dir = "report")
