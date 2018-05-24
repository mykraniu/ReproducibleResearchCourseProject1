setwd('~/git/ReproducibleResearchCourseProject1')
rm(list=ls())

# Libraries
library(ggplot2)
library(dplyr)


# Load data
activity <- read.csv('activity.csv')
# Set Date
activity <- activity %>%
  mutate( date=as.Date(date) )

# Plot histogram of the number of steps each day
g <- ggplot( data=activity, aes(date,steps) )
g + geom_bar( stat="sum" ) + labs( title="Steps taken each day", x="Date", y="Steps" )


# Get mean and median of steps each day (across 5 minute intervals)
activity.means <- activity %>%
  filter( !is.na(steps) ) %>%
  group_by( date ) %>%
  summarize( mean.steps=mean(steps), median.steps=median(steps) )


# Plot the average steps per day for a 5 minute interval
g <- ggplot( data=activity.means, aes(date,mean.steps) )
g + geom_line() + labs( title="Average steps taken each day during a 5 minute period", x="Date", y="Average Steps" )


# 







