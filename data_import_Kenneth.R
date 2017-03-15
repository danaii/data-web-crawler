# Script for Simulation Experiment Section, Post (2003), JF

library(stringr)
library(ggplot2)
library(scales)
library(ggthemes)
library(PerformanceAnalytics)
library(RColorBrewer)

# The URL for the data
url.name <- "http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/ftp/"
file.name <- "25_Portfolios_5x5_CSV.zip"
full.url <- paste(url.name, file.name, sep="/")

# change the ending date of the analysis by changing these variables. Though, source file could be updated annually


end.year <- 2001
end.month <- 10
window.width <- 38*12     # 38 Years in this case

# Download and Unzip 

temp.file <- tempfile()
download.file(full.url, temp.file)
file.list <- unzip(temp.file, list=TRUE)


# Parse the data
benchmark.data <-read.csv(unzip(temp.file, files=as.character(file.list[1,1])), skip=19, header=TRUE, stringsAsFactors=FALSE)
names(benchmark.data)[[1]] <- "DATE"


# Remove all  data below the end date
ds.year <- as.numeric(substr(benchmark.data$DATE[[1533]],1,4))
ds.month <- as.numeric(substr(benchmark.data$DATE[[1533]],5,6))
# First delete the observations prior to our wanted date of July 1963 e.g. row 1534
benchmark.data <- benchmark.data[-c(1:1533), ]
# Keep the first 460 obs ( from July 1963-October 2001 )
num.rows <- 12*(end.year-ds.year)+(end.month-ds.month)+1
benchmark.data <- head(benchmark.data,num.rows)

########
# Format dataframe

# Form the date vector
date.seq <- as.Date(paste(benchmark.data$DATE,"01",sep=""),"%Y%m%d")
benchmark.data$DATE <- date.seq



# Transform the data so that the return cells are in numeric decimal format
for (i in 2:ncol(benchmark.data)) {
  benchmark.data[,i] <- as.numeric(str_trim(benchmark.data[,i]))
}

# Transform the data as percentage returns
for (i in 2:ncol(benchmark.data)) {
  benchmark.data[,i] <- benchmark.data[,i]/100
}