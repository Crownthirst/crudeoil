library(tidyverse)
library(gganimate)
library(lubridate)
library(janitor)
library(Cairo)

#read in data
c <- read.csv("CrudeOilPrice.csv", row.names = NULL)
#modify column names
colnames(c) <- colnames(c)[2:ncol(c)]

#drop last column
c <- c[1:(ncol(c)-1)]

#clean column names
c <- clean_names(c)

#format date
c$date <- mdy(c$date)
#create new column that contains year
c$year <- year(c$date)

#create a plot
co <- ggplot(c, aes(date, crude_oil_price_in_usd))+
  geom_line(size = 0.8)+
  labs(title = "CRUDE OIL PRICE IN USD FROM 2009 TILL DATE",
       subtitle = " 
       
       Crude Oil Price as at : {format(frame_along, '%b - %Y')}
       
       ",
       caption = "@Crownthirst | R(gganimate) |Data: Central Bank Of Nigeria",
       x = "Year", 
       y = "Crude Oil Price in USD")+
  scale_x_date(date_breaks = "2 years", date_labels = "%Y")+
  transition_reveal(date)+
  geom_text(aes(label = "Price"))+
  theme_minimal()+
  theme(plot.title = element_text(size= 15, face = "bold"),
        plot.subtitle = element_text(size = 10),
        plot.caption = element_text(size = 10),
        axis.title = element_text(size = 20),
        axis.text = element_text(size = 15))

crude <- animate(co, width = 900, duration = 30, fps = 20, 
                 renderer = gifski_renderer(), start_pause = 10, 
                 end_pause = 20, device = "png")