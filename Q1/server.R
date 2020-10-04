library(ggplot2)
library(dplyr)
library(shiny)


df_csv <- read.csv("https://raw.githubusercontent.com/charleyferrari/CUNY_DATA608/master/lecture3/data/cleaned-cdc-mortality-1999-2010-2.csv", header= TRUE)
df <- df_csv

df_chapter <- df%>%
  filter(Year == 2010)

df_chapters <- unique(df_chapter$ICD.Chapter)


shinyServer(
  function(input, output, session) {
    
    selectedData <- reactive({
      df %>% filter(ICD.Chapter == input$Cause & Year == 2010 )
    })
    
    output$selection <- renderText({
      paste('<b>Death rate for: </b>', input$Cause)
    })
    
    output$plot <- renderPlot({
      
      ggplot(selectedData(), aes(x=reorder(State, -Crude.Rate), y=Crude.Rate)) +
        geom_col(fill = "lightblue") +
        coord_flip() +
        geom_text(aes(label=Crude.Rate),
                  color="black") +
        xlab("State") +
        ylab("Rate") +
        theme(panel.background = element_blank())
    }, height = function() {
      session$clientData$output_plot_width}
    )
  })

