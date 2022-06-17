# cid2.r - plot for Systematic Review Table 3
#
# Read from Google Sheet, assume location does not change, sheet name does not change, and positioning
# of data within that sheet remains as is.
#
# 23 February 2022  JW prepare for pre-print
# 16 June 2022      JW adopt to final published dataset

# call required libraries for this ggplot

library(ggplot2)
library(googlesheets4)
library(tidyr)
library(dplyr,warn.conflicts = FALSE)
library(RColorBrewer)
library(scales)
library(MASS,warn.conflicts = FALSE)
library(reshape2,warn.conflicts = FALSE)
library(ggrepel)

# if run in development mode, don't save to file

development <- Sys.getenv("RSTUDIO") == "1"

# Location of Google Sheets dataset, with relevant sheet for this figure

google_workbook <- "https://docs.google.com/spreadsheets/d/1ccQmw9hOU7s_bbiHXpA7ekmjj9VfL6bNE1fANDTS7EE"
google_sheet <- "Data by Decade"

# Read the data.  Note that one should be authenticate if the document is protected to access data

grf3 <- read_sheet(google_workbook, sheet=google_sheet, range="A4:R11")

# Change some dataframe names for clarity and ease of use

names(grf3)[2] <- "Studies"
names(grf3)[3] <- "col3"
names(grf3)[4] <- "col4"
names(grf3)[5] <- "col5"
names(grf3)[6] <- "col6"
names(grf3)[7] <- "col7"
names(grf3)[8] <- "nodefineAE"
names(grf3)[9] <- "col9"
names(grf3)[10] <- "nomentionSAE"
names(grf3)[11] <- "col11"
names(grf3)[12] <- "nodataSAE"
names(grf3)[13] <- "col13"
names(grf3)[14] <- "col14"
names(grf3)[15] <- "nodataAE"
names(grf3)[16] <- "col16"
names(grf3)[17] <- "unclearAE"
names(grf3)[18] <- "registered"

# compute percentages

grf3$nodefineAEp <- with(grf3, round(100*nodefineAE / Studies, 1))
grf3$unclearAEp <- with(grf3, round(100*unclearAE / Studies, 1))
grf3$nodataAEp <- with(grf3, round(100*nodataAE / Studies, 1))
grf3$nomentionSAEp <- with(grf3, round(100*nomentionSAE / Studies, 1))
grf3$nodataSAEp <- with(grf3, round(100*nodataSAE / Studies, 1))
grf3$registeredp <- with(grf3, round(100*registered / Studies, 1))

# filter unnecessary portions of table

grf3s <- grf3[-6,]
grf3s <- subset(grf3s, select = -c(col3,col4,col5,col6,col7,col9,col11,col13,col14,col16))

# produce data appropriate for a cumulative grouped bar chart

grf3s.cum <-melt(grf3s, id.vars = c("Decade","Studies","nodefineAE","unclearAE","nodataAE","nomentionSAE","registered","nodataSAE"))


# Build Figure 1.  Decade on independent axis, participants quantity on dependent axis, by SAE and non-SAE

figure1 <- ggplot(grf3s.cum,aes(variable,value,fill=Decade))

# side-by-side bars per decate, give bars a highlight

figure1 <- figure1 + geom_bar(position="dodge", stat="identity",color="gray")

# label bars with quantity, need to use "dodge" type for positioning, place value over top of bar

figure1 <- figure1 + geom_col(position = "dodge") +
  geom_text(
    aes(label = value),
    color = "black", size = 2,
    vjust = -0.4, position = position_dodge(.9))

# title the plot

figure1 <- figure1 + ggtitle("Data Reporting and Database Registration in Published HCTs")

# label axes and legend

figure1 <- figure1 + labs(x = "", y = "% of Studies")

# x category labels

figure1 <- figure1 +
  scale_x_discrete(
    labels=c('nodefineAEp' = 'AE undefined',
             'unclearAEp' = 'AE unclear',
             'nodataAEp' = 'AE no data',
             'nomentionSAEp' = 'SAE no mention',
             'nodataSAEp' = 'SAE no data',
             'registeredp' = 'Registered'
    )
  )

# adjust title position, fonts and grid theme

figure1 <- figure1 + theme(
  text = element_text(size = 10),
  plot.title.position = 'plot',
  plot.title = element_text(hjust = 0.5),
  axis.title.y = element_text(margin = margin(r = 0)),
  legend.position = c(0.82, 0.795),
  axis.ticks.x = element_blank(),
  panel.grid.minor.y = element_blank(),
  panel.grid.major.x = element_blank(),
  panel.grid.major.y = element_line(color = "#cccccc",
                                    size = 0.5,
                                    linetype = 1)
)

# set fill color scheme and labels

figure1 <- figure1 + scale_fill_brewer(palette = "Blues")
figure1 <- figure1 + scale_y_continuous(labels = label_percent(scale = 1))

# now make a final split by decade

figure1 <- figure1 + theme(axis.text.x = element_text(angle = 45, vjust = 1.0, hjust=1))
figure1 <- figure1 + facet_wrap(~Decade, nrow=3)
figure1 <- figure1 + theme(legend.position = "none")

# create Figure 2 plots

grf1 <- read_sheet(google_workbook, range="Figure2aData")
grf1s <- grf1 %>% pivot_longer(!`Pathogen category`,names_to="decade",values_to="studies")
ylabel <- range_read_cells(google_workbook, range="Figure2aStudies")

figure2a <- ggplot(grf1s,aes(x=reorder(`Pathogen category`,desc(studies), sum), y=studies, fill=decade)) +
  geom_bar(position="stack", stat="identity",color="gray") +
  ggtitle("Studies by Pathogen") +
  theme(axis.text.x = element_text(angle = 60, vjust = 1.0, hjust=1)) +
  labs(x = NULL, y = paste("Number of Studies ",ylabel$cell[[1]]$effectiveValue),fill="Decade/Era") +
  geom_col(position = position_stack(reverse = TRUE)) +
  theme(text = element_text(size = 10),
        plot.title.position = 'plot',
        plot.title = element_text(hjust = 0.5),
        legend.position = c(0.86, 0.75),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_line(color = "#cccccc",
                                          size = 0.5,
                                          linetype = 1)) +
  scale_fill_brewer(palette = "Greens")

# Plot for Systematic Review Graphic 2b
#
# 28 February 2022 JW 1DS Research Team

# Read the data.  Note that one should be authenticate if the document is protected to access data

grf2a <- read_sheet(google_workbook, range="Figure2bData")

# Change some dataframe names for clarity and ease of use

names(grf2a)[2] <- "Studies"
names(grf2a)[3] <- "AEs"

# Build the plot.  Decade on independent axis, participants quantity on dependent axis, by SAE and non-SAE

grf2a.cum <- melt(grf2a, id.vars = c("Era"), measure.vars = c("Registered","Unregistered"))
class(grf2a.cum$value) = "double" 

figure2b <- ggplot(grf2a.cum,aes(Era,value,fill=variable))

# side-by-side bars per decade, give bars a highlight

figure2b <- figure2b + geom_bar(position="dodge", stat="identity",color="gray")

# title the plot

figure2b <- figure2b + ggtitle("Data Reporting and Database Registration in Published HCTs")

# label axes and legend

figure2b <- figure2b + labs(x = "Year", y = "Studies", fill = "")

# adjust title position, fonts and grid theme

figure2b <- figure2b + theme(
  text = element_text(size = 10),
  plot.title.position = 'plot',
  plot.title = element_text(hjust = 0.5),
  axis.title.y = element_text(margin = margin(r = 0)),
  legend.position = c(0.91, 0.795),
  panel.grid.minor.y = element_blank(),
  panel.grid.major.x = element_blank(),
  panel.grid.major.y = element_line(color = "#cccccc",
                                    size = 0.5,
                                    linetype = 1)
)

# set fill color scheme and labels

figure2b <- figure2b + scale_fill_brewer(palette = "Set1", labels=c("Registered", "Unregistered"))
figure2b <- figure2b + theme(axis.text.x = element_text(angle = 45, vjust = 1.0, hjust=1))
figure2b <- figure2b + theme(legend.position = "top")

#
#
#

if (!development) {
  ggsave(file = "CID-113513-Figure1.eps") 
  print("Generating TIFF")
  tiff("CID-113513-Figure1.tiff", units="in", width=5, height=5, res=300, compression="zip")
}

figure1

if (!development) {
  ggsave(file = "CID-113513-Figure2a.eps") 
  print("Generating TIFF")
  tiff("CID-113513-Figure2a.tiff", units="in", width=5, height=5, res=300, compression="zip")
}

figure2a

if (!development) {
  ggsave(file = "CID-113513-Figure2b.eps") 
  print("Generating TIFF")
  tiff("CID-113513-Figure2b.tiff", units="in", width=5, height=5, res=300, compression="zip")  
}

figure2b

if (!development) {
  dev.off()
}