###Getting and Cleaning Data Course Project

## Directory and filename of the tidy data
tidyDataFile <- "Tidy - UCI HAR Dataset.txt"

## Directory and filename of the AVG tidy data
tidyDataFileAVG <- "Tidy - UCI HAR Dataset - AVG.txt"

## 1. Merges the training and the test sets to create one data set
#Read train data sets
x_train <- read.table("./train/X_train.txt", header = FALSE)
y_train <- read.table("./train/y_train.txt", header = FALSE)

#Read test data sets
X_test <- read.table("./test/X_test.txt", header = FALSE)
y_test <- read.table("./test/y_test.txt", header = FALSE)

#Read subject data tests
subject_train <- read.table("./train/subject_train.txt", header = FALSE)
subject_test <- read.table("./test/subject_test.txt", header = FALSE)

# Combines each train and test data table by rows
x <- rbind(x_train, X_test)
y <- rbind(y_train, y_test)
s <- rbind(subject_train, subject_test)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement:
# Read features labels
features <- read.table("./features.txt")

# Appropriate names to features column
names(features) <- c('feature_id', 'feature_name')

# Search for matches to argument mean or standard deviation (sd) within each element of character vector
index_features <- grep("-mean\\(\\)|-std\\(\\)", features$feature_name) 
x <- x[, index_features] 

# Replaces all matches of a string features 
names(x) <- gsub("\\(|\\)", "", (features[index_features, 2]))

## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names
# Read activity labels
activities <- read.table("./activity_labels.txt")

# Appropriate names to activities column
names(activities) <- c('activity_id', 'activity_name')
y[, 1] = activities[y[, 1], 2]

names(y) <- "Activity"
names(s) <- "Subject"

# Combines data table by columns
tidyDataSet <- cbind(s, y, x)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
t <- tidyDataSet[, 3:dim(tidyDataSet)[2]] 
tidyDataSetAVG <- aggregate(t,list(tidyDataSet$Subject, tidyDataSet$Activity), mean)

# Activity and Subject name of columns 
names(tidyDataSetAVG)[1] <- "Subject"
names(tidyDataSetAVG)[2] <- "Activity"

# Create tidy data set in diretory
write.table(tidyDataSet, tidyDataFile, row.name=FALSE)

# Create AVG tidy data set in diretory
write.table(tidyDataSetAVG, tidyDataFileAVG, row.name=FALSE)
