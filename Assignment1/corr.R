corr <- function(directory, threshold = 0) {
  options(digits = 4)
  id <- 1:332
  dataSetVector <- list()
  for (fid in id ) { 
    file <- paste (sep="", directory,"/",sprintf("%03d",fid),".csv")
    dataSet <- read.csv(file)
    filteredSet <- subset.data.frame (dataSet, 
                                     sulfate >=0  & nitrate >=0 )
    dataSetVector[[fid]]<-filteredSet
  }
  result <- c()
  for (did in id) {
    currentTh <- nrow(dataSetVector[[did]])
    if (currentTh > threshold) {
      dataSet <- dataSetVector[[did]]
      corVal <- cor(dataSet$sulfate, dataSet$nitrate) 
      result <- append (result, corVal)
    }
  }
  result
}