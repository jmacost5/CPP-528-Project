---
layout: page
title: Evaluation of Tax Credit Programs
---
## Data File

**Data Manipulation Information**

The data used in this analysis is from the LTDB-2000, LTDB-2010, and
LTDB-META-DATA datasets that can be found at:
<https://github.com/jmacost5/CPP-528-Project/tree/main/data/rodeo>.
Code for the data manipulation can be found at:
<https://github.com/jmacost5/CPP-528-Project/blob/main/labs/wk05/lab_05_source.R>

-   Step 1: The data was wrangled from the three data sources listed above
    and merged into a singular data frame. The data frame was filtered to
    only urban tracts.
    
-   Step 2: To add the NMTC and LIHTC data to the data frame, a unique
    id  was created to ensure one id existed per tract; unique ids
    were saved as numerical values.

-   Step 3: The value variable in the data was converted to numeric, commas and $ were removed.

-   Step 4: NMTC and LIHTC data were merged by tract id to make one 
    data frame. The year variable was removed.

-   Step 5: Using an inflation rate of 1.28855, the median home values of 
    2000 were adjusted. Adjusted rates were assigned to the variable
    mhv.00 and the 2010 values to the variable mhv.10.

-   Step 6: The variable mhv.change was calculated by subtracting the
    difference between the 2010 home values (mhv.10) and the inflation
    adjusted 2000 home values (mhv.00).

-   Step 7: To remove outliers, year 2000 home values below $10,000 were 
    removed. The variable mhv.growth was calculated by dividing 
    mhv.change by median home value year 2000 variables and multiplying by 100 (to create 
    a percentage). All variables were bound to the main dataframe.

-   Step 8: Variables of interest to gentrification were selected from
    both time periods.

-   Step 9: Variables selected were converted to percentages.


### Introduction: 

### This analysis looks at median home value change and growth under two different programs - both are tax-credit incentive based, and both strive to provide affordable housing. One program is available to non-profit and for profit entities (LIHTC), and one is for private investors (NMTC). They are also allotted slightly different parameters regarding the poverty rate in the tracts they may invest in affordable housing in. Three different variables are also added in to our models to understand how they may be influencing median home value change between 2000 and 2010. The variables are: percent college graduates, percent unemployment, and percent Black population. 

### TLDR: Exploring neighborhood change through the inclusion of federal program data. Using the difference-in-difference framework to estimate the impact of the NMTC and LIHTC federal programs and determine if the programs are effective at catalyzing neighborhood improvement. 



```r
options(warn=-1)
# load necessary packages ----
library( dplyr )
library( here )
library( knitr )
library( pander )
library( stargazer )
library( scales )
library(import)
library(tidyverse)
library(kableExtra)

source(here::here("labs/wk06/lab_06_source.R"))
# note: all of these are R objects that will be used throughout this .rmd file
 # import::here("S_TYPE",
 #             "INFLATION_RATE",
 #             "panel.cor",
 #             "panel.smooth",
 #             "jplot",
 #             "d",
 #             "df",
 #             "d3",
 #             "PLOTS",
 #             "%>%",
 #             # notice the use of here::here() that points to the .R file
 #             # where all these R objects are created
 #            .from = here::here("labs/wk06/lab_06_source.R"),
 #            .character_only = TRUE)

#detach("package:import", unload = TRUE)
```


### Descriptive Statistics

### A section of the dataset we'll be working with

```r 
head(d, n = c(4,10)) %>%
  kbl() %>%
  kable_minimal()
```

![](https://github.com/jmacost5/CPP-528-Project/blob/main/assets/img/2021-03-14-ch01-example_page_files/figure-gfm/DataframeExcept.png?raw=true)<!-- -->


### Home values change and growth - summary statistics


```r
# show summary statistics
stargazer::stargazer( df, 
                      type=S_TYPE,
                      title = "Home values- All data",
                      digits=0, 
                      summary.stat = c("min", "p25","median","mean","p75","max") )
```
![](https://github.com/jmacost5/CPP-528-Project/blob/main/assets/img/2021-03-14-ch01-example_page_files/figure-gfm/homevalues-alldata.png?raw=true)<!-- -->

### Comparing the two different programs - NMTC and LIHTC. 

### First we will look at how the two programs differ in poverty rates of the tracts selected for investment. 

```r
### POVERTY RATES ----
gridExtra::grid.arrange( PLOTS$pov_rate_2000$nmtc, 
                         PLOTS$pov_rate_2000$lihtc, 
                         nrow = 1 )
```

![](https://github.com/jmacost5/CPP-528-Project/blob/main/assets/img/2021-03-14-ch01-example_page_files/figure-gfm/PovRatePlot.png?raw=true)<!-- -->

### Next we will look at median home values.

```r
### HOME VALUES ----
gridExtra::grid.arrange( PLOTS$mhv_2000$nmtc, 
                         PLOTS$mhv_2000$lihtc, 
                         nrow = 1 )
```

![](https://github.com/jmacost5/CPP-528-Project/blob/main/assets/img/2021-03-14-ch01-example_page_files/figure-gfm/mhvPlot.png?raw=true)<!-- -->

### And finally median home value growth.

```r 
### MHV Growth Rates (DV in Model) ----
gridExtra::grid.arrange( PLOTS$mhv_growth$lihtc, 
                         PLOTS$mhv_growth$nmtc, 
                         nrow = 1 )
```

![](https://github.com/jmacost5/CPP-528-Project/blob/main/assets/img/2021-03-14-ch01-example_page_files/figure-gfm/mhvGrowthPlot.png?raw=true)<!-- -->


```r
#Save data to rodeo folder
#saveRDS(d.fed, here("data/rodeo/rodeo-date-mr.rds"))
```

```r
#Load data set
#readRDS(file = here("data/rodeo/rodeo-date-mr.rds"))
```

### **Difference-in-Difference Model**

#### The difference-in-difference estimate seems like the most robust option for our analysis. It allows for pre-treatment differences as long as the parallel lines assumption is met. That is to say, the rates of growth for the treated and untreated tracts were similar in the period 1990 to 2000. Which is another way of saying we believe that C2-C1 is a good approximation of what the home value change would have been without the program. To satisfy the requirements for this model, lets look at how our two programs compare. 

### NMTC Analysis

```r 

# view regression results
pander(summary(pander(summary(lm( y ~ PercentCollegeGrad +PercentUnemployed + PercentBlackPopulation + treat + post + treat*post, data=data_new)))))

a <- lm( y ~ p.col +p.unemp +p.black + treat + post + treat*post, data=data_new)

# display model results
stargazer::stargazer(a,
                     title  = "NMTC Treatment",
                     covariate.labels = c("Percent College Grads", "Percent Unemployed", "Percent Black Population"),
                     dep.var.labels = "Log Median Home Value",
                     type = S_TYPE,
                     digits = 2)
```

![](https://github.com/jmacost5/CPP-528-Project/blob/main/assets/img/2021-03-14-ch01-example_page_files/figure-gfm/NMTCTreatment.png?raw=true)<!-- -->


### LIHTC Analysis

```r 

# view regression results
pander(summary(lm( y ~ PercentCollegeGrad +PercentUnemployed + PercentBlackPopulation + treat + post + treat*post, data=data_new_l)))

b <- lm( y ~ p.col +p.unemp +p.black + treat + post + treat*post, data=data_new_l)

# display model results
stargazer::stargazer(b,
                     title ="LIHTC Treatment",
                     covariate.labels = c("Percent College Grads", "Percent Unemployed", "Percent Black Population"),
                     dep.var.labels = "Log Median Home Value",
                     type = S_TYPE,
                     digits = 2)
```

![](https://github.com/jmacost5/CPP-528-Project/blob/main/assets/img/2021-03-14-ch01-example_page_files/figure-gfm/LIHTCTreatment.png?raw=true)<!-- -->

### **Parallel Lines Test**

#### NMTC Regression Summary 

```r 
# view regression results
c <- lm( y ~ treat + post + treat*post, data=dt6)
c2 <- lm( y ~ treat + post + treat*post, data=dt7)

pander(summary( c ))
```

![](https://github.com/jmacost5/CPP-528-Project/blob/main/assets/img/2021-03-14-ch01-example_page_files/figure-gfm/Regression3.png?raw=true)<!-- -->

#### LIHTC Regression Summary

```r 
pander(summary(c2))
```
![](https://github.com/jmacost5/CPP-528-Project/blob/main/assets/img/2021-03-14-ch01-example_page_files/figure-gfm/regression4.png?raw=true)<!-- -->

```r 
# display model results
stargazer::stargazer(c,c2,
                     title  = "NMTC and LITHC Comparison",
                     dep.var.labels = "Log Median Home Value",
                     column.labels = c("NMTC", "LIHTC"),
                     type = S_TYPE,
                     digits = 2)
```

![](https://github.com/jmacost5/CPP-528-Project/blob/main/assets/img/2021-03-14-ch01-example_page_files/figure-gfm/NMTC%20AND%20LITHC%20COMP.png?raw=true)<!-- -->

### Home value test - illustrating how logged variables may have similarities - and thus can be used for a difference in difference approach.

```r 
home1 <- 200000
home2 <- 100000

rate.of.return <- ( (1.1)^(1:10) )

roi.1 <- home1*rate.of.return
roi.2 <- home2*rate.of.return 

plot( 1:10, roi.1, type="b", pch=19, bty="n",
      xlab="Time", ylab="Home Value", ylim=c(0,520000) )
points( 1:10, roi.2, type="b", pch=19 )

text( 5, roi.1[5]+100, "Home 1", pos=3, cex=1.5 )
text( 5, roi.2[5]+100, "Home 2", pos=3, cex=1.5 )

log.roi.1 <- log( roi.1 )
log.roi.2 <- log( roi.2 )

plot( 1:10, log.roi.1, type="b", pch=19, bty="n",
      xlab="Time", ylab="Home Value", main = "Logged ROI", ylim=c(0,14) )
points( 1:10, log.roi.2, type="b", pch=19 )

text( 5, log.roi.1[5], "Home 1", pos=3, cex=1.5 )
text( 5, log.roi.2[5], "Home 2", pos=3, cex=1.5 )

options(warn=-0)
```

![](https://github.com/jmacost5/CPP-528-Project/blob/main/assets/img/2021-03-14-ch01-example_page_files/figure-gfm/HomeValuesTest.png?raw=true)<!-- -->

### Slopes become parallel with log:

![](https://github.com/jmacost5/CPP-528-Project/blob/main/assets/img/2021-03-14-ch01-example_page_files/figure-gfm/HomeValuesLog.png?raw=true)<!-- -->

### Illustrating how return-on-investment values may be altered with log. 

```r 
data.frame( time=1:10, value=roi.1, log.value=log.roi.1 )  %>%
  kbl() %>%
  kable_minimal()
```
![](https://github.com/jmacost5/CPP-528-Project/blob/main/assets/img/2021-03-14-ch01-example_page_files/figure-gfm/ROIillustration.png?raw=true)<!-- -->

### True Growth Rate

```r 
yt1 <- roi.1[1]
yt2 <- roi.2[2]


( yt2 - yt1 ) / yt1
```

### Growth Rate Approximation

```r 
log.yt1 <- log.roi.1[1]
log.yt2 <- log.roi.2[2]


log.yt2 - log.yt1
```

### The full difference in difference model. 

```r 
e <- lm( y ~ treat + post + treat*post, data=dt7 )

# display model results
stargazer(e,
          title = "NMTC- Diff-In-Diff",
          type = S_TYPE,
          digits = 2)
```


#### Diff-in-diff model - equation

```r 
b0 <- m$coefficients[1] 
b1 <- m$coefficients[2]
b2 <- m$coefficients[3]
b3 <- m$coefficients[4]
```





### C1 = B0 

```r 
C1 <- b0
pander(exp( C1 ))
```

 (Intercept) 
 
  _159937_    


### C2 = B0 + B2 

```r 
C2 <- b0 + b2
pander(exp( C2 ))
```

 (Intercept) 

  _201590_   



### T1 = B0 + B1 

```r 
T1 <- b0 + b1
pander(exp( T1 ))
```

 (Intercept) 

  _129977_    


### T2 = B0 + B1 + B2 + B3 

```r 
T2 <- b0+b1+b2+b3
pander(exp( T2 ))
```

 (Intercept) 

  _164796_   


### Counterfactual: C2-C1

```r 
CF<- 196984 - 156581

pander(CF)
```
_40403_

### Our Treatment Group: T2-T1

```r 
TR <- 166560 - 120265

pander((TR))
```
_46295_

### Treatment difference in difference (T2-T1) - (C2-C1)

```r 
pander(TR-CF)
```

_5892_

### Reflection

#### Looking at our regression models, it is obvious that some demographic variables impact our policy variables. College graduates have a significant positive relationship with growth in median home value, while percent black population has significantly negative relationship with growth in median home value for both programs. As we know from other labs and research, the positive coefficient with percent unemployed is probably due to multicollinearity/interference from instrumental variables or missing variables. This is probably also true for the negative relationship with percent black population and median home value, as we know that black people do not cause home prices to fall. 

#### Because we are depending on a diff-in-diff model, the comparison of C and T values shows that our treatment group had a higher ROI than the control group. We are asserting that the counterfactual is represented by the ROI of our control group, or the growth of 'control' ROI from time 1 to time 2. We do not have a true counterfactual, but we can assert confidence that our counterfactual, by comparison, can isolate secular trends with minimal variance from unknown factors. We are extrapolating our counterfactual is comprised of: the post growth coefficient (secular trend, C2), the intercept of our untreated group group (C1), the intercept of our treated group (T1) and the median home values post treatment within that group (T2)


#### We know that the base rate of increase in MHV was around 23%, and we can say the null hypothesis, that there was no difference in median home growth in MHV from 2000-2010 for our treatment group from the secular trend of 23%, can be rejected with confidence. 


#### Comparing regression coefficients, looking at graphed data, summary statistics and our diff-in-diff model, it is clear that NMTC performs above secular trends and above LIHTC. 


#### We test the parallel lines assumption by looking at the post regression coefficient in our regression table for both programs. We can see that the coefficient for post, meaning how much the median home value increased over the two stacked time periods, 1990-2000, and 2000-2010, are the same for both our treated and untreated (NMTC and LIHTC) groups. Because our y values, or dependent variables, are logged median home values, we can say that this represents median home value growth, and that the rate of growth is the same. We are effectively comparing apples to apples. This is butressed by our home values test, which visually illustrates this concept. After logging data, the two slopes are parallel, with different intercepts. 



#### In conclusion, it can be said that NMTC's model for low-income housing resulted in higher MHV growth than the secular trend, and it may be inferred that this leads to value improvement of neighborhoods, because home prices tend to reflect the quality of life value of the neighborhoods. However, because the NMTC approach tended to have a 'middle of the road' approach to percent poverty tracts chosen, as seen by our data visualizations ("2000 Poverty Rate Comparison of \nRecipient and Non-Recipient Communities"), it is possible that they chose tracts strategically in areas that would have seen growth anyway, and less people in poverty actually benefited from these programs. Testing this hypothesis would require a different framework that was people-based, not place-based. 

### References

### Delmelle, Elizabeth C. *"Differentiating pathways of neighborhood change in 50 US metropolitan areas."* Environment and planning A 49.10 (2017): 2402-2424.

### Way, Heather, Elizabeth Mueller, and Jake Wegmann. *"Uprooted: Residential displacement in Austin???s gentrifying neighborhoods and what can be done about it."* The University of Texas at Austin???Entrepreneurship and Community Development Clinic???School of Law 3 (2018).

### U.S. Census Bureau. (2012). 2009-2011 American Community Survey 3-year Public Use Microdata Samples, *Harmonized Census Data Part 01.* Retrieved from https://watts-college.github.io/cpp-528-spr-2022/labs/lab-02/

### U.S. Census Bureau (2000). *Harmonized Census Data Part 02.* Retrieved from https://watts-college.github.io/cpp-528-spr-2022/labs/lab-02/

### Spatial Structures in the Social Sciences (S4), Brown University. *Codebook: Longitudinal Tract Data Base Census Data for 1970-2010 and ACS 2008-2012* Retrieved from https://watts-college.github.io/cpp-528-spr-2022/labs/lab-02/

### The Department of Housing and Urban Development. *LIHTCPUB* Retrieved from: https://github.com/DS4PS/cpp-528-spr-2020/blob/master/labs/data/raw/LIHTC/LIHTCPUB.csv

### U.S. Department of the Treasury???s Community Development Financial Institutions Fund. *NMTC-Sheet-01* Retreived from: https://github.com/DS4PS/cpp-528-spr-2020/blob/master/labs/data/raw/NMTC/nmtc-sheet-01.csv




