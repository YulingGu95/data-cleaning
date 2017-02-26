## get the working directory 
setwd("C:/Users/betty/Desktop/coursera/data-cleaning/week-4")

##download the dataset from the url and unzip it
##load label_names.txt
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
activityLabelsnames <- as.character(activityLabels[,2])

##load features.txt
features <- read.table("./UCI HAR Dataset/features.txt")
allfeatures <- as.character(features[,2])

##Extract the measurements on the mean and standard deviation
featuresid <- grep(".*mean.*|.*std.*",allfeatures)
featuresneedednames <- grep(".*mean.*|.*std.*",allfeatures, value = TRUE)
featuresneedednames = gsub('-mean','mean',featuresneedednames)
featuresneedednames = gsub('-std','std', featuresneedednames)
featuresneedednames <- gsub('[-()]','',featuresneedednames)

##Import the dataset for both train and test
trainset<- read.table("./UCI HAR Dataset/train/X_train.txt")[featuresid]
train_activity <- read.table("./UCI HAR Dataset/train/Y_train.txt")
trainsubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainsubject, train_activity, trainset)

testset <-read.table("./UCI HAR Dataset/test/X_test.txt")[featuresid]
test_activity <- read.table("./UCI HAR Dataset/test/Y_test.txt")
testsubject <-  read.table("./UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testsubject, test_activity, testset)

##merge datasets
alldata <- rbind(train, test)

## add labels 
colnames(alldata) <- c("subject", "activity", featuresneedednames)

##turn activity_labels & subject into factors
library(reshape2)
alldata$activity <- factor(alldata$activity, levels = activityLabels[,1], labels = activityLabelsnames)
alldata$subject <- as.factor(alldata$subject)

alldata_melted <- melt(alldata, id = c("subject", "activity"))
alldata_mean <-  dcast(alldata_melted, subject + activity ~ variable, mean)

##export table
write.table(alldata_mean, "tidy.txt", row.names = FALSE, quote = FALSE)
