complete <- function(directory, id = 1:332) {
  dataSetVector <- list()
  for (fid in id ) { 
    file <- paste (sep="", directory,"/",sprintf("%03d",fid),".csv")
    dataSet <- read.csv(file)
    filteredSet <- subset.data.frame (dataSet, 
                                      sulfate >=0  & nitrate >=0 )
    dataSetVector[[fid]]<-filteredSet
  }
  nobs <- c()
  for (fid in id ) {
    nobs <- append( nobs ,
                    nrow(subset(dataSetVector[[fid]],sulfate >= 0 & nitrate >= 0)))
  }
  
  data.frame(id,nobs)
}