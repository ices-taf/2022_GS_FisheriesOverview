library(icesTAF)
library(icesFO)

ecoregion <- icesFO::load_ecoregion("Greenland Sea")

sf::st_write(ecoregion, "ecoregion.csv", layer_options = "GEOMETRY=AS_WKT")
