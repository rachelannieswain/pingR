previous_line <- ""
wait <- 10
repeat{
  current_line <- rstudioapi::getConsoleEditorContext()$contents
  if(previous_line > 0) {
    start <- Sys.time()
    while(previous_line > 0) {
      current_line <- rstudioapi::getConsoleEditorContext()$contents
      if((nchar(current_line) == 0) & (as.numeric(Sys.time() - start) > wait)) {
        beepr::beep(sound = 2)
        break()
      }
    }
  }
  previous_line <- current_line
}
closeAllConnections()


