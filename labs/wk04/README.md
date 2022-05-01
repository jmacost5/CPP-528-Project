# Lab o4 Predicting MHV Change

This lab is designed to allow us build our baseline model of neighborhood change before adding the policy variables in the next lab.

**Part 1 - Data**
We created a dataset that includes 2000 and 2010 census variables after dropping all rural census tracts.

Then, we created a variable that measures the growth of median home value from 2000 to 2010.

Cases that have a median home value less than $10,000 in 2000 and those that have growth rates above 200% were ommitted.

**Part 2 - Predict MHV Change**
Three census variables were selected as good predictors of change in MHV between 2000 and 2010.

Running the model while including metro-level fixed effects (cbsa name or FIPS) while making sure to check for variable skew and multicollinearity and adjust accordingly.

The most important factor is percent unemployment. It has a strong correlation to median home value change, but using the fixed effects model, this correlation is decreased. There is probably missing variable bias, meaning that there is another variable that is not a part of our dataset that is causing variation that is attributed to percent unemployment but the relationship is probably not an accurate portrayal. We can look for alternative data analysis and wrangling with relative certainty that we are not simply trying to find a model to suit our wishes but one that more accurately reflects reality. If we could use more variables or look at more granular units, we could probably find a regression that is negative. 


The college graduate relationship goes from negative in its first regression to positive in the full fixed effects model, which means that the fixed effects model accounted for variation in the intercepts by metro area, but that there is either still more to the story in terms of data analysis or that college graduates truly lower home values (student debt could be a factor). It's possible that if we look by tract we may see a different relationship of college grads to median home value.
 
