
library(icesTAF)
library(icesFO)

sid <- load_sid(2022)

write.taf(sid, quote = TRUE)
