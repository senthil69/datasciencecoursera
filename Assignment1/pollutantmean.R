pollutantmean <- function(directory, pollutant, id = 1:332) {
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
  res<-colMeans(dataSet[pollutant], na.rm=TRUE)
  round(res[[1]],digits=3)
}
