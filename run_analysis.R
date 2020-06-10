library(dplyr)


TrainX <- read.table("./UCI HAR Dataset/train/X_train.txt")
TrainY <- read.table("./UCI HAR Dataset/train/Y_train.txt")
Sub_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
TestX <- read.table("./UCI HAR Dataset/test/X_test.txt")
TestY <- read.table("./UCI HAR Dataset/test/Y_test.txt")
Sub_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
varNames <- read.table("./UCI HAR Dataset/features.txt")
actLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")

mergedX <- rbind(TrainX, TestX)
mergedY <- rbind(TrainY, TestY)
Sub_total <- rbind(Sub_train, Sub_test)

selectVar <- varNames[grep("mean\\(\\)|std\\(\\)",varNames[,2]),]
mergedX <- mergedX[,selectVar[,1]]

colnames(mergedY) <- "activity"
mergedY$activitylabel <- factor(mergedY$activity, labels = as.character(actLabels[,2]))
activitylabel <- mergedY[,-1]

colnames(mergedX) <- varNames[selectVar[,1],2]

colnames(Sub_total) <- "subject"
total <- cbind(mergedX, activitylabel, Sub_total)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./UCI HAR Dataset/finalData.txt", row.names = FALSE, col.names = TRUE)