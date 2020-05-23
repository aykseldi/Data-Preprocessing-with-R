#################          #################
################ Section 2 #################
#Library loading
#Kütüphanelerin yüklenmesi 
library(data.table)
library(tibble)
library(dplyr)
library(tidyr)
library(ggplot2)
library("readxl")
library(readr)
#################          #################
################ Section 3 #################
#Data Loading
#Arge datasını yükleme

raw_data <- read_excel("/home/aty/R//arge.xls",range = "C3:S27", col_names = FALSE)
raw_data[1:5,1:5]
ncol(raw_data)

#################          #################
################ Section 4 #################
#Data tranposed
#Data tranpose edildi

raw_data <- transpose(raw_data)

#Year variable is added
# Dataya Yıl değişkeni eklendi

raw_data["Year"] <- c(2001:2017)
# Colum names has been added
#Datadaki değişken isimleri düzenlendi
colnames(raw_data) <- c("GERD/GDP"   ,"Overall_Total","Overall_Labour" ,"Overall_Other","Overall_Capital","Corporations_Total" ,"Corporations_Labour","Corporations_Other","Corporations_Capital" ,"Government_Total"  ,"Government_Labour" ,"Government_Other","Government_Capital","HigherEducation_Total"  ,   "HigherEducation_Labour","HigherEducation_Other","HigherEducation_Capital", "HeadCount_Total", "HeadCount_Corporations" ,"HeadCount_Government" , "HeadCount_HigherEducation","FTE_Total" ,"FTE_Corporations",  "FTE_Government" ,"FTE_HigherEducati", "Year")
#Transformed to Tibble
#Data tibble formatına dönüştürüldü
my_data <- as_tibble(raw_data)
# Year variable set at first on order.
#Yıl değişkeni en başa alındı 
my_data <- my_data [, c(26,1:25)]
head(my_data)
nrow(my_data)
ncol(my_data)

#Datanın son hali gösterildi. 
head(my_data[,c(1,4,9,18)])
# “GERD/GDP”, “HeadCount_X” and “FTE_X” adlı değişkenlerin bulunmasi

#################          #################
################ Section 5 #################

# Finding indexes of  “GERD/GDP”, “HeadCount_X” and “FTE_X” columns 
# “GERD/GDP”, “HeadCount_X” ve “FTE_X” adlı değişkenlerin indexlerinin bulunması 

# With the matches function, we cen find indexes of variable we are looking for.
#Match fonksiyonu ile bizim kriterlerimize uyan değişken isimlerinin indexleri bulunur
matches <- c(c(names(my_data ) %>% contains(match = "HeadCount_",ignore.case = T)),c( names(my_data ) %>% contains(match = "FTE_",ignore.case = T)),c(names(my_data ) %>% contains(match = "GERD/GDP",ignore.case = T)))

#Removing “GERD/GDP”, “HeadCount_X” and “FTE_X” columns from dataset
# “GERD/GDP”, “HeadCount_X” and “FTE_X” adlı değişkenlerin datasetten kaldırılması.

my_data[matches] <- NULL
# Using gather for tidying data
#Datanın gather ile düzenlenmesi
head(my_data)
my_data <- my_data %>% gather(key = Source, value = Amount, Overall_Total: HigherEducation_Capital)
head(my_data)
# Sperating data according to Source varible. delimiter is _ 
# Datanın seperate ile source ve amount alanlarına seperate fonksiyonu ile ayrılması 
mytidydata <- my_data %>% separate   (col = Source, into = c("Source","Type"), remove = T,sep = "_",convert = F)
head(mytidydata)
#Datanın son durumu 
mytidydata[c(1,25,57,179,253),]


#################          #################
################ Section 6 #################
#Subset your dataset such that it doesn’t contain any row with (Type == “Total”) or (Source == “Overall”)
# Total ve Overall içeren gözlemlerin temizlenmesi
myVisData <- mytidydata%>% 
  filter(Type != "Total") %>%
  filter(Source != "Overall")
head(myVisData)
#Visualization of myVisData 
ggplot(myVisData, aes(x = Year, y = Amount, color = Source)) + 
  geom_line() + 
  facet_wrap( ~ Type)
# Importing Inflation data 
#Enflasyon verisinin txt dosyasından okunması
inflation <- read_delim("/home/aty/R/outfile.txt",delim =  "\t", escape_double = FALSE, trim_ws = TRUE)
head(inflation)

inflation$Change <- NULL
inflation$Rate <- ((inflation$Rate/100)+100)/100
head(inflation) 
str(inflation)
inflation$CumRate <- 0


#Setting first year (2001) as base for inflation total affect so CumRate of year 2001 is set to 1 
# 2001 yılı baz olarak alınmıştır. 
inflation[1,"CumRate"] <- 1

# Enflasyonun kümülatif etkisi hesaplanmıştır.
# Cumulative Rate for Inflation is calculated. 
for (i in 2:17){
  inflation[i,"CumRate"] <- inflation[i-1,"CumRate"] *   inflation[i-1,"Rate"]
  i <- i+1
}

head(inflation)
myVisData <- merge(x = myVisData, y = inflation[, c("Year", "CumRate")], by = "Year" )


myVisData$Amount <- myVisData$Amount/myVisData$CumRate
head(myVisData)


ggplot(myVisData, aes(x = Year, y = Amount, color = Source)) + 
  geom_line() + 
  facet_wrap( ~ Type)
