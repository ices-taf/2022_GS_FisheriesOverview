library(icesTAF)
library(icesFO)
library(sf)
library(ggplot2)
library(dplyr)

## Run utilies
source("bootstrap/utilities.r")

# set values for automatic naming of files:
cap_year <- 2021
cap_month <- "November"
ecoreg_code <- "GS"

##########
#Load data
##########
trends <- read.taf("model/trends.csv")
catch_current <- read.taf("model/catch_current.csv")
catch_trends <- read.taf("model/catch_trends.csv")

#error with number of columns, to check
clean_status <- read.taf("data/clean_status.csv")


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

trends2 <- trends%>% filter (StockKeyLabel %in% c("cod.2127.1f14",
                                                  "ghl.27.561214",
                                                  "mac.27.nea",
                                                  "her.27.1-24a514a",
                                                  "reg.27.561214"))
trends2 <- trends2 [,-1]
colnames(trends2) <- c("FisheriesGuild", "Year", "Metric", "Value")
trends3 <- trends2%>% filter(Metric == "F_FMSY")
# guild2 <- guild %>% filter(Metric == "F_FMSY")
plot_guild_trends(trends3, cap_year, cap_month,return_data = FALSE )
# guild2 <- guild2 %>% filter(FisheriesGuild != "MEAN")
# plot_guild_trends(guild2, cap_year , cap_month,return_data = FALSE )
ggplot2::ggsave(paste0(year_cap, "_", ecoreg_code, "_EO_SAG_GuildTrends_F.png"), path = "report/", width = 178, height = 130, units = "mm", dpi = 300)
# ggplot2::ggsave("2019_BtS_EO_GuildTrends_noMEAN_F.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)


trends3 <- trends2%>% filter(Metric == "SSB_MSYBtrigger")

# guild2 <- guild %>% filter(Metric == "SSB_MSYBtrigger")
# guild3 <- guild2 %>% dplyr::filter(FisheriesGuild != "MEAN")
trends3 <- trends3 %>% filter(Year > 1960)
plot_guild_trends(trends3, cap_year, cap_month,return_data = FALSE )
ggplot2::ggsave(paste0(year_cap, "_", ecoreg_code, "_EO_SAG_GuildTrends_SSB_1960.png"), path = "report/", width = 178, height = 130, units = "mm", dpi = 300)
# ggplot2::ggsave(paste0(year_cap, "_", ecoreg, "_EO_SAG_GuildTrends_SSB_1900.png"), path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

dat <- plot_guild_trends(trends2, cap_year, cap_month ,return_data = TRUE)
write.taf(dat, file =paste0(year_cap, "_", ecoreg_code, "_EO_SAG_GuildTrends.csv"), dir = "report" )

# dat <- trends2[,1:2]
# dat <- unique(dat)
# dat <- dat %>% filter(FisheriesGuild != "MEAN")
# colnames(dat) <- c("StockKeyLabel", "Year")
# dat2 <- sid %>% select(c(StockKeyLabel, StockKeyDescription))
# dat <- left_join(dat,dat2)
# write.taf(dat, file =paste0(year_cap, "_", ecoreg_code, "_EO_SAG_SpeciesGuildList.csv"), dir = "report", quote = TRUE )


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
                                 respect = TRUE, top = "crustacean")
dev.off()


# 6. All
#~~~~~~~~~~~
bar <- plot_CLD_bar(catch_current, guild = "All", caption = T, cap_year , cap_month , return_data = FALSE)

bar_dat <- plot_CLD_bar(catch_current, guild = "All", caption = T, cap_year , cap_month , return_data = TRUE)
write.taf(bar_dat, file =file_name(cap_year,ecoreg_code,"SAG_Current_all", ext = "csv"), dir = "report" )

# top_10 <- bar_dat %>% top_n(10, total)
# bar <- plot_CLD_bar(top_10, guild = "All", caption = TRUE, cap_year = 2020, cap_month = "September", return_data = FALSE)

# top_10 <- unique(top_10)
kobe <- plot_kobe(catch_current, guild = "All", caption = T, cap_year, cap_month , return_data = FALSE)
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

cowplot::plot_grid(discardsA, discardsC, align = "h", nrow = 1, rel_widths = 1, rel_heights = 1)
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
