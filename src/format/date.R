# Functions

# Check format date YYYY-MM-DD
IsDate <- function(x) {
  tryCatch(!is.na(as.Date(x, "%Y-%m-%d")),  
           error = function(err) {FALSE})  
}

# Check format year with 4 digits
IsYear <- function(x) {
  tryCatch(str_length(x) == 4 & str_detect(x, "\\d{4}"),  
           error = function(err) {FALSE})  
}