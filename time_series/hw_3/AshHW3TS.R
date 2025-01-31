library(readxl)
library(lubridate)
library(tidyverse)
library(seasonal)
library(forecast)
library(lmtest)
library(zoo)
library(fma)
library(expsmooth)
install.packages("tseries")
library(tseries)

setwd("time_series/hw_2")

# read only the well sheet from excel
well <- read_excel("../F-179.xlsx", sheet = "Well")

well_2 <- well %>% 
  mutate(Corrected = Corrected + 1) %>% 
  group_by(date = as.yearmon(date)) %>% 
  summarise(avg = mean(Corrected))


# created testing set with last 6 months of data
train <- well_2 %>% 
  filter(date <= '2017-12')
test <- anti_join(well_2, train, by = "date")


# make the timeseries object with training data
well_ts_train <- ts(train$avg, start = c(2007,10), frequency = 12)

#ADF test lag 0, 1, 2
adf.test(well_ts_train, alternative = "stationary", k = 0)
adf.test(well_ts_train, alternative = "stationary", k = 1)
adf.test(well_ts_train, alternative = "stationary", k = 2)

#decomposition
decomp_stl <- stl(well_ts_train, s.window = 7)
plot(decomp_stl)

plot(well_ts_train, col = "dark gray", 
     main = "Average Well Depth - Stationary TS", 
     xlab = "", 
     ylab = "Depth (in Feet)", 
     lwd = 2)
lines(decomp_stl$time.series[,2], 
      col = "red", 
      lwd = 2)

#Seasonally Adjusted
seas_well <- well_ts_train - decomp_stl$time.series[,1]
plot(well_ts_train, 
     col = "grey", 
     main = "Average Well Depth - Seasonally Adjusted", 
     xlab = "", 
     ylab = "Depth (in Feet)", 
     lwd = 2)
lines(seas_well, 
      col = "red", 
      lwd = 2)
