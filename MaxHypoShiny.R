# Packages laden
library(shiny)
library(ggplot2)
library(dplyr)

# UI-Teil
ui <- navbarPage(
  title = "Berechnungen zur Hypothek",
  
  # Erste Unterseite (Maximale Hypothek)
  tabPanel("Max. Hypothek", 
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
           )),
  
  # Zweite Unterseite (Max. kalk. Zins)
  tabPanel("Max. kalk. Zins",
           sidebarLayout(
             sidebarPanel(
               numericInput("bbInput2", "Belehnungsbasis (CHF):", value = 1000000),
               numericInput("hypothekInput2", "Hypothek (CHF):", value = 600000),
               numericInput("b1Input2", "Belehnung 1. Hypothek:", value = 0.67),
               numericInput("b2Input2", "Belehnung 2. Hypothek:", value = 0.8),
               numericInput("yInput2", "Amortisationsdauer (Jahre):", value = 15),
               numericInput("nInput2", "Nebenkosten:", value = 0.01),
               numericInput("eInput2", "Einnahmen (CHF):", value = 100000),
               numericInput("maxtInput2", "Max. Tragbarkeit:", value = 0.37),
               actionButton("calcZinsButton", "Zinssatz berechnen")
             ),
             mainPanel(
               tableOutput("maxZinsOutput")
             )
           ))
)

# Server-Teil
server <- function(input, output, session) {
  
  observeEvent(input$calcButton, {
    
    # Konstanten aus Inputs (1. Unterseite)
    bb <- input$bbInput
    b1 <- input$b1Input
    b2 <- input$b2Input
    y <- input$yInput
    n <- input$nInput
    e <- input$eInput
    i <- input$iInput
    maxt <- input$maxtInput
    
    # High & Low des Vektors definieren
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
    
    # Data Frame erstellen zur Speicherung der Werte
    df <- data.frame(Hypothek = h, Tragbarkeit = t, Belehnung = b)
    
    # Finde nächsten Hypothekarwert zu maximal möglicher Tragbarkeit
    index <- which.min(abs(df$Tragbarkeit - maxt))
    
    hypo_max <- df$Hypothek[index]
    
    # Plot mit ggplot
    output$plotOutput <- renderPlot({
      ggplot(df, aes(x = Hypothek, y = Tragbarkeit)) +
        geom_line() +
        geom_hline(yintercept = maxt, color = "red", linetype = "dotted", size = 1) +
        # geom_vline(xintercept = hypo_max, color = "blue", linetype = "dotted", size = 1) +
        labs(title = "Maximal mögliche Hypothek",x = "Hypothek (in Tsd.)", y = "Tragbarkeit") +
        scale_x_continuous(labels = function(x) x / 1000) +
        theme(text = element_text(size = 16))
    })
    
    # Maximale Hypothek mit maximal möglicher Tragbarkeit als Output definieren
    output$maxHypothek <- renderTable({
      df_rounded <- df[index, ]
      df_rounded$Tragbarkeit <- round(df_rounded$Tragbarkeit, 4)
      df_rounded$Belehnung <- round(df_rounded$Belehnung, 4)
      return(df_rounded)
    }, digits = 4)
  })
  
  observeEvent(input$calcZinsButton, {
    
    # Konstanten aus Inputs (2. Unterseite)
    bb_2 <- input$bbInput2
    h_2 <- input$hypothekInput2
    b1_2 <- input$b1Input2
    b2_2 <- input$b2Input2
    y_2 <- input$yInput2
    n_2 <- input$nInput2
    e_2 <- input$eInput2
    maxt_2 <- input$maxtInput2
    
    # Belehnung
    b_2 <- h_2/bb_2
    
    # Amortisation (CHF)
    a_2 <- pmax((((b_2 - b1_2) * bb_2) / y_2), 0)
    
    # Nebenkosten (CHF)
    nk_2 <- n_2 * bb_2
    
    # Max. kalk. Zins
    max_zins_2 <- ((maxt_2*e_2) - a_2 - nk_2) / h_2
    
    # Break Even Zins
    break_even_zins_2 <- (e_2 - a_2 - nk_2) / h_2
    
    # Max. kalk. Zins & Break Even Zins als Output definieren
    output$maxZinsOutput <- renderTable({
      data.frame(max_kalk_zins = max_zins_2, break_even_zins = break_even_zins_2)
    }, digits = 4)
  })
}

# App laufen lassen
shinyApp(ui = ui, server = server)
