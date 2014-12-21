# README
Bill Nadal  
December 20, 2014  
- README for the project in Coursera's "Getting and Cleaning Data"
- In support of the run_analysis.R script 
- Script, data, codebook & readme are in the github wtnadal/GCDProject repo
- Course date is Dec 1 - Dec 21 (2014)
- Instructors are Jeff Leek, PhD, Roger D. Peng, PhD, Brian Caffo, PhD

Follow these steps to 

- setup the working directory
- download the raw data 
- unzip the raw data into the files to process
- execute script
- produce a compact grouped and summarized analytic file

Note, these instructions are for an Apple iOS or Linux shell.
Adapt as necessary for a Windows based OS (e.g. Windows 8, Vista)

### Create the directory

Start a bash terminal session, enter these commands at the prompt

- $ cd ~
- $ mkdir Data
- $ cd Data

### Download the analysis data

Right click on and save this URL to your newly created /Data directory

- https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

or

copy and paste this cmd at your cmd prompt

- $ curl --url https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


### Unzip the downloaded file

- iOS users can double click on the file and it should automatically unzip

or

- use the appropriate unzip utility for your OS


### Copy all the necessary files to ~/Data

Enter the following commands in your terminal session prompt

- $ cp ~/Data/"UCI HAR Dataset"/*.txt ~/Data
- $ cp ~/Data/"UCI HAR Dataset"/train/*.txt ~/Data
- $ cp ~/"Data/UCI HAR Dataset"/test/*.txt ~/Data
- $ cd ~/Data
- $ ls

You should see the following files in your ~/Data directory
       				
- activity_labels.txt
- features.txt        				
- features_info.txt
- getdata-projectfiles-UCI HAR Dataset.zip
- README.txt 
- UCI HAR Dataset        				
- subject_test.txt
- subject_train.txt
- X_test.txt
- X_train.txt        				
- y_test.txt
- y_train.txt

### Download and run the R script

Copy/save the run_analysis.R file from the github repository to ~/Data

- https://github.com/wtnadal/GCDProject


If you have R Studio installed, you can open and run the run_analysis.R script.


If you have R installed, you can also run the script in BATCH mode


To execute/Run the run_analysis.R script from the cmd prompt

- $ R CMD BATCH ~/Data/run_analysis.R

Depending on your computer's processor speed and the amount of memory, 
this script could take between 15 seconds and several minutes to run.

When the cmd prompt $ returns, the script has finished.

Enter these cmds at the prompt

- $ cd ~/Data
- $ ls

...and you should see several new files, but the one we're interested in is

- tidydata.txt

and it should be about 158KB in size


The "tidaydata.txt" file contains the summarized analysis we're interested in.


It is an independent tidy data set with the average (mean) of

 - each variable (smartphone measurements as means or std)
 - for each activity (WALKING, SITTING, STANDING, ...)
 - for each subject (anonymous userid, i.e. 1, 2, 3, ...)


Good Luck with your data wrangling!

"May you live in times of interesting data" - Bill Nadal
