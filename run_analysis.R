library(dplyr)

#read resource data

#train data
traineX <- read.table("./UCI HAR Dataset/train/X_train.txt")
traineY <- read.table("./UCI HAR Dataset/train/Y_train.txt")
subjectTrain<- read.table("./UCI HAR Dataset/train/subject_train.txt")

#test data
testX <- read.table("./UCI HAR Dataset/test/X_test.txt")
testY <- read.table("./UCI HAR Dataset/test/Y_test.txt")
subjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt")

#data description
var_names<- read.table("./UCI HAR Dataset/features.txt")

#activity labels
act_labels<- read.table("./UCI HAR Dataset/activity_labels.txt")

#1- merging the test and train data
mergedX<- rbind(traineX, testX)
mergedY<- rbind(traineY, testY)
mergedSub<- rbind(subjectTrain, subjectTest)

#2- Extracts only the measurements on the mean and standard deviation for each measurement.

refineData<- var_names[grep("mean\\(\\) | std\\(\\)", var_names[,2]),]
mergedX <- mergedX[,refineData[,1]]

#3- use descriptive activity name in the data set
colnames(mergedY) <- "activity"
mergedY$activitylabel <- factor(mergedY$activity, labels = as.character(act_labels[,2]))
activitylabel<- mergedY[,-1]

#4- Appropriately labels the data set with descriptive variable names
colnames(mergedX)<- var_names[refineData[,1],2]

#5- using the dataset int step 4, create a second, independent
#tidy data set with theaverage of each variable for each activity and each subject
colnames(mergedSub)<- "subject"
total<- cbind(mergedX, activitylabel, mergedSub)
totalMean<- total %>% group_by(activitylabel, subject)%>% summarize_each(list(~mean))
write.table(totalMean, file = "./UCI HAR Dataset/tidydata.txt", row.names = F, col.names = T)
