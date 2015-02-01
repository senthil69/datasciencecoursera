rankhospital <- function(state, outcome, num = "best") {
  
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
  
  validOutcome <- "(heart failure)|(heart attack)|(pneumonia)"
  
  res <- grep (validOutcome , outcome)
  if (length(res) == 0) {
    stop ("invalid outcome")
  }
  
  outcomeTable <- read.csv("outcome-of-care-measures.csv", 
                           colClasses = "character")
  validState<- outcomeTable[,7]
  validState<- unique(validState)
  if (state %in% validState) {} else {
    stop ("invalid state")
  }
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
  citywide <- subset (hf , State == state)
  sortWide <- citywide[with (citywide,order(v3Val,Hospital.Name)),]
  
  if (num == "best") {result<-sortWide[1,1]}
  if (num == "worst") {result <- sortWide[nrow(sortWide),1]} else {
    idx = num
    if (is.numeric(idx)) {
      if (idx > 0 && idx <= nrow(sortWide)) {
        result <- sortWide[idx,1]} else {
          result <- NA
        }
    } else {
      result <- NA
    }
  }
  result
  
}