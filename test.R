
  # Start job
  # if(rstudioapi::isAvailable()) { #check api available
  #
    previous_line <- "" #init
    repeat{
      current_line <- rstudioapi::getConsoleEditorContext()$contents #get console text
      if(previous_line > 0) {
        start <- Sys.time()
        while(previous_line > 0) {
          current_line <- rstudioapi::getConsoleEditorContext()$contents
          if((nchar(current_line) == 0) & (as.numeric(Sys.time() - start) > 30)) {
            beepr::beep(sound = 2)
            break()
          }
        }
      }
      previous_line <- current_line
    }
  # } else {
  #   stop("Rstudio API is not available, please try again.") #error
  # }
