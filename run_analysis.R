# Getting and cleaning data, Course Project
# March 4 2017
# A. P. Ellis

#This script will perform the following steps on the UCI HAR Dataset downloaded from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

# set working directory
setwd('/Users/apellis/Desktop/Coursera/Cleaning_data');

# Get file from link
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipfile <- "getdata.zip"
# download file
download.file(fileURL, zipfile, method="curl")
# Unzip file, this downloads directory "UCI HAR Dataset" that contains multiple files
dataset <- unzip(zipfile)

# Import files and create data table for each
features      = read.table('./features.txt', header=FALSE)
activityType  = read.table('./activity_labels.txt', header=FALSE)
subjectTrain  = read.table('./train/subject_train.txt', header=FALSE)
xTrain        = read.table('./train/x_train.txt',header=FALSE)
yTrain        = read.table('./train/y_train.txt',header=FALSE)
# Read in the test data
subjectTest = read.table('./test/subject_test.txt',header=FALSE) 
xTest       = read.table('./test/x_test.txt',header=FALSE) 
yTest       = read.table('./test/y_test.txt',header=FALSE) 

# names(feature)
#?rbind

# Step 1 of project: Merge the training and test data to create one table

# reassign column names to some columns in the data tables above for clarity when combining
colnames(activityType)  = c('activityId','activityType');
colnames(subjectTrain)  = "subjectId";
colnames(xTrain)        = features[,2]; 
colnames(yTrain)        = "activityId";
colnames(subjectTest) = "subjectId";
colnames(xTest)       = features[,2]; 
colnames(yTest)       = "activityId"


# Binding sensor data
trainData <- cbind(cbind(xTrain, subjectTrain), yTrain)
testData <- cbind(cbind(xTest, subjectTest), yTest)
sensorData <- rbind(trainData, testData)

# 2. Extract only the measurements on the mean and standard deviation for each measurement. 

colNames <- names(sensorData)

# Create a logicalVector that contains TRUE values for the ID, mean() & stddev() columns and FALSE for others
logicalVector <- (grepl("activity..",colNames) | grepl("subject..",colNames) | grepl("-mean..",colNames) & !grepl("-meanFreq..",colNames) & !grepl("mean..-",colNames) | grepl("-std..",colNames) & !grepl("-std()..-",colNames));

# Subset sensorData table based on the logicalVector to keep only desired columns
finalData <- sensorData[logicalVector==TRUE];

# 3. Use descriptive activity names to name the activities in the data set

# Merge the finalData set with the acitivityType table to include descriptive activity names
finalData <- merge(finalData,activityType,by='activityId',all.x=TRUE);

# Updating the colNames vector to include the new column names after merge
colNames <- colnames(finalData)

# Cleaning up variable names, remainming data set columns with descriptive names
#Remove praentheses
names(finalData) <- gsub('\\(|\\)',"",names(finalData), perl = TRUE)
names(finalData) <- gsub('Acc',"Acceleration",names(finalData))
names(finalData) <- gsub('GyroJerk',"AngularAcceleration",names(finalData))
names(finalData) <- gsub('Gyro',"AngularSpeed",names(finalData))
names(finalData) <- gsub('Mag',"Magnitude",names(finalData))
names(finalData) <- gsub('^t',"TimeDomain.",names(finalData))
names(finalData) <- gsub('^f',"FrequencyDomain.",names(finalData))
names(finalData) <- gsub('-mean',".Mean",names(finalData))
names(finalData) <- gsub('-std',".StandardDeviation",names(finalData))
names(finalData) <- gsub('Freq\\.',"Frequency.",names(finalData))
names(finalData) <- gsub('Freq$',"Frequency",names(finalData))

# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 
# Create a new table, finalDataNoActivityType without the activityType column
finalDataNoActivityType <- finalData[,names(finalData) != 'activityType.x']
finalDataNoActivityType <- finalDataNoActivityType[,names(finalDataNoActivityType) != 'activityType.y']

# Summarizing the finalDataNoActivityType table to include just the mean of each variable for each activity and each subject
tidyData <- aggregate(finalDataNoActivityType[,names(finalDataNoActivityType) != c('activityId','subjectId')],by=list(activityId=finalDataNoActivityType$activityId,subjectId = finalDataNoActivityType$subjectId),mean);

# Merging the tidyData with activityType to include descriptive acitvity names
tidyData <- merge(tidyData,activityType,by='activityId',all.x=TRUE);

# Export the tidyData set 
write.table(tidyData, './tidyData.txt',row.names=TRUE,sep='\t')




