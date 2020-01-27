

###Set working directory
setwd("C:/Users/aemmert/Documents/Rstuff/getdata/UCI HAR Dataset")

###Read and initialize features
features<-read.table("C:/Users/aemmert/Documents/Rstuff/getdata/UCI HAR Dataset/features.txt")
features[1:100,]
ProcessNames<-function(InputString){
  WorkingString<-InputString
  WorkingString<-gsub("(","",WorkingString, fixed=T)
  WorkingString<-gsub(")","",WorkingString, fixed=T)
  WorkingString<-gsub(",","-",WorkingString, fixed=T)
  WorkingString
}
features$Name<-sapply(features$V2,FUN=ProcessNames)

###Read activity labels
activitylab<-read.table("C:/Users/aemmert/Documents/Rstuff/getdata/UCI HAR Dataset/activity_labels.txt")
colnames(activitylab)<-c("ID", "Activity")
trainsub<-read.table("C:/Users/aemmert/Documents/Rstuff/getdata/UCI HAR Dataset/train/subject_train.txt")
colnames(trainsub)[1]<-"ID"
trainsub<-merge(trainsub,activitylab,by="ID",all.x=T)
dim(trainsub)
testsub<-read.table("C:/Users/aemmert/Documents/Rstuff/getdata/UCI HAR Dataset/test/subject_test.txt")
colnames(testsub)[1]<-"ID"
testsub<-merge(testsub,activitylab,by="ID",all.x=T)
testsub[1,]


###Read train data and set column names
train<-read.table("C:/Users/aemmert/Documents/Rstuff/getdata/UCI HAR Dataset/train/X_train.txt")
train[1,]
colnames(train)<-features$Name
train$Label<-"train"
train<-cbind(trainsub,train)
train[1,]


###Read test data and set column names
test<-read.table("C:/Users/aemmert/Documents/Rstuff/getdata/UCI HAR Dataset/test/X_test.txt")
test[1,]
colnames(test)<-features$Name
test$Label<-"test"
test<-cbind(testsub,test)
test[1,]


###Merge train and test rows
combined<-rbind(train,test)
combined[1,]

###Remove columns without mean and std in the name, write file
keepcols<-c(1:2,grep("mean", colnames(combined)), grep("std", colnames(combined)))
subcombined<-combined[,keepcols]
write.csv(subcombined,file="subcombined.csv",row.names=F)

###Calculate mean for the columns and output in a matrix
summarycombined<-apply(subcombined[3:ncol(subcombined)],2,FUN=mean)
summarycombined<-data.frame(cbind(VariableName=names(summarycombined),Mean=as.vector(summarycombined)))
write.table(summarycombined,file="summarycombined.txt",row.names = F)


