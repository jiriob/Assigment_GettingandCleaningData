## load packages 
library(tidyr); library(dplyr)

## download raw data and Unzip
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" ,"data.zip")
unzip("data.zip")

## Assignment: Getting and Cleaning Data Course Project
# 1.Merges the training and the test sets to create one data set.
# 2.Extracts only the measurements on the mean and standard deviation for each measurement.
# 3.Uses descriptive activity names to name the activities in the data set
# 4.Appropriately labels the data set with descriptive variable names.
# 5.From the data set in step 4, creates a second, independent tidy data set with the 
#   average of each variable for each activity and each subject.

## 1.Merges the training and the test sets to create one data set
# merge subjects First Test then Train[test train]
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE)
train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE)
subject <- tbl_df(bind_rows(test_subject,train_subject)); rm(test_subject,train_subject) 
# Load and merge Activity label [test train]
test_Activity <- read.table("./UCI HAR Dataset/test/y_test.txt", sep = "", header = FALSE)
train_Activity <- read.table("./UCI HAR Dataset/train/y_train.txt", sep = "", header = FALSE)
Activity <- bind_rows(test_Activity,train_Activity); rm(test_Activity,train_Activity)
# Load and merge test and training, train set
test_training <- read.csv("./UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE)
train_training <- read.csv("./UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE)
training <- tbl_df(bind_rows(test_training,train_training)); rm(test_training,train_training)

## 2.Extracts the measurements on the mean and standard deviation for each measurement.
# extract the column names out of "features.txt" and put in to a data struct
feature_label <- tbl_df(read.csv("./UCI HAR Dataset/features.txt", sep = "", header = FALSE))
feature_label <- rename(feature_label, FeatureNumber = V1, FeatureName = V2 )
# selecting columns Numbers, or "FeatureNumber", consistinf of "mean()" and "std()"
columnNumber_MeanStd <-  grep("mean\\(\\)|std\\(\\)",feature_label$FeatureName) 
SelectedTrainingData <- select(training,num_range("V", columnNumber_MeanStd)); rm(training)

## 3.Uses descriptive activity names to name the activities in the data set
activity_label <- read.csv("./UCI HAR Dataset/features.txt", sep = "", header = FALSE)
Activity <- tbl_df(factor(Activity[[1]], labels = activity_label[,2]))
colnames(Activity) <- "FormOfActivity"

# 4.Appropriately labels the data set with descriptive variable names.
# rename columns 
# t should be Time, OR t = time, f should be Frequency
# furthermore, ACC = Accelerometer, Gyro = Gyroscope, mean()=Mean, std()=Std 
colName_label <- lapply(feature_label$FeatureName[columnNumber_MeanStd],toString)
colName_label <- gsub("'", "", colName_label); colName_label <- gsub("-", "", colName_label)
colName_label <- gsub("^t", "Time", colName_label); colName_label <- gsub("^f", "Frequency", colName_label)
colName_label <- gsub("Acc", "Accelerometer", colName_label); colName_label <- gsub("Gyro", "Gyroscope", colName_label)
colName_label <- gsub("mean\\(\\)", "Mean", colName_label); colName_label <- gsub("std\\(\\)", "StandardDeviation", colName_label)
# give all the columns the appropriate name 
colnames(SelectedTrainingData) <- colName_label

# name the subjects as character
subject  <- rename(subject, Subject = V1)
subjectId <- lapply(subject, as.character)

# merge all the data into one  
tidy_data1 <- bind_cols(subjectId, Activity, SelectedTrainingData)

## 5.From the data set in step 4, creates a second, independent tidy data set with the 
##   average of each variable for each activity and each subject.

# unite the columns Subject and FormOfActivity to create a grouping variable for each activity and each subject
merged_data1 <-  unite(tidy_data1,Subject_FormOfActivity,c(Subject,FormOfActivity))
# group_by then average by each group if it's numeric value
tidy_data2 <- merged_data1 %>% group_by(Subject_FormOfActivity) %>% summarise_if(is.numeric,funs(mean)) %>% arrange(Subject_FormOfActivity)

## save the tidy data in mean_data.Rdata
write.table(tidy_data1,file = "mean_data.txt", row.names = FALSE)
write.table(tidy_data2,file = "mean_grouped_data.txt", row.names = FALSE)
