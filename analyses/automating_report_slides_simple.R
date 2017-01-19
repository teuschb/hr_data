

mydata <- read.csv("https://raw.githubusercontent.com/teuschb/hr_data/master/datasets/modified_watson_dataset.csv",
                   stringsAsFactors = FALSE)


month = "November"
date = "November 2016"







require(rJava)
system("java -version")
if (!require('ReporteRs')) {
  install.packages("ReporteRs")
}


library(ReporteRs)
library(ggplot2)
library(scales)
library(magrittr)


overall_attrition <- as.data.frame(as.list(aggregate(Attrition ~ Department,
                                                     data = mydata,
                                                     FUN = function(x) c(
                                                       n = length(x),
                                                       s = sum(x, na.rm = T),
                                                       mn = mean(x, na.rm = T)))), stringsAsFactors = F)


overall_attrition <- rbind(overall_attrition, c(
  0, # to be replaced with the word "Total"
  sum(overall_attrition$Attrition.n),
  sum(overall_attrition$Attrition.s),
  mean(overall_attrition$Attrition.mn)))
overall_attrition[nrow(overall_attrition),1] <- 'Total'


# format as percentages, rename columns
overall_attrition$Attrition.mn <- percent(as.numeric(overall_attrition$Attrition.mn))
names(overall_attrition) <- c('Department', 'Headcount', 'Attrition', 'Attrition %')

# put data into a table
options("ReporteRs-fontsize"=24) # you can adjust the font size
overall_attrition_table_simple <- vanilla.table(overall_attrition)
overall_attrition_table_simple


jobrole_attrition <- as.data.frame(as.list(aggregate(Attrition ~ JobRole,
                                                     data = mydata,
                                                     FUN = function(x) c(
                                                       n = length(x),
                                                       s = sum(x, na.rm = T),
                                                       mn = mean(x, na.rm = T)))))

names(jobrole_attrition) = c('JobRole', 'Headcount', 'Attrition', 'AttritionRate')


(jobrole_attrition_plot_simple <- ggplot(jobrole_attrition, aes(JobRole, AttritionRate)) +
    geom_col() +
    scale_y_continuous(labels = percent) +
    labs(list(y = paste("Attrition in ", month, sep = ""), x = "Job Role",
              title = paste("Attrition by Job Role, ", date, sep = ""))) +
    coord_flip())

jobrole_attrition <- jobrole_attrition[order(jobrole_attrition$AttritionRate, decreasing = TRUE),]

reduction = .02            # how much could we reduce attrition?
replacement_cost = 1       # how much does it cost to replace an employee, as a multiplier of their salary?
top_role <- as.character(jobrole_attrition$JobRole[1])   # job role with highest attrition
top_role_attrition <- jobrole_attrition$AttritionRate[1] # attrition for that role
salary_lost = 
  sum(mydata$MonthlyIncome[mydata$JobRole == top_role & mydata$Attrition == 1]) * 12 * # total annual salary lost 
  replacement_cost                                                                     # times replacement cost
impact = salary_lost - (salary_lost/top_role_attrition) * (top_role_attrition - reduction) # amount we could save

# format as percentages, rename columns
jobrole_attrition$AttritionRate <- percent(jobrole_attrition$AttritionRate)
names(jobrole_attrition) = c('Job Role', 'Headcount', 'Attrition', 'Attrition %')

# put data into a table
options("ReporteRs-fontsize"=16) #using a smaller font
(jobrole_attrition_table_simple <- vanilla.table(jobrole_attrition))

performance_attrition <- as.data.frame(as.list(aggregate(Attrition ~ PerformanceRating,
                                                         data = mydata, FUN = function(x) c(
                                                           n = length(x),
                                                           s = sum(x, na.rm = T),
                                                           mn = mean(x, na.rm = T)))))

names(performance_attrition) = c('PerformanceRating', 'Headcount', 'Attrition', 'AttritionRate')

(performance_attrition_plot_simple <- ggplot(performance_attrition, aes(PerformanceRating, AttritionRate)) +
    geom_bar(stat = "identity") +
    scale_y_continuous(labels=percent) +
    scale_x_reverse() + 
    labs(list(y = paste("Attrition in ", month, sep = ""),
              x = "Performance Rating",
              title = paste("Attrition by Performance Rating, ", date, sep = ""))) +
    coord_flip())

# format as percentages, rename columns
performance_attrition$AttritionRate <- percent(performance_attrition$AttritionRate)
names(performance_attrition) = c('Performance Rating', 'Headcount', 'Attrition', 'Attrition %')

# put data into a table
(performance_attrition_table_simple <- vanilla.table(performance_attrition))

hiresource_attrition <- as.data.frame(as.list(aggregate(Attrition ~ HireSource, data = mydata,
                                                        FUN = function(x) c(n = length(x),
                                                                            s = sum(x, na.rm = T),
                                                                            mn = mean(x, na.rm = T)) )))

names(hiresource_attrition) = c('HireSource', 'Headcount', 'Attrition', 'AttritionRate')

(hiresource_attrition_plot_simple <- ggplot(hiresource_attrition, aes(HireSource, AttritionRate)) +
    geom_bar(stat = "identity") +
    scale_y_continuous(labels = percent) +
    labs(list(y = paste("Attrition in ", month, sep = ""),
              x = "Job Level",
              title = paste("Attrition by Recruiting Channel, ", date, sep = ""))) +
    coord_flip())

# sort by attrition rate, format as percentages, rename columns
hiresource_attrition <- hiresource_attrition[order(hiresource_attrition$AttritionRate, decreasing = TRUE),]
hiresource_attrition$AttritionRate <- percent(hiresource_attrition$AttritionRate)
names(hiresource_attrition) = c('Recruiting Channel', 'Headcount', 'Attrition', 'Attrition %')

# put data into a table 
(hiresource_attrition_table_simple <- vanilla.table(hiresource_attrition))

# save hire sources with highest and lowest levels of attrition
top_hire <- hiresource_attrition$`Recruiting Channel`[1]
bottom_hire <- hiresource_attrition$`Recruiting Channel`[nrow(hiresource_attrition)]


report <- pptx(title = paste(date, "Acme Co.\nAttrition Report"))
options("ReporteRs-fontsize"=24) #font size for slide text
options("ReporteRs-default-font"="Verdana")
slide.layouts(report)

report <- report %>%
  addSlide(slide.layout = "Title Slide") %>%
  addTitle(paste(date, "Acme Co. Attrition Report"))

report <- report %>%
  addSlide(slide.layout = "Title and Content") %>%
  addTitle("Table of Contents") %>%
  addParagraph( c("Overall Attrition Statistics")) %>%
  addParagraph( c("Attrition by Subgroups"), append = T) %>%
  addParagraph( set_of_paragraphs("by Job Role",
                                  "by Performance Rating",
                                  "by Job Level"), append = T) %>%
  addParagraph( c("Recommendations"), append = T)

report <- report %>%
  addSlide(slide.layout = "Section Header") %>%
  addTitle("Overall Attrition Statistics")

report <- report %>%
  addSlide(slide.layout = "Title and Content") %>%
  addTitle(paste0("Summary of Attrition in ", date)) %>%
  addFlexTable(overall_attrition_table_simple)

report <- report %>%
  addSlide(slide.layout = "Section Header") %>%
  addTitle("Attrition by Subgroup")

report <- report %>%
  addSlide(slide.layout = "Two Content") %>%
  addTitle("Which Jobs have the Highest Attrition?") %>%
  addPlot(function() print(jobrole_attrition_plot_simple)) %>%
  addFlexTable(jobrole_attrition_table_simple)

report <- report %>%
  addSlide(slide.layout = "Two Content") %>%
  addTitle("Are we Keeping Our Top Performers?") %>%
  addPlot(function() print(performance_attrition_plot_simple)) %>%
  addFlexTable(performance_attrition_table_simple) 

report <- report %>%
  addSlide(slide.layout = "Two Content") %>%
  addTitle("Which Hiring Channels have High Attrition?") %>%
  addPlot(function() print(hiresource_attrition_plot_simple)) %>%
  addFlexTable(hiresource_attrition_table_simple)

report <- report %>%
  addSlide(slide.layout = "Title and Content") %>%
  addTitle("Key Insights") %>%
  addParagraph( c(paste0("The job group with the highest attrition was ", top_role,
                         " with an attrition rate of ",as.character(percent(top_role_attrition)),"."))) %>%
  addParagraph( c(paste0("Additional focus should be placed on retaining ", top_role, "s.")),
                append = T) %>%
  addParagraph( c(paste0("We estimate that replacing an employee costs ", replacement_cost,
                         "x their annual salary. Reducing attrition by ", percent(reduction),
                         " in ", month, " could have saved ", dollar(round(impact,0)), ".")),
                append = T) %>%
  addParagraph( c(paste0("Our ", top_hire,
                         " hires have the highest attrition rate. The channel with the lowest attrition rate in ",
                         month, " was the ",
                         bottom_hire, " channel.")), 
                append = T,
                par.properties = parProperties(list.style = "unordered", level = 1)) 

writeDoc(report, paste0("~/hr_data/examples/",date," Attrition Report (Simple).pptx"))