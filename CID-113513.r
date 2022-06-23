# CID-113513.r - plot for Systematic Review Figures 2 and 3
#   Tested with R 4.1.3
#
# Read from Google Sheet dataset at https://bit.ly/1DSSR22
#   
# 23 February 2022  JW prepare for pre-print
# 16 June 2022      JW adopt to final published dataset
# 22 June 2022	    JW shift figure numbers, update layout for CID

# call required libraries for this ggplot

library(ggplot2)
library(gridExtra)
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
#ps.options(colormodel="cmyk")

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


# Build Figure 2.  Decade on independent axis, participants quantity on dependent axis, by SAE and non-SAE

figure2 <- ggplot(grf3s.cum,aes(variable,value,fill=Decade))

# side-by-side bars per decate, give bars a highlight

figure2 <- figure2 + geom_bar(position="dodge", stat="identity",color="gray")

# label bars with quantity, need to use "dodge" type for positioning, place value over top of bar

figure2 <- figure2 + geom_col(position = "dodge") +
  geom_text(
    aes(label = value),
    color = "black", size = 2,
    vjust = -0.4, position = position_dodge(.9))

# title the plot

figure2 <- figure2 + ggtitle("Data Reporting and Database Registration in Published HCTs")

# label axes and legend

figure2 <- figure2 + labs(x = "", y = "% of Studies")

# x category labels

figure2 <- figure2 +
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

figure2 <- figure2 + theme(
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

figure2 <- figure2 + scale_fill_brewer(palette = "Blues")
figure2 <- figure2 + scale_y_continuous(labels = label_percent(scale = 1))

# now make a final split by decade

figure2 <- figure2 + theme(axis.text.x = element_text(angle = 45, vjust = 1.0, hjust=1))
figure2 <- figure2 + facet_wrap(~Decade, nrow=3)
figure2 <- figure2 + theme(legend.position = "none")

# create Figure 3 plots

grf1 <- read_sheet(google_workbook, range="Figure2aData")
grf1s <- grf1 %>% pivot_longer(!`Pathogen category`,names_to="decade",values_to="studies")
ylabel <- range_read_cells(google_workbook, range="Figure2aStudies")

figure3a <- ggplot(grf1s,aes(x=reorder(`Pathogen category`,desc(studies), sum), y=studies, fill=decade)) +
  geom_bar(position="stack", stat="identity",color="gray") +
  ggtitle("Studies by Pathogen", subtitle="Figure 3A") +
  theme(axis.text.x = element_text(angle = 60, vjust = 1.0, hjust=1)) +
  labs(x = NULL, y = paste("Number of Studies ",ylabel$cell[[1]]$effectiveValue),fill="Decade/Era") +
  geom_col(position = position_stack(reverse = TRUE)) +
  theme(text = element_text(size = 10),
        plot.title.position = 'plot',
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        legend.position = c(0.86, 0.75),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_line(color = "#cccccc",
                                          size = 0.5,
                                          linetype = 1)) +
  scale_fill_brewer(palette = "Greens")

# Plot for Systematic Review Graphic 3b
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

figure3b <- ggplot(grf2a.cum,aes(Era,value,fill=variable))

# side-by-side bars per decade, give bars a highlight

figure3b <- figure3b + geom_bar(position="dodge", stat="identity",color="gray")

# title the plot

figure3b <- figure3b + ggtitle("Data Reporting and Database Registration in Published HCTs", subtitle="Figure 3B")

# label axes and legend

figure3b <- figure3b + labs(x = "Year", y = "Studies", fill = "")

# adjust title position, fonts and grid theme

figure3b <- figure3b + theme(
  text = element_text(size = 10),
  plot.title.position = 'plot',
  plot.title = element_text(hjust = 0.5),
  plot.subtitle = element_text(hjust = 0.5),
  axis.title.y = element_text(margin = margin(r = 0)),
  legend.position = c(0.91, 0.795),
  panel.grid.minor.y = element_blank(),
  panel.grid.major.x = element_blank(),
  panel.grid.major.y = element_line(color = "#cccccc",
                                    size = 0.5,
                                    linetype = 1)
)

# set fill color scheme and labels

figure3b <- figure3b + scale_fill_brewer(palette = "Set1", labels=c("Registered", "Unregistered"))
figure3b <- figure3b + theme(axis.text.x = element_text(angle = 45, vjust = 1.0, hjust=1))
figure3b <- figure3b + theme(legend.position = "top")

#
#
#

if (!development) {
  tiff("CID-113513-figure2.tiff", units="in", width=5, height=5, res=1200, compression="zip")
}

#figure2
grid.arrange(figure2, ncol=1, top = "Figure 2")

if (!development) {
  ggsave(file = "CID-113513-figure2.eps") 
  tiff("CID-113513-figure3a.tiff", units="in", width=5, height=5, res=1200, compression="zip")
}

figure3a

if (!development) {
  ggsave(file = "CID-113513-figure3a.eps") 
  tiff("CID-113513-figure3b.tiff", units="in", width=5, height=5, res=1200, compression="zip")  
}

figure3b

if (!development) {
  ggsave(file = "CID-113513-figure3b.eps") 
  tiff("CID-113513-figure3.tiff", units="in", width=10, height=5, res=1200, compression="zip")  
}

grid.arrange(figure3a, figure3b, ncol=2, top = "Figure 3")

if (!development) {
  ggsave(file = "CID-113513-figure3.eps") 
}

if (!development) {
  dev.off()
}