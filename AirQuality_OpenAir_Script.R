library(openair)
View(squareB_for_paper_MOYO_dry_seasons_)

data(squareB_for_paper_MOYO)

library(openair) # load openair
data(squareB_for_paper_MOYO) ## make sure data that comes with openair is loaded
summaryPlot(squareB_for_paper_MOYO, 
            period = "months", 
            ylab = "Parameters",
            fontsize = 10,
            main = "Summary Plot of Parameters")
## date1 date2 NO2 O3 NO PM1
## "POSIXct" "POSIXt" "integer" "integer" "integer" "integer"
## PM2.5 PM10
## "numeric" "numeric"

## make sure squareB_for_paper_MOYO is loaded
library(openair)
library(latticeExtra)
timePlot(selectByDate(squareB_for_paper_MOYO),
         fontsize = 8,
         main = "Time Plot of Parameters",
         pollutant = c("NO2"),
         month = "dec")

timePlot(selectByDate(squareB_for_paper_MOYO),
         fontsize = 8,
         main = "Time Plot of Parameters",
         pollutant = c("O3", "NO"),
         month = "dec")

timePlot(selectByDate(squareB_for_paper_MOYO),
         fontsize = 8,
         main = "Time Plot of Parameters",
         pollutant = c("PM1","PM2.5", "PM10"),
         month = "dec")

timePlot(selectByDate(squareB_for_paper_MOYO),
         fontsize = 8,
         main = "Time Plot of Parameters",
         pollutant = c("Ambient.temp", "Ambient.humid"),
         month = "dec")

calendarPlot(squareB_for_paper_MOYO, 
             pollutant = "PM10", 
             annotate = "value",
             breaks = c(0, 15, 45, 5000),
             fontsize = 10,
             labels = c("Below WHO annual threshold < 15", 
                        "Below WHO daily threshold < 45", 
                        "Above WHO daily threshold > 45"),
             cols = "Purples", 
             col.lim = c("black", "orange"),
             key.footer = "PM10 (ug/m3)",
             main = "Daily Pollutant Concentrations",
             layout = c(4, 3))

## split data into two periods (see Utlities section for more details)
squareB_for_paper_MOYO <- splitByDate(squareB_for_paper_MOYO,
                                      dates= "1/11/2020",
                                      labels = c("Wet Seasons", "Dry Seasons"))

timeVariation(squareB_for_paper_MOYO, 
              pollutant = c("NO2"),
              group = "split.by",
              normalise = TRUE)

## select all of 2020
SiteData <- selectByDate(squareB_for_paper_MOYO, start = "2020/06/07", end = "2020/09/30")
head(data.2020)

## split data into two periods (see Utlities section for more details)
squareB_for_paper_MOYO <- splitByDate(squareB_for_paper_MOYO, dates= "1/1/2021",
                      labels = c("before Jan. 2021", "After Jan. 2021"))
timeVariation(squareB_for_paper_MOYO, 
              pollutant = "NO2", 
              group = "split.by", 
              normalise = TRUE)

timeVariation(squareB_for_paper_MOYO_wet_seasons_, 
              pollutant = c("NO", "O3", "NO2", "PM1", "PM2.5", "PM10"),
              main = "Pollutants during Wet Seasons",
              normalise = TRUE)

timeVariation(squareB_for_paper_MOYO_dry_seasons_, 
              pollutant = c("NO", "O3", "NO2", "PM1", "PM2.5", "PM10"),
              main = "Pollutants during Dry Seasons",
              normalise = TRUE)

scatterPlot(squareB_for_paper_MOYO,
            linear = TRUE,
            y = c("O3"),
            x = "Ambient.humid",
            xlab = "Ambient Humidity",
            ylab = "O3",
            main = "Plot of O3 vs Ambient Humidity")

scatterPlot(squareB_for_paper_MOYO,
            linear = TRUE,
            y = c("NO2"),
            x = "Ambient.temp",
            xlab = "Ambient Temperature",
            ylab = "NO2",
            main = "Plot of NO2 vs Ambient Temperature")

corPlot(squareB_for_paper_MOYO, 
        pollutants = c("NO", "O3", "NO2","PM1","PM2.5", "PM10", "Ambient.temp"),
        Main = "Correlation Plot between Ambient Temperature and Pollutants",
        xlab = "Parameters",
        ylab = "Parameters",
        dendrogram = TRUE)

## select all of 2020
data.2020 <- selectByDate(squareB_for_paper_MOYO, start = "1/7/2020", end = "1/10/2020")
head(data.2020)

## select all of 202021
data.202021 <- selectByDate(squareB_for_paper_MOYO, start = "2/10/2020", end = "1/4/2021")
head(data.202021)

## select all of 2021
data.2021 <- selectByDate(squareB_for_paper_MOYO, start = "2/4/2021", end = "30/6/2021")
head(data.2021)

## split data into two periods (see Utlities section for more details)
squareB_for_paper_MOYO <- splitByDate(squareB_for_paper_MOYO, dates= "1/1/2021",
                      labels = c("before Jan. 2021", "After Jan. 2021"))