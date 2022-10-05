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

year_range = "2017-2020"
##########
#Load data
##########
ecoregion <-
  st_read("ecoregion.csv",
    options = "GEOM_POSSIBLE_NAMES=WKT", crs = 4326
  )
ecoregion <- dplyr::select(ecoregion, -WKT)

# read vms fishing effort
effort <-
  st_read( "vms_effort.csv",
    options = "GEOM_POSSIBLE_NAMES=wkt", crs = 4326
  )
effort <- dplyr::select(effort, -WKT)

# read vms swept area ratio
sar <-
  st_read( "vms_sar.csv",
    options = "GEOM_POSSIBLE_NAMES=wkt", crs = 4326
  )
sar <- dplyr::select(sar, -WKT)

# ~~~~~~~~~~~~~~~#
# A. Effort map
# ~~~~~~~~~~~~~~~#

gears <- c("Static", "Midwater", "Otter", "Demersal seine")

effort <-
  effort %>%
  dplyr::filter(fishing_category_FO %in% gears) %>%
  dplyr::mutate(
    fishing_category_FO =
      dplyr::recode(fishing_category_FO,
        Static = "Static gears",
        Midwater = "Pelagic trawls and seines",
        Otter = "Bottom otter trawls",
        `Demersal seine` = "Bottom seines"
      ),
    mw_fishinghours = as.numeric(mw_fishinghours)
  ) %>%
  filter(!is.na(mw_fishinghours))

# write layer
write_layer <- function(dat, fname) {
  write_sf(dat, paste0("report/", fname, ".shp"))
  files <- dir("report", pattern = fname, full = TRUE)
  files <- files[tools::file_ext(files) != "png"]
  zip(paste0("report/", fname, ".zip"), files, extras = "-j")
  file.remove(files)
}
write_layer(effort, paste0(year_cap, "_", ecoreg,"_FO_VMS_effort"))

# save plot
plot_effort_map(effort, ecoregion) +
  ggtitle(paste0("Average MW Fishing hours ", year_range))

ggplot2::ggsave(paste0(cap_year, "_", ecoreg_code,"_FO_VMS_effort.png"), path = "report", width = 170, height = 200, units = "mm", dpi = 300)

# ~~~~~~~~~~~~~~~#
# A. Swept area map
# ~~~~~~~~~~~~~~~#

# write layer
write_layer(sar, paste0(year_cap, "_", ecoreg,"_FO_VMS_sar"))

plot_sar_map(sar, ecoregion, what = "surface") +
  ggtitle("Average surface swept area ratio 2018-2021")

# ggsave(file_name("sar_map_surface", "png"), path = "report", width = 170, height = 200, units = "mm", dpi = 300)
ggplot2::ggsave(paste0(cap_year, "_", ecoreg_code,"_FO_sar_map_surface.png"), path = "report", width = 170, height = 200, units = "mm", dpi = 300)


plot_sar_map(sar, ecoregion, what = "subsurface") +
  ggtitle("Average subsurface swept area ratio 2018-2021")

# ggsave(file_name("sar_map_subsurface", "png"), path = "report", width = 170, height = 200, units = "mm", dpi = 300)
ggplot2::ggsave(paste0(cap_year, "_", ecoreg_code,"_FO_sar_map_subsurface.png"), path = "report", width = 170, height = 200, units = "mm", dpi = 300)
