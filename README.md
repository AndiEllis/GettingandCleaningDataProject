# GettingandCleaningDataProject
Course Project (Week 4), Peer Reviewed

This is the course project for the Getting and Cleaning Data Coursera course (March 2017. My R script, run_analysis.R, does the following:

1) Download the dataset from accelerometers for the Samsung Galaxy S smartphone in the working directory, and unzips directory
2) Load the activity and feature info
3) Loads both the training and test datasets
4) Creates a data table for each parameter from items 2 & 3. 
5) Merges columns of subject and activity for each data set
keeping only those columns which reflect a mean or standard deviation, then merges the two datasets
6) Selects and saves only those columns which reflect a mean or standard deviation
7) Renames column labels into easier-to-read format, as defined by "tidy data"
8) Creates a second, independent tidy data set wiht the average of each variable for each activity 
9) End result is shown and saved in the tidyData.txt file
