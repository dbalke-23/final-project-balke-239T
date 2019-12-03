---
title: "UCDP-PRIO_ACD_19.1"
author: "Daniel Balke"
date: "November 18, 2019"
output:
  html_document: default
  word_document: default
  pdf_document: default
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

```{r echo=FALSE}
# loading overall conflict dataset
getwd()
library(utils)
conflict_data <- read.csv('ucdp-prio-acd-191.csv')
head(conflict_data)
View(conflict_data)
cwdata <- subset(conflict_data, conflict_data$type_of_conflict >= 3)
View(cwdata)
cwsample <- cwdata[sample(nrow(cwdata), 30), ]
head(cwsample)
# this actually isn't getting me to where i want
``` 
```{r echo=FALSE}
# reading in peace agreement dataframe
pa_data <- read.csv('ucdp-peace-agreements-191.csv')
nrow(pa_data)
head(pa_data)
View(pa_data)
# subsetting to get only civil war peace agreements (as opposed to inter-state)
cwpasub <- pa_data[grep(":", pa_data$conflict_name), ]
View(cwpasub)
nrow(cwpasub)
```

```{r echo=FALSE}
# subsetting to get full peace agreements
cwfullpa <- cwpasub[grep("Full", cwpasub$pa_comment), ]
cwcomprehensivepa <- cwpasub[grep("The Chapultepec Peace Agreement,", cwpasub$pa_comment), ]
cwtypeFullpa <- cwpasub[grep("Type: Full", cwpasub$pa_comment), ]
cwtypefullpa <- cwpasub[grep("Type: full", cwpasub$pa_comment), ]
cwfull_pa <- rbind(cwfullpa, cwtypefullpa, cwtypeFullpa, cwcomprehensivepa)
View(cwfull_pa)
```

```{r echo=FALSE}
# subsetting to get partial peace agreements
cwpartialpa <- cwpasub[grep("Partial", cwpasub$pa_comment), ]
cwtypePartialpa <- cwpasub[grep("Type: Partial", cwpasub$pa_comment), ]
cwtypepartialpa <- cwpasub[grep("Type: partial", cwpasub$pa_comment), ]
cwpatialpa <- cwpasub[grep("Patial", cwpasub$pa_comment), ]
cwpartial_pa <- rbind(cwpartialpa, cwtypePartialpa, cwtypepartialpa, cwpatialpa)
View(cwpartial_pa)
```

```{r echo=FALSE}
# subsetting to get peace process agreements
cwprocesspa <- cwpasub[grep("Peace process", cwpasub$pa_comment), ]
cwProcesspa <- cwpasub[grep("Peace Process", cwpasub$pa_comment), ]
cwtypepeacepa <- cwpasub[grep("Type: Peace", cwpasub$pa_comment), ]
cwtypePeacepa <- cwpasub[grep("Type: peace", cwpasub$pa_comment), ]
cwthispeacepa <- cwpasub[grep("This peace process agreement fixed", cwpasub$pa_comment), ]
jeddahaccord <- cwpasub[grep("were first initiated in 1975", cwpasub$pa_comment), ]
cwonfebpa <- cwpasub[grep("On 23 February", cwpasub$pa_comment), ] 
cwonjunpa <- cwpasub[grep("On 28 June", cwpasub$pa_comment), ]
View(cwonjunpa)
cwprocess_pa <- rbind(cwprocesspa, cwProcesspa, cwtypepeacepa, cwtypePeacepa, cwthispeacepa, jeddahaccord, cwonfebpa, cwonjunpa)
View(cwprocess_pa)
```

```{r echo=FALSE}
# creating a subset of other types of peace agreements
cwreaffirmpa <- cwpasub[grep("Reaffirming", cwpasub$pa_comment), ]
cwsupplementpa <- cwpasub[grep("Supplement to the Lom", cwpasub$pa_comment), ]
cwresidual_pa <- rbind(cwreaffirmpa, cwsupplementpa)
```

```{r echo=FALSE}
# figuring out if number of subset observations sum to full data observations
nrow(cwpasub) - (nrow(cwfull_pa) + nrow(cwpartial_pa) + nrow(cwprocess_pa) + nrow(cwresidual_pa))

# it appears there are duplicate peace agreement observations in my subsets

library(dplyr)
merged <- rbind(cwfull_pa, cwpartial_pa, cwprocess_pa, cwresidual_pa)
duprows <- unique(merged)
nrow(cwpasub) - nrow(duprows)
# when i strip the merged subsets of duplicate rows, i am left with three fewer observations in the subsetted dataframes than in the full civil war peace agreement. i am not sure why, but it probably centers on the way i subsetted my data above
```

```{r echo=FALSE}
# creating random samples from each subset, to determine which texts i will hand code for my analysis
# creating full peace agreement sample
set.seed(1)
cwfull_pa_sample <- cwfull_pa[sample(nrow(cwfull_pa), 15), ]
View(cwfull_pa_sample)
# note: unable to locate peace agreement texts for chad 'tripoli accord' of 2006 or chad 'yebibou agreement' of 2005
```

```{r echo=FALSE}
# creating partial peace agreement sample
set.seed(1)
cwpartial_pa_sample <- cwpartial_pa[sample(nrow(cwpartial_pa), 15), ]
View(cwpartial_pa_sample)
```

```{r echo=FALSE}
# create peace process agreement sample
set.seed(1)
cwprocess_pa_sample <- cwprocess_pa[sample(nrow(cwprocess_pa), 15), ]
View(cwprocess_pa_sample)
```

```{r echo=FALSE}
pasubset <- pa_data[!pa_data$conflict_id == c(11348), ]
View(pasubset)
```

```{r echo=FALSE}
cwpa_data <- merge(cwdata, pa_data, 'conflict_id')
View(cwpa_data)
cwpa_uniqueid_data <- subset(cwpa_data, !duplicated(cwpa_data$conflict_id))
View(cwpa_uniqueid_data)
cwpa_sample <- cwpa_uniqueid_data[sample(nrow(cwpa_uniqueid_data), 30), ]
View(cwpa_sample)
```

Let's dive into some basic description of our data. To start, let's return to the full set of civil war peace agreements to see how common each type - i.e., full, partial, process - is in the overall dataset.

```{r echo=FALSE}
# create bar plot of peace agreement types
library(graphics)
pa_vec <- c(67, 171, 85)
barplot(pa_vec, main = "Civil War Peace Agreements by Type", xlab = "Type", ylab = "Number", col = c("blue", "darkgreen", "red"), ylim = c(0, 200), names.arg = (c("Full", "Partial", "Process")))
```


Partial peace agreements are clearly the most common type of civil war peace agreements, followed by process and, then, full. Let's use a pie chart to show this information as percentages.

```{r echo=FALSE}
# create pie chart to show frequency of different pa types
fullshare <- nrow(cwfull_pa)/nrow(cwpasub)
fullshare
partialshare <- nrow(cwpartial_pa)/nrow(cwpasub)
partialshare
processshare <- nrow(cwprocess_pa)/nrow(cwpasub)
processshare
# accounting for agreements i didn't catch in my subsetting into full, partial, process PAs
residualshare <- nrow(cwfull_pa)/nrow(cwfull_pa) - (fullshare+partialshare+processshare)
residualshare
pashare <- c(fullshare, partialshare, processshare, residualshare)
lbls <- c("Full", "Partial", "Process", "Residual")
pct <- c(round(fullshare*100), round(partialshare*100), round(processshare*100), round(residualshare*100))
lbls <- paste(lbls, pct)
lbls <- paste(lbls, "%", sep = "")
pie(pashare, labels = lbls, main = "Percentage of Civil War Peace Agreements by Type", col = c("blue", "darkgreen", "red"))
```


Let's keep going. I've started to get my hand dirty by reading the texts of the full civil war peace agreement sample created above. I've developed a set of variables that indicate the level of specificty of financial accounting in the peace agreement text. These include things like whether the texts explicitly state the costs, or an estimate of the costs, of implementing the peace agreement provisions (provisions is just a fancy term for what the parties have agreed to, e.g., rural development or ex-combatant reintegration programs). This is a crude measure of financial accounting specificity, and I will need to revise both the variables I am coding, as well as my definition and coding of them (which is not straightforward!) as my project moves forward. Still, this initial cut allows us to take a first cut at whether belligerents to tend to vary in terms of the specificity of the financial accounting they include in their peace agreements. Let's go ahead and read in my full sample coding to get going.

```{r echo=FALSE}
# reading in my initial coding of full pa sample
library(utils)
getwd()
library(readxl)
fullpacode <- read_xlsx('fullPAcode.xlsx')
```

One thing that is key as I begin my second year analysis is to ensure there exists sufficient variation on the independent variable, which is a count of the presence/absence of specific financial accounting indicators that I am coding my sample agreements for. If all civil war peace agreements contain the same level of financial accounting specificity, there's really nothing to investigate here. Do we see variance on the IV? Let's get some basic stats on our IV.

```{r echo=FALSE}
fullsample_var <- var(fullpacode$count) # 27 - pretty wild. it looks like there's reasonable variance
fullsample_sd <- sd(fullpacode$count) # standard deviation - 5.2
fullsample_med <- median(fullpacode$count) # median - 8
fullsample_mean <- mean(fullpacode$count) # mean - 6.7
fullsample_stats <- c(fullsample_var, fullsample_sd, fullsample_mean, fullsample_med)
barplot(fullsample_stats, main = "Descriptive Statistics: Full Civil War PA Sample", xlab = "Statistics", ylab = "Number", names.arg = c("Variance", "StanDev", "Mean", "Median"), ylim = c(0, 30), col = c("blue", "darkgreen", "red", "orange"))
```

Let's do some plotting. Let's start by seeing if there's a correlation between the length, in pages, of peace agreements and their score on the independent variable. This is interesting because we might expect agreements with more pages to reflect more specificity in the way that parties made and described their commitments. If so, we would see a positive correlation between pages and count. this could be a sign, as well, that they included more detail on how their commitments would be paid for.)

```{r echo=FALSE}
library(ggplot2)
ggplot(fullpacode, aes(fullpacode$pages, fullpacode$count)) + geom_point()
# Oof! It looks like we have a page number outlier. I wonder which one that could be? Let's have a look.
View(fullpacode[order(fullpacode$pages, decreasing = TRUE), ])
# it looks like south africa is our culprit. maybe that's because their 'peace agreement' is actually an interim constitution! let's drop south africa and see how our page/count plot looks then.
```
```{r echo=FALSE}
library(stats)
library(dplyr)
library(grDevices)
jpeg(file="plot1.jpeg")
ggplot(fullpacode, aes(fullpacode$pages, fullpacode$count)) + geom_point()
dev.off()

fullpacode %>%
  filter(pa != "Rsa_19931118") %>%
  ggplot(aes(pages, count)) + geom_point() + geom_smooth() 
```
That looks a little better. There's not much of a clear trend, though the shortest PAs do seem to have the lowest scores on 'count', which indicates the level of financial specificity in their texts. This is what we expect, though again, it would take a heroic interpretation to view this plot as showing a trend!

Let's check out some other stuff, working w/ the full and subsetted civil war peace agreement data sets (that is, returning to the overall data set, not the sample I coded). The dependent variable of my project is peace agreement duration, that is, whether peace agreements held. the data sets have a variable for this: "ended" takes on a value of true if the agreement failed, and false if it held. Let's have a look at how common it is for civil war peace agreements to fail/succeed.

```{r echo=FALSE}
pafail <- (sum(cwpasub$ended == 'TRUE') / nrow(cwpasub))
paftw <- (sum(cwpasub$ended == 'FALSE') / nrow(cwpasub))
paresult <- c(pafail, paftw)
successnames <- c("Failed", "Succeeded")
paholdrate <- barplot(paresult, main = "Civil War Peace Agreement Success Rates: 1975-2018", ylab = "%", names.arg = successnames, col = c("blue", "darkgreen"))
```
Civil war peace agreements succeed more than they fail. hoo-ray! but what does this look like when we subset? e.g., do full agreements hold more often than partial? what about process agreements? let's take a look.

```{r echo=FALSE}
# calculate full cw peace agreement success rates
fullfail <- (sum(cwfull_pa$ended == 'TRUE') / nrow(cwfull_pa)) # 22%
fullftw <- (sum(cwfull_pa$ended == 'FALSE') / nrow(cwfull_pa)) # 78%
fullresult <- c(fullfail, fullftw)
fullfholdrate <- barplot(fullresult, main = "Full Civil War Peace Agreement Success Rates: 1975-2018", ylab = "%", ylim = c(0, 1), names.arg = c("Failed", "Succeeded"), col = c("blue", "darkgreen"))
```
Wow. It looks like full peace agreements succeed almost 80% of the time. int'l diplomats take notes. what about partial agreements, which, at 171 of our 324 observations, or 53%, represent the most common type of civil war peace agreement. Sheesh: I hope these types of agreements tend to hold... 

```{r echo=FALSE}
partialfail <- (sum(cwpartial_pa$ended == 'TRUE') / nrow(cwpartial_pa)) # 39%
partialftw <- (sum(cwpartial_pa$ended == 'FALSE') / nrow(cwpartial_pa)) # 61%
partialresult <- c(partialfail, partialftw)
partialholdrate <- barplot(partialresult, main = "Partial Civil War Peace Agreement Success Rates: 1975-2018", ylab = "%", ylim = c(0, 1), names.arg = c("Failed", "Succeeded"), col = c("blue", "darkgreen"))
```
That's quite a difference. Partial peace agreement fail about 2/5 of the time. No bueno. Let's have a look at process agreements. The idea with these agreements is that they don't settle differences between belligerents but instead say that the belligerents have agreed to enter into a process to settle their differences. sometimes, process agreements set the table for negotiations on the more robust partial or full peace agreements, but that is not always the case (for instance, belligerents may set up a discussion process outside of the context of a formal peace negotiation to work out their differences). Since these agreements lack a lot of the features that tend to keep belligerents peace in the long run, we might expect them to fail at the highest rate of our three agreement types. What do the data say?

```{r echo=FALSE}
processfail <- (sum(cwprocess_pa$ended == 'TRUE') / nrow(cwprocess_pa)) # 45%
processftw <- (sum(cwprocess_pa$ended == 'FALSE') / nrow(cwprocess_pa)) # 55%
processresult <- c(processfail, processftw)
processholdrate <- barplot(processresult, main = "Process Civil War Peace Agreement Success Rates: 1975-2018", ylab = "%", ylim = c(0, 1), names.arg = c("Failed", "Succeeded"), col = c("blue", "darkgreen"))
```
Yikes. As expected, process peace agreements break down more often than the other two types, at about 45% of the time. We could be witnessing a selection effect here. perhaps the types of belligerents that enter into full peace agreements are different, and potentially more 'pacific', than those who enter into partial or full peace agreements. as noted above, some of those who enter into process agreements later go onto negotiata, but not all of them do. we might expect those who do not proceed to those more robust agreement types to be more belligerent, and less committed to peace, than their civil war counterparts who do go on to negotiate broader deals. the policy implications here require more analysis, however.

