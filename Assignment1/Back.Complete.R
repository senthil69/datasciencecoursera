complete <- function(directory, id = 1:332) {
  idFormatted <- sprintf("%03d",id)
  fnames <- paste (sep="", directory,"/",idFormatted,".csv")
  
  firstTime <- TRUE
  for (file in fnames) { 
    if (firstTime) {
      dataSet <- read.csv(file)
      firstTime<- FALSE
    } else {
      dataSet <- rbind(dataSet,read.csv(file))
    }
  }
  filterdData <- subset.data.frame (dataSet, sulfate >= 0 & nitrate >= 0, ID)
  resultData <- aggregate(filterdData,list(filterdData$ID), FUN=length)
  names(resultData) <- c("id","nobs")
  resultData
}