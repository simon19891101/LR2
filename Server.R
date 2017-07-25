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


shinyServer(function(input,output){
  
  model <- reactive({
    brushed_data <- brushedPoints(mtcars,input$brush1,xvar="disp",yvar="hp")
    if (nrow(brushed_data)<2){
      return(NULL)
    }
    lm(hp~disp,data=brushed_data)
  })

 
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

