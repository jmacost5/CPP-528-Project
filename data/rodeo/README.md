#### Rodeo Files

This folder contains datasets that have been cleaned and processed, and are ready for analysis. 

Typically in use in RMD scripts used to produce all of the results in our reports we will read data primarily from the rodeo folder.

This allows us to isolate errors made in preparing the data (data wrangling) from errors made during the modeling stages.

we should not be doing data wrangling in your analytical steps with the exception of variable transformations related to modeling. 

For example, creating a squared value of a variable X to use in a quadratic model, logging a variable, or dividind by a constant to change the unit of analysis. 

Since these are steps related directly to the modeling process it is helpful to keep them together.

And finally we have moved all census tract meta-data into on a single file which makes it easy to add to any dataset when desired. Example of The new files consist of:

- LTDB-1970.rds

- LTDB-1980.rds

- LTDB-1990.rds

- LTDB-2000.rds

- LTDB-2010.rds

- LTDB-META-DATA.rds

#### What is a rodeo dataset? 

These are the files that will be utilized to create the analysis for your reports or publications. They're nicknamed "rodeo" datasets because they're ready for the big show - usage in models - once they've been wrangled. Typically, you should only read files from the rodeo folder throughout your analysis.

#### RDS vs CSV formats Why to Use RDS Format ?

Note that these are saved as RDS files instead of CSV files. There are two good reasons to do this:

First, the main difference between the file formats is RDS (R data set) files preserve variables type like numeric, character, factor, etc. R tries to guess at variable types when the data is loaded from a CSV file, but it does a poor job of it (for good reason, it is hard to automate without knowledge of the intended use of the data). As a result, it creates additional efforts needed to convert all of your variables to the proper classes after loading a CSV file. Whereas that step can be skipped when storing data in RDS files.

Second, RDS files by default are compressed, which means they take up less space on your hard drive and are easier to share. On average they are less than one-third the size of equivalent CSV files.

If the files are not extremely large, I find it useful to save both RDS and CSV versions in a folder for the convenience of opening a CSV file in Excel to preview the data. GitHub will also render small CSV files in a web browser for previewing purposes. In addition, if you share files with collaborators CSV is more convenient because most stats programs can use them, whereas RDS files are not as common.
