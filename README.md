# MSDS6306_CaseStudy1_HeidiNguyen:

I. Introduction: 

This repository is a reproducible project using R, Rmarkdown, GitHub, and Git for MSDS 6306 Case Study I.  
This project explores and analyzes the 2012 global GPD rank, GDP value, and income group. 
Two datasets, the 2012 Gross Domestic Product for the 190 ranked countries and the global education data set that
contained income levels by country, were downloaded from The Data World Bank website.
The two datasets were then cleaned and merged based on the short country codes. 
An analysis of the merged data was completed using GDP, and Income Group. The analysis answered the following
questions: 

    1. Merge the data based on the country shortcode and identify how many of the IDs matched. 
    2. Sort the data frame in ascending order by GDP and identify the 13th country in the resulting data frame.
    3. Show the average GDP rankings for the "High income: OECD" and "High income: nonOECD" groups.
    4. Show the distribution of GDP value for all the countries and color plots by income group using ggplot2.
    5. Summary statistics of GDP by income groups.
    6. Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income Group and find out how many countries are Lower middle income but among the 38 nations with highest GDP. 

II. File structure 

--  Analysis
    --  boxplot.png             
    --  casestudy1_analyze_data.R
    --  log10boxplot.png
    --  mergedata.csv 
--  Data
    --  casestudy1_clean_data.R    
    --  casestudy1_download_data.R
    --  educlean.csv              
    --  eduraw.csv               
    --  GDPclean.csv            
    --  GDPraw.csv  
--  Paper
    --  CaseStudy1_GDPstudy_HeidiNguyen.html
    --  CaseStudy1_GDPstudy_HeidiNguyen.md
    --  CaseStudy1_GDPstudy_HeidiNguyen.Rmd
    --  CaseStudy1_GDPstudy_HeidiNguyen_files
        -- figure-html
            -- unnamed-chunk-12-1.png
            -- unnamed-chunk-13-1.png
--  README.md 





