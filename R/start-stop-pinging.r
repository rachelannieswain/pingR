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
  stop_flag <- FALSE
  # Start job
  if(rstudioapi::isAvailable()) { #check api avilable
    job::job(ping_job = {
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

  rstudioapi::jobSetState(ping_job, state = "succeeded")
  print("PingR now inactive...")
}


##IDEA:  Can I just store job as a script somewhere - inst folder? - and run as a parallel process i.e. with parallel package
# library(parallel)
# ncpu <- detectCores()
# cl <- makeCluster(ncpu)
# # full path to file that should execute
# files <- c(...)
# # use an lapply in parallel.
# result <- parLapply(cl, files, source)
# # Remember to close the cluster
# stopCluster(cl)
# # If anything is returned this can now be used.
