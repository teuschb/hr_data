####
# -- Analysis --
####

mydata <- read.csv("https://raw.githubusercontent.com/teuschb/hr_data/master/datasets/recruitment_evaluation_data.csv")

### Just start analyzing this - see how far you are from something good before you keep tweaking it forever
### --------------
library(psych)

# start by looking at the data
summary(mydata)

# question is about hiring channel
summary(HireSource)


### how to say it's better?
# attrition
describeBy(mydata$Attrition, mydata$HireSource, mat = TRUE)                                  # 
t.test(mydata$Attrition[mydata$HireSource == "Campus"], mydata$Attrition[mydata$HireSource == "Referral"]) #
att_mod <- glm(Attrition ~ HireSource + Department + BusinessTravel + OverTime + YearsAtCompany +
                TrainingTimesLastYear + WorkLifeBalance,
               family = binomial(link = 'logit'), data = mydata)
summary(att_mod)
exp(summary(att_mod)$coefficients)
# performance rating
describeBy(mydata$PerformanceRating, mydata$HireSource, mat = TRUE)

att_mod <- lm(PerformanceRating ~ HireSource + Department + , data = mydata)

describeBy(mydata$SalesRating, mydata$HireSource, mat = TRUE)
t.test(mydata$SalesRating[mydata$HireSource == "Campus"], mydata$SalesRating[mydata$HireSource == "Referral"]) #

