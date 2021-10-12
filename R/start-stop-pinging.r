# Starts checking for finished code

#' @title Turns on notification sound for finished code
#'
#' @param wait In seconds, the minimum run time before a notification sound is made.
#' @param ping A number between 1-9 choosing the notification sound (see \link[beepr]{beep} for choices)
#'
#' @return NULL
#' @export
#'
#' @examples
#' \dontrun{
#' startPinging(wait = 30, ping = 5)
#' }
startPinging <- function(wait = 30, ping = 2){
  print("PingR now active...")
  # Start job
  if(rstudioapi::isAvailable()) { #check api avilable
    job::job({
      previous_line <- "" #init
      repeat{
        current_line <- rstudioapi::getConsoleEditorContext()$contents #get console text
        if(previous_line > 0) {
          start <- Sys.time()
          while(previous_line > 0) {
            current_line <- rstudioapi::getConsoleEditorContext()$contents
            if((nchar(current_line) == 0) & (as.numeric(Sys.time() - start) > wait)) {
              beepr::beep(sound = ping)
              break()
            }
          }
        }
        previous_line <- current_line
      }
    }, title = "PingR active")
  } else {
    stop("Rstudio API is not available, please try again.") #error
  }
}



stopPinging <- function(){
  closeAllConnections()

  rstudioapi::jobSetState("PingR active", state = "succeeded")
  print("PingR now inactive...")
}
