# Load required libraries
library(tidyverse)
library(readxl)

setwd("C:/Users/perso/Desktop/WORK/QCB/4_SEMESTRE/Single_Cell/scRNAseq_CS5_unknown")

# Read Excel file
excel_data <- read_excel("Cell_marker_Mouse.xlsx")
ref_excel_data <- read_excel("ScTypeDB_full.xlsx")
ref_excel_data <- ref_excel_data[,1:4]

manipulated_data2 <- excel_data %>%
  select(tissue_class,cell_name) %>%
  distinct(cell_name, .keep_all = TRUE)

# Perform the manipulation
manipulated_data <- excel_data %>%
  select(cell_name,marker,Symbol)

data1 <- manipulated_data  %>% 
  select(-Symbol) %>%
  group_by(cell_name) %>%
  summarise(geneSymbolmore1 = paste(marker, collapse = ", ")) %>%
  ungroup() # ungroup the data frame

data2 <- manipulated_data  %>% 
  select(-marker) %>%
  group_by(cell_name) %>%
  summarise(geneSymbolmore2 = paste(Symbol, collapse = ", ")) %>%
  ungroup() # ungroup the data frame

data1$geneSymbolmore2 <- data2$geneSymbolmore2

df_final <- merge(data1, manipulated_data2, "cell_name")
df_final <- df_final %>% relocate(tissue_class)

df_final$shortName <- df_final$cell_name
df_final$geneSymbolmore2 <- NULL

library("writexl")
write_xlsx(df_final, "NEW_marker.xlsx")

write.csv(df_final,"NEW_marker.csv")
# Write the manipulated data to the new Excel file
