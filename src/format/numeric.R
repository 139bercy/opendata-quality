# Functions

# Check numeric
IsNumeric <- function(x) {
  tryCatch(!is.na(as.numeric(x)),  
           error = function(err) {FALSE})  
}

# Check no letters
NoLetters <- function(x) {
  tryCatch(!str_detect(x, "[:alpha:]"),  
           error = function(err) {FALSE})  
}