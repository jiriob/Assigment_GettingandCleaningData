# CodeBook

## The main script `run_analysis`
The `run_analysis.R` consist of three global steps. Firstly, downloading the data and unzipping the files. Secondly, the tidying of the data and lastly, the saving of the two tidy data sets. 

### Input 
This zip file consist of the following data, which was used as input for the script. The variables of these data set are discribed in "/UCI HAR Dataset/features_info.txt" and the "/UCI HAR Dataset/README.txt" als within the zipfile. 
In the script this data is downloaded and unziped.  
* "./UCI HAR Dataset/activity_labels.txt"
* "./UCI HAR Dataset/features.txt"
* "./UCI HAR Dataset/test/subject_test.txt"
* "./UCI HAR Dataset/train/subject_train.txt"
* "./UCI HAR Dataset/test/y_test.txt"
* "./UCI HAR Dataset/train/y_train.txt"
* "./UCI HAR Dataset/test/X_test.txt"
* "./UCI HAR Dataset/train/X_train.txt"

### Cleaning the Data 
1. Merge and load the training and the test sets.
	* load subject data below then merge data (keep order test-train)
		* "./UCI HAR Dataset/test/subject_test.txt"
		* "./UCI HAR Dataset/train/subject_train.txt"
	* load Activity data below then merge data
		* "./UCI HAR Dataset/test/y_test.txt"
		* "./UCI HAR Dataset/train/y_train.txt"
	* load training data below then merge data
		* "./UCI HAR Dataset/test/X_test.txt"
		* "./UCI HAR Dataset/train/X_train.txt"
2. Extracts only the measurements on the mean and standard deviation for each measurement.
	* load "./UCI HAR Dataset/features.txt"
	* extract the column names out of "features.txt"
	* find the column numbers of the feature names consisting "mean()" and "std()".
	* Use the column numbers to select the  mean and standard deviation measurements. 
3. Set descriptive names to name the activities in the data set.
	* load labels out of "./UCI HAR Dataset/features.txt"
	* factorize labels and set as label 
	* rename column to "FormOfActivity"
4. Appropriately label the data set with descriptive variable names.
	* name all the column according to "features.txt" of the training data and select the correct collumns out of step 2
	* use `gsub` to change in the training data: t = Time, f = Frequency, Acc = Accelerometer, Gyro = Gyroscope, mean()=Mean, std()=Std   
	* bind all the Subjects, FormOfActivity and the training data
5. groups the data of each variable for each activity and each subject amd calculateds the average for each group.
	* `unite` Subjects, FormOfActivity to one variable with Subject_FormOfActivity
	* `group_by` united variable
	* `summarise` by mean all the numeric values for the grouped data

### output
The scripts saves two tidy datasets in a text format. 
* use `write_table` to save the tidy data
* the "mean_data.txt" is the tidy dataset of all the standard deviations and means of the measurement by subject and activity
* "mean_grouped_data.txt" is the grouped and avaraged data by subject and activity 

## tidy_data
* "mean_data.txt" is the data of all mean and standard deviation with the subjects number and the activity label
* "mean_grouped_data.txt" is the avarege of the mean and standard deviation per subjects and the activity 
