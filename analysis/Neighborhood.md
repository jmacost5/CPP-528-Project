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

Today’s date is “May 2nd, 2022”

## Data Information

## Census Variables

### The following factors were chosen to identify gentrification:

-   Percentage of College Graduates: A decrese in percentage of college graduates income may indicate
    gentrification
-   Percentage of unemployed: A decrease in unemployment rate may indicate
    gentrification
-   Percentage of black: A decrease in percentage of black may indicate gentrification

``` r
#Percentage of College Graduates
col.00 <- d$col00  
col.10 <- d$col10
col.change <- col.10 - col.00
p.col.change <- col.change/col.00
p.col.growth <- log10(p.col.change +1)
d$col.change <- p.col.change
d$col.growth <- p.col.growth
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
#Percentage of Black 
black.00 <- d$p.black.00
black.10 <- d$p.black.10
black.change <- black.10 - black.00
p.black.change <- black.change/black.00
p.black.growth <- log10(p.black.change + 1)
d$black.change <- p.black.change
d$black.growth <- p.black.growth
 
```

# Create mini data frame

``` r
df <- data.frame( MedianHomeValue2000 = d$mhv.00, 
                  MedianHomeValue2010 = d$mhv.10, 
                  MHV.Change.00.to.10 = d$mhv.change,
                  MHV.Growth.00.to.12= d$mhv.growth,
                  Black2000 = black.00,
                  Black2010 = black.10,
                  Black.change = p.black.change,
                  Black.growth = p.black.growth,
                  Unemp2000 = unemp.00,
                  Unemp2010 = unemp.10,
                  Unemp.change = p.unemp.change,
                  Unemp.growth = p.unemp.growth,
                  College2000 = col.00,
                  College2010 = col.10,
                  College.change = p.col.change,
                  College.growth = p.col.growth)
df$Unemp.change[df$Unemp.change > 80 | df$Unemp.change < 1] <- NA
df$Unemp.growth[df$Unemp.growth > 80 | df$Unemp.growth < 1] <- NA
```

## Measurement Variables

``` r
#Correlation check
measurement.1 <- select(df, Black2000, College2000, Unemp2000, MedianHomeValue2000) %>% na.omit ()
```

``` r
set.seed(1234)

pairs(measurement.1, lower.panel = panel.smooth, upper.panel = panel.cor)
```
![](https://github.com/jmacost5/CPP-528-Project/blob/main/assets/img/screenshots/Unadjusted%20Variables%20Correlation%20.png)<!-- -->

``` r
measurement.2 <- select(df, Black.change, College.change, Unemp.change, MHV.Change.00.to.10) %>% na.omit ()
```

``` r
set.seed(1234)

pairs(measurement.2, lower.panel = panel.smooth, upper.panel = panel.cor)
```

![](https://github.com/jmacost5/CPP-528-Project/tree/main/assets/img/screenshots)

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

![](https://github.com/jmacost5/CPP-528-Project/blob/main/assets/img/screenshots/MHV%20in%202000.png)

### Descriptives

``` r
stargazer( df, 
           type="text", #S_TYPE, 
           digits=0, 
           summary.stat = c("min", "p25","median","mean","p75","max") )
```

   
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

![](https://github.com/jmacost5/CPP-528-Project/blob/main/assets/img/screenshots/Growth%20in%20MHV%20from%202000%20to%202010.png)

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

![MHV Change](https://github.com/jmacost5/CPP-528-Project/blob/main/assets/images/DorlingCartogram.png)

![](https://github.com/jmacost5/CPP-528-Project/blob/main/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-14-1.png)

 
 ## Metro Level Statistics

#### Metro Demographics

*College Graduates*

![](https://r-class.github.io/cpp-528-fall-2021-group-05/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-16-1.png)

![](https://r-class.github.io/cpp-528-fall-2021-group-05/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-17-1.png)

*Unemployment Rate*

![](https://r-class.github.io/cpp-528-fall-2021-group-05/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-18-1.png)

![](https://r-class.github.io/cpp-528-fall-2021-group-05/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-19-1.png)

*Percentage of black*

![](https://r-class.github.io/cpp-528-fall-2021-group-05/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-20-1.png)

![](https://r-class.github.io/cpp-528-fall-2021-group-05/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-21-1.png)
  
**Correlation between MHV and College Graduates**

``` r
jplot( df$College.change, df$MHV.Growth.00.to.12, ylim=c(-50,100),
       lab1="College Graduates", lab2="MHV Growth" )
```

![](https://r-class.github.io/cpp-528-fall-2021-group-05/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-22-1.png)

``` r
jplot( df$Unemp.change, df$MHV.Growth.00.to.12, ylim=c(-50,100),
       lab1="Unemployment Rates", lab2="MHV Growth" )
```

![](https://r-class.github.io/cpp-528-fall-2021-group-05/main/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-23-1.png)

``` r
jplot( df$Black.change, df$MHV.Growth.00.to.12, ylim=c(-50,100),
       lab1="Black People Number", lab2="MHV Growth" )
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
reg.data$p.col <- log10( reg.data$col.change + 1 )
reg.data$p.black <- log10( reg.data$black.change + 1 )
m1 <- lm( mhv.growth ~  p.black, data=reg.data )
m2 <- lm( mhv.growth ~  p.unemp, data=reg.data )
m3 <- lm(mhv.growth ~ p.col, data = reg.data)
m4 <- lm( mhv.growth ~  p.black + p.unemp + p.col, data=reg.data )
# display model
stargazer( m1, m2, m3, m4,
           type="text", #S_TYPE,
           digits=2,
           omit.stat = c("rsq","f") )
           
           
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

**College Graduates 2000 Metro Level**

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
plot( d5$cbsaname,  d5$p.col, las=1, frame.plot=F, outline=F,
      xlab="", ylab="", main="College Graduates in 2000" )
abline( h=seq(0,15,1), lty=3, col=gray(0.5,0.3) )
axis( side=4, las=1 )
```

![](https://r-class.github.io/cpp-528-fall-2021-group-05/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-26-1.png)

**Black Metro Level**

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
plot( d5$cbsaname,  d5$black.00, las=1, frame.plot=F, outline=F,
      xlab="", ylab="", main="Black People in 2000" )
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
#d5$p.col <- log10( d5$p.col + 1 )
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
plot( x, d5$p.col, 
      pch=19, cex=1.5, bty = "n",  
        col=factor(d5$cbsa),
      # ylim=c(0,40),
      xaxt="n", 
      ylab="", xlab="",
      main="College")
axis( side=1, at=1:3, labels=c("Tyler","Youngstown","Syracuse"), 
      tick=F, col.axis="gray60", cex.axis=1.3 )
```

![](https://r-class.github.io/cpp-528-fall-2021-group-05/assets/img/2021-11-12-ch03-mhv_files/figure-gfm/unnamed-chunk-29-1.png)

 **Baseline metro-level home value growth**
 
 ```{r , echo=FALSE}
d5 <- filter( d, cbsaname %in% 
                c("Tyler, TX",
                  "Minneapolis-St. Paul-Bloomington, MN-WI",
                  "San Francisco-San Mateo-Redwood City,CA") )
d5$cbsaname <- factor( d5$cbsaname, labels=c("MSP-MN","SF-CA","Tyler-TX") )
m <- lm( mhv.growth ~ factor(cbsaname) + p.unemp - 1, data=d5 )
b0.syracuse   <- m$coefficients[1] 
b0.tyler      <- m$coefficients[2] 
b0.youngston  <- m$coefficients[3] 
b1            <- m$coefficients[4] 
palette( c( "steelblue", "green3", "darkorange"  ) )
palette( adjustcolor( palette(), alpha.f = 0.3 ) )
plot( d5$p.unemp, d5$mhv.growth,
        pch=19, cex=1.5, bty = "n",  
        col=factor(d5$cbsa),
      xlim = NULL,
      ylim=c(-50,100),
      xlab="Unemployment Rate (logged)",
      ylab="Median Home Value Growth 2000-2010")
          
abline( b0.syracuse, b1, col="steelblue", lwd=3 )
abline( b0.tyler, b1, col="green3", lwd=3 )
abline( b0.youngston, b1, col="darkorange", lwd=3 )
```
           
![](https://github.com/jmacost5/CPP-528-Project/blob/main/assets/img/screenshots/Baseline%20MHV%20Growth%202000-2010.png)         
           
           
           
           
### Regression shows mutlicolinearity in coefficient and SD for percent black. Standard deviations increased for all variables but coefficents increased for percent college graduates and percent unemployed.


```{r, results='asis', echo=FALSE}
reg.data <- d
reg.data$mhv.growth[ d2$mhv.growth > 200 ] <- NA
reg.data$p.col <- log10( d2$p.col + 1 )
reg.data$p.black <- log10( d2$p.black+ 1 )
reg.data$p.unemp <- log10( d2$p.unemp  + 1  )
m1 <- lm( mhv.growth ~  p.black, data=reg.data )
m2 <- lm( mhv.growth ~  p.col, data=reg.data )
m3 <- lm( mhv.growth ~  p.unemp, data=reg.data )
m4 <- lm( mhv.growth ~ p.black+p.col+p.unemp  , data=reg.data )
stargazer( m1,m2, m3, m4, 
           type='html', 
           digits=2,
           omit.stat = c("rsq","f") )
```

![](https://github.com/jmacost5/CPP-528-Project/blob/main/assets/img/screenshots/Regression%20Table.png) 



### College graduates appear to have a negative correlation to median home value change in a regression with median home value. So, we will use a fixed effects model to account for unit level bias. 




**Adding fixed effect**

```{r, results='asis', echo=FALSE}
d.reg <- d
d.reg$mhv.growth[ d.reg$mhv.growth > 200 ] <- NA
d.reg$p.unemp <- log10( d.reg$p.unemp + 1 )
d.reg$p.col <- log10( d2$p.col + 1 )
d.reg$p.black <- log10( d2$p.black+ 1 )
d.reg$p.unemp <- log10( d2$p.unemp  + 1  )
# average growth in median home value for the city
d.reg <- 
  d.reg %>%
  group_by( cbsaname ) %>%
  mutate( metro.mhv.growth = 100 * median( mhv.growth, na.rm=T ) ) %>%
  ungroup() 
m1 <- lm( mhv.growth ~ p.unemp, data=d.reg )
m2 <- lm( mhv.growth ~  p.col, data=reg.data )
m3 <- lm( mhv.growth ~  p.black  , data=reg.data )
m4 <- lm( mhv.growth ~ p.unemp + cbsa+p.col+p.black , data=d.reg )
stargazer( m1, m2, m3, m4,
           type='html',
           digits=2,
           omit.stat = c("rsq","f"),
           omit="cbsa",
           add.lines = list(c("Metro Fixed Effects:", "NO", "NO","NO", "YES")) )
```
 
![](https://github.com/jmacost5/CPP-528-Project/blob/main/assets/img/screenshots/Regression%20Table%20after%20adding%20the%20fixed%20effect.png)  

     

**What are the results? Which factor was most important? Did it meet
your expectations? Were there any variables that were not significant
that you expected to be?**

The most important factor is percent unemployment. It has a strong correlation to median home value change, but using the fixed effects model, this correlation has decreased. There is probably missing variable bias, meaning that there is another variable that is not a part of our dataset that is causing variation that is attributed to percent unemployment but the relationship is probably not an accurate portrayal. We can look for alternative data analysis and wrangling with relative certainty that we are not simply trying to find a model to suit our wishes but one that more accurately reflects reality. If we could use more variables or look at more granular units, we could probably find a regression that is negative.
The college graduate relationship goes from negative in its first regression to positive in the full fixed effects model, which means that the fixed effects model accounted for variation in the intercepts by metro area, but that there is either still more to the story in terms of data analysis or that college graduates truly lower home values (student debt could be a factor). It’s possible that if we look by tract we may see a different relationship of college grads to median home value. 
