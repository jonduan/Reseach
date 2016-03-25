# Import price and export price extraction program for FAO data.


### Load packages


library(dplyr)
library(tidyr) 
library(readxl)
library(knitr)
library(ggplot2)
### load data
dat=read_excel("ProductionDataFAO(2014).xlsx",sheet = 1, col_names = TRUE, col_types = NULL)

# head(dat) # last two columns' name are NA, cause problems.
# last two rows are not info, which cause problems.
dat=dat[-c(nrow(dat)-1,nrow(dat)),-c(ncol(dat)-1,ncol(dat))]
# glimpse(dat)
names(dat)
dat.value=dat %>% select(AreaCode,AreaName,ElementName,Value) %>% 
  tidyr::spread(key = ElementName, value = Value) 
# Error: Duplicate identifiers for rows (1125, 1126), 
# last two rows have to be removed at beginning
# head(dat.value)
# glimpse(dat.value)
# str(dat.value)

dat.Price=dat.value %>% mutate(ImportPrice=`Import Value`/`Import Quantity`, `ExportPrice` =`Export Value`/`Export Quantity`)
# Error: non-numeric argument to binary operator, 
# Use the make.names() function to create safe names; 
# this is used by R too to create identifiers (eg by using underscores for spaces etc)
# If you must, protect the unsafe identifiers with backticks.
#head(dat.Price)


# gather data for ploting

dat.long=dat.Price %>% select(AreaCode,AreaName,Production,ImportPrice,ExportPrice) %>% 
  gather(key=type,value=price,4:5)

## show some outliers
dat.long %>% ggplot(aes(factor(type), price) ) +
  geom_boxplot() 
# log price
dat.long %>% ggplot(aes(factor(type), price) ) +
  geom_boxplot() + scale_y_log10()

# outlier
dat.long %>% ggplot(aes(factor(dat.long$AreaCode), price) ) +
  geom_point(aes(colour = factor(type)))+ 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))



# outlier
dat.long %>% ggplot(aes(factor(dat.long$AreaName), price) ) +
  geom_point(aes(colour = factor(type)))+ 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


# outlier 
dat.long %>% ggplot(aes(Production, price) ) +
  geom_point(aes(colour = factor(type)))
# log price and production
dat.long %>% ggplot(aes(Production, price) ) +
  geom_point(aes(colour = factor(type)))+ scale_y_log10() + scale_x_log10()

# Compare import and export price
dat.long %>%  ggplot(aes(price, fill=type))+ 
  geom_histogram(alpha=0.5, position="identity")


dat.Price %>% ggplot(aes(x=ImportPrice)) +  geom_histogram()

dat.Price %>% ggplot(aes(x=ExportPrice)) +  geom_histogram()


# plot(dat.Price$ImportPrice)
# text(which.max(dat.Price$ImportPrice)+6, 
#         y = dat.Price$ImportPrice[(which.max(dat.Price$ImportPrice))], 
#         labels = dat.Price$AreaName[(which.max(dat.Price$ImportPrice))])
# points(dat.Price$ExportPrice,col = "red3")
# legend("topright", c("ImportPrice","ExportPrice"), pch=c(1,1), col=c("black","red3"))
# 
# 
# boxplot(dat.Price[,c('ImportPrice', 'ExportPrice')])




# dat.Price$ImportPrice[(which.max(dat.Price$ImportPrice))]
# dat.Price$AreaName[(which.max(dat.Price$ImportPrice))]

#source("https://raw.githubusercontent.com/talgalili/R-code-snippets/master/boxplot.with.outlier.label.r") # Load the function

write.csv(dat.Price,"PriceSwanwood2014.csv")

