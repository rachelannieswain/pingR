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
startPinging <- function(wait = 30, ping = 2) {
  print("PingR now active...")

  # Script to run
  checkConsole <- c('
    # Start job
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
    }')

  checkConsole <- gsub("wait", wait, checkConsole) # Specify wait time
  checkConsole <- gsub("ping", ping, checkConsole) # Specify notification sound

  # Write to tmp file
  script_file = tempfile()
  write(checkConsole, file = script_file)

  # start job
  # assign job id as var in new environment
  # pkgenv <- new.env()
  # pkgenv$jobid <- rstudioapi::jobRunScript(script_file)
  assign('jobid', rstudioapi::jobRunScript(script_file), pkgenv)
}




#' @title Stop notifications for finished code
#'
#' @return NULL
#' @export
#'
#' @examples
#' \dontrun{
#' stopPinging()
#' }
stopPinging <- function() {
  # job_id <- .pkgglobalenv$jobid
  rstudioapi::jobSetState(pkgenv$jobid, state = "succeeded")
  print("PingR now inactive...")
}



