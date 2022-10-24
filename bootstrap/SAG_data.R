library(icesFO)


out <- load_sag(2022, "Greenland Sea")

sag_complete <- out
<<<<<<< HEAD

status <- load_sag_status(2022)
write.taf(status, file = "SAG_status.csv", quote = TRUE)
=======
write.taf(out, file = "SAG_complete_GS.csv", quote = TRUE)


status <- load_sag_status(2022)

write.taf(status, file = "SAG_status_GS.csv", quote = TRUE)
>>>>>>> 1c736f48dc41dd1df1ffcfce226e54e733c8c157
