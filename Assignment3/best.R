best <- function(state, outcome) {
  
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
  res <- subset (hf , State == state)
  ret <- res[res$v3Val == min(res$v3Val),1]
  ret
  
  #suppressWarnings(y<-lapply(hf[,3],FUN=as.numeric))
  #suppressWarnings(z<-lapply(hf[,4],FUN=as.numeric))
  #hf$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure  <- y
  #hf$Number.of.Patients...Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure<- z
  #hf
  ## Check that state and outcome are valid
  ## Return hospital name in that state with lowest 30-day death
  ## rate
  #  Number.of.Patients...Hospital.30.Day.Readmission.Rates.from.Pneumonia
}
