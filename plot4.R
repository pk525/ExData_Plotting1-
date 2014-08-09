## downloading the zip file from web in temporary file:
tf<- tempfile()
fileUrl="http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
## But since it's compressed, it's a binary file, hence the "wb". Without the "wb"
## part,one can't open the zip file at all:

download.file(fileUrl,destfile=tf,mode="wb")
tf
#[1] "C:\\Users\\PK\\AppData\\Local\\Temp\\RtmpyYpP8X\\file138822de12eb"
## after knowing the file name manually after downloading in window:
## zip file contains the following file:

[1] "household_power_consumption.txt"

con<- unzip(tf,"household_power_consumption.txt")#file has been downloaded 
#and stored in the working directory
unlink(tf)

## As the file has been downloaded and stored in the working directory with 
#name"household_power_consumption.txt" where the data is having missing value as "?"
# by putting argument na.string="?" for a treatment to read as NA for missing value as '?':

hhpcon<- read.table("household_power_consumption.txt",sep=";",header=TRUE,stringsAsFactor=FALSE,na.string="?")

dim(hhpcon)

## for subsetting the given data frame for the given dates; rearranging dates:
dt<- c("1/2/2007","2/2/2007")
dt<- strsplit(gsub("/"," ",dt)," ")

# arranging list into a dataframe:
library(plyr)
datf<- ldply(dt,function(m)m)
datf
## rearranging and combinig in 'year-month-day' format in the data frame & converting
##in single column dataframe duly converted to date class:

DatF<- data.frame(year=datf[,3],month=datf[,2],day=datf[,1])
DatF
date<- as.Date(paste(DatF$year,DatF$month,DatF$day,sep="-"))
class(date)

## Now rearranging the dates of hhpcon dataframe and split into a list to dataframe:
x<- hhpcon$Date
x<- strsplit(gsub("/"," ",x)," ")
df<- ldply(x,function(m)m)
## rearranging year-month-day in the data frame:

DF<- data.frame(year=df[,3],month=df[,2],day=df[,1])

# changing the date column of hhpcon data frame in yr-month-day format from DF combining and
#converting into date class:
hhpcon$Date<-  as.Date(paste(DF$year,DF$month,DF$day,sep="-"))
class(hhpcon$Date)

## subsetting the hhpcon dataframe by row of dates wrt the given dates in "date" dataframe:

hhpcon.date<-hhpcon[hhpcon$Date  %in% date,]
dim(hhpcon.date)


## Plotting 4 graphs on the single panel:
str(hhpcon.date)
par(mfrow=c(2,2))

# from hhpcon.date data frame ,combining date and time

hhpcon.date$Date <- paste(hhpcon.date$Date,hhpcon.date$Time)
head(hhpcon.date$Date)
d<- hhpcon.date$Date
class(d)
## coercing character string of d= date/time by as.POSIXct():
D<- as.POSIXct(d)
head(D)
##Graph between GlobalActivePower as y axis & day and time combined x axis :

h<-hhpcon.date$Global_active_power
plot(D,h,xlab="",ylab="Global Active Power",type="l")

## graph between Voltage & datetime:
plot(D,hhpcon.date$Voltage,xlab="datetime",ylab="Voltage",type="l")

## Graph between energy sub metering Vs daytime:
## defining other energy sub metering vector variables on y-axis:

E<- hhpcon.date$Sub_metering_1
F<-hhpcon.date$Sub_metering_2
G<- hhpcon.date$Sub_metering_3

plot(D,E,type="l",col="black",ylim=c(0,40),xlab="",ylab="Energy sub metering")
lines(D,F,col="red")
lines(D,G,col="blue")
legend("topright",legend=c("sub_metering_1","sub_metering_2","sub_metering_3"),
col=c("black","red","blue"),bty="n",lty=1,box.lty=1,cex=0.8)

##Graph between GlobalreactivePower Vs datetime:
plot(D,hhpcon.date$Global_reactive_power,xlab="datetime",
ylab="Global_reactive_power",type="l")

## copying the histogram with 480X480 pixcel in png file type:
dev.copy(png,file="plot4.png",width=480,height=480)
dev.off()

