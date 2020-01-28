

###See working directory
getwd()

###Read and initialize features
features<-read.table("./UCI HAR Dataset/features.txt")
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
activitylab<-read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(activitylab)<-c("ActivityID", "Activity")

###Read train data and set column names
train<-read.table("./UCI HAR Dataset/train/X_train.txt")
colnames(train)<-features$Name
trainy<-read.table("./UCI HAR Dataset/train/Y_train.txt")
colnames(trainy)<-"ActivityID"
trainid<-read.table("./UCI HAR Dataset/train/subject_train.txt")
colnames(trainid)[1]<-"ID"
train<-cbind(trainid,trainy,train)
train<-merge(train,activitylab,by="ActivityID",all.x=T,all.y=F,sort=F)
dim(train)
train[1,]


###Read test data and set column names
test<-read.table("./UCI HAR Dataset/test/X_test.txt")
colnames(test)<-features$Name
testy<-read.table("./UCI HAR Dataset/test/Y_test.txt")
colnames(testy)<-"ActivityID"
testid<-read.table("./UCI HAR Dataset/test/subject_test.txt")
colnames(testid)[1]<-"ID"
test<-cbind(testid,testy,test)
test<-merge(test,activitylab,by="ActivityID",all.x=T,all.y=F,sort=F)
dim(test)
test[1,]


###Merge train and test rows
combined<-rbind(train,test)
combined[1,]

###Remove columns without mean and std in the name, write file
keepcols<-c(2,564,grep("mean", colnames(combined)), grep("std", colnames(combined)))
subcombined<-combined[,keepcols]
str(subcombined)
write.csv(subcombined,file="subcombined.csv",row.names=F)

###Calculate mean for the columns and output in a matrix
Index<-paste(subcombined$ID,subcombined$Activity,sep="_")
summarycombined<-apply(subcombined[3:ncol(subcombined)], 2, FUN=function(x) tapply(x,Index,FUN=mean))
summarycombined<-lapply(subcombined[3:ncol(subcombined)], FUN=function(x) tapply(x,Index,FUN=mean))
a<-as.data.frame(summarycombined)
write.table(summarycombined,file="summarycombined.txt",row.names = T)
