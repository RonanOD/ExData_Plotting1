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

# Open a png file for writing
png(filename = "plot1.png")
hist(con$Global_active_power, col="red", xlab = "Global Active Power (kilowatts)", main="Global Active Power")
# Close the device
dev.off()