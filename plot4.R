setwd("~/R/Explore_DA/Project1/ExData_Plotting1")
library(data.table)

fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipname <- "./data/household_power_consumption.zip"
filename <- ("./data/household_power_consumption.txt")

#Get data
if (!file.exists("data")) {
        dir.create("data")
}
if (!file.exists(zipname)){
        download.file(fileurl, destfile=zipname, mode="wb")
        unzip(zipname, exdir="./data")
        dateDownloaded <- date()
        write(dateDownloaded, file = paste("./data/datedownloaded.txt"))
}


#Load Data
findRows<-fread(filename , header = TRUE, select = 1) # reads date column into vector findRows
all<-(which(findRows$Date %in% c("1/2/2007", "2/2/2007")) ) # vector all contains row numbers with Date equal to "1/2/2007", "2/2/2007" 
## This selective loading of rows is only working if dates are ordered sequentially
skipLines<- min(all)-1 #numbers of rows to skip
keepRows<- length(all) #numbers of rows to load
data<- fread(filename, skip = (skipLines) , nrows = keepRows, header = TRUE)# unfortunately na.strings= "?" does not work and everything is converted to characters
rm(findRows)
# need to give column the original names
febNames<- names(fread(filename, nrow = 1))
setnames(data, febNames)
# create new column with POSIXct time of character value Date and Time
# strptime or date was not as usefull as I thought
data[,datetime:= as.POSIXct(paste (Date,Time), format="%d/%m/%Y %H:%M:%S")]

#plot 4

png (filename="plot4.png", width=480, height=480)
par(mfrow=c(2,2))
# Subplot 1 of 4
with (data, {plot (datetime,Global_active_power, type = "n", ylab="Global Active Power", xlab="")
             lines (datetime,Global_active_power)
})
# Subplot 2 of 4
with (data, {plot (datetime,Voltage, type = "n")
             lines (datetime,Voltage)
})
# Subplot 3 of 4
with (data, {plot (datetime,Sub_metering_1, type = "n", ylab="Energy sub metering", xlab="")
             lines (datetime,Sub_metering_1, col="black")
             lines (datetime,Sub_metering_2, col="red")
             lines (datetime,Sub_metering_3, col="blue")
             legend("topright",names(data)[7:9],bty="n",cex=0.9, lty="solid", col=c("black", "red", "blue"))
})
# Subplot 4 of 4
with (data, {plot (datetime,Global_reactive_power, type = "n")
             lines(datetime,Global_reactive_power)
})
dev.off()
