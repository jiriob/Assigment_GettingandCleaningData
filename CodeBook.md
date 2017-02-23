# CodeBook

## run_analysis.R

### Input 
This zip file consist of the following data, which was used as input for the script 
*"./UCI HAR Dataset/features.txt"
*"./UCI HAR Dataset/test/subject_test.txt"
*"./UCI HAR Dataset/train/subject_train.txt"
*"./UCI HAR Dataset/test/y_test.txt"
*"./UCI HAR Dataset/train/y_train.txt"
*"./UCI HAR Dataset/test/X_test.txt"
*"./UCI HAR Dataset/train/X_train.txt"

### Cleaning the Data 
1. Merge the training and the test sets
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. groups the data of each variable for each activity and each subject amd calculateds the average for each group.

### output
The scripts saves two tidy datasets in a text format. 
* the "mean_data.txt" is the tidy dataset of all the standard deviations and means of the measurement by subject and activity
* "mean_grouped_data.txt" is the grouped and avaraged data by subject and activity 