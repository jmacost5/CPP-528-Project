####Raw Files

All of the raw data files will go in the raw folder. By “raw” we mean the data as it arrived from whatever site we retrieved it from, or the file exactly how it was exported from a custom data collection tool like an online survey program.

Anything that documents the data collection process lives here. This folder also contain scripts used to download data from APIs or scripts that scrape data from websites. Also include any documentation of source data files like data dictionaries or guides to use.

If you are using data from third-party sources make sure you document retrieval dates, URLs, and to the extent possible any parameters that were used when downloading the data. Scripts are preferable because the arguments are then documented and the behavior can be replicated. If you have to manually enter a bunch of parameters in a data download GUI on the website then if there are questions about the raw data it is never possible to fully replicate the process. It will be unclear whether the provide updated the database and the data files changed, or whether the user incorrectly entered some parameters.

Common errors at the download step include things like making an error on a Census variable name (easy to do since the raw names are things like *B19013*). Or alternatively, incorrectly applying a filter like geography or time-period during a download.

Depending on how many unique data sources you use, you may want to include subdirectories for each unique source.

**The raw folder consists of the following: 


LTDB-DATA-DICTIONARY.xlsx
LTDB-codebook.pdf
LTDB_County_1980_Global_Neighborhood.csv
LTDB_County_1990_Global_Neighborhood.csv
LTDB_County_2000_Global_Neighborhood.csv
LTDB_County_2010_Global_Neighborhood.csv
LTDB_Std_1970_fullcount.csv
LTDB_Std_1980_fullcount.csv
LTDB_Std_1990_fullcount.csv
LTDB_Std_2000_fullcount.csv
LTDB_Std_2010_fullcount.csv
LTDB_Std_All_Sample.zip
LTDB_Std_All_fullcount.zip
cbsa-crosswalk.rds
ltdb_data_dictionary.csv
ltdb_std_1970_sample.csv
ltdb_std_1980_sample.csv
ltdb_std_1990_sample.csv
ltdb_std_2000_sample.csv
ltdb_std_2010_sample.csv

