rankall <- function(outcome, num = "best") {
  
  isValid <- function (x) {
    y<-type.convert(x)
    z<-is.numeric(y)
  }
  
  normalizeInput <- function (table,fields) {
    colmn <- table[,fields]
    colmn$v3 <- vapply(colmn[,3],FUN=isValid,FUN.VALUE = c(TRUE))
    res<- subset (colmn, v3==TRUE)
    res$v3Val <- vapply (res[,3],FUN=type.convert,c(0.0) )
    res
  }
  
  nthorder <- function (x) {
    y<-  x[with (x,order(v3Val,Hospital.Name)),]
    if (num == "best") {
      result<-y[1,];
      return (result)
    }
    if (num == "worst") {
      result <- y[nrow(y),]
      return (result)
      }
    
    idx = num
    if (is.numeric(idx)) {
        if (idx > 0 && idx <= nrow(y)) {
          result <- y[idx,]
          } else {
            result <- NA
          }
      } else {
        result <- NA
      }
  
  }

  
  validOutcome <- "(heart failure)|(heart attack)|(pneumonia)"
  
  res <- grep (validOutcome , outcome)
  if (length(res) == 0) {
    stop ("invalid outcome")
  }
  
  outcomeTable <- read.csv("outcome-of-care-measures.csv", 
                           colClasses = "character")
  if (outcome == "heart failure") {
    listHF<- c("Hospital.Name" ,"State" ,
               "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure"
    )
  } else if (outcome == "heart attack") {
    listHF<- c("Hospital.Name" ,"State" ,
               "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack"
    )    
  } else if (outcome == "pneumonia") {
    listHF<- c("Hospital.Name" ,"State" ,
               "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"
    )
  }
  hf <- normalizeInput(outcomeTable, listHF)
  hfByState <- split(hf,hf$State)
  hfByRanking <- lapply (hfByState, FUN=nthorder)
  len <- length(hfByRanking)
  idx <- 1
  result <- data.frame(hospital=rep(character(),len),
                       state=rep(character(),len),
                       row.names = NULL,        
                       stringsAsFactors=FALSE)
  for (key in names(hfByRanking)) {
    v<-hfByRanking[[key]]
    if (class(v)=="data.frame") {
      result [key,] <- c (v$Hospital.Name,key)  
    } else {
      result [key,] <- c (NA,key)
    } 
    idx <- idx +1
  }
  return(result)   
}