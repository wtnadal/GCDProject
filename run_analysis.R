# last updated on 2014-12-20 by wtn

# author:       Bill Nadal
# course:       "Getting and Cleaning Data"
# course date:  Dec 1 - Dec 21 (2014)
# instructors: Jeff Leek, PhD, Roger D. Peng, PhD, Brian Caffo, PhD

# the overall project requirements consists of the following:
# 1)  create and test the run_analysis.R script
# 2)  create the readme.md file explaining how to run the script
# 3)  create the codebook.md file explaining the data, variables, etc.
# 4)  create the final "tidy dataset" and attach the file

# => a note for my fellow Coursera student project evaluator(s) <=
# we were to create one script called "run_analysis.R"   
# the project steps 1-4 can be done in any order according to the TAs
# I've arranged the steps in the order done in this/my version
# a remark of "COMPLETE" in the code means a sucessful run & test of that step
# this is the order of completion within my run_analysis.R script
# 
# 4) COMPLETE:  Appropriately labels the data set with descriptive variable names.
# 1) COMPLETE:  Merges the training and the test sets to create one data set.
# 3) COMPLETE:  Uses descriptive activity names to name the activities in the data set
# 2) COMPLETE:  Extracts only the measurements on the mean and standard deviation for each measurement. 
# 5) COMPLETE:  From the data set in step 4, creates a second, independent tidy data set with:
#               the average of each variable for each activity and each subject.

# load required libraries
library(dplyr)

# step-1 prepare the data
# data source file "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# the raw source files were manually downloaded and manually unzipped into the "~/Data" directory
# the run_analysis.R source is also in the "~/Data" directory
# refer to the codebook for more detailed file and data information

#set the current directory
setwd("~/Data")    

# read each file into R and give descriptive file names
# test files
testactivities <- read.table("y_test.txt", header = FALSE, sep = "", strip.white = TRUE)
testset <- read.table("X_test.txt", header = FALSE, sep = "", strip.white = TRUE)
testsubject <- read.table("subject_test.txt", header = FALSE, sep = "", strip.white = TRUE)

# training files
trainingactivities <- read.table("y_train.txt", header = FALSE, sep = "", strip.white = TRUE)
trainingset <- read.table("X_train.txt", header = FALSE, sep = "", strip.white = TRUE)
trainingsubject <- read.table("subject_train.txt", header = FALSE, sep = "", strip.white = TRUE)

# features and activity names files
features <- read.table("features.txt", header = FALSE, sep = "", strip.white = TRUE)
activitynames <- read.table("activity_labels.txt", header = FALSE, sep = "", strip.white = TRUE)

# make file col names descriptive and change factors to chars
# rename col V1 to subject
colnames(testsubject) <- c("subject")
# rename col V1 to subject
colnames(trainingsubject) <- c("subject")
# rename cols V1 & V2 to seqno & feature
colnames(features) <- c("seqno", "feature") 
# turn features into a char vector for setting col names
features <- as.character(features$feature) 
# rename all test V cols to feature names
colnames(testset) <- c(features)
# rename all training V cols to feature names
colnames(trainingset) <- c(features) 
# rename cols V1 & V2 to seqno & activity
colnames(activitynames) <- c("seqno", "activity")
# turn activities into a char vector for setting col names
activitynames$activity <- as.character(activitynames$activity) 
# rename test col V1 to label
colnames(testactivities) <- c("activity") 
# rename training col V1 to label
colnames(trainingactivities) <- c("activity")  

# 4) COMPLETE:  
# Appropriately labels the data set with descriptive variable names. 

# bind/add the subject ids to each of the respective train & test data sets
trainingset <- cbind(trainingsubject, trainingset)
testset <- cbind(testsubject, testset)

# bind/add the activity type codes ids to each of the respective train & test data sets
trainingset <- cbind(trainingactivities, trainingset)
testset <- cbind(testactivities, testset)

# finally, bind the two data tables together by row (they each share the same col names)
mergedset <- rbind(trainingset, testset)

# 1) COMPLETE:  
# mergedset merges the training and  test sets to create one data set

# substitute/replace the activity codes with their descriptive names
mergedset$activity[mergedset$activity == 1] <- "WALKING"       
mergedset$activity[mergedset$activity == 2] <- "WALKING_UPSTAIRS"
mergedset$activity[mergedset$activity == 3] <- "WALKING_DOWNSTAIRS"
mergedset$activity[mergedset$activity == 4] <- "SITTING"
mergedset$activity[mergedset$activity == 5] <- "STANDING"
mergedset$activity[mergedset$activity == 6] <- "LAYING"

# 3) COMPLETE:  
# Uses descriptive activity names to name the activities in the data set

# extract the column variables (values for "mean" or "std") 

# find the cols that are mean related
meanfeaturesindex <- grep("mean", features)
meanfeatures <- features[meanfeaturesindex]

# find the cols that are std related
stdfeaturesindex <- grep("std", features)
stdfeatures <- features[stdfeaturesindex]

# combine the vectors holding the cols names of interest
meanstdfeatureset <- c(meanfeatures, stdfeatures)

# keep the activity label col amd subject id col 
meanstdfeatureset <- c("activity", "subject", meanstdfeatureset)

# now select a subset for the cols we are interested in (subject, activity, stds, means)
submergedset <- subset(mergedset, select = meanstdfeatureset)

# 2) COMPLETE:  Extracts only the measurements on the mean and standard deviation for each measurement. 

# create the "tidy" data set, by activity, subject and the mean of each feature
# 
# group_by         "The group_by function takes an existing tbl and converts it 
#                   into a grouped tbl where operations are performed "by group"
# summarize_each   "Apply one or more functions to one or more columns" 
#                   Grouping variables are always excluded from modification"

tidydata <-  
        submergedset %>%
        group_by(subject, activity) %>%
        summarise_each(funs(mean))

# write out the table to a file, without row names
write.table(tidydata, file = "tidydata.txt", row.name = FALSE)

# 5) COMPLETE: From the data set in Step 4, creates a second, independent tidy data set
#     with: the average of each variable for each activity and each subject

# as an integrity test, read the tidydata file back into R
tidydataIn <- read.table("tidydata.txt", stringsAsFactors = FALSE, header = TRUE)


# end of source code for run_analysis.R #