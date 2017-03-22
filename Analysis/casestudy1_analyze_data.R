##################################
#MSDS6306_CaseStudy1_HeidiNguyen
#Date: 3/23/2017 
#PART 3:Merging and Analyzing data                                                 
##################################

#3A. MERGING THE CLEAN GDP AND EDUCATIONAL DATA BASED ON COUNTRY SHORTCODE
#set the directory
setwd("/Volumes/NO NAME/Data Science/2016-0831 MSDS 6306 Doing Data Science/Unit 8/CaseStudy1/MSDS6306_CaseStudy1_HeidiNguyen/Data")

#read in the clean GDP data. 
GDPclean <- read.csv("GDPclean.csv", encoding="latin1", stringsAsFactors=FALSE, header=TRUE, na.strings=c("NA", "NULL"))
#examine the data 
dim(GDPclean)
names(GDPclean)
str(GDPclean)
head(GDPclean, 20)
tail(GDPclean, 20)
#remove the numbering column 1 and the  groupnote column 6
GDPclean <- GDPclean[,c(2:5)]
str(GDPclean)

#read in the clean Educational data
educlean <- read.csv("educlean.csv", encoding="latin1", stringsAsFactors=FALSE, header=TRUE, na.strings=c("NA", "NULL"))
#examine the data 
dim(educlean)
names(educlean)
str(educlean)
head(educlean, 20)
tail(educlean, 20)
#remove the numbering column 1
educlean <- educlean[,c(2:3)] 
str(educlean)

# Merge the data on "CountryCode" 
clean <- merge(GDPclean, educlean, by="CountryCode", all=TRUE)
#check for duplicates of CountryCode
table(clean$CountryCode)[table(clean$CountryCode) != 1]
#check the merged data 
str(clean)
head(clean)
tail(clean)

# write the clean education data set and save in the same /Analysis folder
setwd("/Volumes/NO NAME/Data Science/2016-0831 MSDS 6306 Doing Data Science/Unit 8/CaseStudy1/MSDS6306_CaseStudy1_HeidiNguyen/Analysis")
write.csv(clean,"mergedata.csv")

#3B. ANALYZING THE MERGED DATA

#Question 1: Find the number of matched ID. 
#Note that GDP data set should all have rank and GDP2012millionsUSD while Education set should all have data in IncomeGroup 
#All matched ID should be complete with CountryCode (column1), rank(column2), GDP2012millionsUSD(column4), and IncomeGroup (column5)
#subset a cleanID that only has CountryCode (column1), rank(column2), GDP2012millionsUSD(column4), and IncomeGroup (column5)
cleanID <- clean[, c(1:2,4:5)]
#Find which cases are complete, which are not complete 
nonmatchID <- cleanID[!(complete.cases(cleanID)),]
nonmatchID 
#The number of unmatched IDs
dim(nonmatchID) #  22  4
matchID <- cleanID[(complete.cases(cleanID)),]
#The number of matched IDs
dim(matchID) # 189   4

#Question 2: Sort the data frame in ascending order by GDP (so United States is last) and find the 13th country in the sorted data frame
#sort cleanID in ascending order by GDP
#attach matchID so that we can use the columns by their names 
attach(matchID)
matchIDsorted <- matchID[order(rank, na.last=TRUE, decreasing=TRUE),] #also - cleanID
#check to make sure United States is last
tail(matchIDsorted)
#The 13th country in the resulting data frame
matchIDsorted[13,] # KNA  178
#detach matchID
detach(matchID)

#Question 3: Find the average GDP rankings for the "High income: OECD" and "High income: nonOECD" groups
#using mean() to find the average GDP rankings for the "High income: OECD"
mean(matchIDsorted[matchIDsorted$IncomeGroup == "High income: OECD","rank"]) #32.96667
#using mean to find the average GDP rankings for the "High income: nonOECD" 
mean(matchIDsorted[matchIDsorted$IncomeGroup == "High income: nonOECD","rank"]) #91.91304

#Question 4: Show the distribution of GDP value for all the countries and color plots by income group using ggplot2.
#Load the ggplot2 package
library(ggplot2)
#use geom_boxplot with option fill=IncomeGroup to show the distribution of GDP value for all the countries and color plots by income group
#add theme_update at the beginning to center the title before any plot is created
#add ggsave to save the plot and adjust the window dpi to show ylabel
#alpha 0.8 for some transparency effect. size = 0.25 to make the outside lines of the boxes thinner
title.boxplot <- ggtitle("GDP by Income Group")
boxplotGPD <- ggplot(data=matchIDsorted, aes(x=IncomeGroup, y=GDP2012millionsUSD,fill=IncomeGroup)) + 
  theme_update(plot.title = element_text(hjust = 0.5)) + 
  geom_boxplot(width=.5, alpha=0.8, size=0.25) + xlab("Income Group") + ylab("GDP in millions USD")
#generate box plot
boxplotGPD + title.boxplot
#save the box plox
saveboxplotGDP <- ggsave(file = "boxplot.png", dpi = 500, width = 12, height = 8, units = "in")

#Due to the skewness of the data and the order of magnitude is of factor of 10, I will transform y to log10(y)
#load library scale to transform and format y-axis scale
library(scales)
transform.y <- scale_y_continuous(trans='log10', name = "GDP in millions USD - log10 scaling")
title.boxplot.log <- ggtitle("GDP by Income Group - log10 scaling")
#boxplot of log10(GDP) vs income group
boxplotGPD + transform.y + title.boxplot.log 
#save the log10 box plot
saveboxplot <- ggsave(file = "log10boxplot.png", dpi = 500, width = 12, height = 8, units = "in")

#Question 5: Summary statistics of GDP by income groups.
#use tapply() to show the summary of GDP (GDP2012millionsUSD) by income groups (IncomeGroup)
tapply(matchIDsorted$GDP2012millionsUSD, matchIDsorted$IncomeGroup, summary)
#to get scientific notation, use a custom function instead of summary such as
tapply(matchIDsorted$GDP2012millionsUSD, matchIDsorted$IncomeGroup, function(x) format(summary(x), scientific = TRUE))

#Question 6: Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. Find the number of countries are Lower middle income but among the 38 nations with highest GDP.
#6a: use cut() and quantile() to separate the rankings into 5 groups
matchIDsorted$quantile  <- with(matchIDsorted, cut(matchIDsorted$rank, 
                                                   breaks=quantile(matchIDsorted$rank, probs=seq(0,1, by=0.20), na.rm=TRUE), labels=c("Q1","Q2","Q3","Q4", "Q5"),include.lowest=TRUE))
#review the data
str(matchIDsorted)
summary(matchIDsorted)
head(matchIDsorted)
tail(matchIDsorted)

#6b: Table of quantile versus income group
tablequantileincomegroup <- with(matchIDsorted, table(matchIDsorted$quantile, matchIDsorted$IncomeGroup))
tablequantileincomegroup

#6c: Find the number of countries that are Lower middle income but among the 38 nations with highest GDP.
tablehighGDPlowmiddleincome <- with(highGDPlowmiddleincome<-matchIDsorted[(matchIDsorted$quantile=="Q1" & matchIDsorted$IncomeGroup=="Lower middle income"),], table(highGDPlowmiddleincome$quantile,highGDPlowmiddleincome$IncomeGroup))
#table of countries that are Lower middle income but among the 38 nations with highest GDP.
tablehighGDPlowmiddleincome
#number of countries: 
tablehighGDPlowmiddleincome[tablehighGDPlowmiddleincome>0]

       