library(shiny)
library(miniUI)
library(ggplot2)
library(WDI)
library(plyr)
library(googleVis)
library(caret)
library(ROCR)
library(xgboost)
library(plotly)
library(shinycssloaders)


options(shiny.port = 7776)
options(shiny.host = "192.168.178.29")
#https://shiny.rstudio.com/tutorial/lesson5/
#The server.R script is run once, when you launch your app
#The unnamed function inside shinyServer is run once each time a user visits your app
#The R expressions inside render* functions are run many times. Shiny runs them once each time a user changes a widget.



# shinyServer(function(input,output){
#     output$text1 = renderText(input$slider2)#take input element with id of "slider2", output in element id "text1"
# }
# )

# shinyServer(function(input,output){
#   output$plot1 <- renderPlot({
#     set.seed(2016-05-25)
#     number_of_points <- input$numeric
#     minX <- input$sliderX[1]
#     maxX <- input$sliderX[2]
#     minY <- input$sliderY[1]
#     maxY <- input$sliderY[2]
#     dataX <- runif(number_of_points,minX,maxX)
#     dataY <- runif(number_of_points,minY,maxY)
#     xlab <- ifelse(input$show_xlab,"X Axis","")#checkbox returns T/F
#     ylab <- ifelse(input$show_ylab,"Y Axis","")
#     main <- ifelse(input$show_title,"Title","")
#     plot(dataX,dataY,xlab=xlab,ylab=ylab,main=main,xlim=c(-100,100),ylim=c(-100,100))
#   })
# })

# shinyServer(function(input,output){
#   mtcars$mpgsp <- ifelse(mtcars$mpg-20>0,mtcars$mpg-20,0)
#   model1 <- lm(hp~mpg,mtcars)
#   model2 <- lm(hp~mpgsp+mpg,mtcars)
#   #reactive function. Only executes when called. No unnecessary calculation.
#   model1pred <- reactive({
#     mpgInput <- input$sliderMPG
#     predict(model1,newdata=data.frame(mpg=mpgInput))
# 
#   })
#   #reactive function. Only executes when called. No unnecessary calculation.
#   model2pred <- reactive({
#     mpgInput <- input$sliderMPG
#     predict(model2,newdata=data.frame(mpg=mpgInput,mpgsp=ifelse(mpgInput-20>20,mpgInput-20,0)))
# 
#   })
# 
#   output$plot1 <- renderPlot({
#     mpgInput <- input$sliderMPG
#     plot(mtcars$mpg,mtcars$hp,xlab="MPG",ylab="HP",bty="n",pch=16,xlim=c(10,35),ylim=c(50,350))
#     if(input$showModel1){
#       abline(model1,col="red",lwd=2)
#     }
#     if(input$showModel2){
#       model2lines <- predict(model2,newdata=data.frame(mpg=10:35,mpgsp=ifelse(10:35-20>0,10:35-20,0)))
#       lines(10:35,model2lines,col="blue",lwd=2)
#     }
#     legend(25,250,c("Model 1 Prediction","Model 2 Prediction"),pch=16,cex=2,col = c("red","blue"))
#     points(mpgInput,model1pred(),col="red",cex=2,pch=16)
#     points(mpgInput,model2pred(),col="blue",cex=2,pch=16)
#   })
# 
#   output$pred1 <- renderText({
#     model1pred()
#   })
# 
#   output$Rsquare1 <- renderText({
#     summary(model1)$r.squared
#   })
# 
#   output$pred2 <- renderText({
#     #model2pred()
#     mpgInput <- input$sliderMPG
#     predict(model2,newdata=data.frame(mpg=mpgInput,mpgsp=ifelse(mpgInput-20>20,mpgInput-20,0)))
# 
#   })
# 
#   output$Rsquare2 <- renderText({
#     summary(model2)$r.squared
#   })
# 
# })

# shinyServer(function(input,output){
#   library(randomForest)
#   library(caret)
#   data(iris)
#   model <- train(Species~Sepal.Length,data=iris,method="rf")
#   
#   output$Pred <- renderText({
#     as.character(predict(model,newdata=data.frame(Sepal.Length=input$Sepallength)))
#   })
#   
# })

# shinyServer(function(input,output){
#   output$out1 <- renderPlot(hist(rnorm(input$numeric)))
#   output$out2 <- renderText(input$box2)
#   output$out3 <- renderText(input$box3)
# 
# })

shinyServer(function(input,output){
  
  model <- reactive({
    brushed_data <- brushedPoints(mtcars,input$brush1,xvar="disp",yvar="hp")
    if (nrow(brushed_data)<2){
      return(NULL)
    }
    lm(hp~disp,data=brushed_data)
  })

  # output$slopeOut <- renderText({
  #   if(is.null(model())){
  #     "NA"
  #   }else{
  #     model()[[1]][2]#gradient/slope
  #   }
  # })
  #
  # output$intOut <- renderText({
  #   if(is.null(model())){
  #     "NA"
  #   }else{
  #     model()[[1]][1]#intercept
  #   }
  # })
  #
  # output$R2Out <- renderText({
  #   if(is.null(model())){
  #     "NA"
  #   }else{
  #     summary(model())$r.squared#rsquared
  #   }
  # })

  output$table1 <- renderTable({
    if(is.null(model())){
      table <- data.frame(Slope="NA",Intercept="NA",RSquared="NA")
    }else{
      table <- data.frame(Slope=model()[[1]][2],Intercept=model()[[1]][1],RSquared=summary(model())$r.squared)
    }
    table
  },align='c')

  output$plot1 <- renderPlot({
    brushed_data <- brushedPoints(mtcars,input$brush1,xvar="disp",yvar="hp")
    mtcars$Type <- "Data "
    if (nrow(brushed_data)>0){
      brushed_data$Type <- "Brush"
      DT <- rbind(mtcars,brushed_data)
      #DT$Type <- as.factor(DT$Type)
      DT$Type <- factor(DT$Type,levels = c("Data ","Brush"))
    }else{
      DT <- mtcars
    }

    # plot(trees$Girth,trees$Volume)
    # if(!is.null(model())){
    #   points(brushed_data$Girth,brushed_data$Volume,col="blue",cex=1, pch=19)
    #   abline(model(),col="blue")
    # }

    g1 <- ggplot(DT,aes(disp,hp,col=Type))+geom_point()+theme(legend.position="none",axis.text=element_text(size=12), axis.title=element_text(size=14,face="bold"))+
          xlab("Displacement (cu.in.)")+ylab("Horse Power")+theme_bw()+theme(axis.text=element_text(size=12), axis.title=element_text(size=14,face="bold"))
    if(!is.null(model())){
      lm <- model()
      g1 <- g1+geom_abline(intercept = lm$coefficients[1],slope = lm$coefficients[2],col="blue")+
        scale_color_manual(values=c("red", "blue"))
      }
    g1

  })

  output$plot2 <- renderPlot({
    if(is.null(model())){
      par(mfrow=c(1,4))
      plot(1, type="n", xlim=c(0, 10), ylim=c(0, 10),ylab="Residuals",xlab="Fitted values",cex.lab=1.3);title("Residuals vs Fitted", line=0.5, font.main=1,cex.main=1.5)
      plot(1, type="n", xlim=c(0, 10), ylim=c(0, 10),ylab="Standarized residuals",xlab="Theoretical Quantiles",cex.lab=1.3);title("Normal Q-Q", line=0.5, font.main=1,cex.main=1.5)
      plot(1, type="n", xlim=c(0, 10), ylim=c(0, 10),ylab=expression(sqrt("Standarized residuals")),xlab="Fitted Values",cex.lab=1.3);title("Residuals vs Fitted", line=0.5, font.main=1,cex.main=1.5)
      plot(1, type="n", xlim=c(0, 10), ylim=c(0, 10),ylab="Standarized residuals",xlab="Leverage",cex.lab=1.3);title("Residuals vs Leverage", line=0.5, font.main=1,cex.main=1.5)
    }else{
      if(class(try(plot(model()),TRUE))== "try-error"){
        #print("Please select more points")
      }else{
        par(mfrow=c(1,4))
        plot(model(),cex.lab=1.3)
      }
    }
  })

})

######use shiny gadget to render app in R studio#######
#Shiny apps are designed to be used by end users from web
#Shiny Gadgets are intended to be used by R users in R studio(interactive graphics)
# myFirstGadget <- function(){
#   ui <- miniPage(
#     gadgetTitleBar("My first Gadget")
#   )
#   server <- function(input,output,session){
#     observeEvent(input$done,{
#       stopApp()
#     })
#   }
#   runGadget(ui,server)
#   
# }
#myFirstGadget()


# multiplyNumbers <- function(number1,number2){
#   ui <- miniPage(
#     gadgetTitleBar("Multiply two Numbers"),
#     miniContentPanel(
#       selectInput("num1","First Number",choices = number1),#sliderInput
#       selectInput("num2","Second Number",choices = number2)
#     )
#   )
#   
#   server <- function(input,output,session){
#     observeEvent(input$done,{
#       num1 <- as.numeric(input$num1)
#       num2 <- as.numeric(input$num2)
#       stopApp(num1*num2)
#     })
#   }
#   runGadget(ui,server)
# }
# 
# multiplyNumbers(1:10,1:10)

# pickTrees <- function(){
#   ui <- miniPage(
#     gadgetTitleBar("Select points by dragging your Mouse"),
#     miniContentPanel(
#       plotOutput("plot",height="100%",brush="brush")
#     )
#   )
#   
#   server <- function(input,output,session){
#     output$plot <- renderPlot({#use renderVis to render GoogleVis
#       #coltree <- 
#       plot(trees$Girth,trees$Volume,main="Trees!",xlab="Girth",ylab="Volume")
#       brush <- brushedPoints(trees,input$brush,xvar = "Girth",yvar="Volume")
#       if (nrow(brush)>1){
#         points(brush$Girth,brush$Volume,col="red")
#       }
#     })
#     observeEvent(input$done,{
#       stopApp(brushedPoints(trees,input$brush,xvar = "Girth",yvar="Volume"))
#     })
#   }
#   
#   runGadget(ui,server)
# }
# 
# pickTrees()

