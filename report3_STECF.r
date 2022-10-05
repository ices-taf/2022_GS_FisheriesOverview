
library(icesTAF)
taf.library(icesFO)
library(sf)
library(ggplot2)
library(dplyr)

## Run utilies
source("bootstrap/utilities.r")

# set values for automatic naming of files:
cap_year <- 2021
cap_month <- "October"
ecoreg_code <- "GS"

##########
#Load data
##########
# effort_dat <- read.taf("bootstrap/initial/data/vms_effort_data.csv")
# landings_dat <- read.taf("bootstrap/initial/data/vms_landings_data.csv")

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

