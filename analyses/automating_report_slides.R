
####
# Guide for making an automated attrition report using R, 
# 5/2017
# Ben Teusch
####

##
# Load Data
##

mydata <- read.csv("https://raw.githubusercontent.com/teuschb/hr_data/master/datasets/modified_watson_dataset.csv",
                   stringsAsFactors = FALSE)

##
# Set Report Parameters
##

month = "May"
date = "May 2017"

##
# Libraries
##

require(rJava)
if (!require('ReporteRs')) {
  install.packages("ReporteRs")
}
library(ReporteRs)
library(ggplot2)     # for plotting graphs
library(scales)      # for formatting numbers
library(magrittr)    # for the %>% operator

##
# Attrition Overview Table
##

overall_attrition <- as.data.frame(
  as.list(aggregate(Attrition ~ Department,
                    data = mydata,
                    FUN = function(x) c(
                      n = length(x),
                      s = sum(x, na.rm = T),
                      mn = mean(x, na.rm = T))
                    ) 
  ), stringsAsFactors = F)

overall_attrition <- rbind(overall_attrition, c(
  0, # to be replaced with the word "Total"
  sum(overall_attrition$Attrition.n),
  sum(overall_attrition$Attrition.s),
  mean(overall_attrition$Attrition.mn))
)
overall_attrition[nrow(overall_attrition),1] <- 'Total'

# format as percentages, rename columns
overall_attrition$Attrition.mn <- percent(as.numeric(overall_attrition$Attrition.mn))
names(overall_attrition) <- c('Department', 'Headcount', 'Attrition', 'Attrition %')

# Put data into a table
options("ReporteRs-fontsize"=16) #font size for tables
overall_attrition_table <- vanilla.table(overall_attrition) %>%
  setZebraStyle(odd = '#eeeeee', even = 'white' ) %>%
  setFlexTableWidths(widths = c(4.5, 2.5, 2, 2.5)) 

overall_attrition_table[,1] = parLeft()
overall_attrition_table[,2:4] = parCenter()
overall_attrition_table[,,to='header'] = parCenter()
overall_attrition_table[4,] = textProperties(font.weight = 'bold' )
overall_attrition_table

##
# Attrition by Job Role
##

jobrole_attrition <- as.data.frame(
  as.list(aggregate(Attrition ~ JobRole,
                    data = mydata,
                    FUN = function(x) c(
                      n = length(x),
                      s = sum(x, na.rm = T),
                      mn = mean(x, na.rm = T))
                  )
  ))

names(jobrole_attrition) = c('JobRole', 'Headcount', 'Attrition', 'AttritionRate')

# bar chart
(jobrole_attrition_plot <- ggplot(jobrole_attrition,
                                  aes(reorder(JobRole, AttritionRate), AttritionRate)) +
    geom_col(aes(fill = '')) +
    scale_fill_manual(values = c("#1D243C"),guide=FALSE) +
    theme_minimal() +
    scale_y_continuous(labels=percent) +
    labs(list(y = paste("Attrition in ",month,sep = ""), x = "Job Role",
              title = paste("Attrition by Job Role, ", date, sep = ""))) +
    theme(panel.grid.minor = element_blank()) +
    coord_flip())

# sort data
jobrole_attrition <- jobrole_attrition[order(jobrole_attrition$AttritionRate, decreasing = TRUE),]

# to be used later
reduction = .05            # how much could we reduce attrition?
replacement_mult = 1.5       # how much does it cost to replace an employee, as a multiplier of their salary?
top_role <- as.character(jobrole_attrition$JobRole[1])   # job role with highest attrition
top_role_attrition <- jobrole_attrition$AttritionRate[1] # attrition for that role
left_from_top_role <- mydata$JobRole == top_role & mydata$Attrition == 1 
salary_lost = 
  sum(mydata$MonthlyIncome[left_from_top_role]) * 12 *     # total annual salary lost 
  replacement_mult                                         # times replacement cost
impact = salary_lost * reduction # amount we could save

# create table
# format as percentages, rename columns
jobrole_attrition$AttritionRate <- percent(jobrole_attrition$AttritionRate)
names(jobrole_attrition) = c('Job Role', 'Headcount', 'Attrition', 'Attrition %')

# put data into a table
options("ReporteRs-fontsize"=16) #font size for tables
table_widths = c(2.8, 1.2, 1, 1.6) 

jobrole_attrition_table <- vanilla.table(jobrole_attrition) %>%
  setZebraStyle(odd = '#eeeeee', even = 'white' ) %>%
  setFlexTableWidths(widths = table_widths) 
jobrole_attrition_table[,2:4] = parCenter()
jobrole_attrition_table[,1] = parLeft()
jobrole_attrition_table[,,to='header'] = parCenter()
jobrole_attrition_table

##
# Attrition by Performance
##

performance_attrition <- as.data.frame(
  as.list(aggregate(Attrition ~ PerformanceRating,
                    data = mydata, FUN = function(x) c(
                      n = length(x),
                      s = sum(x, na.rm = T),
                      mn = mean(x, na.rm = T))
  )
  ))

names(performance_attrition) = c('PerformanceRating', 'Headcount', 'Attrition', 'AttritionRate')

(performance_attrition_plot <- ggplot(performance_attrition, aes(PerformanceRating, AttritionRate)) +
    geom_bar(stat = "identity", aes(fill = '')) +
    scale_fill_manual(values = c("#1D243C"),guide=FALSE) +
    theme_minimal() +
    scale_y_continuous(labels=percent) +
    scale_x_reverse() +
    labs(list(y = paste("Attrition in ",month,sep = ""), x = "Performance Rating",
              title = paste("Attrition by Performance Rating, ", date, sep = ""))) +
    theme(panel.grid.minor = element_blank()) +
    coord_flip())

# format as percentages, rename columns
performance_attrition$AttritionRate <- percent(performance_attrition$AttritionRate)
names(performance_attrition) = c('Performance Rating', 'Headcount', 'Attrition', 'Attrition %')

# put data into a table
performance_attrition_table <- vanilla.table(performance_attrition) %>%
  setZebraStyle(odd = '#eeeeee', even = 'white' ) %>%
  setFlexTableWidths(widths = table_widths) 
performance_attrition_table[,1:4] = parCenter()
performance_attrition_table[,,to='header'] = parCenter()
performance_attrition_table

##
# Attrition by Recruiting Channel
##

hiresource_attrition <- as.data.frame(
  as.list(aggregate(Attrition ~ HireSource, data = mydata,
                    FUN = function(x) c(
                      n = length(x),
                      s = sum(x, na.rm = T),
                      mn = mean(x, na.rm = T))
  )
  ))

names(hiresource_attrition) = c('HireSource', 'Headcount', 'Attrition', 'AttritionRate')

(hiresource_attrition_plot <- ggplot(hiresource_attrition, aes(reorder(HireSource, AttritionRate), AttritionRate)) +
    geom_bar(stat = "identity", aes(fill = '')) +
    scale_fill_manual(values = c("#1D243C"),guide=FALSE) +
    theme_minimal() +
    scale_y_continuous(labels=percent) +
    labs(list(y = paste("Attrition in ",month,sep = ""), x = "Job Level",
              title = paste("Attrition by Recruiting Channel, ", date, sep = ""))) +
    theme(panel.grid.minor = element_blank()) +
    coord_flip())

# sort by attrition rate, format as percentages, rename columns
hiresource_attrition <- hiresource_attrition[order(hiresource_attrition$AttritionRate, decreasing = TRUE),]
hiresource_attrition$AttritionRate <- percent(hiresource_attrition$AttritionRate)
names(hiresource_attrition) = c('Recruiting Channel', 'Headcount', 'Attrition', 'Attrition %')

# put data into a table 
hiresource_attrition_table <- vanilla.table(hiresource_attrition) %>%
  setZebraStyle(odd = '#eeeeee', even = 'white' ) %>%
  setFlexTableWidths(widths = table_widths) 
hiresource_attrition_table[,1] = parLeft()
hiresource_attrition_table[,2:4] = parCenter()
hiresource_attrition_table[,,to='header'] = parCenter()
hiresource_attrition_table

# save hire sources with highest and lowest levels of attrition
top_hire <- hiresource_attrition$`Recruiting Channel`[1]
bottom_hire <- hiresource_attrition$`Recruiting Channel`[nrow(hiresource_attrition)]

##
# Create and Publish Report
##

report <- pptx(title = paste(date, "Acme Co. \nAttrition Report"),
               template = '~/hr_data/example_corporate_template.pptx')
options("ReporteRs-fontsize"=24) #font size for text
slide.layouts(report)

report <- report %>%
  addSlide(slide.layout = "Title Slide") %>%
  addTitle(paste(date, "Acme Co. Attrition Report"))



report <- report %>%
  addSlide(slide.layout = "Title and Content") %>%
  addTitle("Table of Contents") %>%
  addParagraph( c("Overall Attrition Statistics"), 
                par.properties = parProperties(list.style = "unordered", level = 1)) %>%
  addParagraph( c("Attrition by Subgroups"), append = T,
                par.properties = parProperties(list.style = "unordered", level = 1)) %>%
  addParagraph( set_of_paragraphs("by Job Role",
                                  "by Performance Rating",
                                  "by Job Level"),
                append = T,
                par.properties = parProperties(list.style = "unordered", level = 2) )%>%
  addParagraph( c("Recommendations"), append = T,
                par.properties = parProperties(list.style = "unordered", level = 1))

report <- report %>%
  addSlide(slide.layout = "Section Header") %>%
  addTitle("Overall Attrition Statistics")

report <- report %>%
  addSlide(slide.layout = "Title and Content") %>%
  addTitle(paste0("Summary of Attrition in ", date)) %>%
  addFlexTable(overall_attrition_table)


report <- report %>%
  addSlide(slide.layout = "Section Header") %>%
  addTitle("Attrition by Subgroup")

report <- report %>%
  addSlide(slide.layout = "Two Content") %>%
  addTitle("Which Jobs have the Highest Attrition?") %>%
  addPlot(function() print(jobrole_attrition_plot)) %>%
  addFlexTable(jobrole_attrition_table)

report <- report %>%
  addSlide(slide.layout = "Two Content") %>%
  addTitle("Are We Keeping Our Top Performers?") %>%
  addPlot(function() print(performance_attrition_plot)) %>%
  addFlexTable(performance_attrition_table) 

report <- report %>%
  addSlide(slide.layout = "Two Content") %>%
  addTitle("Which Hiring Channels have High Turnover?") %>%
  addPlot(function() print(hiresource_attrition_plot)) %>%
  addFlexTable(hiresource_attrition_table)

report <- report %>%
  addSlide(slide.layout = "Title and Content") %>%
  addTitle("Key Insights") %>%
  addParagraph( c(paste0("The job group with the highest attrition was ", top_role,
                         " with an attrition rate of ",as.character(jobrole_attrition$`Attrition %`[1]),".")), 
                par.properties = parProperties(list.style = "unordered", level = 1)) %>%
  addParagraph( c(paste0("Additional focus should be placed on retaining ", top_role,
                         "s.")),
                append = T,
                par.properties = parProperties(list.style = "unordered", level = 2)) %>%
  addParagraph( c(paste0("We estimate that replacing an employee costs ", replacement_mult,
                         "x their annual salary. Reducing attrition by ", percent(reduction),
                         " in ", month, " could have saved ", dollar(round(impact,0)), ".")),
                append = T,
                par.properties = parProperties(list.style = "unordered", level = 2)) %>%
  addParagraph( c(paste0("Our ", hiresource_attrition$`Recruiting Channel`[1],
                         " hires have the highest attrition rate. The channel with the lowest attrition rate in ",
                         month, " was the ",
                         hiresource_attrition$`Recruiting Channel`[nrow(hiresource_attrition)], " channel.")), 
                append = T,
                par.properties = parProperties(list.style = "unordered", level = 1)) 

writeDoc(report, paste0("~/hr_data/examples/",date," Attrition Report.pptx"))