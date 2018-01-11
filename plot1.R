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

#Grab the global active power as a decimal so we can make a histogram
globalActivePower <- as.numeric(as.character(sampledat$Global_active_power))

#open the png file to write the output
png(file="./plot1.png",width=480,height=480)


#Create the histogram
hist(globalActivePower, 
     main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)",
     ylab = "Freqency",
     col = "red"
     )


dev.off()
