#############w1#############
#shiny is a web-development framework based on R for data products 
library(shiny)
library(shinycssloaders)
data("Titanic")
#see builder for html elements
?builder

# shinyUI(fluidPage(
#   titlePanel("Slider App"),
#   sidebarLayout(
#     sidebarPanel(
#       h1("Move the Slider!"),
#       sliderInput("slider2","Slide Me!",0,100,0)#slider2 as id,label display,min,max,initial value
#     ),
#     mainPanel(
#       h3("Slider Value:"),
#       textOutput("text1")
#     )
#   )
# 
# ))

# shinyUI(fluidPage(
#   titlePanel("Plot Random Numbers"),
#   sidebarLayout(
#     sidebarPanel(
#       numericInput("numeric","How many random numbers to plot?",value=1000,min=1,max=1000,step=1),
#       sliderInput("sliderX","Pick minimum and maximum for X",-100,100,value = c(-50,50)),#value controls this bidirection bar
#       sliderInput("sliderY","Pick minimum and maximum for Y",-100,100,value = c(-50,50)),
#       checkboxInput("show_xlab","Show/Hide X axis label",value = TRUE),#checkbox returns T/F
#       checkboxInput("show_ylab","Show/Hide Y axis label",value = TRUE),
#       checkboxInput("show_title","Show/Hide Title")
#     ),
#     mainPanel(
#       h3("Graph of random points"),
#       plotOutput("plot1")
#     )
#   )
# ))

#  shinyUI(fluidPage(
#    titlePanel("Predict Horsepower from MPG"),
#    sidebarLayout(
#      sidebarPanel(
#        sliderInput("sliderMPG","What's the MPG of the car?",10,35,value=20),
#        checkboxInput("showModel1","Show/Hide Model 1",value=TRUE),
#        checkboxInput("showModel2","Show/Hide Model 2",value=TRUE),
#        submitButton("Submit")
#      ),
#      mainPanel(
#        plotOutput("plot1"),
#        h3("Predicted Horse power from Model 1:"),
#        textOutput("pred1"),
#        textOutput("Rsquare1"),
#        h3("Predicted Horse power from Model 1:"),
#        textOutput("pred2"),
#        textOutput("Rsquare2")
# 
#      )
# 
#    )
# 
# ))

# shinyUI(fluidPage(
#   titlePanel("Species"),
#   sidebarLayout(
#     sidebarPanel(
#       sliderInput("Sepallength","what is the spedal length?",0,10,value=0)
#     ),
#     mainPanel(
#       textOutput("Pred"),
#       h3("Species prediction")
#     )
#   )
#   
# ))

# shinyUI(fluidPage(
#   titlePanel("Tabs"),
#   sidebarLayout(
#     sidebarPanel(
#       numericInput("numeric","How many random numbers to plot?",value=1000,min=1,max=1000,step=1),
#       textInput("box2","Enter Tab 2 Text:",value = "Tab 2!"),
#       textInput("box3","Enter Tab 3 Text:",value = "Tab 3!")
#     ),
#     mainPanel(
#       tabsetPanel(
#         type = "tabs",
#         tabPanel("Tab 1",br(),plotOutput("out1")),# br() -> break row
#         tabPanel("Tab 2",br(),textOutput("out2")),
#         tabPanel("Tab 3",br(),textOutput("out3"))
#       )
#       
#     )
#     
#   )
#   
# ))

# shinyUI(fluidPage(
#   tags$head(tags$style(
#     HTML('
#          #sidebar {
#             background-color: white
#         }')
#   )),
#   #titlePanel("Linear Regression Demo"),
#   #p("Regression",align = "center",size=10),
#   tags$p("Regression", style = "font-size: 200%;text-align: center;"),
#   sidebarLayout(
#     sidebarPanel(id="sidebar",
#       align = "center",
#       h4("Data set: mtcars"),
#       br(),
#       div(tableOutput("table1"),align="center"),
#       br(),
#       br()
#       #h5("slope"),
#       #textOutput("slopeOut"),
#       #h5("Intercept"),
#       #textOutput("intOut"),
#       #h5("R Squared"),
#       #textOutput("R2Out")
#     ),
#     mainPanel(
#       plotOutput("plot1",height = 250,brush=brushOpts(#let user brush target data
#         id = "brush1"
#       ))
#     )
#   ),
#   plotOutput("plot2",height = 230),
#   tags$p("Classification",id="Classification", style = "font-size: 200%;text-align: center;")
# ))

# fluidRow(
#   column(3,
#          h4("Car Information"),
#          tags$div(align="left",
#                   selectInput("buying_price", "Price:", 
#                               choices=unique(DT_raw$buying_price)),
#                   selectInput("maintenance_cost", "Maintenance Cost:", 
#                               choices=unique(DT_raw$buying_price)),
#                   selectInput("doors", "Doors:", 
#                               choices=unique(DT_raw$doors)),
#                   selectInput("passenger_capacity", "Passenger Capacity:", 
#                               choices=unique(DT_raw$passenger_capacity)),
#                   selectInput("luggage_capacity", "Luggage Capacity:", 
#                               choices=unique(DT_raw$passenger_capacity)),
#                   selectInput("safety", "Safety:", 
#                               choices=unique(DT_raw$passenger_capacity))
#                   
#          )
#   ),
#   column(4, offset = 1,
#          h4("Algorithm Selection"),
#          br(),
#          tags$div(align="left",
#                   checkboxInput("LR","Logistic Regression",value = TRUE),
#                   checkboxInput("SVM","Support Vector Machine",value = FALSE),
#                   checkboxInput("DT","Decision Tree",value = FALSE),
#                   checkboxInput("Boost","XGBoost Tree",value = FALSE),
#                   checkboxInput("RF","Random Forest",value=FALSE)
#          )
#   ),
#   column(4,
#          plotOutput("plot1",height = 250,brush=brushOpts(#let user brush target data
#            id = "brush1"
#          ))
#   )
# ),
  
  #############w1#############
  #shiny is a web-development framework based on R for data products 
  library(shiny)
  data("Titanic")
  #see builder for html elements
  ?builder
  
  # shinyUI(fluidPage(
  #   titlePanel("Slider App"),
  #   sidebarLayout(
  #     sidebarPanel(
  #       h1("Move the Slider!"),
  #       sliderInput("slider2","Slide Me!",0,100,0)#slider2 as id,label display,min,max,initial value
  #     ),
  #     mainPanel(
  #       h3("Slider Value:"),
  #       textOutput("text1")
  #     )
  #   )
  # 
  # ))
  
  # shinyUI(fluidPage(
  #   titlePanel("Plot Random Numbers"),
  #   sidebarLayout(
  #     sidebarPanel(
  #       numericInput("numeric","How many random numbers to plot?",value=1000,min=1,max=1000,step=1),
  #       sliderInput("sliderX","Pick minimum and maximum for X",-100,100,value = c(-50,50)),#value controls this bidirection bar
  #       sliderInput("sliderY","Pick minimum and maximum for Y",-100,100,value = c(-50,50)),
  #       checkboxInput("show_xlab","Show/Hide X axis label",value = TRUE),#checkbox returns T/F
  #       checkboxInput("show_ylab","Show/Hide Y axis label",value = TRUE),
  #       checkboxInput("show_title","Show/Hide Title")
  #     ),
  #     mainPanel(
  #       h3("Graph of random points"),
  #       plotOutput("plot1")
  #     )
  #   )
  # ))
  
  #  shinyUI(fluidPage(
  #    titlePanel("Predict Horsepower from MPG"),
  #    sidebarLayout(
  #      sidebarPanel(
  #        sliderInput("sliderMPG","What's the MPG of the car?",10,35,value=20),
  #        checkboxInput("showModel1","Show/Hide Model 1",value=TRUE),
  #        checkboxInput("showModel2","Show/Hide Model 2",value=TRUE),
  #        submitButton("Submit")
  #      ),
  #      mainPanel(
  #        plotOutput("plot1"),
  #        h3("Predicted Horse power from Model 1:"),
  #        textOutput("pred1"),
  #        textOutput("Rsquare1"),
  #        h3("Predicted Horse power from Model 1:"),
  #        textOutput("pred2"),
  #        textOutput("Rsquare2")
  # 
  #      )
  # 
  #    )
  # 
  # ))
  
  # shinyUI(fluidPage(
  #   titlePanel("Species"),
  #   sidebarLayout(
  #     sidebarPanel(
  #       sliderInput("Sepallength","what is the spedal length?",0,10,value=0)
  #     ),
  #     mainPanel(
  #       textOutput("Pred"),
  #       h3("Species prediction")
  #     )
  #   )
  #   
  # ))
  
  # shinyUI(fluidPage(
  #   titlePanel("Tabs"),
  #   sidebarLayout(
  #     sidebarPanel(
  #       numericInput("numeric","How many random numbers to plot?",value=1000,min=1,max=1000,step=1),
  #       textInput("box2","Enter Tab 2 Text:",value = "Tab 2!"),
  #       textInput("box3","Enter Tab 3 Text:",value = "Tab 3!")
  #     ),
  #     mainPanel(
  #       tabsetPanel(
  #         type = "tabs",
  #         tabPanel("Tab 1",br(),plotOutput("out1")),# br() -> break row
  #         tabPanel("Tab 2",br(),textOutput("out2")),
  #         tabPanel("Tab 3",br(),textOutput("out3"))
  #       )
  #       
  #     )
  #     
  #   )
  #   
  # ))
  
  shinyUI(fluidPage(
    tags$head(tags$style(
      HTML('
           #sidebar {
              background-color: white
          }')
    )),
    #titlePanel("Linear Regression Demo"),
    #p("Regression",align = "center",size=10),
    sidebarLayout(
      sidebarPanel(id="sidebar",
        align = "center",
        h4("Linear Regression Parameters:"),
        br(),
        div(tableOutput("table1"),align="center"),
        br(),
        br()
        #h5("slope"),
        #textOutput("slopeOut"),
        #h5("Intercept"),
        #textOutput("intOut"),
        #h5("R Squared"),
        #textOutput("R2Out")
      ),
      mainPanel(
        plotOutput("plot1",height = 250,brush=brushOpts(#let user brush target data
          id = "brush1"
        ))
      )
    ),
    plotOutput("plot2",height = 230)
  ))