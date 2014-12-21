
# Getting and Cleaning Data Course project
# Alok Jadhav
# 07/12/2014

## Data loading
# set path
#setwd("S:\\Online_courses\\DataScience_Specialization\\3_Getting_and_cleaning_data\\project\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset")

##########################################################################################
##1 Merges the training and the test sets to create one data set.
train.data <- read.table("train/X_train.txt")
train.label <- read.table("train/y_train.txt")
train.subject <- read.table("train/subject_train.txt")

test.data <- read.table("test/X_test.txt")
test.label <- read.table("test/y_test.txt") 
test.subject <- read.table("test/subject_test.txt")

m.data <- rbind(train.data, test.data)
m.label <- rbind(train.label, test.label)
m.subject <- rbind(train.subject, test.subject)

##########################################################################################
# 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
features <- read.table("features.txt")
mean.std.i <- grep("mean\\(\\)|std\\(\\)",features$V2)
m.data <- m.data[, mean.std.i] # since index and V1 values are same we can use index as it is
names(m.data) <- gsub("\\(\\)|-", "", features[mean.std.i, 2]) # remove "()"

##########################################################################################
# 3.Uses descriptive activity names to name the activities in the data set
act <- read.table("activity_labels.txt")
act.label <- act[m.label$V1, 2]
m.label[, 1] <- act.label
names(m.label) <- "activity"

##########################################################################################
# 4.Appropriately labels the data set with descriptive variable names. 
names(m.subject) <- "subject"
final.data <- cbind(m.subject, m.label, m.data)
dim(cleanedData) # 10299*68
write.table(cleanedData, "merged_data.txt") # write out the 1st dataset

##########################################################################################
# 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(reshape)
data.m <- melt(final.data,id=c("subject","activity"))
result <- cast(data.m, subject+activity ~ variable, mean)
write.table(result, "final_result.txt",row.name=FALSE) # write out the 2nd dataset
##########################################################################################
