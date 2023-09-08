# Installieren und Laden der erforderlichen Pakete
library(shiny)
library(ggplot2)

# UI-Teil
ui <- fluidPage(
  titlePanel("Schätzung der maximalen Hypothek"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("bbInput", "Belehnungsbasis (CHF):", value = 1000000),
      numericInput("b1Input", "Belehnung 1. Hypothek:", value = 0.67),
      numericInput("b2Input", "Belehnung 2. Hypothek:", value = 0.8),
      numericInput("yInput", "Amortisationsdauer (Jahre):", value = 15),
      numericInput("nInput", "Nebenkosten:", value = 0.01),
      numericInput("eInput", "Einnahmen (CHF):", value = 100000),
      numericInput("iInput", "Kalk. Zins:", value = 0.045),
      numericInput("maxtInput", "Max. Tragbarkeit:", value = 0.37),
      actionButton("calcButton", "Berechnen")
    ),
    
    mainPanel(
      plotOutput("plotOutput"),
      tableOutput("maxHypothek")
    )
  )
)

# Server-Teil
server <- function(input, output, session) {
  
  observeEvent(input$calcButton, {
    # Konstanten aus Inputs
    bb <- input$bbInput
    b1 <- input$b1Input
    b2 <- input$b2Input
    y <- input$yInput
    n <- input$nInput
    e <- input$eInput
    i <- input$iInput
    maxt <- input$maxtInput
    
    # Loop Start und Stop definieren
    low <- 0
    high <- bb*b2
    
    # Vektor für Hypothekenwerte
    h <- low:high
    
    # Belehnung
    b <- h/bb
    
    # Zinsen (CHF)
    ix <- i * h
    
    # Amortisation (CHF)
    a <- pmax((((b - b1) * bb) / y), 0)
    
    # Nebenkosten (CHF)
    nk <- n * bb
    
    # Tragbarkeit
    t <- (ix + a + nk) / e
    
    # DataFrame erstellen
    df <- data.frame(Hypothek = h, Tragbarkeit = t)
    
    # Finde nächsten Hypothekarwert zu maximal möglicher Tragbarkeit
    index <- which.min(abs(df$Tragbarkeit - maxt))
    
    hypo_max <- df$Hypothek[index]
    
    # Plot mit ggplot
    output$plotOutput <- renderPlot({
      ggplot(df, aes(x = Hypothek, y = Tragbarkeit)) +
        geom_line() +
        geom_hline(yintercept = maxt, color = "red", linetype = "dotted", size = 1) +
        geom_vline(xintercept = hypo_max, color = "red", linetype = "dotted", size = 1) +
        labs(x = "Hypothek (in Tsd.)", y = "Tragbarkeit") +
        scale_x_continuous(labels = function(x) x / 1000) +
        theme(text = element_text(size = 16))
    })
    
    # Maximale Hypothek mit maximal möglicher Tragbarkeit als Output definieren
    output$maxHypothek <- renderTable({
      df[index, ]
    })
  })
}

# App laufen lassen
shinyApp(ui = ui, server = server)
