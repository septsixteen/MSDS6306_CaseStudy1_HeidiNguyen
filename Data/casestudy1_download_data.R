################################
#MSDS6306_CaseStudy1_HeidiNguyen
#Date: 3/23/2017 
#PART 1: Download Data
################################

#set the directory
setwd("/Volumes/NO NAME/Data Science/2016-0831 MSDS 6306 Doing Data Science/Unit 8/CaseStudy1/MSDS6306_CaseStudy1_HeidiNguyen/Data")

#Install Packages and download library
#install.packages("downloader")
#load library 
library(downloader)

#1. download the GDP data
#Load the Gross Domestic Product data for the 190 ranked countries in this data set:
site1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
#download Gross Domestic Product data and named file as "GDPraw.csv"
download.file(site1, destfile="./GDPraw.csv")

#2. download on the educational data
#Load the educational data from this data set
site2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
#download educational data and named file as "eduraw.csv"
download.file(site2, destfile="./eduraw.csv")

#list all the files in the set directory for make sure the file was downloaded
list.files()

