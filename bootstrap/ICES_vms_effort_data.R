

library("icesVMS")

vms_effort_data <- icesVMS::get_fo_effort("Greenland Sea")
write.taf(vms_effort_data, file = "vms_effort_data.csv", quote= TRUE)
