<<<<<<< Updated upstream
#
# Author:   Cristian Nuno
# Date:     March 30, 2021
# Purpose:  Store relevant lab 04 objects in this source file
#

# load necessary packages ----
`%>%` <- magrittr::`%>%`

# load necessary constants ----

# stargazer settings
S_TYPE <- "html"

# inflation rate
INFLATION_RATE <- 1.28855 

# load custom functions ----

# Helper functions for the **pairs()** correlation table 
panel.cor <- function(x, y, digits=2, prefix="", cex.cor)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  r <- abs(cor(x, y))
  txt <- format(c(r, 0.123456789), digits=digits)[1]
  txt <- paste(prefix, txt, sep="")
  if(missing(cex.cor)) cex <- 0.8/strwidth(txt)
  
  test <- cor.test(x,y)
  # borrowed from printCoefmat
  Signif <- symnum(test$p.value, corr = FALSE, na = FALSE,
                   cutpoints = c(0, 0.001, 0.01, 0.05, 0.1, 1),
                   symbols = c("***", "**", "*", ".", " "))
  
  text(0.5, 0.5, txt, cex = 1.5 )
  text(.7, .8, Signif, cex=cex, col=2)
}

panel.smooth <- function (x, y, col = par("col"), bg = NA, pch = par("pch"), 
                          cex = 0.5, col.smooth = "red", span = 2/3, iter = 3, ...) 
{
  points(x, y, pch = 19, col = gray(0.7,0.2), bg = bg, cex = cex)
  ok <- is.finite(x) & is.finite(y)
  if (any(ok)) 
    lines(stats::lowess(x[ok], y[ok], f = span, iter = iter), 
          col = col.smooth, lwd=2, ...)
}

# custom plot
jplot <- function( x1, x2, lab1="", lab2="", draw.line=T, ... )
{
  
  plot( x1, x2,
        pch=19, 
        col=gray(0.6, alpha = 0.2), 
        cex=0.5,  
        bty = "n",
        xlab=lab1, 
        ylab=lab2, cex.lab=1.5,
        ... )
  
  if( draw.line==T ){ 
    ok <- is.finite(x1) & is.finite(x2)
    lines( lowess(x2[ok]~x1[ok]), col="red", lwd=3 ) }
  
}

# load necessary data ----
# remember to use the here::here() function
d1 <- readRDS( here::here( "data/rodeo/LTDB-2000.rds" ) )
d2 <- readRDS( here::here( "data/rodeo/LTDB-2010.rds" ) )
md <- readRDS( here::here( "data/rodeo/LTDB-META-DATA.rds" ) )

d1 <- dplyr::select( d1, - year )
d2 <- dplyr::select( d2, - year )

d <- merge( d1, d2, by="tractid" )
d <- merge( d, md, by="tractid" )

# filter rural districts
d <- dplyr::filter( d, urban == "urban" )

d <- dplyr::select( d, tractid, 
             mhmval00, mhmval12, 
             hinc00, 
             hu00, vac00, own00, rent00, h30old00,
             empclf00, clf00, unemp00, prof00,  
             dpov00, npov00,
             ag25up00, hs00, col00, 
             pop00.x, nhwht00, nhblk00, hisp00, asian00,
             cbsa, cbsaname )


d <- 
  d %>%
  dplyr::mutate( p.white = 100 * nhwht00 / pop00.x,
          p.black = 100 * nhblk00 / pop00.x,
          p.hisp = 100 * hisp00 / pop00.x, 
          p.asian = 100 * asian00 / pop00.x,
          p.hs = 100 * (hs00+col00) / ag25up00,
          p.col = 100 * col00 / ag25up00,
          p.prof = 100 * prof00 / empclf00,
          p.unemp = 100 * unemp00 / clf00,
          p.vacant = 100 * vac00 / hu00,
          mhv.change.00.to.10 = mhmval12 - mhmval00,
          p.mhv.change = 100 * (mhmval12 - mhmval00) / mhmval00,
          pov.rate = 100 * npov00 / dpov00 )


# adjust 2000 home values for inflation 
mhv.00 <- d$mhmval00 * INFLATION_RATE 
mhv.10 <- d$mhmval12

# change in MHV in dollars
mhv.change <- mhv.10 - mhv.00


# drop low 2000 median home values
# to avoid unrealistic growth rates.
#
# tracts with homes that cost less than
# $10,000 are outliers
mhv.00[ mhv.00 < 10000 ] <- NA

# change in MHV in percent
mhv.growth <- 100 * ( mhv.change / mhv.00 )

d$mhv.00 <- mhv.00
d$mhv.10 <- mhv.10
d$mhv.change <- mhv.change
d$mhv.growth <- mhv.growth 

# create mini data frame
df <- data.frame( MedianHomeValue2000=mhv.00, 
                  MedianHomeValue2010=mhv.10, 
                  MHV.Change.00.to.10=mhv.change,
                  MHV.Growth.00.to.12=mhv.growth )

# average growth in median home value for the city
cbsa_stats_df <- 
  d %>%
  dplyr::group_by( cbsaname ) %>%
  dplyr::summarize( metro.mhv.change = median( mhv.change, na.rm=T ),
             metro.mhv.growth = 100 * median( mhv.growth, na.rm=T ) ) %>%
  dplyr::ungroup() 




=======
#
# Author:   Cristian Nuno
# Date:     March 30, 2021
# Purpose:  Store relevant lab 04 objects in this source file
#

# load necessary packages ----
`%>%` <- magrittr::`%>%`

# load necessary constants ----

# stargazer settings
S_TYPE <- "html"

# inflation rate
INFLATION_RATE <- 1.28855 

# load custom functions ----

# Helper functions for the **pairs()** correlation table 
panel.cor <- function(x, y, digits=2, prefix="", cex.cor)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  r <- abs(cor(x, y))
  txt <- format(c(r, 0.123456789), digits=digits)[1]
  txt <- paste(prefix, txt, sep="")
  if(missing(cex.cor)) cex <- 0.8/strwidth(txt)
  
  test <- cor.test(x,y)
  # borrowed from printCoefmat
  Signif <- symnum(test$p.value, corr = FALSE, na = FALSE,
                   cutpoints = c(0, 0.001, 0.01, 0.05, 0.1, 1),
                   symbols = c("***", "**", "*", ".", " "))
  
  text(0.5, 0.5, txt, cex = 1.5 )
  text(.7, .8, Signif, cex=cex, col=2)
}

panel.smooth <- function (x, y, col = par("col"), bg = NA, pch = par("pch"), 
                          cex = 0.5, col.smooth = "red", span = 2/3, iter = 3, ...) 
{
  points(x, y, pch = 19, col = gray(0.7,0.2), bg = bg, cex = cex)
  ok <- is.finite(x) & is.finite(y)
  if (any(ok)) 
    lines(stats::lowess(x[ok], y[ok], f = span, iter = iter), 
          col = col.smooth, lwd=2, ...)
}

# custom plot
jplot <- function( x1, x2, lab1="", lab2="", draw.line=T, ... )
{
  
  plot( x1, x2,
        pch=19, 
        col=gray(0.6, alpha = 0.2), 
        cex=0.5,  
        bty = "n",
        xlab=lab1, 
        ylab=lab2, cex.lab=1.5,
        ... )
  
  if( draw.line==T ){ 
    ok <- is.finite(x1) & is.finite(x2)
    lines( lowess(x2[ok]~x1[ok]), col="red", lwd=3 ) }
  
}

# load necessary data ----
# remember to use the here::here() function
d1 <- readRDS( here::here( "data/rodeo/LTDB-2000.rds" ) )
d2 <- readRDS( here::here( "data/rodeo/LTDB-2010.rds" ) )
md <- readRDS( here::here( "data/rodeo/LTDB-META-DATA.rds" ) )

d1 <- dplyr::select( d1, - year )
d2 <- dplyr::select( d2, - year )

d <- merge( d1, d2, by="tractid" )
d <- merge( d, md, by="tractid" )

# filter rural districts
d <- dplyr::filter( d, urban == "urban" )

d <- dplyr::select( d, tractid, 
             mhmval00, mhmval12, 
             hinc00, 
             hu00, vac00, own00, rent00, h30old00,
             empclf00, clf00, unemp00, prof00,  
             dpov00, npov00,
             ag25up00, hs00, col00, 
             pop00.x, nhwht00, nhblk00, hisp00, asian00,
             cbsa, cbsaname )


d <- 
  d %>%
  dplyr::mutate( p.white = 100 * nhwht00 / pop00.x,
          p.black = 100 * nhblk00 / pop00.x,
          p.hisp = 100 * hisp00 / pop00.x, 
          p.asian = 100 * asian00 / pop00.x,
          p.hs = 100 * (hs00+col00) / ag25up00,
          p.col = 100 * col00 / ag25up00,
          p.prof = 100 * prof00 / empclf00,
          p.unemp = 100 * unemp00 / clf00,
          p.vacant = 100 * vac00 / hu00,
          mhv.change.00.to.10 = mhmval12 - mhmval00,
          p.mhv.change = 100 * (mhmval12 - mhmval00) / mhmval00,
          pov.rate = 100 * npov00 / dpov00 )


# adjust 2000 home values for inflation 
mhv.00 <- d$mhmval00 * INFLATION_RATE 
mhv.10 <- d$mhmval12

# change in MHV in dollars
mhv.change <- mhv.10 - mhv.00


# drop low 2000 median home values
# to avoid unrealistic growth rates.
#
# tracts with homes that cost less than
# $10,000 are outliers
mhv.00[ mhv.00 < 10000 ] <- NA

# change in MHV in percent
mhv.growth <- 100 * ( mhv.change / mhv.00 )

d$mhv.00 <- mhv.00
d$mhv.10 <- mhv.10
d$mhv.change <- mhv.change
d$mhv.growth <- mhv.growth 

# create mini data frame
df <- data.frame( MedianHomeValue2000=mhv.00, 
                  MedianHomeValue2010=mhv.10, 
                  MHV.Change.00.to.10=mhv.change,
                  MHV.Growth.00.to.12=mhv.growth )

# average growth in median home value for the city
cbsa_stats_df <- 
  d %>%
  dplyr::group_by( cbsaname ) %>%
  dplyr::summarize( metro.mhv.change = median( mhv.change, na.rm=T ),
             metro.mhv.growth = 100 * median( mhv.growth, na.rm=T ) ) %>%
  dplyr::ungroup() 
>>>>>>> Stashed changes


---
  title: "Week 4 - Predicting Change"
author: "Team 1"
date: '2022-04-12'
output: html_document
---
  

# load necessary packages
library( dplyr )
library( here )
library( knitr )
library( pander )
library( stargazer )
library( scales )
library(knitr)

# set randomization seed ----
set.seed( 1234 )
source(here::here("labs/wk04/lab_04_source.R"))
# load necessary functions and objects ----
# note: all of these are R objects that will be used throughout this .rmd file
import::here("S_TYPE",
             "panel.cor",
             "panel.smooth",
             "jplot",
             "d",
             "df",
             "cbsa_stats_df",
             # notice the use of here::here() that points to the .R file
             # where all these R objects are created
             .from = here::here("labs/wk04/lab_04_source.R"),
             .character_only = TRUE) 
S_TYPE <-"text"
INFLATION_RATE <- 1.28855 


# load necessary data ----
# remember to use the here::here() function
d1 <- readRDS( here::here( "data/rodeo/LTDB-2000.rds" ) )
d2 <- readRDS( here::here( "data/rodeo/LTDB-2010.rds" ) )
md <- readRDS( here::here( "data/rodeo/LTDB-META-DATA.rds" ) )

d1 <- dplyr::select( d1, - year )
d2 <- dplyr::select( d2, - year )

d <- merge( d1, d2, by="tractid" )
d <- merge( d, md, by="tractid" )



## Part 1 - Data

stargazer (df, 
           type = 'html', 
           digits=0, 
           summary.stat = c("min", "p25","median","mean","p75","max") )


### Dataframe Preview


kable(head(df), 'html')










MHV.Change.00.to.10 <- df$MHV.Change.00.to.10
MHV2000 <- df$MedianHomeValue2000


#Only Urban, no rurl
d <- filter( d, urban == "urban" )

d <- select( d, tractid, 
             mhmval00, mhmval12, 
             hinc00, 
             hu00, vac00, own00, rent00, h30old00,
             empclf00, clf00, unemp00, prof00,  
             dpov00, npov00,
             ag25up00, hs00, col00, hinc00,
             pop00.x, nhwht00, nhblk00, hisp00, asian00,
             cbsa, cbsaname
             #NEW VARIABLE IDEAS
             #mar00,flabf00
)
d <- 
  d %>%
  mutate( # percent white in 2000
    p.white = 100 * nhwht00 / pop00.x,
    # percent black in 2000
    p.black = 100 * nhblk00 / pop00.x,
    # percent hispanic in 2000
    p.hisp = 100 * hisp00 / pop00.x, 
    # percent asian in 2000
    p.asian = 100 * asian00 / pop00.x,
    # percent high school grads by age 25 in 2000 
    p.hs = 100 * (hs00+col00) / ag25up00,
    # percent pop with college degree in 2000
    p.col = 100 * col00 / ag25up00,
    # percent employed in professional fields in 2000
    p.prof = 100 * prof00 / empclf00,
    # percent unemployment  in 2000
    p.unemp = 100 * unemp00 / clf00,
    # percent of housing lots in tract that are vacant in 2000
    p.vacant = 100 * vac00 / hu00,
    # dollar change in median home value 2000 to 2010 
    pov.rate = 100 * npov00 / dpov00,
    # NEW VARIABLE percent married in 2000
    # p.mar = 100 * mar00 / pop00.x,
    # NEW VARIABLE percent females in the labor force
    #p.flabf00 =  100 * flabf00/empclf00 
  )

# adjust 2000 home values for inflation 
mhv.00 <- d$mhmval00 * INFLATION_RATE 
mhv.10 <- d$mhmval12

# change in MHV in dollars
mhv.change <- mhv.10 - mhv.00

# drop low 2000 median home values, to avoid unrealistic growth rates, tracts with homes that cost less than, $10,000 are outliers
#Omit cases that have a median home value less than $10,000 in 2000.
mhv.00[ mhv.00 < 10000 ] <- NA

# change in MHV in percent, 
mhv.growth <- 100 * ( mhv.change / mhv.00 )
d$mhv.00 <- mhv.00
d$mhv.10 <- mhv.10
d$mhv.change <- mhv.change
d$mhv.growth <- mhv.growth 

# Create a variable that measures the growth of median home value from 2000 to 2010.
MHV.Growth.00.to.10 <- ( MHV.Change.00.to.10 / MHV2000 )
mhv.growth <- ( mhv.change / mhv.00 )

# Omit cases with growth rates above 200%. 
# change in MHV.00.to.10 in percent, 
p.MHV.Growth.00.to.10 <- 100 * ( MHV.Change.00.to.10 / MHV2000 )

# Omit cases with growth rates above 200%.
p.MHV.Growth.00.to.10[ p.MHV.Growth.00.to.10 > 200 ] <- NA
mhv.growth[ mhv.growth > 200 ] <- NA




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


## Part 2 - Predicting MHV Change

### Checking Skew


# create subset to visualize in correlation matrix 
d6 <- select( d, mhv.growth, p.col,  p.black, p.unemp )

# reduce data density for visualization
set.seed( 1234 )
d3 <- sample_n( d6, 10000 ) %>% na.omit()

# correlation plots
pairs( d3, upper.panel=panel.cor, lower.panel=panel.smooth )



### Adjusting for skew


set.seed( 1234 )

d2 <- select( d, mhv.growth, p.col, p.black, p.unemp  )

# recode some vars to remove outliers and skew
d2$mhv.growth[ d2$mhv.growth > 200 ] <- NA
d2$p.col <- log10( d2$p.col + 1 )
d2$p.black <- log10( d2$p.black+ 1 )
d2$p.unemp  <- log10( d2$p.unemp  + 1  )


d4 <- sample_n( d2, 5000 ) %>% na.omit()
pairs( d4, upper.panel=panel.cor, lower.panel=panel.smooth )




### Regression shows mutlicolinearity in coefficient and SD for percent black. Standard deviations increased for all variables but coefficents increased for percent college graduates and percent unemployed.


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




### College graduates appear to have a negative correlation to median home value change in a regression with median home value. So, we will use a fixed effects model to account for unit level bias. 



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



### The most important factor is percent unemployment. It has a strong correlation to median home value change, but using the fixed effects model, this correlation is decreased. There is probably missing variable bias, meaning that there is another variable that is not a part of our dataset that is causing variation that is attributed to percent unemployment but the relationship is probably not actually true, and we can look for alternative data analysis and wrangling with relative certainty that we are not simply trying to find a model to suit our wishes but one that more accurately reflects reality. If we could use more variables or look at more granular units, we could probably find a regression that is negative. 


### The college graduate relationship goes from negative in its first regression to positive in the full fixed effects model, which means that the fixed effects model accounted for variation in the intercepts by metro area, but that there is either still more to the story in terms of data analysis or that college graduates truly lower home values (student debt could be a factor). It's possible that if we look by tract we may see a different relationship of college grads to median home value.


