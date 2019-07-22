source(paste0(getwd(),"/Read_docs.R"))
library(shiny)
server<-function(input, output,session) {
  
  observeEvent(c(input$txt,input$Dir,input$Deep),{
    DT<-try(Read_docs(input$Dir,text_ = input$txt,deep = input$Deep),silent = T)
    if(is.error(DT)){DT<-data.frame(Message="File not found")}
    output$table <- DT::renderDataTable({
      DT
    },
    options = list(scrollX = TRUE))
  })
  if (!interactive()) {
    session$onSessionEnded(function() {
      stopApp()
      q("no")
    })
  }
}

ui<-fluidPage(
    titlePanel("Basic Finder"),
    fluidRow(
      column(4,
             textInput("Dir","File address",value = getwd()),
             textInput("txt","Text to find",value = "Hello World!"),
             checkboxInput(inputId = "Deep","Search in subfolders?",value = FALSE)
      )
    ),
    DT::dataTableOutput("table")
  )

shinyApp(ui,server)
