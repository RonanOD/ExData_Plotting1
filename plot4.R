# Load household consumption data for only the dates we are interested in: Feb 1 and 2 of 2007.
# How many rows to skip
dates <- c("2006-12-16 17:24:00", "2007-02-01 00:00:00")
skip_span <- as.POSIXct(dates)
skip_rows <- as.numeric(difftime(skip_span[2], skip_span[1], units = "mins"))
# How many rows to read in
dates2 <- c("2007-02-01 00:00:00", "2007-02-03 00:00:00")
nrows_span <- as.POSIXct(dates2)
nrows_count <- as.numeric(difftime(nrows_span[2], nrows_span[1], units = "mins"))

con <- read.table("household_power_consumption.txt", stringsAsFactors = FALSE, 
                  header = FALSE, skip = skip_rows + 1, nrows = nrows_count, 
                  sep = ";", na.strings="?")
# Retrieve header
header <- read.table('household_power_consumption.txt', nrows = 1, 
                     header = FALSE, sep =';', stringsAsFactors = FALSE)

colnames(con) <- unlist(header)
# Merge the date and time column into a single 
dateTimeStr <- paste(con$Date, con$Time)
dateTimes <- strptime(dateTimeStr, "%d/%m/%Y %H:%M:%S")
con$dateTime <- dateTimes
con <- subset(con, select = -c(Date,Time) )

# Open a png file for writing
png(filename = "plot4.png")

# Make a grid for all charts
par(mfrow=c(2,2))

# Chart 1
plot(con$dateTime, con$Global_active_power, type = "n", xlab = "", ylab = "Global Active Power")
lines(con$dateTime, con$Global_active_power, type = "l")

# Chart 2
plot(con$dateTime, con$Voltage, type = "n", xlab = "datetime", ylab="Voltage")
lines(con$dateTime, con$Voltage, type = "l")

# Chart 3
plot(con$dateTime, con$Sub_metering_1, type = "n", ylab = "Energy sub metering", xlab = "")
lines(con$dateTime, con$Sub_metering_1, type = "l")
lines(con$dateTime, con$Sub_metering_2, type = "l", col="red")
lines(con$dateTime, con$Sub_metering_3, type = "l", col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=c(1,1,1), lwd=c(1,1,1), col=c("black", "red", "blue"), bty = "n")

# Chart 4
plot(con$dateTime, con$Global_reactive_power, type = "n", ylab = "Global_reactive_power", xlab = "datetime")
lines(con$dateTime, con$Global_reactive_power, type = "l")
# Close the device
dev.off()