
require(stringr)
require(rjson)

warning <- 0.1 # 1 pour 1000
dataset_id <- "marques-francaises"

api_data <- paste0("https://data.economie.gouv.fr/explore/dataset/", dataset_id, "/download/?format=csv&timezone=Europe/Berlin&use_labels_for_header=true")
api_meta <- paste0("https://data.economie.gouv.fr/api/v2/catalog/datasets/", dataset_id)

meta <- fromJSON(file = api_meta)

# Chargement du fichier et import en dataframe
data <- read.csv2(api_data)

# Mdification des noms des variables
myvar <- c("DATE_DEPOT", "TYPE", "CLASSES", "LIBELLE_MARQUE", "ID_MARQUE", "DATE_EXPIRATION")
colnames(data) <- myvar

# Fonctions tests pour les dates et les numériques 
IsDate <- function(mydate, date.format = "%Y-%m-%d") {
  tryCatch(!is.na(as.Date(mydate, date.format)),  
           error = function(err) {FALSE})  
}
IsNumeric <- function(myvalue) {
  tryCatch(!is.na(as.numeric(myvalue)),  
           error = function(err) {FALSE})  
}

# Tests des variables
data$DATE_DEPOT_CTRL <- IsDate(data$DATE_DEPOT)
data$DATE_EXPIRATION_CTRL <- IsDate(data$DATE_EXPIRATION)
#test <- str_split(data$CLASSES, ",")
#test2 <- lapply(test, sapply, IsNumeric)
test2 <- lapply(str_split(data$CLASSES, ","), IsNumeric)
data$CLASSES_CTRL <- sapply(test2, any)


# Calcul de la qualité
nrow <- nrow(data)
nb1 <- length(data$DATE_DEPOT_CTRL[data$DATE_DEPOT_CTRL==FALSE])
nb2 <- length(data$DATE_EXPIRATION_CTRL[data$DATE_EXPIRATION_CTRL==FALSE])
nb3 <- length(data$CLASSES_CTRL[data$CLASSES_CTRL==FALSE])
nb <- sum(nb1, nb2, nb3)

# Enregistrement des résultats
new_record <- c(dataset_id, meta$dataset$metas$default$title, nb > 0, nb > nrow * warning / 100, nrow, nb, c(nb1, nb2, nb3))
