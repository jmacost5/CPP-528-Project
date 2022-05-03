---
title: Neighborhood Characteristics
subtitle: "Predicting Median Home Value Change" 
---
# Neighborhood Change

## Gentrification

Gentrification is a complex issue. It can cause disruption in a
community and make residents feel as though they are no longer welcome
in areas where they have lived (for, sometimes, generations). Local
residents frequently worry that gentrification will lead to negative
impacts such as forced displacement, a fostering of discriminatory
behavior by people in power, and a focus on spaces that exclude
low-income individuals and people of color.[1]

Gentrification has increased over the last few decades.[2] High-income
and college-educated individuals increasingly have chosen to relocate to
dense, urban neighborhoods. Increased attention has led to an increase
in data-driven studies to understand this issue and help protect the
original residents. The byproduct has been more studies showing the
complicated nature of this problem and studies that show positive
outcomes for some communities going through this change. This
gentrification process reverses decades of urban decline and could bring
broad new benefits to cities through a growing tax base, increased
socioeconomic integration, and improved amenities (Vigdor 2002; Diamond
2016). Moreover, a large neighborhood effects literature shows that
exposure to higher-income neighborhoods has important benefits for
low-income residents, such as improving the mental and physical health
of adults and increasing the long-term educational attainment and
earnings of children (Kling et al. 2007; Ludwig et al. 2012; Chetty et
al. 2016; Chetty and Hendren 2018a,b; Chyn 2018). Gentrification thus
has the potential to dramatically reshape the geography of opportunity
in American cities.[3]


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

``` r
measurement.2 <- select(df, Black.change, College.change, Unemp.change, MHV.Change.00.to.10) %>% na.omit ()
```

``` r
set.seed(1234)

pairs(measurement.2, lower.panel = panel.smooth, upper.panel = panel.cor)
```
![](https://jmacost5.github.io/CPP-528-Project/assets/img/screenshots/Variables_Correlation.png)<!-- -->

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
![](https://jmacost5.github.io/CPP-528-Project/assets/img/screenshots/MHV_in_2000.png)<!-- -->

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
![](https://jmacost5.github.io/CPP-528-Project/assets/img/screenshots/Growth_in_MHV_from_2000_to_2010.png)<!-- -->

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
![](https://jmacost5.github.io/CPP-528-Project/assets/img/screenshots/Baseline_MHV_Growth_2000-2010.png)<!-- -->                
           
       
           
### Regression shows mutlicolinearity in coefficient and SD for percent black. Standard deviations increased for all variables but coefficents increased for percent college graduates and percent unemployed.

 ```{r , echo=FALSE}
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




![](https://jmacost5.github.io/CPP-528-Project/assets/img/screenshots/Regression_Table.png)<!-- -->    






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

![](https://jmacost5.github.io/CPP-528-Project/assets/img/screenshots/Regression_Table_after_adding_the_fixed_effect.png)<!-- -->    

     

**What are the results? Which factor was most important? Did it meet
your expectations? Were there any variables that were not significant
that you expected to be?**

The most important factor is percent unemployment. It has a strong correlation to median home value change, but using the fixed effects model, this correlation has decreased. There is probably missing variable bias, meaning that there is another variable that is not a part of our dataset that is causing variation that is attributed to percent unemployment but the relationship is probably not an accurate portrayal. We can look for alternative data analysis and wrangling with relative certainty that we are not simply trying to find a model to suit our wishes but one that more accurately reflects reality. If we could use more variables or look at more granular units, we could probably find a regression that is negative.
The college graduate relationship goes from negative in its first regression to positive in the full fixed effects model, which means that the fixed effects model accounted for variation in the intercepts by metro area, but that there is either still more to the story in terms of data analysis or that college graduates truly lower home values (student debt could be a factor). It’s possible that if we look by tract we may see a different relationship of college grads to median home value.


[1] Chong, E. (2017). Examining the negative impacts of gentrification.
Georgetown Journal on Poverty Law & Policy.

[2] Rucks-Ahidiana, Z. (2021). Racial composition and trajectories of
gentrification in the United States. Urban Studies, 58(13), 2721-2741.

[3] Brummet, Q., & Reed, D. (2019). The effects of gentrification on the
well-being and opportunity of original resident adults and children.

