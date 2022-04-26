#Lab 4
# load necessary packages ----
`%>%` <- magrittr::`%>%`
# load necessary packages
library( dplyr )
library( here )
library( knitr )
library( pander )
library( stargazer )
library( scales )
library(import)
library(tidyverse)


set.seed( 1234 )
# source(here::here("labs/wk06/lab_06_source.R"))
# 
# import::here("S_TYPE",
#              "panel.cor",
#              "panel.smooth",
#              "jplot",
#              "d",
#              "df",
#              "cbsa_stats_df",
#              # notice the use of here::here() that points to the .R file
#              # where all these R objects are created
#              .from = here::here("labs/wk06/lab_06_source.R"),
#              .character_only = TRUE) 

S_TYPE <-"html"
INFLATION_RATE <- 1.28855 

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


MHV.Change.00.to.10 <- d$MHV.Change.00.to.10

MHV2000 <- d$MedianHomeValue2000

stargazer (d, 
           type = 'html', 
           digits=0, 
           summary.stat = c("min", "p25","median","mean","p75","max") )


### Dataframe Preview


kable(head(df), 'html')


#Only Urban, no rural
d <- filter( d, urban == "urban" )

d <- select( d, tractid, 
             mhmval00, mhmval12, 
             hinc00, hinc12,hu10, own10, rent10,
             hu00, vac00, own00, rent00, h30old00,
             empclf00, clf00, unemp00, prof00,  
             empclf12, clf12, unemp12, prof12,
             dpov00, npov00,
             dpov12, npov12,
             ag25up00, hs00, col00, 
             ag25up12, hs12, col12,
             pop00.x, nhwht00, nhblk00, hisp00, asian00,
             pop10, nhwht10, nhblk10, hisp10, asian10,
             cbsa, cbsaname,
             #NEW VARIABLE IDEAS
             mar00,flabf00
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
    p.mar = 100 * mar00 / pop00.x,
    # NEW VARIABLE percent females in the labor force
    p.flabf00 =  100 * flabf00/empclf00 
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

#lab 5

# obtain NMTC data
NMTC_URL <- "https://raw.githubusercontent.com/DS4PS/cpp-528-spr-2020/master/labs/data/raw/NMTC/nmtc-sheet-01.csv"
nmtc <- read.csv( NMTC_URL, stringsAsFactors=F )

# obtain LIHTC data
LIHTC_URL <- "https://raw.githubusercontent.com/DS4PS/cpp-528-spr-2020/master/labs/data/raw/LIHTC/LIHTCPUB.csv"
lihtc <- read.csv( LIHTC_URL, stringsAsFactors=F )

# create a key that will allow us to obtain federal data for each tract ----
# remove anything not a number from the string
d$id2 <- gsub( "[^0-9]", "", d$tractid )

# fix IDs so they are match
d$id2 <- as.numeric( d$id2 )

# aggregate federal programs such that there is one record per tract ----
lihtc.dollars <-
  lihtc %>% 
  dplyr::filter( yr_alloc >= 2000 & yr_alloc <= 2010 ) %>%
  dplyr::group_by( fips2010 ) %>%
  dplyr::summarize( num.lihtc = dplyr::n(), lihtc.total = sum( allocamt, na.rm=T ) )

# remove dollar sign and commas
nmtc$amount <- gsub( "[,$]", "", nmtc$QLICI.Amount )

# convert characters to numeric 
nmtc$amount <- as.numeric( nmtc$amount ) %>% round(0)


nmtc.dollars <- 
  nmtc %>% 
  dplyr::filter( Origination.Year >= 2000 & Origination.Year <= 2010 ) %>%
  dplyr::group_by( X2010.Census.Tract ) %>% 
  dplyr::summarize( num.nmtc = dplyr::n(), nmtc.total = sum( amount, na.rm=T ) )

# merge federal data onto census tracts ----
d.fed <- merge( d, nmtc.dollars, by.x="id2", by.y="X2010.Census.Tract", all.x=T )
d.fed <- merge( d.fed, lihtc.dollars, by.x="id2", by.y="fips2010", all.x=T )

# recode tracts that had no grants from NA to 0 ---
d.fed$num.nmtc[ is.na(d.fed$num.nmtc) ] <- 0
d.fed$nmtc.total[ is.na(d.fed$nmtc.total) ] <- 0

d.fed$num.lihtc[ is.na(d.fed$num.lihtc) ] <- 0 
d.fed$lihtc.total[ is.na(d.fed$lihtc.total) ] <- 0


# adjust 2000 home values for inflation 
mhv.00 <- d.fed$mhmval00 * INFLATION_RATE  
mhv.10 <- d.fed$mhmval12

# change in MHV in dollars
mhv.change <- mhv.10 - mhv.00


# drop low year 2000 median home values
# to avoid unrealistic growth rates.
#
# tracts with homes that cost less than
# $10,000 are outliers
# approximately 200 out of 59,000 cases 
sum( mhv.00 < 10000 ) 
mhv.00[ mhv.00 < 10000 ] <- NA

# change in MHV in percent
mhv.growth <- 100 * ( mhv.change / mhv.00 )

# store mini data frame to be used for descriptive statistics ----
df <- data.frame( MedianHomeValue2000=mhv.00, 
                  MedianHomeValue2010=mhv.10, 
                  MHV.Change.00.to.10=mhv.change,
                  MHV.Growth.00.to.12=mhv.growth )

# add variables to the main data frame ----
d.fed$mhv.00 <- mhv.00
d.fed$mhv.10 <- mhv.10
d.fed$mhv.change <- mhv.change
d.fed$mhv.growth <- mhv.growth 

# select a few variables ----
d.fed <- dplyr::select( d.fed, 
                    
                    tractid, cbsa, cbsaname,            # ids / units of analysis
                    
                    mhv.00, mhv.10, mhv.change, mhv.growth,    # home value 
                    
                    hinc00, hu00, own00, rent00,        # ses
                    hinc12, hu10, own10, rent10,
                    
                    empclf00, clf00, unemp00, prof00,   # employment 
                    empclf12, clf12, unemp12, prof12,
                    
                    dpov00, npov00,                     # poverty
                    dpov12, npov12,
                    
                    ag25up00, hs00, col00,              # education 
                    ag25up12, hs12, col12,
                    
                    pop00.x, nhwht00, nhblk00, hisp00, asian00,   # race
                    pop10, nhwht10, nhblk10, hisp10, asian10,
                    
                    num.nmtc, nmtc.total,              # tax policy data
                    num.lihtc, lihtc.total             # aggregated by census tract
                    
) # end select


# create new variables ----
d.fed <- 
  d.fed %>%
  dplyr::mutate( 
    # 2000 variables
    p.white.00 = 100 * nhwht00 / pop00.x,
    p.black.00 = 100 * nhblk00 / pop00.x,
    p.hisp.00 = 100 * hisp00 / pop00.x, 
    p.asian.00 = 100 * asian00 / pop00.x,
    p.hs.edu.00 = 100 * (hs00+col00) / ag25up00,
    p.col.edu.00 = 100 * col00 / ag25up00,
    p.prof.00 = 100 * prof00 / empclf00,
    p.unemp.00 = 100 * unemp00 / clf00,
    pov.rate.00 = 100 * npov00 / dpov00,
    
    # 2010 variables
    p.white.10 = 100 * nhwht10 / pop10,
    p.black.10 = 100 * nhblk10 / pop10,
    p.hisp.10 = 100 * hisp10 / pop10, 
    p.asian.10 = 100 * asian10 / pop10,
    p.hs.edu.10 = 100 * (hs12+col12) / ag25up12,
    p.col.edu.10 = 100 * col12 / ag25up12,
    p.prof.10 = 100 * prof12 / empclf12,
    p.unemp.10 = 100 * unemp12 / clf12,
    pov.rate.10 = 100 * npov12 / dpov12 ) %>%
  # remove any NA or Inf values
  na.omit(use = "everything")

# inflation adjust income  ----
d.fed$hinc00 <- INFLATION_RATE * d.fed$hinc00

# create new variables by cbsa ----
d.fed<-
  d.fed %>%
  dplyr::group_by( cbsaname ) %>%
  dplyr::mutate( # metro rank of home value in 2000
    metro.mhv.pct.00 = dplyr::ntile( mhv.00, 100 ),
    # metro rank of home value in 2010
    metro.mhv.pct.10 = dplyr::ntile( mhv.10, 100 ),
    # median pay for metro area 2000
    metro.median.pay.00 = median( hinc00, na.rm=T ),
    # median pay for metro area 2010
    metro.median.pay.10 = median( hinc12, na.rm=T ),
    # tract rank in metro area for diversity (% non-white)
    metro.diversity.rank.00 = dplyr::ntile( (100-p.white.00), 100 ),
    # metro total population 2000
    metro.pop.total.00 = sum( pop00.x, na.rm=T ),
    # metro total population 2010
    metro.pop.total.10 = sum( pop10, na.rm=T ) ) %>%
  dplyr::ungroup() %>%
  dplyr::mutate( # change in relative rank of mhv in metro area 2000-2010
    metro.mhv.pctile.change = metro.mhv.pct.10 - metro.mhv.pct.00,
    # growth in ave pay in metro
    metro.pay.change = metro.median.pay.10 - metro.median.pay.00,
    # metro population growth 2000-2010
    metro.pop.growth = ( metro.pop.total.10 - metro.pop.total.00 ) / metro.pop.total.00,
    # increase in the proportion of whites in tract 
    increase.p.white = p.white.10 - p.white.00  )

# Create a true/false code for recipient tracts ----
d.fed$LIHTC <- ifelse( d.fed$num.lihtc > 0, "YES", "NO" )
d.fed$NMTC <- ifelse( d.fed$num.nmtc > 0, "YES", "NO" )

# create a growth column within the data frame ----
d.fed$growth <- d.fed$mhv.growth
d.fed$growth[ d.fed$growth > 200 ] <- NA




# store plots in a list for easy access ----

PLOTS <-
  list(
    "pov_rate_2000" = list(
      "nmtc" = ggplot2::ggplot(d.fed, ggplot2::aes(x=pov.rate.00, fill=NMTC )) +
        ggplot2::geom_density(alpha=0.4) + 
        ggplot2::ggtitle("2000 Poverty Rate")+
        ggplot2::labs(subtitle = "Recipient and Non-Recipient Communities"),
      "lihtc" = ggplot2::ggplot( d.fed, ggplot2::aes(x=pov.rate.00, fill=LIHTC)) +
        ggplot2::geom_density(alpha=0.4) +
        ggplot2::ggtitle("2000 Poverty Rate") +
        ggplot2::labs(subtitle = "Recipient and Non-Recipient Communities")),
    
    "mhv_2000" = list(
      "nmtc" = ggplot2::ggplot( d.fed, ggplot2::aes(x=log10(mhv.00), fill=NMTC )) +
        ggplot2::geom_density( alpha=0.4 ) +
        ggplot2::ggtitle("2000 Median Home Value of Recipient") +
        ggplot2::labs(subtitle = "Recipient and Non-Recipient Communities"),
      "lihtc" = ggplot2::ggplot( d.fed, ggplot2::aes(x=log10(mhv.00), fill=LIHTC )) +
        ggplot2::geom_density( alpha=0.4 )  +
        ggplot2::ggtitle("2000 Median Home Value") +
        ggplot2::labs(subtitle = "Recipient and Non-Recipient Communities")),
    
    "mhv_growth" = list(
      "nmtc" = ggplot2::ggplot( d.fed, ggplot2::aes(x=growth, fill=NMTC )) +
        ggplot2::geom_density( alpha=0.4 )  +
        ggplot2::ggtitle("MHV Growth 2000 to 2010") +
        ggplot2::labs(subtitle = "Recipients vs Non-Recipients"),
      "lihtc" = ggplot2::ggplot( d.fed, ggplot2::aes(x=growth, fill=LIHTC )) +
        ggplot2::geom_density( alpha=0.4 )  +
        ggplot2::ggtitle("MHV Growth 2000 to 2010") + 
        ggplot2::labs(subtitle = "Recipient vs Non-Recipients")))



### select vars
d.fed <- select(d.fed, mhv.00, mhv.10, p.col.edu.00, p.col.edu.10, p.unemp.00, p.unemp.10, p.black.10, p.black.00, num.nmtc, nmtc.total,num.lihtc, lihtc.total)

### remove nas
d.fed <- do.call(data.frame, lapply(d.fed, function(x) {
  replace(x, is.infinite(x) | is.na(x), 0)
}))

# create the difference in difference dataset ----

# store DV in both time periods

# store DV in both time periods
y1 <- log( d.fed$mhv.00 )
y2 <- log( d.fed$mhv.10 )

# store IV in both time periods
p.col00 <- as.numeric(log(d.fed$p.col.edu.00))
p.col10 <- as.numeric(log(d.fed$p.col.edu.10))
p.unemp00 <- as.numeric(log( d.fed$p.unemp.00))
p.unemp10 <- as.numeric(log( d.fed$p.unemp.10))
p.black00 <- as.numeric(log( d.fed$p.black.00))
p.black10 <- as.numeric(log( d.fed$p.black.10))

# create a variable that identifies if a tract received NMTC funding
treat <- as.numeric( d.fed$num.nmtc > 0 )

# add DV and IVs into one data frame per time period
df1 <- data.frame( y=y1, treat=treat, post=0, p.col=p.col00, p.unemp = p.unemp00, p.black = p.black00)
df2 <- data.frame( y=y2, treat=treat, post=1, p.col=p.col10, p.unemp = p.unemp10, p.black = p.black10)

# stack the time periods together into one data frame
df3 <- rbind( df1, df2 )
data_new <- df3                                                        # Duplicate data
data_new[is.na(data_new) | data_new == "Inf" | data_new == "-Inf"] <- NA  # Replace NaN & Inf & -Inf with NA

###labels for knitting
PercentCollegeGrad <- data_new$p.col
PercentUnemployed <- data_new$p.unemp
PercentBlackPopulation <- data_new$p.black

a <- lm( y ~ p.col +p.unemp +p.black + treat + post + treat*post, data=data_new)

# view regression results
pander(summary( pander(summary(lm( y ~ PercentCollegeGrad +PercentUnemployed + PercentBlackPopulation + treat + post + treat*post, data=data_new))) ))

# display model results
stargazer::stargazer(a,
                     title  = "NMTC Treatment",
                     covariate.labels = c("Percent College Grads", "Percent Unemployed", "Percent Black Population"),
                     dep.var.labels = "Log Median Home Value",
                     type = S_TYPE,
                     digits = 2)


treat2 <- as.numeric( d.fed$num.lihtc > 0 )

# add DV and IVs into one data frame per time period
dl1 <- data.frame( y=y1, treat=treat2, post=0, p.col=p.col00, p.unemp = p.unemp00, p.black = p.black00)
dl2 <- data.frame( y=y2, treat=treat2, post=1, p.col=p.col10, p.unemp = p.unemp10, p.black = p.black10)

# stack the time periods together into one data frame
dl3 <- rbind( dl1, dl2 )
data_new_l <- dl3                                   # Duplicate data
data_new_l[is.na(data_new_l) | data_new_l == "Inf" | data_new_l == "-Inf"] <- NA  # Replace NaN & Inf with NA



b <- lm( y ~ p.col +p.unemp +p.black + treat + post + treat*post, data=data_new_l)

###labels for knitting
PercentCollegeGrad <- data_new_l$p.col
PercentUnemployed <- data_new_l$p.unemp
PercentBlackPopulation <- data_new_l$p.black

# view regression results
pander(summary(lm( y ~ PercentCollegeGrad +PercentUnemployed + PercentBlackPopulation + treat + post + treat*post, data=data_new_l)))

# display model results
stargazer::stargazer(b,
                     title ="LIHTC Treatment",
                     covariate.labels = c("Percent College Grads", "Percent Unemployed", "Percent Black Population"),
                     dep.var.labels = "Log Median Home Value",
                     type = S_TYPE,
                     digits = 2)

# create a variable that identifies if a tract received NMTC funding
treat_t <- as.numeric( d.fed$num.nmtc > 0 )

# store the year 2000 data
dt1 <- data.frame( y=y1, treat=treat_t, post=0 )
# store the year 2010 data
dt2 <- data.frame( y=y2, treat=treat_t, post=1 )

# stack the two time periods together
dt3 <- rbind( dt1, dt2 )

# create a variable that identifies if a tract received NMTC funding
treat_t1 <- as.numeric( d.fed$num.lihtc > 0 )

# store the year 2000 data
dt4 <- data.frame( y=y1, treat=treat_t1, post=0 )
# store the year 2010 data
dt5 <- data.frame( y=y2, treat=treat_t1, post=1 )

# stack the two time periods together
dt6 <- rbind( dt1, dt2 )
dt7 <- rbind( dt4, dt5 )

c <- lm( y ~ treat + post + treat*post, data=dt6)
c2 <- lm( y ~ treat + post + treat*post, data=dt7)


#### NMTC Regression Summary 
# view regression results
pander(summary( c ))

#### LIHTC Regression Summary
pander(summary(c2))

# display model results
stargazer::stargazer(c,c2,
                     title  = "NMTC and LITHC Comparison",
                     dep.var.labels = "Log Median Home Value",
                     column.labels = c("NMTC", "LIHTC"),
                     type = S_TYPE,
                     digits = 2)

### Home value test
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


## Illustrating log relationships
data.frame( time=1:10, value=roi.1, log.value=log.roi.1 ) %>% pander()

### True Growth Rate
yt1 <- roi.1[1]
yt2 <- roi.2[2]


( yt2 - yt1 ) / yt1

### Growth Rate Approximation

log.yt1 <- log.roi.1[1]
log.yt2 <- log.roi.2[2]


log.yt2 - log.yt1

e <- lm( y ~ treat + post + treat*post, data=dt7 )

# display model results
stargazer(e,
          title = "NMTC- Diff-In-Diff",
          type = S_TYPE,
          digits = 2)

#### Diff-in-diff model - equation
b0 <- m$coefficients[1] 
b1 <- m$coefficients[2]
b2 <- m$coefficients[3]
b3 <- m$coefficients[4]

### C1 = B0 
C1 <- b0
pander(exp( C1 ))

### C2 = B0 + B2 
C2 <- b0 + b2
pander(exp( C2 ))

### T1 = B0 + B1 
T1 <- b0 + b1
pander(exp( T1 ))

### T2 = B0 + B1 + B2 + B3 
T2 <- b0+b1+b2+b3
pander(exp( T2 ))

### Counterfactual: C2-C1

CF<- 196984 - 156581

pander(CF)

### Our Treatment Group: T2-T1

TR <- 166560 - 120265
pander((TR))

### Treatment difference in difference (T2-T1) - (C2-C1)
pander(TR-CF)
