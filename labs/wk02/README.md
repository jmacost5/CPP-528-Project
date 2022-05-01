# Lab 02 - Data Wrangling 

This lab contains all the data prep process steps.
The end goal of data wrangling is for the data to be clean and easy to
use during the analytical stage of the project.  
Meaningful metadata about the LTDB dataset was added to a machine-readable
concordance file that will be used to greatly improve the usability of
the data.

**Part 1: Data Concordance** Downloaded the data concordance spreadsheet
that was created from the data prep process steps and stored it within the
data/rodeo directory. It has all of the information
about variable changes over time, but it has incomplete meta-data that
describes the variables.

**Part 2: Built a Variable Filter** Part of the challenge of working
with this dataset is its size. It’s hard to keep track of dozens of
variables at once, especially when the abbreviations are not very
helpful and many concepts are closely related.

**ONE: Filtered variables by theme or group.** Wrote a function that takes
as an argument one or more of the groups that was just created in the
concordance file under the “category” field and returns all of the
variables associated with that group.

**TWO: Created a function that searches variable descriptions for a
specific string and returns any variables that match.**

**THREE: Created a function to filter variables by time periods.
Specifically, the user will specify the time periods of interest for the
study and the function will identify all variables that have measures
for those periods.

This lab contains all files used in week 02 of CPP 528 Class. These files are not
meant to be used for decision-making or final analysis. These files
represent the project work in accomplishing the final product.
