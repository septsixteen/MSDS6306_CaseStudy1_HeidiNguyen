# Country GDP and Income Level Analysis
Heidi Nguyen  
March 23, 2017  




##Introduction

The following documents describes the analysis performed on the 2012 global GPD and the global education data set.  

  * The Gross Domestic Product data for the 190 ranked countries was downloaded at:

    https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv

  * The educational data was downloaded at:

    https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv

The data files were stored in the following factor –

  * File Name – data files were saved as .csv files. Image files were saved as .png

  * No headers in the original downloaded GDP file. The headers were defined in the code after reading the files into the environment

  * Latin1 encoding was being used in the data

  * Required data for analysis –
      1. Country shortcode – 3-char code (abbreviated form of the country name) 
      2. GDP rank - integer
      3. GDP value - integer 
      4. Income Group - factor

  * Problems with the data –
      1. There were NAs and NULLS rows or columns at the beginning, in between, and at the end of the data set
      2. The type of the variables were not correct. We needed to reassign to achieve the above required data for analysis 
      3. There were commas separator in the values that needed to remove before reassigning the correct type
      4. There were some statistics summaries of the data that were not needed for the analysis. These needed to remove. 
      
The two datasets were first cleaned, then merged. An analysis of the merged data was completed using GDP, and Income Group. The analysis answered the following questions:
  
  1. Merge the data based on the country shortcode and identify how many of the IDs matched.
  
  2. Sort the data frame in ascending order by GDP and identify the 13th country in the resulting data frame.
  
  3. Show the average GDP rankings for the "High income: OECD" and "High income: nonOECD" groups.
    
  4. Show the distribution of GDP value for all the countries and color plots by income group using ggplot2.
    
  5. Summary statistics of GDP by income groups.
    
  6. Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income Group and find out how many countries are Lower middle income but among the 38 nations with highest GDP. 

### File structure 

- Analysis

    1. boxplot.png    
    2. casestudy1_analyze_data.R 
    3. log10boxplot.png
    4. mergedata.csv  
    
- Data

    1. casestudy1_clean_data.R   
    2. casestudy1_download_data.R
    3. educlean.csv              
    4. eduraw.csv              
    5. GDPclean.csv            
    6. GDPraw.csv 
    
- Paper

    1. CaseStudy1_GDPstudy_HeidiNguyen.html 
    2. CaseStudy1_GDPstudy_HeidiNguyen.md
    3. CaseStudy1_GDPstudy_HeidiNguyen.Rmd
    4. CaseStudy1_GDPstudy_HeidiNguyen_files
        + figure-html
            + unnamed-chunk-12-1.png
            + unnamed-chunk-13-1.png
            
- README.md

### Required Packages

This RMD requires the following R packages:

* downloader
* ggplot2
* scales
* plyr
* magrittr
* imager


```r
#If you do not currently have  any of these packages, you can install them using the below install.packages lines before knitting this file.
#install.packages("downloader")
#install.packages("ggplot2")
#install.packages("scales")
#install.packages("plyr")
#install.packages("magrittr") 
#install.packages("imager")

library(downloader)
library(ggplot2)
library(scales)
library(plyr)
library(magrittr)
library(imager)
```

### Download Data
Download the two datasets from The World Bank website and place each dataset in a .csv file.  The .csv files are then read into R as dataframes.


```r
setwd("/Volumes/NO NAME/Data Science/2016-0831 MSDS 6306 Doing Data Science/Unit 8/CaseStudy1/MSDS6306_CaseStudy1_HeidiNguyen/Data")
#casestudy1_download_data.R downloads the data sets: 
source ("casestudy1_download_data.R", print.eval=TRUE, echo=FALSE)
```

```
## [1] "casestudy1_clean_data.R"    "casestudy1_download_data.R"
## [3] "educlean.csv"               "eduraw.csv"                
## [5] "GDPclean.csv"               "GDPraw.csv"
```

### Clean Data
Data cleanup is imperative to any data analysis. The following section will walk through cleaning the data to prep for analysis.


```r
setwd("/Volumes/NO NAME/Data Science/2016-0831 MSDS 6306 Doing Data Science/Unit 8/CaseStudy1/MSDS6306_CaseStudy1_HeidiNguyen/Data")
source ("casestudy1_clean_data.R", print.eval=FALSE, echo=FALSE)
```

Exam the cleaned GDP data. There are 190 observations. 
GDP ranking and value are classified as integer and numeric.

```r
setwd("/Volumes/NO NAME/Data Science/2016-0831 MSDS 6306 Doing Data Science/Unit 8/CaseStudy1/MSDS6306_CaseStudy1_HeidiNguyen/Data")
print(head(GDP,10))
```

```
##    CountryCode rank        CountryName GDP2012millionsUSD groupnote
## 6          USA    1      United States           16244600          
## 7          CHN    2              China            8227103          
## 8          JPN    3              Japan            5959718          
## 9          DEU    4            Germany            3428131          
## 10         FRA    5             France            2612878          
## 11         GBR    6     United Kingdom            2471784          
## 12         BRA    7             Brazil            2252664          
## 13         RUS    8 Russian Federation            2014775          
## 14         ITA    9              Italy            2014670          
## 15         IND   10              India            1841710
```

```r
print(str(GDP))
```

```
## 'data.frame':	190 obs. of  5 variables:
##  $ CountryCode       : chr  "USA" "CHN" "JPN" "DEU" ...
##  $ rank              : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ CountryName       : chr  "United States" "China" "Japan" "Germany" ...
##  $ GDP2012millionsUSD: num  16244600 8227103 5959718 3428131 2612878 ...
##  $ groupnote         : chr  "" "" "" "" ...
## NULL
```

```r
print(dim(GDP))
```

```
## [1] 190   5
```

Exam the cleaned Education data. There are 210 observations.
Income group is classified as factor. 

```r
print(head(educlean,10))
```

```
##    CountryCode          IncomeGroup
## 1          ABW High income: nonOECD
## 2          ADO High income: nonOECD
## 3          AFG           Low income
## 4          AGO  Lower middle income
## 5          ALB  Upper middle income
## 6          ARE High income: nonOECD
## 7          ARG  Upper middle income
## 8          ARM  Lower middle income
## 9          ASM  Upper middle income
## 10         ATG  Upper middle income
```

```r
print(str(educlean))
```

```
## 'data.frame':	210 obs. of  2 variables:
##  $ CountryCode: chr  "ABW" "ADO" "AFG" "AGO" ...
##  $ IncomeGroup: Factor w/ 6 levels "","High income: nonOECD",..: 2 2 4 5 6 2 6 5 6 6 ...
## NULL
```

### Analyze Data
The casestudy1_analyze_data.R file merges and analyzes the data to answer the study questions. 


```r
setwd("/Volumes/NO NAME/Data Science/2016-0831 MSDS 6306 Doing Data Science/Unit 8/CaseStudy1/MSDS6306_CaseStudy1_HeidiNguyen/Analysis")
source ("casestudy1_analyze_data.R", print.eval=FALSE, echo=FALSE)
```

Merge the cleaned GDP data and the cleaned Education data by short country name. The resulting data looks like the following: 

```r
print(head(clean,10))
```

```
##    CountryCode rank          CountryName GDP2012millionsUSD
## 1          ABW  161                Aruba               2584
## 2          ADO   NA                 <NA>                 NA
## 3          AFG  105          Afghanistan              20497
## 4          AGO   60               Angola             114147
## 5          ALB  125              Albania              12648
## 6          ARE   32 United Arab Emirates             348595
## 7          ARG   26            Argentina             475502
## 8          ARM  133              Armenia               9951
## 9          ASM   NA                 <NA>                 NA
## 10         ATG  172  Antigua and Barbuda               1134
##             IncomeGroup
## 1  High income: nonOECD
## 2  High income: nonOECD
## 3            Low income
## 4   Lower middle income
## 5   Upper middle income
## 6  High income: nonOECD
## 7   Upper middle income
## 8   Lower middle income
## 9   Upper middle income
## 10  Upper middle income
```

```r
print(str(clean))
```

```
## 'data.frame':	211 obs. of  5 variables:
##  $ CountryCode       : chr  "ABW" "ADO" "AFG" "AGO" ...
##  $ rank              : int  161 NA 105 60 125 32 26 133 NA 172 ...
##  $ CountryName       : chr  "Aruba" NA "Afghanistan" "Angola" ...
##  $ GDP2012millionsUSD: int  2584 NA 20497 114147 12648 348595 475502 9951 NA 1134 ...
##  $ IncomeGroup       : Factor w/ 5 levels "High income: nonOECD",..: 1 1 3 4 5 1 5 4 5 5 ...
## NULL
```

#### Question 1: Finding matching IDs 

There are 189 matching IDs

```r
print(dim(matchID))
```

```
## [1] 189   4
```

There are 22 unmatching IDs

```r
print(dim(nonmatchID))
```

```
## [1] 22  4
```

##### Question 2: Sort the matching 189 data and find the 13th country from the sorted data.
Here is the sorted data by ascending rank. Tuvula has the lowest GDP and highest rank (first in the ascending sorted list); the US has the highest GDP value and rank of 1 (last in the ascending sorted list).


```r
print(head(matchIDsorted)) 
```

```
##     CountryCode rank GDP2012millionsUSD         IncomeGroup quantile
## 193         TUV  190                 40 Lower middle income       Q5
## 101         KIR  189                175 Lower middle income       Q5
## 124         MHL  188                182 Lower middle income       Q5
## 151         PLW  187                228 Upper middle income       Q5
## 174         STP  186                263 Lower middle income       Q5
## 65          FSM  185                326 Lower middle income       Q5
```

```r
print(tail(matchIDsorted))
```

```
##     CountryCode rank GDP2012millionsUSD         IncomeGroup quantile
## 67          GBR    6            2471784   High income: OECD       Q1
## 63          FRA    5            2612878   High income: OECD       Q1
## 49          DEU    4            3428131   High income: OECD       Q1
## 96          JPN    3            5959718   High income: OECD       Q1
## 37          CHN    2            8227103 Lower middle income       Q1
## 198         USA    1           16244600   High income: OECD       Q1
```

The 13th country from the sorted data is St. Kitts and Nevis. 

```r
print(matchIDsorted[13,])
```

```
##     CountryCode rank GDP2012millionsUSD         IncomeGroup quantile
## 102         KNA  178                767 Upper middle income       Q5
```

#### Question 3: The average GDP ranking for the "High income: OECD" group is 32.97 and for the "High income: nonOECD" group is 91.91.

```r
#using mean to find the average GDP rankings 
print(mean(matchIDsorted[matchIDsorted$IncomeGroup == "High income: OECD","rank"])) 
```

```
## [1] 32.96667
```

```r
print(mean(matchIDsorted[matchIDsorted$IncomeGroup == "High income: nonOECD","rank"]))
```

```
## [1] 91.91304
```

#### Question 4: Box Plot the GDP for all of the 189 matching countries by Income Group. 

##### Box Plot before log transform

```r
plot(boxplot)
```

![](CaseStudy1_GDPstudy_HeidiNguyen_files/figure-html/unnamed-chunk-12-1.png)<!-- -->

This plot indicates the GDP distributions for each Income Group are very skewed. A log 10 transformation is in order.

##### Box Plot in log 10 scale 

```r
plot(boxplotlog)
```

![](CaseStudy1_GDPstudy_HeidiNguyen_files/figure-html/unnamed-chunk-13-1.png)<!-- -->

The log transformed GDP Density Distibutions by Income Group plot shows that the distributions are relatively normal under a log 10 transformation with different variabilities between the groups.

The lower middle and upper middle income groups have the largest spread. The medians of the High income: nonOECD and the Lower middle income groups are very similar. The high income: OCED has the highest median while the low income has the lowest median with the lowest variability.  In addition, the low income and the high income groups have the most normal distributions.

#### Question 5: Summary statistics of GDP by income groups.

```r
print(GPDstats)
```

```
## $`High income: nonOECD`
##        Min.     1st Qu.      Median        Mean     3rd Qu.        Max. 
## "2.584e+03" "1.284e+04" "2.837e+04" "1.043e+05" "1.312e+05" "7.110e+05" 
## 
## $`High income: OECD`
##        Min.     1st Qu.      Median        Mean     3rd Qu.        Max. 
## "1.358e+04" "2.111e+05" "4.865e+05" "1.484e+06" "1.480e+06" "1.624e+07" 
## 
## $`Low income`
##        Min.     1st Qu.      Median        Mean     3rd Qu.        Max. 
## "5.960e+02" "3.814e+03" "7.843e+03" "1.441e+04" "1.720e+04" "1.164e+05" 
## 
## $`Lower middle income`
##        Min.     1st Qu.      Median        Mean     3rd Qu.        Max. 
## "4.000e+01" "2.549e+03" "2.427e+04" "2.567e+05" "8.145e+04" "8.227e+06" 
## 
## $`Upper middle income`
##        Min.     1st Qu.      Median        Mean     3rd Qu.        Max. 
## "2.280e+02" "9.613e+03" "4.294e+04" "2.318e+05" "2.058e+05" "2.253e+06"
```

#### Question 6a: Table of quantile versus income group

```r
print(tablequantileincomegroup)
```

```
##     
##      High income: nonOECD High income: OECD Low income Lower middle income
##   Q1                    4                18          0                   5
##   Q2                    5                10          1                  13
##   Q3                    8                 1          9                  11
##   Q4                    4                 1         16                   9
##   Q5                    2                 0         11                  16
##     
##      Upper middle income
##   Q1                  11
##   Q2                   9
##   Q3                   8
##   Q4                   8
##   Q5                   9
```

#### Question 6b: There are 5 countries which are classified as Lower middle income but among the 38 nations with the highest GDP (the top 20% GDP ranking) 

```r
#table of countries that are Lower middle income but among the 38 nations with highest GDP.
tablehighGDPlowmiddleincome
```

```
##     
##      High income: nonOECD High income: OECD Low income Lower middle income
##   Q1                    0                 0          0                   5
##   Q2                    0                 0          0                   0
##   Q3                    0                 0          0                   0
##   Q4                    0                 0          0                   0
##   Q5                    0                 0          0                   0
##     
##      Upper middle income
##   Q1                   0
##   Q2                   0
##   Q3                   0
##   Q4                   0
##   Q5                   0
```

```r
#number of countries that are classified as Lower middle income but among the 38 nations with the highest GDP
print(tablehighGDPlowmiddleincome[tablehighGDPlowmiddleincome>0]) 
```

```
## [1] 5
```

### Conclusion

In order to analyze the GDP and Education data, we had to go through several steps of cleaning and tidying the data. Data cleaning were performed to remove NAs and Blanks, to replace or to remove unwanted miscellaneous text with appropriate text (e.g: remove commas "," in the GDP value), to reassign our variable types the correct class of integer (rank and GDP) and factor (income groups), and to remove any miscellaneous data (the world statistics summary). 
This tidying data process was very important to providing accuracy in our analysis.  

There were 190 countries in the cleaned GDP data set and 211 countries in the cleaned education data set, but there were only 189 matching countries between the two data sets. There were 22 unmatched coutries.  As  result, the analysis were based on 189 countries of the matched data set.Of those 189 countries, St. Kitts and Nevis (KNA) was identified as the 13th lowest ranked by USD, while Tuvula had the lowest GDP value (first in the ascending sorted list) and the US had the highest GDP value (last in the ascending sorted list)
 
The average GDP ranking for the "High income: nonOECD" group was 91.9, which was 2.8 times higher than that of the "High income: OECD"(32.97). This meant the gap income between these 3 groups are quite large. The box plot further confirmed this. 

Due to the skewness of the data and the nature of the magnitude of the data, it was more appropriate to transform the data to log 10 scale. Box plot of the transformed data was deployed to show the distribution of GDP (in million of dollars) of the 189 countries by Income Groups. The log scale plot suggested normal GDP distributions for all income groups. The medians of the High income: nonOECD and the Lower middle income groups are very similar. The high income: OCED has the highest median while the low income has the lowest median with the lowest variability.

The spread of each group was quite different, however there was overlapping of distribution of all the income groups. We identified 5 countries which were both classified as Lower middle income but ranked as the top 20% GDP ranking. This was not being explained just by examining the data. More economical and/or finance knowledge might be needed to explainn this further. This was the reason data scientist needed not only be competent in programming, data visualization, maths, or statistics, but also needed to be knowlegable in his/her field of work.

