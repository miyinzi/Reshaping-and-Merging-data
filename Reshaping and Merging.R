#***********************************************************************************************************
#***********************************************************************************************************

# Collapsing Data to compute Household size 
#Chris Miyinzi Mwungu
#06/05/2017

#***********************************************************************************************************
#Installing required libraries
#install.packages("plyr")
#install.packages("dplyr")
#install.packages("reshape")

library(plyr) #Useful to process matrix
library(dplyr) 
library(reshape)

#Clearing all objects in the memory
rm(list=ls())  

#Setting working directory
setwd("C:/Users/cmwungu/Desktop/Reshaping and Merging data") 

#Importing the CSV

dataset_wide <- read.csv("dataset_wide.csv", header = T,sep = ",")

#Understanding your data
summary(dataset_wide) #Generate basic descriptives
glimpse(dataset_wide) #Structure of the data
head(dataset_wide) # Prints the first 6 observations
tail(dataset_wide) # Prints the last 6 observations

#Reshaping from wide to long in R 

dataset_long_new <- reshape( dataset_wide, idvar = "id_event",varying = list(2:7,8:13,14:19),
                  v.names=c("n_amount","p_amount","k_amount"),direction = "long")

View(dataset_long_new)

#Removing missing values (na.omit)
dataset_long_new1 <- dataset_long_new[complete.cases(dataset_long_new),]

dataset_long_final <- ddply(dataset_long_new1,~id_event,summarise,accum_N=sum(n_amount),
                  accum_p=sum(p_amount),accum_k=sum(k_amount),freqfert=length(n_amount))

#Merging Data in R
#Here we merge dataset_long_final and yield_inf imported below 
yield_info <- read.csv("yield_inf.csv")

merged_data <- merge(yield_info,dataset_long_final,by.x= "id",by.y = "id_event",all.x=F,all.y = T)

#Saving final dataset in CSV
write.csv(merged_data,"merged_data.csv")


#Reshaping from long to wide
data_set_long <- read.csv("dataset_long.csv")

# rm(data_set_wide)
data_set_wide_final <- reshape(data_set_long,idvar = "id_event",
                         v.names = c("amount_ton_N","amount_ton_P_ha","amount_ton_K_ha"),
                         timevar = "time",direction = "wide")

#Saving final dataset in CSV
write.csv(data_set_wide_final,"data_set_wide_final.csv")


#***********************************************************************************************************

# End of Code!

#***********************************************************************************************************


