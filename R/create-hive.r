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
if (!require('dplyr')){
  install.packages('dplyr')
  library(dplyr)
}
if(!require(DBI)){
  install.packages('DBI')
  library(DBI)
}

Sys.setenv(HIVE_CONF_DIR = "/etc/hive/conf")
.config <- spark_config()

spark <- spark_connect(appName="BancaMarch HiveR", master="yarn", config = .config)


dbGetQuery(spark, "CREATE DATABASE IF NOT EXISTS e_temp_test")
dbGetQuery(spark, "CREATE TABLE IF NOT EXISTS e_temp_test.rloan2( 
  Age BIGINT,Experience BIGINT,Income BIGINT,
  ZIP BIGINT,Family BIGINT,CCAvg DECIMAL, 
  Education BIGINT,Mortgage SMALLINT,SecAccount SMALLINT, 
  CDAccount SMALLINT,Online SMALLINT,CreditCard SMALLINT 
    ) 
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ',' 
STORED AS TEXTFILE")

df <- read.csv('test.csv', encoding="UTF-8")
df <- df[,-1]

df_spark_table <- copy_to(spark, df, overwrite = TRUE)
spark_write_table(
  df_spark_table, 
  name = 'e_temp_test.rloan2', 
  mode = 'overwrite'
)


spark_disconnect(spark)
