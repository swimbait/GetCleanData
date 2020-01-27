# GetCleanData

This repository contains several files and an associated R script that produced them. The script starts with this data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and then does the following:

- Opens the feature set file, cleans the column names
- Opens the train and test files, applies the cleaned column names, and row combines
- Removes columns that don't contain "mean" or "std" and saves the tidy data
- Calculates the mean for each remaining column, and saves the tidy data
