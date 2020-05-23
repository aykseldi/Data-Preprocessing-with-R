# Data-Preprocessing-with-R

> This project aims at data preparation and visualization with R. I used ggplot for graphs.

I used  R&D dataset file from the TUIK web site. Each year TUIK announces what statistics about R&D investments of state, private sector and higher education institutions. I tried to figure out whether R&D investment has increased in respect to inflation.  

## Installing / Getting started

First, download the “Araştırma Geliştirme Faaliyetleri İstatistikleri” dataset file from the TUIK web site. (http://www.tuik.gov.tr/PreIstatistikTablo.do?istab_id=1620)



## Developing

Data needs some tidy up. It ıs shown in R code file.

```shell
ggplot(myVisData, aes(x = Year, y = Amount, color = Source)) + 
   geom_line() + 8
   facet_wrap
```

Here what actually happens when you execute the code above. (https://github.com/aykseldi/Data-Preprocessing-with-R/blob/master/ggplot_year_amount.png)

After this initial lookup at data , I took inflation data from here. (https://ekonomiatlasi.com/enflasyon-orani)

Then I put the data in a text file inflation.txt, where columns are separated by tabs, and column names exist.
The decimals must be in English format. 

I Added a new column CumRate to the tibble. CumRate for 2001 is 1.0. For every other year it is defined as follows: 

Year  |	Rate  |	Change
------|-------|-------------
2001  | 68.53 |	29.50
2002  | 29.75 |	-38.78
2003  | 18.36 |	-11.39
2004  | 9.32 	|-9.04
2005  | 7.72 	|-1.60

After taking inflation  into account, our curves have changed dramatically.
(https://github.com/aykseldi/Data-Preprocessing-with-R/blob/master/ggplot_year_amount_with_inflation.png)
2006  | 9.65 	|1.93


## Links

Even though this information can be found inside the project on machine-readable
format like in a .json file, it's good to include a summary of most useful
links to humans using your project. 

- Project homepage: https://github.com/aykseldi/Data-Preprocessing-with-R
- Repository: https://github.com/aykseldi/Data-Preprocessing-with-R
- Issue tracker: https://github.com/aykseldi/Data-Preprocessing-with-R/issues
  - In case of sensitive bugs like security vulnerabilities, please contact
    aykseldi1@yahoo.com directly instead of using issue tracker. We value your effort
    to improve the security and privacy of this project!
- Related projects:
  - My other project: https://github.com/aykseldi/Outlier-Detection-and-Predicting-the-Game-Outcome



## Licensing

"The code in this project is licensed under MIT license."
