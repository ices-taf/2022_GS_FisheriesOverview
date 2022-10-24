library(icesFO)


out <- load_sag(2022, "Greenland Sea")

sag_complete <- out

status <- load_sag_status(2022)
write.taf(status, file = "SAG_status.csv", quote = TRUE)
