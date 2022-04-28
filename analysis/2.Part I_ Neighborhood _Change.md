---
title: Neighborhood Characteristics
subtitle: "Predicting Median Home Value Change" 
---

``` r
#Load the necessary packages ----
library(dplyr)
library(here)
library(knitr)
library(pander)
library(stargazer)
library(scales)
library(rmarkdown)
library(namespace)
```

Today’s date is “November 29, 2021”

## Data Information

## Census Variables

### The following factors were chosen to identify gentrification:

-   Household Income: An increase in household income may indicate
    gentrification
-   Percentage unemployed: a decrease in unemployment rate may indicate
    gentrification
-   Vacancy Rate: A decrease in vacancy rate may indicate gentrification

``` r
#Household Income
hinc.00 <- d$hinc00 * 1.28855
hinc.10 <- d$hinc12
hinc.change <- hinc.10 - hinc.00
p.hinc.change <- hinc.change/hinc.00
p.hinc.growth <- log10(p.hinc.change +1)
d$hinc.change <- p.hinc.change
d$hinc.growth <- p.hinc.growth
```

``` r
#% Unemployed 
#d$p.unemp[ d$p.unemp > 80 & d$p.unemp <= 1 ] <- NA
#d$p.unemp10[ d$p.unemp10 > 80 & d$unemp.00 <= 1 ] <- NA
unemp.00 <- d$p.unemp.00
unemp.10 <- d$p.unemp.10
unemp.change <- unemp.10 - unemp.00
p.unemp.change <- unemp.change/unemp.00
p.unemp.growth <- log10(p.unemp.change +1)
d$unemp.change <- p.unemp.change
d$unemp.change[d$unemp.change > 80 | d$unemp.change < 1] <- NA
d$unemp.growth  <- p.unemp.growth
d$unemp.growth[d$unemp.growth > 80 | d$unemp.growth < 1] <- NA
```

``` r
#Vacancy Rate 
vacant.00 <- d$p.vacant.00
vacant.10 <- d$p.vacant.10
vacant.change <- vacant.10 - vacant.00
p.vacant.change <- vacant.change/vacant.00
p.vacant.growth <- log10(p.vacant.change + 1)
d$vacant.change <- p.vacant.change
d$vacant.change[d$vacant.change > 80 | d$vacant.change < 1] <- NA
d$vacant.growth <- p.vacant.growth
d$vacant.growth[d$vacant.growth > 80 | d$vacant.growth < 1] <- NA
```

# create mini data frame

``` r
df <- data.frame( MedianHomeValue2000 = d$mhv.00, 
                  MedianHomeValue2010 = d$mhv.10, 
                  MHV.Change.00.to.10 = d$mhv.change,
                  MHV.Growth.00.to.12= d$mhv.growth,
                  Vacant2000 = vacant.00,
                  Vacant2010 = vacant.10,
                  Vacant.change = p.vacant.change,
                  Vacant.growth = p.vacant.growth,
                  Unemp2000 = unemp.00,
                  Unemp2010 = unemp.10,
                  Unemp.change = p.unemp.change,
                  Unemp.growth = p.unemp.growth,
                  Income2000 = hinc.00,
                  Income2010 = hinc.10,
                  Income.change = p.hinc.change,
                  Income.growth = p.hinc.growth)
df$Vacant.growth[df$Vacant.growth > 80 | df$Vacant.growth < 1] <- NA
df$Vacant.change[df$Vacant.change > 80 | df$Vacant.change < 1] <- NA
df$Unemp.change[df$Unemp.change > 80 | df$Unemp.change < 1] <- NA
df$Unemp.growth[df$Unemp.growth > 80 | df$Unemp.growth < 1] <- NA
```

## Measurement Variables

``` r
#Correlation check
measurement.1 <- select(df, Vacant2000, Income2000, Unemp2000, MedianHomeValue2000) %>% na.omit ()
```

``` r
set.seed(1234)

pairs(measurement.1, lower.panel = panel.smooth, upper.panel = panel.cor)
```
![](https://r-class.github.io/cpp-528-fall-2021-group-05/assets/img/2021-11-07-CH03-mhv_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

``` r
measurement.2 <- select(df, Vacant.change, Income.change, Unemp.change, MHV.Change.00.to.10) %>% na.omit ()
```

``` r
set.seed(1234)

pairs(measurement.2, lower.panel = panel.smooth, upper.panel = panel.cor)
```

![](https://r-class.github.io/cpp-528-fall-2021-group-05/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-10-1.png)

## Median Home Value

``` r
hist( df$MedianHomeValue2000, breaks=200, xlim=c(0,500000), 
      col="gray20", border="white",
      axes=F, 
      xlab="MHV (median = $138k)",
      ylab="",
      main="Median Home Value in 2000 (2010 US dollars)" )
axis( side=1, at=seq(0,500000,100000), 
      labels=c("$0","$100k","$200k","$300k","$400k","$500k") )
abline( v=median( df$MedianHomeValue2000, na.rm=T ), col="orange", lwd=3 )
```

![](https://r-class.github.io/cpp-528-fall-2021-group-05/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-11-1.png)

### Descriptives

``` r
stargazer( df, 
           type="text", #S_TYPE, 
           digits=0, 
           summary.stat = c("min", "p25","median","mean","p75","max") )
```

    ## 
    ## ===========================================================================
    ## Statistic              Min     Pctl(25)  Median   Mean   Pctl(75)    Max   
    ## ---------------------------------------------------------------------------
    ## MedianHomeValue2000   11,167   105,624  154,690  187,207 224,594  1,288,551
    ## MedianHomeValue2010   9,999    122,600  191,200  246,632 313,900  1,000,001
    ## MHV.Change.00.to.10 -1,228,651  7,051    35,680  59,425   93,913   983,765 
    ## MHV.Growth.00.to.12    -97        6        25      33       49      6,059  
    ## Vacant2000              0         3        5        7       9        94    
    ## Vacant2010              0         5        8       11       14      9,467  
    ## Vacant.change           1         1        2        2       3        60    
    ## Vacant.growth           1         1        1        1       1         3    
    ## Unemp2000               0         3        5        6       8        97    
    ## Unemp2010               0         6        9       10       13       79    
    ## Unemp.change            1         1        2        2       3        78    
    ## Unemp.growth            1         1        1        1       1         6    
    ## Income2000            4,149     54,855   72,731  79,260   96,565   332,074 
    ## Income2010            2,499    39,179.8 54,017.5 59,671   73,921   250,001 
    ## Income.change           -1        -0       -0      -0       -0       23    
    ## Income.growth           -2        -0       -0      -0       -0        1    
    ## ---------------------------------------------------------------------------

### Change in MHV 2000 - 2010

``` r
hist( df$MHV.Change.00.to.10/1000, breaks=500, 
      xlim=c(-100,500), yaxt="n", xaxt="n",
      xlab="Thousand of US Dollars (adjusted to 2010)", cex.lab=1.5,
      ylab="", main="Change in Median Home Value 2000 to 2010",
      col="gray20", border="white" )
axis( side=1, at=seq( from=-100, to=500, by=100 ), 
      labels=paste0( "$", seq( from=-100, to=500, by=100 ), "k" ) )
        
mean.x <- mean( df$MHV.Change.00.to.10/1000, na.rm=T )
abline( v=mean.x, col="darkorange", lwd=2, lty=2 )
text( x=200, y=1500, 
      labels=paste0( "Mean = ", dollar( round(1000*mean.x,0)) ), 
      col="darkorange", cex=1.8, pos=3 )
median.x <- median( df$MHV.Change.00.to.10/1000, na.rm=T )
abline( v=median.x, col="dodgerblue", lwd=2, lty=2 )
text( x=200, y=2000, 
      labels=paste0( "Median = ", dollar( round(1000*median.x,0)) ), 
      col="dodgerblue", cex=1.8, pos=3 )
```

![](https://r-class.github.io/cpp-528-fall-2021-group-05/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-13-1.png)

### Percent Change in Median Home Value 2000 to 2010

``` r
hg <-
hist( df$MHV.Growth.00.to.12, breaks=5000, 
      xlim=c(-100,200), yaxt="n", xaxt="n",
      xlab="", cex.main=1.5,
      ylab="", main="Growth in Home Value by Census Tract 2000 to 2010",
      col="gray40", border="white" )
axis( side=1, at=seq( from=-100, to=200, by=50 ), 
      labels=paste0( seq( from=-100, to=200, by=50 ), "%" ) )
ymax <- max( hg$count )
        
mean.x <- mean( df$MHV.Growth.00.to.12, na.rm=T )
abline( v=mean.x, col="darkorange", lwd=2, lty=2 )
text( x=100, y=(0.5*ymax), 
      labels=paste0( "Mean = ", round(mean.x,0), "%"), 
      col="darkorange", cex=1.8, pos=4 )
median.x <- median( df$MHV.Growth.00.to.12, na.rm=T )
abline( v=median.x, col="dodgerblue", lwd=2, lty=2 )
text( x=100, y=(0.6*ymax), 
      labels=paste0( "Median = ", round(median.x,0), "%"), 
      col="dodgerblue", cex=1.8, pos=4 )
```

![MHV Change](https://r-class.github.io/cpp-528-fall-2021-group-05/assets/images/DorlingCartogram.png)

![](https://r-class.github.io/cpp-528-fall-2021-group-05/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-14-1.png)

## Metro Level Statistics

#### Metro Demographics

**Vacancy Rate**

![](https://r-class.github.io/cpp-528-fall-2021-group-05/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-16-1.png)

![](https://r-class.github.io/cpp-528-fall-2021-group-05/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-17-1.png)

**Unemployment Rate**

![](https://r-class.github.io/cpp-528-fall-2021-group-05/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-18-1.png)

![](https://r-class.github.io/cpp-528-fall-2021-group-05/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-19-1.png)

**Household Income**

![](https://r-class.github.io/cpp-528-fall-2021-group-05/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-20-1.png)

![](https://r-class.github.io/cpp-528-fall-2021-group-05/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-21-1.png)

**Correlation between MHV and Vacancy Rates**

``` r
jplot( df$Vacant.change, df$MHV.Growth.00.to.12, ylim=c(-50,100),
       lab1="Vacancy Rates", lab2="MHV Growth" )
```

![](https://r-class.github.io/cpp-528-fall-2021-group-05/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-22-1.png)

``` r
jplot( df$Unemp.change, df$MHV.Growth.00.to.12, ylim=c(-50,100),
       lab1="Unemployment Rates", lab2="MHV Growth" )
```

![](https://r-class.github.io/cpp-528-fall-2021-group-05/main/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-23-1.png)

``` r
jplot( df$Income.growth, df$MHV.Growth.00.to.12, ylim=c(-50,100),
       lab1="Household Income Change(logged)", lab2="MHV Growth" )
```

![](https://r-class.github.io/cpp-528-fall-2021-group-05/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-24-1.png)

## Including regression output

``` r
# load necessary packages ----
library(stargazer)
# load constants ----
STARGAZER_OUTPUT_TYPE = "html"
# create model ----
reg.data <- d
reg.data$mhv.growth[ reg.data$mhv.growth > 200 ] <- NA
reg.data$p.unemp <- log10( reg.data$unemp.change + 1 )
reg.data$p.vacant <- log10( reg.data$vacant.change + 1 )
reg.data$p.hinc <- log10( reg.data$hinc.change + 1 )
m1 <- lm( mhv.growth ~  p.hinc, data=reg.data )
m2 <- lm( mhv.growth ~  p.unemp, data=reg.data )
m3 <- lm(mhv.growth ~ p.vacant, data = reg.data)
m4 <- lm( mhv.growth ~  p.hinc + p.unemp + p.vacant, data=reg.data )
# display model
stargazer( m1, m2, m3, m4,
           type="text", #S_TYPE,
           digits=2,
           omit.stat = c("rsq","f") )
```
    ##
    ## ==============================================================================================
    ## Dependent variable:  
    ##————————————————————————– mhv.growth  
    ## (1) (2) (3) (4)  
    ## ———————————————————————————————- p.hinc 152.13\*\*\* 183.63\*\*\*  
    ## (1.47) (3.39)

    ## p.unemp -14.52\*\*\* -11.12\*\*\*  
    ## (1.16) (1.67)

    ## p.vacant -5.64\*\*\* -0.16  
    ## (1.61) (1.79)

    ## Constant 49.59\*\*\* 30.66\*\*\* 29.64\*\*\* 55.34\*\*\*  
    ## (0.24) (0.61) (0.82) (1.32)

    ## ------------------------------------------------------------------------

    ## Observations 58,557 25,844 19,489 9,330  
    ## Adjusted R2 0.15 0.01 0.001 0.24  
    ## Residual Std. Error 32.16 (df = 58555) 31.31 (df = 25842) 35.00 (df =19487) 27.44 (df = 9326)
    ## ==============================================================================================
    ## Note: *p&lt;0.1; **p&lt;0.05; ***p&lt;0.01

## Group Structure

``` r
d5 <- filter( d, cbsaname %in% 
                c("Tyler, TX",
                  "Minneapolis-St. Paul-Bloomington, MN-WI",
                  "San Francisco-San Mateo-Redwood City,CA") )
d5$cbsaname <- factor( d5$cbsaname, labels=c("MSP-MN","SF-CA","Tyler-TX") )
par( mar=c(4,6,4,6), mfrow=c(1,2) )
plot( d5$cbsaname,  d5$mhv.00, las=1, frame.plot=F, outline=F,
      xlab="", ylab="", main="Home Values in 2000" )
abline( h=seq(0,1200000,100000), lty=3, col=gray(0.5,0.3) )
axis( side=4, las=1 )
plot( d5$cbsaname,  d5$p.unemp, las=1, frame.plot=F, outline=F,
      xlab="", ylab="", main="Unemployment Rates in 2000" )
abline( h=seq(0,15,1), lty=3, col=gray(0.5,0.3) )
axis( side=4, las=1 )
```

![](https://r-class.github.io/cpp-528-fall-2021-group-05/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-25-1.png)

**Vacancy 2000 Metro Level**

``` r
d5 <- filter( d, cbsaname %in% 
                c("Tyler, TX",
                  "Minneapolis-St. Paul-Bloomington, MN-WI",
                  "San Francisco-San Mateo-Redwood City,CA") )
d5$cbsaname <- factor( d5$cbsaname, labels=c("MSP-MN","SF-CA","Tyler-TX") )
par( mar=c(4,6,4,6), mfrow=c(1,2) )
plot( d5$cbsaname,  d5$mhv.00, las=1, frame.plot=F, outline=F,
      xlab="", ylab="", main="Home Values in 2000" )
abline( h=seq(0,1200000,100000), lty=3, col=gray(0.5,0.3) )
axis( side=4, las=1 )
plot( d5$cbsaname,  d5$p.vacant, las=1, frame.plot=F, outline=F,
      xlab="", ylab="", main="Vacant in 2000" )
abline( h=seq(0,15,1), lty=3, col=gray(0.5,0.3) )
axis( side=4, las=1 )
```

![](https://r-class.github.io/cpp-528-fall-2021-group-05/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-26-1.png)

**Household Income Metro Level**

``` r
d5 <- filter( d, cbsaname %in% 
                c("Tyler, TX",
                  "Minneapolis-St. Paul-Bloomington, MN-WI",
                  "San Francisco-San Mateo-Redwood City,CA") )
d5$cbsaname <- factor( d5$cbsaname, labels=c("MSP-MN","SF-CA","Tyler-TX") )
par( mar=c(4,6,4,6), mfrow=c(1,2) )
plot( d5$cbsaname,  d5$mhv.00, las=1, frame.plot=F, outline=F,
      xlab="", ylab="", main="Home Values in 2000" )
abline( h=seq(0,1200000,100000), lty=3, col=gray(0.5,0.3) )
axis( side=4, las=1 )
plot( d5$cbsaname,  d5$hinc00, las=1, frame.plot=F, outline=F,
      xlab="", ylab="", main="Household Income in 2000" )
abline( h=seq(0,15,1), lty=3, col=gray(0.5,0.3) )
axis( side=4, las=1 )
```

![](https://r-class.github.io/cpp-528-fall-2021-group-05/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-27-1.png)

**Health of City 2000 to 2010 Grouped**

``` r
d5 <- filter( d, cbsaname %in%
                c("Tyler, TX",
                  "Youngstown-Warren-Boardman, OH-PA",
                  "Syracuse, NY") )
d5$mhv.growth[ d5$mhv.growth > 200 ] <- NA
d5$p.unemp.00 <- log10( d5$p.unemp.00 + 1 )
x <- rnorm( nrow(d5), 0, 0.1 ) +
     as.numeric( d5$cbsaname == "Tyler, TX" ) + 
     2 * as.numeric( d5$cbsaname == "Youngstown-Warren-Boardman, OH-PA" ) + 
     3* as.numeric( d5$cbsaname == "Syracuse, NY" ) 
par( mfrow=c(1,2) )
plot( x, d5$mhv.growth, 
      pch=19, cex=1.5, bty = "n",  
        col=factor(d5$cbsa),
      ylim=c(-50,50),
      xaxt="n", 
      ylab="", xlab="",
      main="MHV Growth")
axis( side=1, at=1:3, labels=c("Tyler","Youngstown","Syracuse"), 
      tick=F, col.axis="gray60", cex.axis=1.3 )
plot( x, d5$p.unemp, 
      pch=19, cex=1.5, bty = "n",  
        col=factor(d5$cbsa),
      # ylim=c(0,40),
      xaxt="n", 
      ylab="", xlab="",
      main="Unemployment (logged)")
axis( side=1, at=1:3, labels=c("Tyler","Youngstown","Syracuse"), 
      tick=F, col.axis="gray60", cex.axis=1.3 )
```

![](https://r-class.github.io/cpp-528-fall-2021-group-05/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-28-1.png)

``` r
d5 <- filter( d, cbsaname %in%
                c("Tyler, TX",
                  "Youngstown-Warren-Boardman, OH-PA",
                  "Syracuse, NY") )
d5$mhv.growth[ d5$mhv.growth > 200 ] <- NA
#d5$p.vacant <- log10( d5$p.vacant + 1 )
x <- rnorm( nrow(d5), 0, 0.1 ) +
     as.numeric( d5$cbsaname == "Tyler, TX" ) + 
     2 * as.numeric( d5$cbsaname == "Youngstown-Warren-Boardman, OH-PA" ) + 
     3* as.numeric( d5$cbsaname == "Syracuse, NY" ) 
par( mfrow=c(1,2) )
plot( x, d5$mhv.growth, 
      pch=19, cex=1.5, bty = "n",  
        col=factor(d5$cbsa),
      ylim=c(-50,50),
      xaxt="n", 
      ylab="", xlab="",
      main="MHV Growth")
axis( side=1, at=1:3, labels=c("Tyler","Youngstown","Syracuse"), 
      tick=F, col.axis="gray60", cex.axis=1.3 )
plot( x, d5$p.vacant, 
      pch=19, cex=1.5, bty = "n",  
        col=factor(d5$cbsa),
      # ylim=c(0,40),
      xaxt="n", 
      ylab="", xlab="",
      main="Vacant")
axis( side=1, at=1:3, labels=c("Tyler","Youngstown","Syracuse"), 
      tick=F, col.axis="gray60", cex.axis=1.3 )
```

![](https://r-class.github.io/cpp-528-fall-2021-group-05/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-29-1.png)

**Baseline metro-level home value growth**

``` r
m <- lm( mhv.growth ~ factor(cbsaname) + p.unemp.00 - 1, data=d5 )
b0.syracuse   <- m$coefficients[1] 
b0.tyler      <- m$coefficients[2] 
b0.youngston  <- m$coefficients[3] 
b1            <- m$coefficients[4] 
palette( c( "steelblue", "green3", "darkorange"  ) )
palette( adjustcolor( palette(), alpha.f = 0.3 ) )
plot( d5$p.unemp.00, d5$mhv.growth,
        pch=19, cex=1.5, bty = "n",  
        col=factor(d5$cbsa),
      ylim=c(-50,50),
      xlab="Unemployment Rate (logged)",
      ylab="Median Home Value Growth 2000-2010")
          
abline( b0.syracuse, b1, col="steelblue", lwd=3 )
abline( b0.tyler, b1, col="green3", lwd=3 )
abline( b0.youngston, b1, col="darkorange", lwd=3 )
```

![](https://r-class.github.io/cpp-528-fall-2021-group-05/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-30-1.png)

``` r
m <- lm( mhv.growth ~ factor(cbsaname) + p.vacant.00, data=d5 )
b0.syracuse   <- m$coefficients[1] 
b0.tyler      <- m$coefficients[2] 
b0.youngston  <- m$coefficients[3] 
b1            <- m$coefficients[4] 
palette( c( "steelblue", "green3", "darkorange"  ) )
palette( adjustcolor( palette(), alpha.f = 0.3 ) )
plot( d5$p.vacant.00, d5$mhv.growth,
        pch=19, cex=1.5, bty = "n",  
        col=factor(d5$cbsa),
      ylim=c(-50,50),
      xlab="Vacant",
      ylab="Median Home Value Growth 2000-2010")
          
abline( b0.syracuse, b1, col="steelblue", lwd=3 )
abline( b0.tyler, b1, col="green3", lwd=3 )
abline( b0.youngston, b1, col="darkorange", lwd=3 )
```

![](https://r-class.github.io/cpp-528-fall-2021-group-05/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-31-1.png)

**Adding fixed effect**

``` r
d.reg <- d
d.reg$mhv.growth[ d.reg$mhv.growth > 200 ] <- NA
d.reg$p.unemp.00 <- log10( d.reg$p.unemp.00 + 1 )
# average growth in median home value for the city
d.reg <- 
  d.reg %>%
  group_by( cbsaname ) %>%
  mutate( metro.mhv.growth = 100 * median( mhv.growth, na.rm=T ) ) %>%
  ungroup() 
m1 <- lm( mhv.growth ~ unemp.change + vacant.change + hinc.change, data=d.reg )
m2 <- lm( mhv.growth ~ unemp.change + vacant.change + hinc.change + metro.mhv.growth, data=d.reg )
m3 <- lm( mhv.growth ~ unemp.change + vacant.change + hinc.change + cbsa, data=d.reg )
stargazer( m1, m2, m3, 
           type="text", #S_TYPE,
           digits=2,
           omit.stat = c("rsq","f"),
           omit="cbsa",
           add.lines = list(c("Metro Fixed Effects:", "NO", "NO","YES")) )
```

    ## 
    ## ==========================================================================
    ##                                       Dependent variable:                 
    ##                      -----------------------------------------------------
    ##                                           mhv.growth                      
    ##                             (1)               (2)               (3)       
    ## --------------------------------------------------------------------------
    ## unemp.change             -0.67***          -0.43***          -0.47***     
    ##                           (0.13)            (0.09)            (0.09)      
    ##                                                                           
    ## vacant.change              -0.04            -0.23**           -0.27**     
    ##                           (0.15)            (0.11)            (0.12)      
    ##                                                                           
    ## hinc.change              117.20***         54.90***          57.31***     
    ##                           (2.10)            (1.70)            (1.76)      
    ##                                                                           
    ## metro.mhv.growth                            0.01***                       
    ##                                            (0.0001)                       
    ##                                                                           
    ## Constant                 56.65***          20.00***          12.12***     
    ##                           (0.82)            (0.73)            (3.31)      
    ##                                                                           
    ## --------------------------------------------------------------------------
    ## Metro Fixed Effects:        NO                NO                YES       
    ## Observations               9,330             9,330             9,330      
    ## Adjusted R2                0.25              0.60              0.60       
    ## Residual Std. Error  27.32 (df = 9326) 20.07 (df = 9325) 19.95 (df = 8997)
    ## ==========================================================================
    ## Note:                                          *p<0.1; **p<0.05; ***p<0.01

**What are the results? Which factor was most important? Did it meet
your expectations? Were there any variables that were not significant
that you expected to be?**

The results were that two of our three variables ended up being
indicators of neighborhood change. Income was the most significant
followed by unemployment. We assumed that a change in vacancy influence
the median home value due to less people occupying homes, thereby
decrease the average price. However, vacancy did not have a significant
influence on median home value indicating that additional research is
needed to determine why vacancy does not have an impact.
