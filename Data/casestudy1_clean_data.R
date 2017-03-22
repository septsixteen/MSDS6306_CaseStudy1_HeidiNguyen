################################
#MSDS6306_CaseStudy1_HeidiNguyen
#Date: 3/23/2017 
#PART 2: Tidying Data                                                 
################################

#set the directory
setwd("/Volumes/NO NAME/Data Science/2016-0831 MSDS 6306 Doing Data Science/Unit 8/CaseStudy1/MSDS6306_CaseStudy1_HeidiNguyen/Data")

#2A. CLEANING GDP DATA 
#load in the GDP data into R using read.csv() with the option to replace "NA" and NULLs by NA values
GDPraw <- read.csv("GDPraw.csv", na.strings=c("NA", "NULL"))
#read in the GDP data again with latin1 encoding to ensure all the latin words are read correctly
#note that the data set does not have a header. 
GDPraw <- read.csv("GDPraw.csv", encoding="latin1", stringsAsFactors=FALSE, header=FALSE, na.strings=c("NA", "NULL"))

#delete the first 5 lines of GDPraw
#delete the empty columns 3,7-10
#create GDP data that starts from line 6:331 and columns 1,2,4,5, and 6  
GDP <- GDPraw[6:331,c(1:2,4:6)]
#give names to all the variables
names(GDP) <- c("CountryCode", "rank", "CountryName", "GDP2012millionsUSD", "groupnote")

#change rank and GDPvalue to be integer and numeric, not character 
#before making this change, to avoid NAs to be introduced by coercion, I remove all the commas separator by making a substitute of "" for ","
GDP$rank <- gsub(",", "", GDP$rank)
GDP$GDP2012millionsUSD <- gsub(",", "", GDP$GDP2012millionsUSD)
GDP$rank <- as.integer(GDP$rank)
GDP$GDP2012millionsUSD <- as.numeric(GDP$GDP2012millionsUSD)

#remove all rows that are either empty or with all NAs.
#since I made all empty (NULLs) to be NAs above, it’s safe to remove just rows with all NAs 
GDP <- GDP[!apply(is.na(GDP) | GDP == "", 1, all),]
#now GDP should have less observations [228 obs. of  5 variables]

#remove those last rows of world statistics 
worldstat <- which(is.na(GDP$rank)==TRUE & is.na(GDP$GDP2012millionsUSD)==FALSE)
#number of world statistical values that are removed
length(worldstat)
# GDP data set without world statistics 
GDP <- GDP[-1*worldstat,]

#Since there are countries without ranks, I will remove those countries without GDP confirmed (without ranking (no GDP estimate).
fslines <- which(is.na(GDP$rank)==TRUE)
#remove those lines of fslines
GDP <- GDP[-1*fslines,]

# write the clean GDP data set and save in the same /Data folder
write.csv(GDP,"GDPclean.csv")

#2B. CLEANING EDUCATION DATA 
#load in the eduraw data into R using read.csv() with the option to replace "NA" and NULLs by NA values
eduraw <- read.csv("eduraw.csv", na.strings=c("NA", "NULL"))
#read in the education data again with latin1 encoding to ensure all the latin words are read correctly
#note that the data set has headers, so we want the option header = TRUE 
eduraw <- read.csv("eduraw.csv", encoding="latin1", stringsAsFactors=FALSE, header=TRUE, na.strings=c("NA", "NULL"))

#There are space in the variable names that I want to remove,so that variable names in this edu data set is aligned with the way I named the variables in the GDP data
edudata <- eduraw 
names(edudata) <- gsub(x = names(edudata),pattern = "\\.", replacement = "")
#change income group to be factor instead of char
edudata$IncomeGroup <- as.factor(edudata$IncomeGroup )
#remove empty rows or rows with all NA if any
edudata <- edudata[!apply(is.na(edudata) | edudata == "", 1, all),]
#remove world statistics that don’t have note on IncomeGroup columns
eduworldstat <- which(edudata$IncomeGroup=="")
#number of world statistical values that are removed from education data set
length(eduworldstat)
# edudata set without world statistics 
edudata <- edudata[-1*eduworldstat,]

#I only need CountryName (column1) and IncomeGroup (column3) to merge and to analyze the data.
#remove all the other columns and only keep CountryName (column1) and IncomeGroup (column3).
educlean <-  edudata[,c(1,3)] #all rows and columns 1 and 3

# write the clean education data set and save in the same /Data folder
write.csv(educlean,"educlean.csv")
