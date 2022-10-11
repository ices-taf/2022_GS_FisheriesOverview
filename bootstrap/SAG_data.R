library(icesFO)


out <- load_sag(2022, "Greenland Sea")

sag_complete <- out
write.taf(out, file = "SAG_complete_GS.csv", quote = TRUE)


status <- load_sag_status(2022)

write.taf(status, file = "SAG_status_GS.csv", quote = TRUE)
