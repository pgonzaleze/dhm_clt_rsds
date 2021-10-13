
"
Author: Pedro González-Espinosa
Date: April 8th 2021
University of British Columbia
Geography Department
"

################# ================== ###################
###### Mixed Effects Regression | R Data Analysis ######
################# ================== ###################

require(ggplot2) # to plot 
#require(lme4) # to perform mixed effect models
#library(stargazer) # to make table 
library(MuMIn) # to compute r2
library(lmerTest) # to get the p-value
library(sjPlot) # to plot estimates
library(sjlabelled)
library(sjmisc)
#library(ncf) # Moran index and Mantel test (erase if not succes)
library(dplyr)

# Load the database

hdp <- read.csv("df_sst_clouds_rsds_mon_t.csv", sep = ";") # may use ', sep = ";"' 

hdp <- subset(hdp, SEVERITY_CODE >= 0)

# perform a simple lm
basic.lm <- lm(SEVERITY_CODE ~ DHM * CF_a_monmean, data = hdp)
summary(basic.lm)
#plot qq plot
plot(basic.lm, which = 2)

########## =============== ##########
### Perform a mixed effects model ###
########## =============== ########## 

# lmer 
m <- lmer(SEVERITY_CODE ~ DHM * CLT2017+
            (1 | lat), REML = F, data = hdp)
n <- lmer(SEVERITY_CODE ~ DHM * RSDS+
            (1 | lat), REML = F, data = hdp)
l <- lmer(SEVERITY_CODE ~ DHM +
            (1 | lat), REML = F, data = hdp)
summary(m)

AICc(m, n, l)

# plot estimates
theme_set(theme_sjplot2())
plot_model(m, sort.est = TRUE,
           show.values = TRUE, value.offset = .3)

# Reference: Kutner, et al. (2005). Applied Linear Statistical Models. McGraw-Hill. (Ch. 8)

# plot qq plot
qqnorm(resid(log))
qqline(resid(m))
plot(m, which = 2) 

# plot results in a nice table 
# Use this only with "lmer" and not with lmerTest 
stargazer(m, type = "text",
          digits = 3,
          star.cutoffs = c(0.05, 0.01, 0.001),
          digit.separator = "")

# to get the r2; will returns the marginal and the conditional R�
r.squaredGLMM(m)

# To extract the residuals (errors) and summarize them, 
# as well as plot them (they should be approximately normally distributed around a mean of zero)
residuals <- resid(m)
summary(residuals) 
hist(residuals)

# Compute the profile confidence intervals
confint(m, oldNames = FALSE)

# Performa Anova
anova(m)

# alternative (it does not suppor 'stargazer' package)
# # lmerTest
# mm <- lmerTest::lmer(SEVERITY_CODE ~ DHW + CF_a_runmean7 +
#                        (1 | lat) +
#                        (1 | lon), data = hdp)
# summary(mm)


# Interaction plot
theme_set(theme_sjplot2())
plot_model(m, type = "int", show.p = TRUE,
           terms = c("DHM", 'CF_a_monmean'))
# Aiken and West (1991). Multiple Regression: Testing and Interpreting Interactions.

