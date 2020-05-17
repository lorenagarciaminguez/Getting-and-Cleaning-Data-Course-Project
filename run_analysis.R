##First of all, open (create a directory) and unzip data
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")
unzip(zipfile="./data/Dataset.zip",exdir="./data")
##See the files unzipped
listado <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(listado, recursive=TRUE)
files
##Read the data
atrain <- read.table(file.path(listado, "train", "Y_train.txt"))
str(atrain)
atest  <- read.table(file.path(listado, "test" , "Y_test.txt" ))
str(atest)
strain <- read.table(file.path(listado, "train", "subject_train.txt"))
str(strain)
stest  <- read.table(file.path(listado, "test" , "subject_test.txt"))
str(stest)
ftrain <- read.table(file.path(listado, "train", "X_train.txt"))
str(ftrain)
ftest  <- read.table(file.path(listado, "test" , "X_test.txt" ))
str(ftest)
##Merges the training and the test sets to create one data set.
activity <- rbind(atest, atrain)
str(activity)
subject <- rbind(stest, strain)
str(subject)
features <- rbind(ftest, ftrain)
str(features) 
##In str funcion we can see that the number of obs. is the sum of train and test.
##New names to the variables
names(activity)<- c("activity")
head(activity)
names(subject)<-c("subject")
head(subject)
featuresnames <- read.table(file.path(listado, "features.txt"),head=FALSE)
names(features)<- featuresnames$V2
head(features)
datacomb <- cbind(subject, activity)
datacomb <- cbind(datacomb, features)
str(datacomb)
##Extracts only the measurements on the mean and standard deviation for each measurement.
meansd1<-featuresnames$V2[grep("mean\\(\\)|std\\(\\)", featuresnames$V2)]
meansd2 <- c("subject", "activity", as.character(meansd1))
meansd <- subset(datacomb, select=meansd2)
str(meansd)
##Uses descriptive activity names to name the activities in the data set
activitylabels <- read.table(file.path(listado, "activity_labels.txt"))
summary(activitylabels)
names(meansd)
names(meansd)<-gsub("^t", "tiempo", names(meansd))
names(meansd)<-gsub("^f", "frecuencia", names(meansd))
names(meansd)<-gsub("Acc", "Acelerar", names(meansd))
names(meansd)<-gsub("Gyro", "Giro", names(meansd))
names(meansd)<-gsub("Mag", "Magnitud", names(meansd))
names(meansd)<-gsub("BodyBody", "Cuerpo", names(meansd))
names(meansd)
##New tidy data set
tidydata<-aggregate(. ~subject + activity, meansd, mean)
newtidydata<-tidydata[order(tidydata$subject,tidydata$activity),]
write.table(newtidydata, file = "tidydata.txt",row.name=FALSE)
