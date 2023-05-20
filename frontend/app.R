# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)
library(shinydashboard)
library(tidyverse)
library(tidytext)
library(here)

# Charger les données des tweets
 tweets <- read.csv(file = here("data", "tweets.csv"))
# tweets <- read.csv(file = "data/tweets.csv")

# script_dir <- dirname(here::here())
# tweets <- read.csv(file = here(script_dir, "data", "tweets.csv"))

tweets$date <- as.Date(tweets$date)  # Conversion de la colonne de date en type Date

# UI
ui <- dashboardPage(
  dashboardHeader(title = "Recherche de tweets de Donald Trump"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Recherche par période", tabName = "recherche_periode"),
      menuItem("Analyse des mots clés", tabName = "analyse_mots")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "recherche_periode",
        fluidPage(
          sidebarLayout(
            sidebarPanel(
              textInput("mots_periode", "Mots-clés (séparés par des virgules)"),
              selectInput("timePeriod_periode", "Période de temps :", choices = c("Année", "Mois")),
              conditionalPanel(
                condition = "input.timePeriod_periode == 'Mois'",
                selectInput("selectedYear_periode", "Sélectionnez une année :", choices = unique(format(tweets$date, "%Y")))
              ),
              actionButton("goButton_periode", "Rechercher")
            ),
            mainPanel(
              plotOutput("tweetPlot_periode")
            )
          )
        )
      ),
      tabItem(
        tabName = "analyse_mots",
        fluidPage(
          sidebarLayout(
            sidebarPanel(
              textInput("mots_analyse", "Mots-clés (séparés par des virgules)"),
              actionButton("goButton_analyse", "Rechercher")
            ),
            mainPanel(
              plotOutput("tweetPlot_analyse")
            )
          )
        )
      )
    )
  )
)

# Server
server <- function(input, output) {
  observeEvent(input$goButton_periode, {
    mots_periode <- str_split(input$mots_periode, "\\s*,\\s*")[[1]]

    # Vérifier si les inputs sont vides
    if (length(mots_periode) == 0 || all(mots_periode == "")) {
      output$tweetPlot_periode <- renderPlot({
        # Ne rien afficher si la recherche est vide
        NULL
      })
      return()
    }

    # Filtrer les tweets contenant les mots spécifiés
    tweets_filtres_periode <- tweets[str_detect(tweets$text, str_c(mots_periode, collapse = "|")), ]

    # Calculer le total de tweets pour chaque mot et chaque année/mois
    if (input$timePeriod_periode == "Année") {
      tweet_count_mots_periode <- tweets_filtres_periode %>%
        mutate(period = format(date, "%Y")) %>%
        group_by(mot = str_extract(text, str_c(mots_periode, collapse = "|")), period) %>%
        summarize(total_tweets = n(), .groups = "drop") %>%
        ungroup()
    } else {
      selectedYear_periode <- input$selectedYear_periode
      tweet_count_mots_periode <- tweets_filtres_periode %>%
        mutate(period = format(date, "%Y-%m")) %>%
        filter(format(date, "%Y") == selectedYear_periode) %>%
        group_by(mot = str_extract(text, str_c(mots_periode, collapse = "|")), period) %>%
        summarize(total_tweets = n(), .groups = "drop") %>%
        ungroup()
    }
    # Créer le diagramme avec une courbe reliant les points
    output$tweetPlot_periode <- renderPlot({
      ggplot(tweet_count_mots_periode, aes(x = period, y = total_tweets, color = mot, group = mot)) +
        geom_point() +
        geom_line() +
        labs(title = "Fréquence d'utilisation des mots clés par période",
             x = ifelse(input$timePeriod_periode == "Année", "Année", "Mois"),
             y = "Nombre de tweets") +
        scale_color_discrete() +
        theme(legend.position = "top")
    })
  })

  observeEvent(input$goButton_analyse, {
    mots_analyse <- str_split(input$mots_analyse, "\\s*,\\s*")[[1]]

    # Vérifier si les inputs sont vides
    if (length(mots_analyse) == 0 || all(mots_analyse == "")) {
      output$tweetPlot_analyse <- renderPlot({
        # Ne rien afficher si la recherche est vide
        NULL
      })
      return()
    }

    # Filtrer les tweets contenant les mots spécifiés
    tweets_filtres_analyse <- tweets[str_detect(tweets$text, str_c(mots_analyse, collapse = "|")), ]

    # Calculer le total de tweets et le total de tweets supprimés pour chaque mot
    tweet_count_mots_analyse <- tweets_filtres_analyse %>%
      group_by(mot = str_extract(tweets_filtres_analyse$text, str_c(mots_analyse, collapse = "|"))) %>%
      summarize(total_tweets = n(),
                total_tweets_suppr = sum(isDeleted == "t"), .groups = "drop")

    # Créer le diagramme
    output$tweetPlot_analyse <- renderPlot({
      ggplot(tweet_count_mots_analyse, aes(x = mot)) +
        geom_bar(aes(y = total_tweets, fill = "Total tweets"), stat = "identity", position = "stack") +
        geom_bar(aes(y = total_tweets_suppr, fill = "Tweets supprimés"), stat = "identity", position = "stack") +
        geom_text(data = subset(tweet_count_mots_analyse, total_tweets_suppr > 0),
                  aes(y = total_tweets_suppr, label = total_tweets_suppr),
                  vjust = -0.5, color = "red") +
        geom_text(
          aes(y = total_tweets, label = total_tweets),
          vjust = -0.5, color = "black") +
        labs(title = "Nombre de tweets et tweets supprimés pour chaque mot clé",
             x = "Mot clé",
             y = "Nombre de tweets") +
        scale_fill_manual(values = c("Total tweets" = "lightblue", "Tweets supprimés" = "red")) +
        theme_minimal()
    })
  })
}

# Lancement de l'application
shinyApp(ui = ui, server = server)

