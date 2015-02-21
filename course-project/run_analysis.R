#Load library
library(plyr)



url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
file <- "dataset.zip"
baseDir <-"UCI HAR Dataset"

# Download the files if required 
if(!file.exists(file)){
  download.file(url, file, method="curl")
  unzip(file, list = FALSE, overwrite = TRUE)  
}

# Load activity and feature mapping tables
activityLabelF <- file.path(baseDir,"activity_labels.txt" )
featureLabelsF <- file.path(baseDir, "features.txt")
activityLabels <-read.table(activityLabelF)
featureLabels <- read.table(featureLabelsF)

# Read the values in the table
# type - train or test data
# name - name of the file 
readMain <- function (type, name) {
  fName <- file.path(baseDir,type, paste0(name,"_",type,".txt"))
  read.table (fName)
}


# Read the tables for training/test data sets
readTable <- function (type) {
  dataSet <- list()
  
  dataSet$subject <- readMain(type,"subject")
  dataSet$X <- readMain(type,"X")
  names(dataSet$X)<-featureLabels$V2
  dataSet$Y <- readMain(type,"y")
  dataSet
}

#Load training and test data set. 
#The training and test data set follow the naming convention
#Leverage the naming convention
trainSet <- readTable("train")
testSet <- readTable("test")

#merge the training and test data set
#Filter the metrics deal with mean and standard deviation. 
#Any metrics with keyword "std" or "mean" will be considered for now
mergeTables <- function (a,b){
  trY <- merge (a$Y,activityLabels)
  teY <- merge (b$Y,activityLabels)
  trX <- a$X[,c(grep("std",x=featureLabels$V2,ignore.case = TRUE),
                grep("mean",x=featureLabels$V2,ignore.case = TRUE))]
  
  teX <- b$X[,c(grep("std",x=featureLabels$V2,ignore.case = TRUE),
                grep("mean",x=featureLabels$V2,ignore.case = TRUE))]
  
  trX<-  cbind (person=a$subject$V1, activity=trY$V2,trX)
  teX<-  cbind (person=b$subject$V1,activity=teY$V2,teX)
  rbind (trX,teX )
}
mT <- mergeTables (trainSet,testSet)

#Split the result data by person and activity and find the mean
result_data <- ddply(mT, .(person, activity), .fun=function(row){ colMeans(row[,-c(1,2)]) })

# Change the headers and write the results in a file
headToBeChanged <- colnames(result_data)[-(1:2)]
newHead <- c("person","activity",paste0("mean-",headToBeChanged))
names(result_data)<-newHead
result_file <- "result.csv"
write.table(result_data,file = result_file,row.names = FALSE)