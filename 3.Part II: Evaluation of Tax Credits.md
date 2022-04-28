---
layout: page
title: Evaluation of Tax Credit Programs
---

## Data File

**Data Manipulation Information**

The data used in the test was derived from the LTDB-2000, LTDB-2010, and
LTDB-META-DATA datasets that can be found at
<https://github.com/R-Class/cpp-528-fall-2021-group-05/tree/main/data/rodeo>.
Code for the data manipulation steps can be found at
<https://github.com/R-Class/cpp-528-fall-2021-group-05/blob/main/labs/wk05/lab_05_source.R>

-   Step 1: The data was wrangled from the three separate data sources
    and was merged into a singular data frame to allow for easy data
    manipulation and visualization. The data frame was filtered to keep
    the urban tracts only.

-   Step 2: To add the NMTC and LIHTC data to the data frame a few
    prerequisite steps had be completed. The first step was to create a
    unique id to ensure one id was allocated per tract; the unique ids
    were created as a numerical value.

-   Step 3: The value variable in the data set needed to be converted to
    a numeric variable, therefore the dollar sign and comma were
    removed, and the variable was converted to a numeric value.

-   Step 4: The NMTC and LIHTC cleaned data needed to be merged into the
    main data frame. The variables select from the NMTC and LIHTC to me
    merged into the main data frame were the value, unique id, and tract
    id variables. With the NMTC and LIHTC data merged into the main data
    frame, the null or NA values needed to be converted to a 0 (zero)
    numerical value.

-   Step 5: The median home values in 2000 were adjusted to 2010
    inflated values by using the inflation rate constant of 1.28855. The
    new adjusted rates were added to the variable mhv.00 and the 2010
    values were added to the variable mhv.10.

-   Step 6: A new variable mhv.change was created by finding the
    difference between the 2010 home values (mhv.10) and the inflation
    adjusted 2000 home values (mhv.00).

-   Step 7: To add precision to the analysis and avoid unrealistic
    growth rates the inflation adjusted to remove outliers; 2000 home
    values below $10,000 were removed. A new variable mhv.growth was
    created to show the home value change as a percentage. All the new
    variables were added to the main dataframe.

-   Step 8: To reduce the size of the main dataframe, only variables
    that were of interest to the analysis were selected and ones that
    were not of interest were dropped from the main dataframe.

-   Step 9: The selected variables from the previous step were then
    converted into percentages and stored into new variables for further
    analysis.

## Variables effect on Neighborhood Improvement

Below is a log-linear diff-in-diff model which compares MHV with the
NMTC, and LIHTC programs. The treatment of the model includes
application of either the NMTC or LIHTC programs with the census
variables of change in vacancy rates, change in unemployment rates, and
change in household income. The additional variables have all been
logged to align with a growth measurement over time related to a growth
measurement of Median Home Value over time.

``` r
d$p.vacant.change <- d$p.vacant.10 - d$p.vacant.00
d$vacant.change <- d$p.vacant.change
d$vacant.change[d$vacant.change >80 | d$vacant.change < -1] <- NA

d$p.unemp.change <- (d$unemp12-d$unemp00)/d$unemp00
d$unemp.change <- d$p.unemp.change
d$unemp.change[d$unemp.change >80 | d$unemp.change < -1] <- NA


d$p.income.change <- (d$hinc12-d$hinc00)/d$hinc00
d$income.change <- d$p.income.change
d$income.change[d$income.change >80 | d$income.change < -1] <- NA




y1 <- log( d$mhv.00 + 10)
y2 <- log( d$mhv.10 + 10)


vacant <- log(d$vacant.change + 10)
unemp <- log(d$unemp.change + 10)
income <- log(d$income.change + 10)

# create a variable that identifies if a tract received NMTC funding
treat <- as.numeric( d$num.nmtc > 0 )

#vacant <- log(d$p.vacant)
#unemp <- log(d$p.unemp)

#change variable name so we don't copy
treat.lihtc <- as.numeric(d$num.lihtc >0)

# store the year 2000 data
d1 <- data.frame( y=y1, treat=treat, post=0, vacant, unemp, income )
# store the year 2010 data
d2 <- data.frame( y=y2, treat=treat, post=1, vacant, unemp, income) 

# stack the two time periods together
d3 <- rbind( d1, d2)
d3<- na.omit(d3)

# store the year 2000 data
e1 <- data.frame( y=y1, treat=treat.lihtc, post=0, vacant, unemp, income) 
# store the year 2010 data
e2 <- data.frame( y=y2, treat=treat.lihtc, post=1, vacant, unemp, income) 

# stack the two time periods together
e3 <- rbind( e1, e2)
e3<- na.omit(e3)
```

**Summary statistics of percent of vacant change**

``` r
summary(d$vacant.change)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  -1.000   1.478   3.828   5.146   7.211  71.553   10384

**Summary statistics of percent of unemployment change**

``` r
summary(d$unemp.change)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ## -1.0000  0.2911  1.0045  1.7512  2.1111 78.7828     411

**Summary statistics of percent of household income change**

``` r
summary(d$income.change)
```

    ##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
    ## -0.96352 -0.15868 -0.04698 -0.02648  0.07343 30.32680

**Difference in Difference Model**

``` r
# create the difference in difference model
# note: treat = B1, post = B2, treat*post = B3
nmtc <- lm( y ~ treat + post + treat*post + income + vacant + unemp, data=d3 )

lihtc <- lm( y ~ treat + post + treat*post + income + vacant + unemp, data=e3 )

# display model results
stargazer::stargazer(nmtc, lihtc,
                     type = "text",
                     digits = 2, column.labels = c("NMTC", "LIHTC"), covariate.lables = c("intercept (b0)", "treat(b1)", "post(b2)", "Income", "Vacancy", "Unemployment", "treat x post (b3)"), intercept.bottom = FALSE)
```

    ## 
    ## =============================================================
    ##                                      Dependent variable:     
    ##                                  ----------------------------
    ##                                               y              
    ##                                       NMTC          LIHTC    
    ##                                       (1)            (2)     
    ## -------------------------------------------------------------
    ## Constant                            -3.10***      -2.66***   
    ##                                      (0.22)        (0.22)    
    ##                                                              
    ## treat                               -0.21***      -0.17***   
    ##                                      (0.02)        (0.01)    
    ##                                                              
    ## post                                0.23***        0.23***   
    ##                                     (0.004)        (0.004)   
    ##                                                              
    ## income                              6.71***        6.53***   
    ##                                      (0.09)        (0.09)    
    ##                                                              
    ## vacant                              -0.45***      -0.45***   
    ##                                      (0.01)        (0.01)    
    ##                                                              
    ## unemp                               0.34***        0.34***   
    ##                                      (0.01)        (0.01)    
    ##                                                              
    ## treat:post                          0.09***         0.004    
    ##                                      (0.02)        (0.01)    
    ##                                                              
    ## -------------------------------------------------------------
    ## Observations                         96,784        96,784    
    ## R2                                    0.14          0.15     
    ## Adjusted R2                           0.14          0.15     
    ## Residual Std. Error (df = 96777)      0.60          0.60     
    ## F Statistic (df = 6; 96777)       2,651.75***    2,780.71*** 
    ## =============================================================
    ## Note:                             *p<0.1; **p<0.05; ***p<0.01
    ## 
    ## ===============================================================================
    ## intercept (b0) treat(b1) post(b2) Income Vacancy Unemployment treat x post (b3)
    ## -------------------------------------------------------------------------------

**Interpretation of Results**

**Are the programs effective at catalizing neighborhood improvement?**

The treatment x post variable (b3) indicates that the NMTC program is
effective at impacting Median Home Value Growth. When control
for the variables of Vacancy Rate, Unemployment Rate, and Household
Income, we can see that appling the NMTC (treatment) represents 9%
significant growth in Median Home Value compared to the 1% decrease
after application of the LIHTC program.

**How can we test the parallel lines assumption in this model?**

Using the fixed model effect the coefficients across both models it looks like on vacancy and
unemployment they stay the same which would not violate the parallel
lines assumption (Harrell, 2015). 

Reference Harrell, F. E. (2015). Regression modeling strategies: With
applications to linear models, logistic and ordinal regression, and
survival analysis. Springer.
