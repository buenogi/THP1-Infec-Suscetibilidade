################################################################################
################################## DR SbIII EDA ##################################
################################################################################

# Packages
library(dplyr)
library(ggplot2)


# Loading data
DataSbIII <-  read.csv(file = 
                         "Data/processed/DataSbIII_processed_normalized.csv",
                       header = TRUE, sep =",")


# Checking variables
sapply(DataSbIII, class)
DataSbIII$conc <- as.factor(DataSbIII$conc)
DataSbIII$pop <- as.factor(DataSbIII$pop)
DataSbIII$experiment <- as.factor(DataSbIII$experiment)
sapply(DataSbIII, class)

# Dose response - amastigotes accounts for each conc

AmaPcellplot <- ggplot(DataSbIII, aes(fill= conc,
                                      y = viability_normalized,
                                      x = pop))+
  geom_bar(position = "dodge", stat = "identity")+
  ggtitle("Nº of amastigote per cell SbIII dosage in different populations") +
  labs(x = " Conc [   ] μM ", y = "Nº of cells")+
  theme(plot.title = element_text(size = 14,face="bold"),
        axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size = 10),
        axis.title.x = element_text(size = 15),
        axis.title.y = element_text(size = 15))+
  facet_wrap(DataSbIII$experiment)
theme_bw()
AmaPcellplot

ggsave("Figures/09_SbIII_AmaPcellplot_SbIII.jpg")

# Lines

lineplot <- ggplot(DataSbIII, aes(y = viability_normalized, x = conc, group = pop))+
  geom_line(aes(color = pop))+
  ggtitle("Dose response pattern for different SbIII concentrations") +
  labs(x = " Conc [   ] μM ", y = "Nº of cells")+
  theme(plot.title = element_text(size = 14,face="bold"),
        axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size = 10),
        axis.title.x = element_text(size = 15),
        axis.title.y = element_text(size = 15))+
  facet_wrap(~experiment)+
  theme_bw()
lineplot

ggsave("Figures/08_SbIII_AmaPcellplot_SbIII.jpg")

# Summarized

EXP_sum <- DataSbIII%>%
  group_by(conc,pop)%>%
  summarise(mean_value = mean(viability_normalized), sd_value = sd(ama_per_cell) )

lineplot_sum <- ggplot(EXP_sum, aes(y = mean_value, x = conc, group = pop))+
  geom_line(aes(color = EXP_sum$pop))+
  ggtitle("Dose response pattern for different SbIII concentrations") +
  labs(x = " Conc [   ] μM ", y = "Nº of cells")+
  theme(plot.title = element_text(size = 14,face="bold"),
        axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size = 10),
        axis.title.x = element_text(size = 15),
        axis.title.y = element_text(size = 15))+
  theme_bw()
lineplot_sum+  labs(color = "Populations")

ggsave("Figures/10_SbIII_AmaPcellplot_SbIII.jpg")
