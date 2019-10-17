
require(stringr)
require(rjson)

warning <- 0.1 # 1 pour 1000

# Fonctions tests pour les dates et les numériques 
IsDate <- function(x) {
  tryCatch(!is.na(as.Date(x, "%Y-%m-%d")),  
           error = function(err) {FALSE})  
}
IsYear <- function(x) {
  tryCatch(str_length(x) == 4 & str_detect(x, "\\d{5}"),  
           error = function(err) {FALSE})  
}
IsNumeric <- function(x) {
  tryCatch(!is.na(as.numeric(x)),  
           error = function(err) {FALSE})  
}
NoLetters <- function(x) {
  tryCatch(!str_detect(x, "[:alpha:]"),  
           error = function(err) {FALSE})  
}


controls_list <- "data/controls_list.csv"

# Chargement du fichier et import en dataframe
data <- read.csv2(controls_list)
data[] <- lapply(data, as.character)
data$countobs <- 0
data$counterr <- 0
dataset_id_old <- ""
operation <- function(FUN, x){ FUN(x)}

# Boucle
for (i in 1:nrow(data)) {
  dataset_id <- data[i,'dataset_id']
  datavar_id <- data[i,'datavar_id']
  fct_control <- data[i,'function_control']
  
  api_data <- paste0("https://data.economie.gouv.fr/explore/dataset/", dataset_id, "/download/?format=csv&timezone=Europe/Berlin&use_labels_for_header=false")
  api_meta <- paste0("https://data.economie.gouv.fr/api/v2/catalog/datasets/", dataset_id)
  
  #meta <- fromJSON(file = api_meta)
  
  # Chargement du fichier et import en dataframe
  if (dataset_id != dataset_id_old) data_tmp <- read.csv2(api_data)
  

  l_tmp <- operation(match.fun(fct_control), data_tmp[[datavar_id]])
  data[i,'countobs'] <- length(l_tmp)
  data[i,'counterr'] <- length(l_tmp[l_tmp==FALSE])
  
  dataset_id_old <- dataset_id
}


