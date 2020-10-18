#' test UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_test_ui <- function(id){
  ns <- NS(id)
  tagList(
    actionButton(inputId = ns("go"), label = "Generate PDF"),
    downloadButton(outputId = ns("save_pdf"), label = "Save PDF") %>% shinyjs::hidden()
  )
}

#' test Server Function
#'
#' @noRd 
mod_test_server <- function(input, output, session){
  ns <- session$ns
  r <- reactiveValues(
    pdf_path = NULL
  )
  
  observeEvent(input$go, {
    
    # create the temp where the .html is going to be stored
    html_path <- paste0(tempfile(), ".html")
    r$pdf_path <- paste0(tempfile(), ".pdf")
    
    rmarkdown::render(
      input = system.file('app/www/Untitled.Rmd', package = 'golem.reprex'), 
      output_file = html_path,
      envir = new.env()
    )
    
    pagedown::chrome_print(
      input = html_path, 
      output = r$pdf_path, 
      extra_args = c('--disable-gpu',	'--no-sandbox'), 
      timeout = 60,
      verbose = 1
    )
    
    shinyjs::show(id = "save_pdf", asis = FALSE)
  })
  
  output$save_pdf <- downloadHandler(
    filename = "Output.pdf",
    content = function(file) {
      file.copy(r$pdf_path, file)
    }
  )
}

## To be copied in the UI
# mod_test_ui("test_ui_1")

## To be copied in the server
# callModule(mod_test_server, "test_ui_1")

