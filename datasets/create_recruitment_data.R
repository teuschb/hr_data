
library(ggplot2)

# start with real data from https://www.ibm.com/communities/analytics/watson-analytics-blog/hr-employwat-attrition/

wat_raw <- read.csv("https://raw.githubusercontent.com/teuschb/hr_data/master/datasets/original_watson_dataset.csv")
wat <- wat_raw

set.seed(10)


### Delete some unnatural columns
wat$X <- NULL
wat$EmployeeCount <- NULL
wat$MaritalStatus <- NULL
wat$Over18 <- NULL

### Clean up

# performance rating has no variation
wat$PerformanceRating <- floor(rnorm(nrow(wat), 3.4, .6))
wat$SalesRating <- ifelse(wat$Department == "Sales", rnorm(nrow(wat),1.1,.7),NA)

wat$SalesRating[wat$Department == "Sales"] <- ifelse(wat$HireSource[wat$Department == "Sales"] == "Referral", wat$SalesRating + .4, wat$SalesRating)

#
wat$RandNum <- runif(nrow(wat))
wat$RandNum <- ifelse(wat$YearsAtCompany > 6, NA, wat$RandNum) # we only have data for the last 6 years
wat$HireSource <- runif(nrow(wat), 0, 0)

# make sure campus hires actually have a college degrwat
wat$HireSource <- ifelse(wat$Education == 1 & wat$RandNum < .8, "Applied Online", wat$HireSource)
wat$HireSource <- ifelse(wat$Education == 1 & wat$RandNum > .8, "Referral", wat$HireSource)
wat$HireSource <- ifelse(wat$RandNum > .9, "Referral", wat$HireSource)
# make sure search firm hires are high level
wat$HireSource <- ifelse(wat$RandNum > .8 & wat$MonthlyRate > 20000, "Search Firm", wat$HireSource)


wat$HireSource <- ifelse(wat$RandNum <= .4 & wat$HireSource == 0, "Applied Online", wat$HireSource)
wat$HireSource <- ifelse(wat$RandNum >= .4 & wat$RandNum <= .5 & wat$HireSource == 0, "Referral", wat$HireSource)
wat$HireSource <- ifelse(wat$RandNum > .5 & wat$HireSource == 0, "Campus", wat$HireSource)
wat$HireSource <- as.factor(wat$HireSource)
summary(factor(wat$HireSource))

watHire <- na.omit(wat)

# campus hires - which university?
set.swatd(11)
wat$RandNum <- rnorm((nrow(wat)))
wat$RandNum <- ifelse(wat$HireSource != "Campus", NA, wat$RandNum)

wat$Campus <- ifelse(wat$RandNum <= -.8, "State",
                    ifelse(wat$RandNum <= 0, "Tech",
                           ifelse(wat$RandNum <= .6, "Northern", "A&M")))
summary(factor(wat$Campus))

wat$RandNum = NULL

wat$Attrition <- ifelse(wat$Attrition == "Yes", 1, 0)


watCampus <- na.omit(wat)

ggplot(watCampus, aes(factor(Campus), fill = factor(Gender))) +
  geom_bar()

ggplot(wat, aes(factor(HireSource), fill = factor(Attrition))) +
  geom_bar()

"
Education	1 'Below College'
2 'College'
3 'Bachelor'
4 'Master'
5 'Doctor'
"

write.csv(wat, "~/hr_data/datasets/recruitment_evaluation_data.csv")

####
# -- Analysis --
####



### Just start analyzing this - see how far you are from something good before you keep tweaking it forever
### --------------
library(psych)
attach(wat)

# start by looking at the data
summary(wat)

# question is about hiring channel
summary(HireSource)


### how to say it's better?
# attrition
describeBy(Attrition, HireSource, mat = TRUE)                                  # 
t.test(Attrition[HireSource == "Campus"], Attrition[HireSource == "Referral"]) #
att_mod <- lm(Attrition ~ HireSource, data = wat)

# performance rating
describeBy(PerformanceRating, HireSource, mat = TRUE)
describeBy(SalesRating, HireSource, mat = TRUE)
t.test(SalesRating[HireSource == "Campus"], SalesRating[HireSource == "Referral"]) #


