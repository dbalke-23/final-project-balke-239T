# final-project-balke-239T
This is my final project for 239T.

# Short Description
This project reads in, subsets, analyzes, produces visuals from, and does an initial coding of a random sample of civil war peace agreements from 1975-2018. The data include the peace agreement texts (which I do not upload here but are available upon request) and indicator data about the peace agreements from the Uppsala Conflict Data Program (UCDP), from which I downloaded all my data and texts. The purpose of my project was to capture and start to work with the data I will need to use for your my second year paper. Judged by that metric, the project proved a success.

To conduct my work, I used R, using multiple skills learned in class, including basic tools such as subsetting, as well as data visualization tools from base R and ggplot2. In terms of conducting my exploration of the data, I first read in the full UCDP Peace Agreement Dataset. I then did several subsets on the data, as commented in my code. First, I subsetted so it would only include civil wars, instead of also including inter-state wars. Then, I subsetted to three different types of civil war peace agreements - full, partial, and process - so that analysis a disaggregated analysis can be performed on each type. Later, I read in to my R script an Excel file that features an initial coding of a random sample of full civil war peace agreements. Visuals were produced in my R script based on each of these two sources - the UCDP dataset and my Excel coding spreadsheet. My code is commented, as are the knit Word document and PDF I include to show its output, so readers can see the objectives I attempted to complete step-by-step.

# Dependencies

1. R, 3.5.0

# Files

Results

1. Narrative.docx: Features the key outputs and visuals of my work in R, as well as comments and commentary on each step.
2. Narrative.pdf: A PDF of 'Narrative.docx'
3. Presentation_Balke.pdf: This is a slide deck on the research project into which my final project fits, and key steps in the latter.

Data: Please open these first as you view my work.

1. ucdp-peace-agreements-191.csv: The full set of peace agreements from UCDP that formed the heart of my coding and analysis.
2. ucdp-prio-acd-191.csv: The full data frame of conflict data from UCDP. In the end, I did not make much use of this.
3. fullPAcode.xlsx: An initial coding of financial accounting specificity indicators of my sample of full civil war peace agreements

Code: Please open this after you load my data.

1. analysis.R: The heart of my work, this is the code I used to load, subset, analyze, and produce visuals from my peace agreement data.

Other

1. PAT_notes.docx: These are notes from my initial coding of the full civil war peace agreement sample. They are raw and just for me.

# More Information

The files do not feature numerical prefaces, since there is only one script file, which features all of my code. I did not divide my code into different scripts because I believe it will be easier to assess when consolidated. As noted above, the reader is asked to load my data files before cutting into the R code, as the latter requires the former to run. In addition to the narrative, the PowerPoint slides provide an overview of the broader research project into which this final project feeds. I hope the viewer finds both efforts interesting and worthwhile, and welcome comments and suggestions on how to use additional computational tools in the research project going forward!
