library(icesTAF)
taf.library(icesFO)

areas <- load_areas("Greenland Sea")

sf::st_write(areas, "areas.csv", layer_options = "GEOMETRY=AS_WKT")
