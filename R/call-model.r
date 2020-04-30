if (!require('sparklyr')){
  install.packages('sparklyr')
  library(sparklyr)
  spark_install(version = "2.1.0")
  devtools::install_github("rstudio/sparklyr")
}
if (!require('stringr')){
  install.packages('stringr')
  library(stringr)
}
if(!require(httr)){
  install.packages('httr')
  library(httr)
}
if(!require(DBI)){
  install.packages('DBI')
  library(DBI)
}
library(jsonlite)


Sys.setenv(HIVE_CONF_DIR = "/etc/hive/conf")
.config <- spark_config()

spark <- spark_connect(appName="BancaMarch HiveR", master="yarn", config = .config)

df = dbGetQuery(spark, "SELECT * FROM e_temp_test.rloan2 ORDER BY zip_code DESC LIMIT 10")

# Coge nombre archivo como variable de entorno
json_path = os.environ["X_DATA"] 
API_KEY <- Sys.getenv("API_KEY")
HOST <- Sys.getenv("HOST")

with open(json_path) as jsonfile:
    data = json.load(jsonfile)
    
m <- data.matrix(df)
datos = list(acessKey=API_KEY,clients=split(m, seq(nrow(m))))


tmp <- cbind(HOST, "api/altus-ds-1/models/call-model")
url <- str_c(tmp, collapse = "/")

r <- POST(url, body = datos, add_headers("Content-Type" = "application/json"))
print ("HTTP status code", r.status_code)

if (r.status_code = 200){
  print('Success')
  pred = res.json()['response']
  df = pd.DataFrame(data={'index':index, 'loan_pred':pred})
  name = 'RESULTS/'+str(datetime.now()).replace(' ','_') +'_predictions.csv'
  df.to_csv(name)
  df.to_csv('new_pred.csv')
}else{
  print ('Error!')
  print(r.content)
  name = 'RESULTS/'+str(datetime.now()).replace(' ','_') +'_error.txt'
  with open(name, 'wb') as file:
    file.write(res.content)
  