# load required libraries
library(tidyverse)
library(ggplot2)
library(caret)
library(mgcv)
library(ggthemes)

# load data
df <- as.data.frame(X_dffinal)
head(df)

# predictor variable analysis
ggplot(df, aes(x=rswp)) +
        geom_histogram(aes(y=..density..), bins=15, fill="steel blue",
                       color = "white") +
        geom_density(color="red") + theme_few() +
        ggtitle("Density Histogram of Regular Season Win Percentage")

ggplot(df, aes(sample=rswp)) +
        stat_qq(aes(sample=rswp), color="steel blue")+ 
        theme_few()+
        ggtitle("RSWP Quantile Plot")
        
#After looking at histogram and quantile plot can conclude that rswp 
# follows assumption of normality


