library('plyr')
library('ggplot2')
library('zoo')
library('lubridate')
library('scales')
#library('dplyr')
library('data.table')
library('stringr')
library('extrafont')
library('ggthemes')



#Add your file location for the graphs
FILE_LOCATION <- ''
WORKING_DIRECTORY <- ''

#height and width of graphs
image_height <- 600
image_width <- 1000



graph_colors <- c("#1BB9EC","#0b1628","#7ed321","#E7AC28","#569117","#666666","#3A65E5","#B548EF","#bf2218","#CF2256","#c7c116")




#Adding footnote to graphs
makeFootnote <- function(footnoteText =
                           format(Sys.time(), "%d %b %Y"),
                         size = 1, color = grey(.5))
  {
    require(grid)
    pushViewport(viewport())
    grid.text(label = footnoteText ,
              x = unit(1,"npc") - unit(2, "mm"),
              y = unit(2, "mm"),
              just = c("right", "bottom"),
              gp = gpar(cex = size, col = color))
    popViewport()
  }



#Cleaning data for combining into one large data set
clean_data <- function(data){
  names(data)[names(data) == 'Time..ms.'] <- 'frame_time'
  setDT(data)
  data[,expected_time := 16.66667 + shift(frame_time)]
  data$miss <- data$frame_time - data$expected_time
  data$actual_time <- data$miss + 16.66667
  if (data$Scenario == "Local"){
    data$Platform[data$Platform == "Steam"] <- "Steam"
  } else {
    data$Platform[data$Platform == "Steam"] <- "Steam + VPN"
  }
  data$Scenario[data$Scenario == "Simple"] <- "No Change To Internet"
  data$Scenario[data$Scenario == "Fifty Percent Out Of Order"] <- "Fifty Percent Out Of Order Packets"
  return(data)
}


#Set your working directory
setwd(WORKING_DIRECTORY)

#parsing CSV files with original FRAPS data
parsec_grid_simple <- read.csv('grid_simple_parsec.csv', header=TRUE, sep=',', strip.white=TRUE, na.strings="", stringsAsFactors=FALSE)
parsec_grid_three <- read.csv('grid_3_loss_parsec.csv', header=TRUE, sep=',', strip.white=TRUE, na.strings="", stringsAsFactors=FALSE)
parsec_grid_fifty <- read.csv('grid_50_oo_parsec.csv', header=TRUE, sep=',', strip.white=TRUE, na.strings="", stringsAsFactors=FALSE)
steam_grid_simple <- read.csv('grid_simple_steam.csv', header=TRUE, sep=',', strip.white=TRUE, na.strings="", stringsAsFactors=FALSE)
steam_grid_three <- read.csv('grid_3_loss_steam.csv', header=TRUE, sep=',', strip.white=TRUE, na.strings="", stringsAsFactors=FALSE)
steam_grid_fifty <- read.csv('grid_50_oo_steam.csv', header=TRUE, sep=',', strip.white=TRUE, na.strings="", stringsAsFactors=FALSE)
parsec_tr_simple <- read.csv('tomb_raider_simple_parsec.csv', header=TRUE, sep=',', strip.white=TRUE, na.strings="", stringsAsFactors=FALSE)
parsec_tr_three <- read.csv('tomb_raider_3_loss_parsec.csv', header=TRUE, sep=',', strip.white=TRUE, na.strings="", stringsAsFactors=FALSE)
parsec_tr_fifty <- read.csv('tomb_raider_50_oo_parsec.csv', header=TRUE, sep=',', strip.white=TRUE, na.strings="", stringsAsFactors=FALSE)
steam_tr_simple <- read.csv('tomb_raider_simple_steam.csv', header=TRUE, sep=',', strip.white=TRUE, na.strings="", stringsAsFactors=FALSE)
steam_tr_three <- read.csv('tomb_raider_3_loss_steam.csv', header=TRUE, sep=',', strip.white=TRUE, na.strings="", stringsAsFactors=FALSE)
steam_tr_fifty <- read.csv('tomb_raider_50_oo_steam.csv', header=TRUE, sep=',', strip.white=TRUE, na.strings="", stringsAsFactors=FALSE)
parsec_jc_simple <- read.csv('just_cause_simple_parsec.csv', header=TRUE, sep=',', strip.white=TRUE, na.strings="", stringsAsFactors=FALSE)
steam_jc_simple <- read.csv('just_cause_simple_steam.csv', header=TRUE, sep=',', strip.white=TRUE, na.strings="", stringsAsFactors=FALSE)

parsec_grid_local <- read.csv('Grid_local_parsec.csv', header=TRUE, sep=',', strip.white=TRUE, na.strings="", stringsAsFactors=FALSE)
parsec_tr_local <- read.csv('tomb_raider_local_parsec.csv', header=TRUE, sep=',', strip.white=TRUE, na.strings="", stringsAsFactors=FALSE)
steam_grid_local <- read.csv('Grid_local_steam.csv', header=TRUE, sep=',', strip.white=TRUE, na.strings="", stringsAsFactors=FALSE)
steam_tr_local <- read.csv('tomb_raider_local_steam.csv', header=TRUE, sep=',', strip.white=TRUE, na.strings="", stringsAsFactors=FALSE)


#cleaning original data
parsec_grid_simple <- clean_data(parsec_grid_simple) 
parsec_grid_three <- clean_data(parsec_grid_three)
parsec_grid_fifty <- clean_data(parsec_grid_fifty)
steam_grid_simple <- clean_data(steam_grid_simple)
steam_grid_three <- clean_data(steam_grid_three)
steam_grid_fifty <- clean_data(steam_grid_fifty)
parsec_tr_simple <- clean_data(parsec_tr_simple)
parsec_tr_three <- clean_data(parsec_tr_three)
parsec_tr_fifty <- clean_data(parsec_tr_fifty)
steam_tr_simple <- clean_data(steam_tr_simple)
steam_tr_three <- clean_data(steam_tr_three)
steam_tr_fifty <- clean_data(steam_tr_fifty)
parsec_jc_simple <- clean_data(parsec_jc_simple)
steam_jc_simple <- clean_data(steam_jc_simple)

parsec_grid_local <- clean_data(parsec_grid_local)
parsec_tr_local <- clean_data(parsec_tr_local)
steam_grid_local <- clean_data(steam_grid_local)
steam_tr_local <- clean_data(steam_tr_local)


#combining cleaned data into one datatable
data <- do.call("rbind", list(
  parsec_grid_simple,
  parsec_grid_three,
  parsec_grid_fifty,
  steam_grid_simple,
  steam_grid_three,
  steam_grid_fifty,
  parsec_tr_simple,
  parsec_tr_three,
  parsec_tr_fifty,
  steam_tr_simple,
  steam_tr_three,
  steam_tr_fifty,
  parsec_jc_simple,
  steam_jc_simple,
  parsec_grid_local,
  parsec_tr_local,
  steam_grid_local,
  steam_tr_local
))





#Data subsets
#########scenarios
simple <- subset(data, data$Scenario=='No Change To Internet')
three <- subset(data, data$Scenario=='Three Percent Loss')
fifty <- subset(data, data$Scenario=='Fifty Percent Out Of Order Packets')
local <- subset(data, data$Scenario=='Local')

#########games
grid_game <- subset(data, data$Game=='GRID')
just_cause <- subset(data, data$Game=='Just Cause 3')
tomb_raider <- subset(data, data$Game=='Tomb Raider 2013')

#########platforms
parsec <- subset(data, data$Platform=='Parsec')
steam <- subset(data, data$Platform=='Steam')


#Graphs
#########Platform Histogram

scenarios <- list("No Change To Internet","Three Percent Loss","Fifty Percent Out Of Order Packets", "Local") 

for (i in scenarios){
  dataset <- subset(data, data$Scenario == i)  

    p <- ggplot()+geom_density(data=dataset,aes(x=actual_time,group=Platform,fill=Platform),alpha=0.5)+scale_x_continuous(breaks=seq(14.67,18.67,1), limits = c(14.67,18.67))
    p <- p +theme(
      legend.title=element_blank(), 
      axis.ticks.y = element_blank(),
      axis.text.y = element_blank(),
      text=element_text(family="Gill Sans MT",size=13),
      plot.background=element_rect(colour="#f7f7f7",fill="#f7f7f7"),
      panel.background=element_rect(colour="#f7f7f7",fill="#f7f7f7"),
      legend.background=element_rect(colour="#f7f7f7",fill="#f7f7f7"))+scale_fill_manual(values=graph_colors)
    p <- p+ labs(title = paste("Frames Delivered At 16.67ms (60 FPS) With",i, sep=" "), x = 'Milliseconds After Last Frame', y = 'Likelihood Frame Captured At 60 FPS')
    jpeg(file=paste(FILE_LOCATION,i,"platform_density.jpg", sep=""), width=image_width, height=image_height)
    print(p)
    makeFootnote("Credit: Parsec.tv", color = "#0b1628")
    dev.off()
}
#########Platform Scatterplot

for (i in scenarios){
  dataset <- subset(data, data$Scenario == i)  
    p <- ggplot(dataset, aes(x=Frame, y=actual_time))+scale_y_continuous(breaks=seq(10.67,20.67,1), limits = c(10.67,20.67))
    d <- p + geom_point(aes(colour=Platform))+stat_smooth(aes(colour=Platform))
    d <- d +theme(
      legend.title=element_blank(), 
      text=element_text(family="Gill Sans MT",size=20),
      plot.background=element_rect(colour="#f7f7f7",fill="#f7f7f7"),
      panel.background=element_rect(colour="#f7f7f7",fill="#f7f7f7"),
      legend.background=element_rect(colour="#f7f7f7",fill="#f7f7f7"))+scale_colour_manual(values=graph_colors)
    d <- d+ labs(title = paste("Milliseconds Between Each Frame With",i,sep=" "), x = 'Frame', y = 'Milliseconds')
    jpeg(file=paste(FILE_LOCATION,i,"_scenario_scatter.jpg", sep=""), width=image_width, height=image_height)
    print(d)
    makeFootnote("Credit: Parsec.tv", color = "black")
    dev.off()
}
#####Games graphs
games <- list('GRID', 'Tomb Raider 2013', 'Just Cause 3')

for (i in games){
  interim_data <- subset(data, data$Game == i)
  if (i == 'Just Cause 3') {
    scenarios <- list("No Change To Internet")
  } else {
    scenarios <- list("No Change To Internet","Three Percent Loss","Fifty Percent Out Of Order Packets") 
  }
  for (s in scenarios){
    dataset <- subset(interim_data, interim_data$Scenario == s)
    p <- ggplot()+geom_density(data=dataset,aes(x=actual_time,group=Platform,fill=Platform),alpha=0.5)+scale_x_continuous(breaks=seq(14.67,18.67,1), limits = c(14.67,18.67))
    p <- p +theme(
      legend.title=element_blank(), 
      axis.ticks.y = element_blank(),
      axis.text.y = element_blank(),
      text=element_text(family="Gill Sans MT",size=13),
      plot.background=element_rect(colour="#f7f7f7",fill="#f7f7f7"),
      panel.background=element_rect(colour="#f7f7f7",fill="#f7f7f7"),
      legend.background=element_rect(colour="#f7f7f7",fill="#f7f7f7"))+scale_fill_manual(values=graph_colors)
    p <- p+ labs(title = paste("Frames Delivered At 16.67ms (60 FPS) Playing",i,"With",s, sep=" "), x = 'Milliseconds After Last Frame', y = 'Likelihood Frame Captured At 60 FPS')
    jpeg(file=paste(FILE_LOCATION,i,"platform_density_",s,".jpg", sep=""), width=image_width, height=image_height)
    print(p)
    makeFootnote("Credit: Parsec.tv", color = "#0b1628")
    dev.off()
  }
}
