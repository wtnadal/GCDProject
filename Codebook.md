# Codebook.md
Bill Nadal  
December 17, 2014  
*"May you live in times of interesting data"* - Bill Nadal

- Codebook for the project in Coursera's "Getting and Cleaning Data"
- In support of the run_analysis.R script 
- Script, data, codebook & readme are in the github wtnadal/GCDProject repo
- Course date is Dec 1 - Dec 21 (2014)
- Instructors are Jeff Leek, PhD, Roger D. Peng, PhD, Brian Caffo, PhD

### Note for my fellow Coursera project evaluators  
*This codebook is intended to help readers understand the source data files, 
the transformation steps, the order of transformation, and the final result 
(tidydata file).  I am using the "Knit" feature in R Studio, which creates 
the .md file, and can execute and embed R code and output within the .md file.
I have used the echo=FALSE option, which will include the R code in the .md file.
This was necessary as I use the str(dataset) function to display relevant information 
about the data sets, and by setting echo=FALSE the dataset name is also displayed for 
reference and documentation.*

*For accessibility and ease of access, this Codebook.md has appended the 
researchers "readme.txt" file contents at the end of this codebook. The readme provides
the details for the data collected and the relationships between the files.*

### Overview and background info
The original data file used in this analysis was manually downloaded 
from the UCI Machine Learning website and manually unzipped under 
the current working directory, e.g. "~/Data".

The original data file can be downloaded at this link:  
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The original reseachers overview and additional readme.txt file is at this link:  
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Hadley Wickham, in his document *"Tidy Data"* decscribes the goals, motivations, 
and approaches for cleaning and transforming data and observations into
tidy data files. http://www.jstatsoft.org/v59/i10/paper

*"Tidy datasets are easy to manipulate, model and visualise, and have a
specific structure: each variable is a column, each observation is a row,
and each type of observational unit is a table." - HW*

Our goal is to take several large corpuses of smartphone physical observations 
from anonymous subjects across 6 types of physical activities, focused on the
mean and standard deviations form the measurements. Summarizing and grouping 
all this data in a "tidydata.txt" file about 268KB in size.

Their are several places to start with this set of files, with the goal of
achieving a data file with the characteristics in Hadley's quote above.

We will merge like data sets, assign descriptive column names, assign 
descriptive names to numeric code values, and bring all this together into
a single table, and finally group and summarize this large table into a
smaller and more relevant table.

In our project the data in the files represents the following:
Subjects (1:30) who perform Activities (1:6) that are Measured/Recorded (1:561) 
as many different type of variables, but still grouped within certain 
measurement types and recording sources (e.g. Triaxial acceleration from the 
accelerometer and estimated body acceleration from the gyroscope). 

### The Goal

An independent tidy data set with the average (mean) of

 - each variable (smartphone measurements as means or std)
 - for each activity (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
 - for each subject (anonymous userid, i.e. 1, 2, 3, ..., 30)

### The raw data files used in this analysis

The followinmg unzipped raw data files are used in my analysis and include
the row & col counts (dim) for each of the selected and unzipped data files:

- features.txt           (561 x   2) 
- X_train.txt           (7352 x 561) 
- X_test.txt            (2947 x 561) 
- subject_train.txt     (7352 x   1) 
- subject_test.txt      (2947 x   1) 
- Y_train.txt           (7532 x   1) 
- Y_test.txt            (2947 x   1)
- activity_labels.txt      (6 x   2)

### Start of the processing steps in the run_analysis.R script


```
## 
## Attaching package: 'dplyr'
## 
## The following object is masked from 'package:stats':
## 
##     filter
## 
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

### Read each file into R and give a descriptive file name

### The test files

```r
setwd("~/Data")    
testactivities <- read.table("y_test.txt", header = FALSE, sep = "", strip.white = TRUE)
str(testactivities, list.len = 10)
```

```
## 'data.frame':	2947 obs. of  1 variable:
##  $ V1: int  5 5 5 5 5 5 5 5 5 5 ...
```

```r
testset <- read.table("X_test.txt", header = FALSE, sep = "", strip.white = TRUE)
str(testset, list.len = 10)
```

```
## 'data.frame':	2947 obs. of  561 variables:
##  $ V1  : num  0.257 0.286 0.275 0.27 0.275 ...
##  $ V2  : num  -0.0233 -0.0132 -0.0261 -0.0326 -0.0278 ...
##  $ V3  : num  -0.0147 -0.1191 -0.1182 -0.1175 -0.1295 ...
##  $ V4  : num  -0.938 -0.975 -0.994 -0.995 -0.994 ...
##  $ V5  : num  -0.92 -0.967 -0.97 -0.973 -0.967 ...
##  $ V6  : num  -0.668 -0.945 -0.963 -0.967 -0.978 ...
##  $ V7  : num  -0.953 -0.987 -0.994 -0.995 -0.994 ...
##  $ V8  : num  -0.925 -0.968 -0.971 -0.974 -0.966 ...
##  $ V9  : num  -0.674 -0.946 -0.963 -0.969 -0.977 ...
##  $ V10 : num  -0.894 -0.894 -0.939 -0.939 -0.939 ...
##   [list output truncated]
```

```r
testsubject <- read.table("subject_test.txt", header = FALSE, sep = "", strip.white = TRUE)
str(testsubject, list.len = 10)
```

```
## 'data.frame':	2947 obs. of  1 variable:
##  $ V1: int  2 2 2 2 2 2 2 2 2 2 ...
```

### The training files

```r
trainingactivities <- read.table("y_train.txt", header = FALSE, sep = "", strip.white = TRUE)
str(trainingactivities, list.len = 10)
```

```
## 'data.frame':	7352 obs. of  1 variable:
##  $ V1: int  5 5 5 5 5 5 5 5 5 5 ...
```

```r
trainingset <- read.table("X_train.txt", header = FALSE, sep = "", strip.white = TRUE)
str(trainingset, list.len = 10)
```

```
## 'data.frame':	7352 obs. of  561 variables:
##  $ V1  : num  0.289 0.278 0.28 0.279 0.277 ...
##  $ V2  : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
##  $ V3  : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
##  $ V4  : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
##  $ V5  : num  -0.983 -0.975 -0.967 -0.983 -0.981 ...
##  $ V6  : num  -0.914 -0.96 -0.979 -0.991 -0.99 ...
##  $ V7  : num  -0.995 -0.999 -0.997 -0.997 -0.998 ...
##  $ V8  : num  -0.983 -0.975 -0.964 -0.983 -0.98 ...
##  $ V9  : num  -0.924 -0.958 -0.977 -0.989 -0.99 ...
##  $ V10 : num  -0.935 -0.943 -0.939 -0.939 -0.942 ...
##   [list output truncated]
```

```r
trainingsubject <- read.table("subject_train.txt", header = FALSE, sep = "", strip.white = TRUE)
str(trainingsubject, list.len = 10)
```

```
## 'data.frame':	7352 obs. of  1 variable:
##  $ V1: int  1 1 1 1 1 1 1 1 1 1 ...
```

### The features and activity names files

```r
features <- read.table("features.txt", 
                header = FALSE, sep = "", strip.white = TRUE)
str(features, list.len = 10)
```

```
## 'data.frame':	561 obs. of  2 variables:
##  $ V1: int  1 2 3 4 5 6 7 8 9 10 ...
##  $ V2: Factor w/ 477 levels "angle(tBodyAccJerkMean),gravityMean)",..: 243 244 245 250 251 252 237 238 239 240 ...
```

```r
activitynames <- read.table("activity_labels.txt", 
                header = FALSE, sep = "", strip.white = TRUE)
str(activitynames, list.len = 10)
```

```
## 'data.frame':	6 obs. of  2 variables:
##  $ V1: int  1 2 3 4 5 6
##  $ V2: Factor w/ 6 levels "LAYING","SITTING",..: 4 6 5 2 3 1
```

### Make the file col names descriptive and change factors to chars

```r
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
```

### Bind/add the subject ids to each of the respective train & test data sets

```r
trainingset <- cbind(trainingsubject, trainingset)
str(trainingset, list.len = 10)
```

```
## 'data.frame':	7352 obs. of  562 variables:
##  $ subject                             : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ tBodyAcc-mean()-X                   : num  0.289 0.278 0.28 0.279 0.277 ...
##  $ tBodyAcc-mean()-Y                   : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
##  $ tBodyAcc-mean()-Z                   : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
##  $ tBodyAcc-std()-X                    : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
##  $ tBodyAcc-std()-Y                    : num  -0.983 -0.975 -0.967 -0.983 -0.981 ...
##  $ tBodyAcc-std()-Z                    : num  -0.914 -0.96 -0.979 -0.991 -0.99 ...
##  $ tBodyAcc-mad()-X                    : num  -0.995 -0.999 -0.997 -0.997 -0.998 ...
##  $ tBodyAcc-mad()-Y                    : num  -0.983 -0.975 -0.964 -0.983 -0.98 ...
##  $ tBodyAcc-mad()-Z                    : num  -0.924 -0.958 -0.977 -0.989 -0.99 ...
##   [list output truncated]
```

```r
testset <- cbind(testsubject, testset)
str(testset, list.len = 10)
```

```
## 'data.frame':	2947 obs. of  562 variables:
##  $ subject                             : int  2 2 2 2 2 2 2 2 2 2 ...
##  $ tBodyAcc-mean()-X                   : num  0.257 0.286 0.275 0.27 0.275 ...
##  $ tBodyAcc-mean()-Y                   : num  -0.0233 -0.0132 -0.0261 -0.0326 -0.0278 ...
##  $ tBodyAcc-mean()-Z                   : num  -0.0147 -0.1191 -0.1182 -0.1175 -0.1295 ...
##  $ tBodyAcc-std()-X                    : num  -0.938 -0.975 -0.994 -0.995 -0.994 ...
##  $ tBodyAcc-std()-Y                    : num  -0.92 -0.967 -0.97 -0.973 -0.967 ...
##  $ tBodyAcc-std()-Z                    : num  -0.668 -0.945 -0.963 -0.967 -0.978 ...
##  $ tBodyAcc-mad()-X                    : num  -0.953 -0.987 -0.994 -0.995 -0.994 ...
##  $ tBodyAcc-mad()-Y                    : num  -0.925 -0.968 -0.971 -0.974 -0.966 ...
##  $ tBodyAcc-mad()-Z                    : num  -0.674 -0.946 -0.963 -0.969 -0.977 ...
##   [list output truncated]
```

### Bind/add the activity type codes ids to each of the  train & test data sets

```r
trainingset <- cbind(trainingactivities, trainingset)
str(trainingset, list.len = 10)
```

```
## 'data.frame':	7352 obs. of  563 variables:
##  $ activity                            : int  5 5 5 5 5 5 5 5 5 5 ...
##  $ subject                             : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ tBodyAcc-mean()-X                   : num  0.289 0.278 0.28 0.279 0.277 ...
##  $ tBodyAcc-mean()-Y                   : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
##  $ tBodyAcc-mean()-Z                   : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
##  $ tBodyAcc-std()-X                    : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
##  $ tBodyAcc-std()-Y                    : num  -0.983 -0.975 -0.967 -0.983 -0.981 ...
##  $ tBodyAcc-std()-Z                    : num  -0.914 -0.96 -0.979 -0.991 -0.99 ...
##  $ tBodyAcc-mad()-X                    : num  -0.995 -0.999 -0.997 -0.997 -0.998 ...
##  $ tBodyAcc-mad()-Y                    : num  -0.983 -0.975 -0.964 -0.983 -0.98 ...
##   [list output truncated]
```

```r
testset <- cbind(testactivities, testset)
str(testset, list.len = 10)
```

```
## 'data.frame':	2947 obs. of  563 variables:
##  $ activity                            : int  5 5 5 5 5 5 5 5 5 5 ...
##  $ subject                             : int  2 2 2 2 2 2 2 2 2 2 ...
##  $ tBodyAcc-mean()-X                   : num  0.257 0.286 0.275 0.27 0.275 ...
##  $ tBodyAcc-mean()-Y                   : num  -0.0233 -0.0132 -0.0261 -0.0326 -0.0278 ...
##  $ tBodyAcc-mean()-Z                   : num  -0.0147 -0.1191 -0.1182 -0.1175 -0.1295 ...
##  $ tBodyAcc-std()-X                    : num  -0.938 -0.975 -0.994 -0.995 -0.994 ...
##  $ tBodyAcc-std()-Y                    : num  -0.92 -0.967 -0.97 -0.973 -0.967 ...
##  $ tBodyAcc-std()-Z                    : num  -0.668 -0.945 -0.963 -0.967 -0.978 ...
##  $ tBodyAcc-mad()-X                    : num  -0.953 -0.987 -0.994 -0.995 -0.994 ...
##  $ tBodyAcc-mad()-Y                    : num  -0.925 -0.968 -0.971 -0.974 -0.966 ...
##   [list output truncated]
```

### Bind the two data tables together by row (they share the same col names)

```r
mergedset <- rbind(trainingset, testset)
str(mergedset, list.len = 10)
```

```
## 'data.frame':	10299 obs. of  563 variables:
##  $ activity                            : int  5 5 5 5 5 5 5 5 5 5 ...
##  $ subject                             : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ tBodyAcc-mean()-X                   : num  0.289 0.278 0.28 0.279 0.277 ...
##  $ tBodyAcc-mean()-Y                   : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
##  $ tBodyAcc-mean()-Z                   : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
##  $ tBodyAcc-std()-X                    : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
##  $ tBodyAcc-std()-Y                    : num  -0.983 -0.975 -0.967 -0.983 -0.981 ...
##  $ tBodyAcc-std()-Z                    : num  -0.914 -0.96 -0.979 -0.991 -0.99 ...
##  $ tBodyAcc-mad()-X                    : num  -0.995 -0.999 -0.997 -0.997 -0.998 ...
##  $ tBodyAcc-mad()-Y                    : num  -0.983 -0.975 -0.964 -0.983 -0.98 ...
##   [list output truncated]
```

### Substitute/replace the activity codes with their descriptive names

```r
mergedset$activity[mergedset$activity == 1] <- "WALKING"       
mergedset$activity[mergedset$activity == 2] <- "WALKING_UPSTAIRS"
mergedset$activity[mergedset$activity == 3] <- "WALKING_DOWNSTAIRS"
mergedset$activity[mergedset$activity == 4] <- "SITTING"
mergedset$activity[mergedset$activity == 5] <- "STANDING"
mergedset$activity[mergedset$activity == 6] <- "LAYING"
str(mergedset, list.len = 10)
```

```
## 'data.frame':	10299 obs. of  563 variables:
##  $ activity                            : chr  "STANDING" "STANDING" "STANDING" "STANDING" ...
##  $ subject                             : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ tBodyAcc-mean()-X                   : num  0.289 0.278 0.28 0.279 0.277 ...
##  $ tBodyAcc-mean()-Y                   : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
##  $ tBodyAcc-mean()-Z                   : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
##  $ tBodyAcc-std()-X                    : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
##  $ tBodyAcc-std()-Y                    : num  -0.983 -0.975 -0.967 -0.983 -0.981 ...
##  $ tBodyAcc-std()-Z                    : num  -0.914 -0.96 -0.979 -0.991 -0.99 ...
##  $ tBodyAcc-mad()-X                    : num  -0.995 -0.999 -0.997 -0.997 -0.998 ...
##  $ tBodyAcc-mad()-Y                    : num  -0.983 -0.975 -0.964 -0.983 -0.98 ...
##   [list output truncated]
```

### Extract the column variables of interest (values for "mean" or "std") 

### Find the cols that are mean related

```r
meanfeaturesindex <- grep("mean", features)
meanfeatures <- features[meanfeaturesindex]
str(meanfeatures, list.len = 10)
```

```
##  chr [1:46] "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" ...
```

### Find the cols that are std related

```r
stdfeaturesindex <- grep("std", features)
stdfeatures <- features[stdfeaturesindex]
str(stdfeatures, list.len = 10)
```

```
##  chr [1:33] "tBodyAcc-std()-X" "tBodyAcc-std()-Y" ...
```

### Combine the vectors holding the cols names of interest

```r
meanstdfeatureset <- c(meanfeatures, stdfeatures)
str(meanstdfeatureset, list.len = 10)
```

```
##  chr [1:79] "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" ...
```

### Keep the activity label col and subject id col 

```r
meanstdfeatureset <- c("activity", "subject", meanstdfeatureset)
str(meanstdfeatureset, list.len = 10)
```

```
##  chr [1:81] "activity" "subject" "tBodyAcc-mean()-X" ...
```

### Select a subset (subject, activity, stds, means)

```r
submergedset <- subset(mergedset, select = meanstdfeatureset)
str(submergedset, list.len = 10)
```

```
## 'data.frame':	10299 obs. of  81 variables:
##  $ activity                       : chr  "STANDING" "STANDING" "STANDING" "STANDING" ...
##  $ subject                        : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ tBodyAcc-mean()-X              : num  0.289 0.278 0.28 0.279 0.277 ...
##  $ tBodyAcc-mean()-Y              : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
##  $ tBodyAcc-mean()-Z              : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
##  $ tGravityAcc-mean()-X           : num  0.963 0.967 0.967 0.968 0.968 ...
##  $ tGravityAcc-mean()-Y           : num  -0.141 -0.142 -0.142 -0.144 -0.149 ...
##  $ tGravityAcc-mean()-Z           : num  0.1154 0.1094 0.1019 0.0999 0.0945 ...
##  $ tBodyAccJerk-mean()-X          : num  0.078 0.074 0.0736 0.0773 0.0734 ...
##  $ tBodyAccJerk-mean()-Y          : num  0.005 0.00577 0.0031 0.02006 0.01912 ...
##   [list output truncated]
```

### Create the "tidy" data set, by activity, subject and  mean of each feature
 
"The group_by() function takes an existing tbl and converts it into a grouped tbl where operations are performed "by group"

"The summarize_each() function will apply one or more functions to one or more columns. Grouping variables are always excluded from modification"


```r
tidydata <-  
        submergedset %>%
        group_by(subject, activity) %>%
        summarise_each(funs(mean))
```

### Write out the table to a file, without row names

```r
write.table(tidydata, file = "tidydata.txt", row.name = FALSE)
str(tidydata, list.len = 10)
```

```
## Classes 'grouped_df', 'tbl_df', 'tbl' and 'data.frame':	180 obs. of  81 variables:
##  $ subject                        : int  1 1 1 1 1 1 2 2 2 2 ...
##  $ activity                       : chr  "LAYING" "SITTING" "STANDING" "WALKING" ...
##  $ tBodyAcc-mean()-X              : num  0.222 0.261 0.279 0.277 0.289 ...
##  $ tBodyAcc-mean()-Y              : num  -0.04051 -0.00131 -0.01614 -0.01738 -0.00992 ...
##  $ tBodyAcc-mean()-Z              : num  -0.113 -0.105 -0.111 -0.111 -0.108 ...
##  $ tGravityAcc-mean()-X           : num  -0.249 0.832 0.943 0.935 0.932 ...
##  $ tGravityAcc-mean()-Y           : num  0.706 0.204 -0.273 -0.282 -0.267 ...
##  $ tGravityAcc-mean()-Z           : num  0.4458 0.332 0.0135 -0.0681 -0.0621 ...
##  $ tBodyAccJerk-mean()-X          : num  0.0811 0.0775 0.0754 0.074 0.0542 ...
##  $ tBodyAccJerk-mean()-Y          : num  0.003838 -0.000619 0.007976 0.028272 0.02965 ...
##   [list output truncated]
##  - attr(*, "vars")=List of 1
##   ..$ : symbol subject
##  - attr(*, "drop")= logi TRUE
```

### As an integrity test, read the tidydata file back into R

```r
tidydataIn <- read.table("tidydata.txt", stringsAsFactors = FALSE, header = TRUE)
str(tidydataIn, list.len = 10)
```

```
## 'data.frame':	180 obs. of  81 variables:
##  $ subject                        : int  1 1 1 1 1 1 2 2 2 2 ...
##  $ activity                       : chr  "LAYING" "SITTING" "STANDING" "WALKING" ...
##  $ tBodyAcc.mean...X              : num  0.222 0.261 0.279 0.277 0.289 ...
##  $ tBodyAcc.mean...Y              : num  -0.04051 -0.00131 -0.01614 -0.01738 -0.00992 ...
##  $ tBodyAcc.mean...Z              : num  -0.113 -0.105 -0.111 -0.111 -0.108 ...
##  $ tGravityAcc.mean...X           : num  -0.249 0.832 0.943 0.935 0.932 ...
##  $ tGravityAcc.mean...Y           : num  0.706 0.204 -0.273 -0.282 -0.267 ...
##  $ tGravityAcc.mean...Z           : num  0.4458 0.332 0.0135 -0.0681 -0.0621 ...
##  $ tBodyAccJerk.mean...X          : num  0.0811 0.0775 0.0754 0.074 0.0542 ...
##  $ tBodyAccJerk.mean...Y          : num  0.003838 -0.000619 0.007976 0.028272 0.02965 ...
##   [list output truncated]
```

### End of source code for run_analysis.R 


### The readme.txt file from the original researchers

Human Activity Recognition Using Smartphones Dataset
Version 1.0
 
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Universit‡ degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The dataset includes the following files:

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

Notes: 
 
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

For more information about this dataset contact: activityrecognition@smartlab.ws

License:
 
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.

### End of the readme.txt file from the original researchers







