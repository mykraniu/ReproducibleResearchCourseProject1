setwd('~/git/ReproducibleResearchCourseProject1')
rm(list=ls())

# Libraries
library(ggplot2)
library(dplyr)
library(lubridate)


# 1. Load data
activity <- read.csv('activity.csv')
# Set Date
activity <- activity %>%
  mutate( date=as.Date(date) )

# 2. Plot histogram of the number of steps each day
g <- ggplot( data=activity, aes(date,steps) )
g + geom_bar( stat="sum" ) + labs( title="Steps taken each day", x="Date", y="Steps" )
ggsave('daily.steps.png')


# 3. Get mean and median of steps each day (across 5 minute intervals)
activity.means <- activity %>%
  filter( !is.na(steps) ) %>%
  group_by( date ) %>%
  summarize( mean.steps=mean(steps), median.steps=median(steps) )

# Write out the CSV with activity means and medians
write.csv(activity.means,'activity.means.csv',row.names = FALSE)


# 4. Plot the average steps per day for a 5 minute interval
g <- ggplot( data=activity.means, aes(date,mean.steps) )
g + geom_line() + labs( title="Average steps taken each day during a 5 minute period", x="Date", y="Average Steps" )
ggsave('average.daily.steps.png')


# 5. The 5-minute interval that, on average, contains the maximum number of steps
activity.interval.means <- activity %>%
  filter(!is.na(steps)) %>%
  group_by(interval) %>%
  summarize( mean.steps=mean(steps) )

activity.interval.max <- activity.interval.means %>%
  filter( mean.steps==max(mean.steps) )
  

print('Interval With the maximum average number of steps')
print(activity.interval.max$interval)




# Print a histogram of the intervals
g <- ggplot( data=activity.interval.means, aes(interval,mean.steps) )
g + geom_bar( stat="sum" ) + labs( title="Average Steps taken each Interval", x="Interval", y="Steps" ) +
  geom_hline(yintercept=activity.interval.max$mean.steps, linetype='dashed', color='red') +
  geom_vline(xintercept=activity.interval.max$interval, linetype='dashed', color='red')
ggsave('interval.steps.png')



# 6. Code to describe and show a strategy for imputing missing data

# lookup- missing values
activity.missing.vals <- activity %>%
  filter(is.na(steps))


# * Mean: the mean of the observed values for that variable
#    We can use the mean data points from either interval or from date
#    We cannot use the mean data points from the date as only a fraction of dates have missing values.
#    We will use the mean data poiints from interval as this gives a better sample.

# Convert interval means to a named numeric that we can lookup
int.m <- activity.interval.means$mean.steps
names(int.m) <- activity.interval.means$interval

# Fill in the empty steps with the mean
activity[is.na(activity$steps),'steps'] <- int.m[as.character(activity[is.na(activity$steps),'interval'])] 




# 7. Histogram of the total number of steps taken each day after missing values are imputed
g <- ggplot( data=activity, aes(date,steps) )
g + geom_bar( stat="sum" ) + labs( title="Steps taken each day (after imputing)", x="Date", y="Steps" )
ggsave('daily.steps.post.impute.png')



# Panel plot comparing the average number of steps taken per 5-minute interval across weekdays and weekends

# 8. Add a weekday/weekend label to activity.interval.means
weekdays <- c('Mon','Tue','Wed','Thu','Fri')
activity <- activity %>%
  mutate ( wday = lubridate::wday(date,label=TRUE) ) %>%
  mutate ( wday.wend = ifelse( wday %in% weekdays, 'weekday', 'weekend' ) )



# The 5-minute interval that, on average, contains the maximum number of steps
activity.interval.means <- activity %>%
  group_by(interval,wday.wend) %>%
  summarize( mean.steps=mean(steps) )



g <- ggplot( data=activity.interval.means, aes(interval,mean.steps) )
g + geom_bar( stat="sum" ) + 
  facet_grid(.~wday.wend) +
  labs( title="Average Steps taken each Interval\nWeekday vs Weekend", x="Interval", y="Steps" )
ggsave('average.steps.interval.wday,wend.png')






