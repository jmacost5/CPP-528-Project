#
# Author:   Cristian Nuno
# Date:     March 14, 2021
# Purpose:  Create .md files from .rmd files and store them elsewhere
#

# load necessary packages ----
library(here)
library(readr)
library(rmarkdown)
library(stringr)

# load necessary constants ----
FILE_INFO <- list(
  # note: all .rmd files must live in the analysis/ directory
  "rmd_files" = c(
    here::here("analysis/2021-11-28-2021-ch02-Group-05.Rmd"), here::here("analysis/2021-12-03-ch04-Predicting_Change.Rmd")
  ),
  "yaml_files" = c(
    here::here("assets/yaml/2021-03-14-ch01-example_page.yaml")
  )
)

# create render function ----
create_chapter <- function(input_file, yaml_file) {
  # export the .rmd files as .md files into the assets/img/ directory
  rmarkdown::render(input = input_file,
                    output_format = "md_document",
                    output_dir = here::here("assets/img/")
                    )
  
  # obtain the .rmd file name
  rmd_filename <- stringr::str_replace(input_file,
                                      # find the analysis sub string
                                      "analysis",
                                      # replace it with where the .md file lives
                                      "assets/img")
  
  # replace the .rmd with .md within the file name
  md_filename <- stringr::str_replace(rmd_filename,
                                      # find the .rmd sub string
                                      "rmd",
                                      # replace it with .md
                                      "md")

  # read the .md file name as a string
  md_string_raw <- readr::read_file(md_filename)
  
  # replace every instance of here::here() with .. to create a relative path 
  md_string_clean <- stringr::str_replace_all(md_string_raw,
                                              here::here(),
                                              "..")
  
  # add the .yaml file at the top of .md file
  md_string_clean_with_yaml <- paste(append(md_string_clean, 
                                            readr::read_file(yaml_file),
                                            # add .yaml contents to the top
                                            after = 0),
                                     # squish the vector into one element
                                     collapse = "\n")
  print(md_string_clean_with_yaml)
  
  # rewrite the .md file with the relative paths now referenced
  readr::write_file(md_string_clean_with_yaml,
                    file = md_filename)

  
  # move the .md file from assets/img into _posts/
  file.rename(from = md_filename,
              to = here::here("_posts", basename(md_filename)))
}

# for each file, create a chapter that the user can view on the website ----
mapply(FUN = create_chapter,
       FILE_INFO$rmd_files,
       FILE_INFO$yaml_files,
       SIMPLIFY = FALSE)

# end of script #
