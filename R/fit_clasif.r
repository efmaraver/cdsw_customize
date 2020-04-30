# cargamos las librerías de visualización
if(!require(caret)){
    install.packages('caret')
    library(caret)
}
if(!require(xgboost)){
    install.packages('xgboost', dependencies=TRUE)
    library(xgboost)
}
if (!require("pROC")) {
  install.packages("pROC")
  library(pROC)
}
if (!require("rjson")) {
  install.packages("rjson")
  install.packages("jsonlite")
  library(rjson)
  library(jsonlite)
}

library (cdsw)

# Split train-test
data <- read.csv("Bank_Loan_Clean.csv")
num <- createDataPartition(data$Personal.Loan, p = .80, list = F)
train_set <- data[num,]
test_set <- data[-num,]
#train <- subset(data, select = -c(Personal.Loan))
#label <- subset(data, select = c(Personal.Loan))

set.seed(123)
train <- data.matrix(train_set[,c(-1,-10)])
output_vector = train_set[,'Personal.Loan'] == "1"

boost <- xgboost(data =train, 
                 label = output_vector,
                 nthread = 2,
                 nrounds = 2,
                 objective = "binary:logistic")


y_pred <- predict(boost, data.matrix(test_set[,c(-1,-10)]))

# si la probabilidad es mayor al 65%, será 1
pred <- integer(length((y_pred)))
pred[(y_pred >= 0.65)] <- 1

# Checking classification accuracy
cm <- table(pred, test_set$Personal.Loan)
cm

#calcula métricas de validación (AUC y precisión)
roc_obj <- roc(test_set$Personal.Loan, pred)
auc = auc(roc_obj)
acc = 100 * sum(diag(cm)) / sum(cm)
acc

# Define métricas para seguir en el workbench
#cdsw::track.metric("acc", acc)
#cdsw::track.metric("auc", auc)

# save model
filename = "model.pkl"
saveRDS(boost, file=filename)
#cdsw::track.file(filename)

write.csv(test_set, 'test.csv')
#test <- data.matrix(test_set[,c(-1,-10)])
#x <-toJSON(test, dataframe = c("columns"),matrix = c("rowmajor"))
#write_json(list("clients"=x), "test.json")
#result <- fromJSON("test.json")
