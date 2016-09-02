####
# -- Analysis --
####

wat <- read.csv("https://raw.githubusercontent.com/teuschb/hr_data/master/datasets/recruitment_evaluation_data.csv")

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

