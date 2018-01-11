library(dplyr)

#Check to see if the zip file has been downloaded to the current directory.
#If it hasn't been downloaded, do so and unzip the file.

remotefile <- c("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip")
localzip <- c("./household_power_consumption.zip")
localfile <- c("./household_power_consumption.txt")

if (!file.exists(localfile)) {
        download.file(remotefile, localzip, method = "auto")
        unzip(localzip)
        unlink(localzip)
}

#Read the semi-colon delimited file, then subset the two days we are trying to 
#analyze
dat <- read.table(localfile, sep = ";", header = TRUE)
sampledat <-  filter(dat, Date == "1/2/2007" | Date == "2/2/2007")

#Add a field using mutate that will incorporate the date and time in a formatted
#field that we can easily graph and manipulate
sampledat <- mutate(sampledat, tstamp = 
                            as.POSIXct(
                                    strptime(paste(sampledat$Date, sampledat$Time), 
                                             "%e/%m/%Y %H:%M:%S")
                            )
)

#Grab the global active power as a decimal
globalActivePower <- as.numeric(as.character(sampledat$Global_active_power))

#open the png file to write the output
png(file="./plot4.png",width=480,height=480)

#set the mfrow global par so that we write 2 rows with 2 cols
par(mfrow=c(2,2))

#First plot
plot(x = sampledat$tstamp, 
     y =  globalActivePower, 
     type = "l", 
     xlab = "",
     ylab = "Global Active Power (kilowatts)"
)



# Second plot
plot(x = sampledat$tstamp, 
     y =  as.numeric(as.character(sampledat$Voltage)), 
     type = "l", 
     xlab = "datetime",
     ylab = "voltage"
)

#3rd plot has several calls to build up the multiple sub metering lines
plot(x = sampledat$tstamp, 
     y = as.numeric(as.character(sampledat$Sub_metering_1)),
     type = "l",
     xlab = "",
     ylab = "Energy sub metering"
)

lines(x = sampledat$tstamp, 
      y = as.numeric(as.character(sampledat$Sub_metering_2)),
      col = "red"
)

lines(x = sampledat$tstamp, 
      y =  as.numeric(as.character(sampledat$Sub_metering_3)),
      col = "blue"
)

#Add the legend
legend("topright", 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"),
       cex = 0.5,
       pt.lwd = 3,
       lty = 1
)


#4th plot
plot(x = sampledat$tstamp, 
     y =  as.numeric(as.character(sampledat$Global_reactive_power)), 
     type = "l", 
     xlab = "datetime",
     ylab = "Global_reactive_power"
)

#Close the file

dev.off()



