########Google vis#########
suppressPackageStartupMessages(library(googleVis))
M <- gvisMotionChart(Fruits,"Fruit","Year",options = list(width=600,height=400))#motionchart
print(M)#render HTML
plot(M,file="M.html")#render APP

G <- gvisGeoChart(Exports,locationvar = "Country",colorvar="Profit",options=list(height=400))
G150 <- gvisGeoChart(Exports,locationvar = "Country",colorvar="Profit",options=list(height=400,region="150"))
plot(G)
print(G)
plot(G150)

T <- gvisTable(Exports,options=list(height=300))
plot(T)

GT <- gvisMerge(G,T,horizontal = FALSE)
pdf("G.pdf",height = 10)
plot(GT)
dev.off()

GTM <- gvisMerge(GT,M,horizontal = TRUE)
plot(GTM)

demo(googleVis)
########Plotly#########
library("plotly")
plot_ly(mtcars,x=~wt,y=~mpg,type="scatter",mode="lines",color = ~as.factor(cyl))#can be saved as html
plot_ly(mtcars,x=~wt,y=~mpg,mode="markers",color = ~disp)#can be saved as html
p <- plot_ly(mtcars,x=~wt,y=~mpg,mode="markers",color = ~as.factor(cyl),size = ~hp, width = 500, height = 500)#can be saved as html
htmlwidgets::saveWidget(as_widget(p), "Plotly.html")

plot_ly(mtcars,x=~wt,y=~mpg,z=~drat,mode="markers",type = "scatter3d", color = ~as.factor(cyl),size=~hp*2)#can be saved as html

#plot_geo(data=Exports,locationcolor=~Profit)
plot_ly(x=~time(airmiles),y=~airmiles,type="scatter",mode="lines")

plot_ly(x=~airmiles,type="histogram")

plot_ly(iris,y=~Petal.Length,color=~Species,type="box")

t1 <- matrix(sort(rnorm(100*100)),nrow=100,ncol=100)
plot_ly(z=~t1,type="heatmap")
plot_ly(z=~t1,type="surface")

state_pop <- data.frame(State=state.abb, Pop = as.vector(state.x77[,1]))
state_pop$hover <- with(state_pop,paste(State,'<br>',"Population:",Pop))#<br> is line break
borders <- list(color = toRGB("red"))
map_options <- list(
  scope='usa',
  projection=list(type='albers usa'),
  showlakes=TRUE,
  lakecolor=toRGB('white')
)
plot_ly(state_pop,z=~Pop,text=~hover,locations=~State,type='choropleth',locationmode='USA-states',
        color=Pop,colors='Blues',marker=list(line=borders)) %>% 
  layout(title='US Population in 1975',geo=p_options)
#use ggplot in plot_ly
g <- ggplot(diamonds,aes(x=carat,y=price))+geom_point(aes(text = paste("Clarity",clarity)))+facet_wrap(~cut)
g
ggplotly(g)#slow

############################
DT <- airquality
DT$Date <- as.Date(paste("1973-",DT$Month,"-",DT$Day,sep=""))
DT$Month <- as.factor(DT$Month)
AQI <- gvisMotionChart(DT,"Month","Date",options = list(width=600,height=400))#motionchart
plot(AQI)

tb <- gvisTable(DT, options=list(page='enable', height='automatic',width='automatic'))

plot(tb)
plot_ly(DT,type = "table")
############################
DT <- mtcars
DT$brand <- sapply(strsplit(rownames(mtcars)," "), "[", 1)
DT$qsecT <- as.ts(DT$qsec)
CAR <- gvisMotionChart(DT,"brand",timevar="qsecT",options = list(width=600,height=400))#motionchart
plot(CAR)
###############################
library(WDI)
# World population total
population = WDI(indicator='SP.POP.TOTL', country="all",start=1990, end=2014)
# GDP in US $
gdp= WDI(indicator='NY.GDP.MKTP.CD', country="all",start=1990, end=2014)
# Life expectancy at birth (Years)
lifeExpectancy= WDI(indicator='SP.DYN.LE00.IN', country="all",start=1990, end=2014)
# pm25
pm25 = WDI(indicator='EN.ATM.PM25.MC.M3', country="all",start=1990, end=2014)
# Renewable electricity output (% of total electricity output)
RE = WDI(indicator='EG.ELC.RNEW.ZS', country="all",start=1990, end=2014)
# Fossil fuel energy consumption (% of total)
FE= WDI(indicator='EG.USE.COMM.FO.ZS', country="all",start=1990, end=2014)

names(population)[3]="Total population"
names(lifeExpectancy)[3]="Life Expectancy (Years)"
names(gdp)[3]="GDP (US$)"
names(pm25)[3]="PM2.5 (mg/m^3)"
names(RE)[3]="Renewable electricity output"
names(FE)[3]="Fossil fuel energy consumption"

j <- join(population,lifeExpectancy)
j <- join(j,gdp)
j <- join(j,pm25)
j <- join(j,RE)
j <- join(j,FE)
DT <- j
Polution <- gvisMotionChart(DT,"country",timevar="year",yvar="PM2.5 (mg/m^3)",xvar="Fossil fuel energy consumption",options = list(width=1000,height=360))#motionchart
#Polution <- gvisMotionChart(DT,"country",timevar="year",options = list(width=1000,height=360))#motionchart
plot(Polution)
print(Polution,file="GoogleVis.html")

tb <- gvisTable(DT,options=list(page='enable', height=150,width='automatic',pageSize=10))
print(tb,file="tb1.html")
#################train models for server##############
download.file("https://archive.ics.uci.edu/ml/machine-learning-databases/car/car.data","car.data")

DT_raw <- read.table("car.data",sep=",")
names(DT_raw) <- c("buying_price","maintenance_cost","doors","passenger_capacity","luggage_capacity","safety","acceptance")
DT <- read.table("car.data",sep=",")
names(DT) <- c("buying price","maintenance cost","doors","passenger capacity","luggage capacity","safety","acceptance")
tb2 <- gvisTable(DT,options=list(page='enable', height=150,width='automatic',pageSize=10))
print(tb2,file="tb2.html")

control <- rfeControl(functions=rfFuncs, method="cv", number=10)
feature <- rfe(DT[,1:6],DT_raw$acceptance,rfeControl = control)

library(doParallel)
cluster <- makeCluster(detectCores()-1)
registerDoParallel(cluster)

ts_SVM <- proc.time()
SVM <- train(acceptance~safety+passenger_capacity+buying_price+maintenance_cost+luggage_capacity,data=DT_raw,method="svmLinear2")
t_SVM <- proc.time()-ts_SVM

ts_RF <- proc.time()
RF <- train(acceptance~safety+passenger_capacity+buying_price+maintenance_cost+luggage_capacity,data=DT_raw)
t_RF <- proc.time()-ts_RF

ts_DTree <- proc.time()
DTree <- train(acceptance~safety+passenger_capacity+buying_price+maintenance_cost+luggage_capacity,data=DT_raw,method="rpart")
t_DTree <- proc.time()-ts_DTree

ts_xgb <- proc.time()
xgb <- train(acceptance~safety+passenger_capacity+buying_price+maintenance_cost+luggage_capacity,data=DT_raw,method="xgbTree")
t_xgb <- proc.time()-ts_xgb

ts_ANN <- proc.time()
ANN <- train(acceptance~safety+passenger_capacity+buying_price+maintenance_cost+luggage_capacity,data=DT_raw,method="nnet")
t_ANN <- proc.time()-ts_ANN

stopCluster(cluster)
registerDoSEQ()


SVMParam <- confusionMatrix(predict(SVM,DT_raw),DT_raw$acceptance)
RFParam <- confusionMatrix(predict(RF,DT_raw),DT_raw$acceptance)
xgbParam <- confusionMatrix(predict(xgb,DT_raw),DT_raw$acceptance)
ANNParam <- confusionMatrix(predict(ANN,DT_raw),DT_raw$acceptance)

Accuracy <- data.frame(Algorithm=character(),Accuracy=numeric(),AccuracyLower=numeric(),AccuracyUpper=numeric())
SVMAccuracy <- data.frame(Algorithm="SVM",Accuracy=SVMParam$overall[1]*100,AccuracyLower=SVMParam$overall[3]*100,AccuracyUpper=SVMParam$overall[4]*100)
RFAccuracy <- data.frame(Algorithm="RF",Accuracy=RFParam$overall[1]*100,AccuracyLower=RFParam$overall[3]*100,AccuracyUpper=RFParam$overall[4]*100)
xgbAccuracy <- data.frame(Algorithm="XGBoost",Accuracy=xgbParam$overall[1]*100,AccuracyLower=xgbParam$overall[3]*100,AccuracyUpper=xgbParam$overall[4]*100)
ANNAccuracy <- data.frame(Algorithm="ANN",Accuracy=ANNParam$overall[1]*100,AccuracyLower=ANNParam$overall[3]*100,AccuracyUpper=ANNParam$overall[4]*100)
Accuracy <- rbind(SVMAccuracy,RFAccuracy,xgbAccuracy,ANNAccuracy)
rownames(Accuracy) <- 1:nrow(Accuracy)

g <- ggplot(Accuracy,aes(Algorithm, Accuracy,color=Algorithm))+geom_point()+geom_errorbar(aes(ymin = AccuracyLower, ymax = AccuracyUpper))+theme_bw()+ylab("Accuracy (%)")
p <- ggplotly(g,width = 600, height = 350)
htmlwidgets::saveWidget(p, "Accuracy.html")

SNS <- data.frame(Algorithm=character(),Sensitivity=numeric(),Specificity=numeric(),Class=character())
SVMSNS <- data.frame(Algorithm=character(),Sensitivity=numeric(),Specificity=numeric(),Class=character())
RFSNS <- data.frame(Algorithm=character(),Sensitivity=numeric(),Specificity=numeric(),Class=character())
xgbSNS <- data.frame(Algorithm=character(),Sensitivity=numeric(),Specificity=numeric(),Class=character())
ANNSNS <- data.frame(Algorithm=character(),Sensitivity=numeric(),Specificity=numeric(),Class=character())
for(i in 1:4){
  SVMSNS <- rbind(SVMSNS,data.frame(Algorithm="SVM", Sensitivity=SVMParam$byClass[i,1]*100,Specificity=SVMParam$byClass[i,2]*100,Class=levels(DT_raw$acceptance)[i]))
  RFSNS <- rbind(RFSNS,data.frame(Algorithm="RF", Sensitivity=RFParam$byClass[i,1]*100,Specificity=RFParam$byClass[i,2]*100,Class=levels(DT_raw$acceptance)[i]))
  xgbSNS <- rbind(xgbSNS,data.frame(Algorithm="XGBoost", Sensitivity=xgbParam$byClass[i,1]*100,Specificity=xgbParam$byClass[i,2]*100,Class=levels(DT_raw$acceptance)[i]))
  ANNSNS <- rbind(ANNSNS,data.frame(Algorithm="ANN", Sensitivity=ANNParam$byClass[i,1]*100,Specificity=ANNParam$byClass[i,2]*100,Class=levels(DT_raw$acceptance)[i]))
}
SNS <- rbind(SVMSNS,RFSNS,xgbSNS,ANNSNS)
rownames(SNS) <- 1:nrow(SNS)


Time <- data.frame(Algorithm=character(),Time=numeric())
Time <- rbind(Time,data.frame(Algorithm="SVM",Time=as.numeric(t_SVM[3])))
Time <- rbind(Time,data.frame(Algorithm="RF",Time=as.numeric(t_RF[3])))
Time <- rbind(Time,data.frame(Algorithm="XGBoost",Time=as.numeric(t_xgb[3])))
Time <- rbind(Time,data.frame(Algorithm="ANN",Time=as.numeric(t_ANN[3])))
names(Time)<-c("Algorithm","Training Time")

save.image("Server.RData")
