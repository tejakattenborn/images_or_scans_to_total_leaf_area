# DIN A4 21.0 cm x 29.7 cm / Scan resolution: 2550 x 3501 pixels (200 dpi)
# total pixels: 7877250 / total cm²: 6237

require(raster)


# SET PATH    path to folder with all single plot folders within
setwd("D:/googledrive/teaching/2021_forschungspraktikum/leaf_area")  # requires an "input" and "output" folder in there


#function
report = function(scan, scan_pixels){

  if(bw==1){    # for black and white image
    lblack = round(length(which(scan == 0))* 623.7/scan_pixels, digits=2)
    lwhite = round(length(which(scan == 1))* 623.7/scan_pixels, digits=2)
  }
  else{         # for grey scale image (threshold set here to 200)
    lblack = round(length(which(scan >= 200))* 623.7/scan_pixels, digits=2) 
    lwhite = round(length(which(scan <= 201))* 623.7/scan_pixels, digits=2)
  }
  area=list(files[i], lblack, lwhite)
  return(area)
}

files = list.files("input/", full.names = T)
report_table = as.data.frame(matrix(NA, nrow=length(files), ncol=3))

for(i in 1:length(files)){
  scan = raster(files[i])
  scan_pixels = nrow(scan) * ncol(scan)
  if(summary(scan)[5]==1){
    bw=1
  }
  else{
    bw=0
  }
  scan_mat = as.data.frame(scan)
  report_result = report(scan_mat, scan_pixels)
  report_table[i,1]=report_result[[1]]
  report_table[i,2]=report_result[[2]]
  report_table[i,3]=report_result[[3]]
}

colnames(report_table) = c("species", "leaf area [cm2]", "non leaf area [cm2]")
report_table
write.table(report_table, "output/leaf_area_total.csv", sep=",", dec=".")


