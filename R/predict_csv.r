#Use the csv with the data as input
if(!require(forecast)){
  install.packages('forecast')
  library(forecast)
}
if(!require(jsonlite)){
  install.packages('jsonlite')
  library(jsonlite)
}

model <- readRDS('model.pkl')

predict <- function(args){
  filename <- as.character(args[[1]])
  df <- read.csv(filename, encoding="UTF-8")
  result <- predict(model, data.matrix(df[,c(-1,-2,-11)]))
  pred <- integer(length(result))
  pred[(result >= 0.65)] <- 1
  (list(pred_boost = as.numeric(pred))) 
}

