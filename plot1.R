##Downloading the zipped file in temporary file:
tf<- tempfile()
fileUrl="http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
## But since it's compressed, it's a binary file, hence the "wb". Without the "wb"
## part, one can't open the zip at all
download.file(fileUrl,destfile=tf,mode="wb")
tf
#[1] "C:\\Users\\PK\\AppData\\Local\\Temp\\RtmpyYpP8X\\file138822de12eb"

## after knowing the file name manually after downloading in window:
## zip file contains the following file:

[1] "household_power_consumption.txt"

con<- unzip(tf,"household_power_consumption.txt")## file has been downloaded and stored in the working directory  

unlink(tf)

## file has been downloaded and stored in the working directory with 
#name"household_power_consumption.txt" where the data is having missing value as "?":
# by putting argument na.string="?",a treatment to read as 'NA' for missing value as '?':

hhpcon<- read.table("household_power_consumption.txt",sep=";",header=TRUE,stringsAsFactor=FALSE,na.string="?")

dim(hhpcon)

## Rearanging the given dates for which the main data is to be subsetted:

dt<- c("1/2/2007","2/2/2007")
dt<- strsplit(gsub("/"," ",dt)," ")
# converting the resulted list into dataframe:

library(plyr)
datf<- ldply(dt,function(m)m)
datf
## rearranging year-month-day in the data frame by suffling the columns & converting in single col dataframe:
 
DatF<- data.frame(year=datf[,3],month=datf[,2],day=datf[,1])

class(DatF$year)
date<- as.Date(paste(DatF$year,DatF$month,DatF$day,sep="-"))
date
class(date)
##  similarly rearranging the dates of hhpcon dataframe:
x<- hhpcon$Date
x<- strsplit(gsub("/"," ",x)," ")
df<- ldply(x,function(m)m)
## rearranging year-month-day in the data frame:

DF<- data.frame(year=df[,3],month=df[,2],day=df[,1])
hhpcon$Date<-  as.Date(paste(DF$year,DF$month,DF$day,sep="-"))
head(hhpcon$Date)
class(hhpcon$Date)
## subsetting the hhpcon dataframe by row of dates:
hhpcon.date<-hhpcon[hhpcon$Date  %in% date,]

dim(hhpcon.date)

##Preparation for the histogram:

sum(is.na(hhpcon.date$Global_active_power))

h<-hhpcon.date$Global_active_power
 
hist(h,xlim=range(h),ylim=c(0,1200),
xlab="Global Active Power(kilowatts)",
main="Global Active Power",cex.main=1.5,col="red")

## copying the histogram with 480X480 pixcel in png file type:
dev.copy(png,file="plot1.png",width=480,height=480)
dev.off()


