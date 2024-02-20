## install packages
install.packages("tidyverse")
install.packages("readxl")
install.packages("GGally")

## load packages
library(tidyverse)
library(readxl)

## get list of files in the folder

list.files("data")

## loading in the data
## see what sheets are in the Excel workbook

excel_sheets("data/rockydata.xlsx")

## Sites
## Read in data

sites <- read_xlsx("data/rockydata.xlsx", sheet = "Sites")

## print a summary

sites

## Getting things tidy
## putting data into long format
sites %>%
  pivot_longer(cols = c("PercentRock", "waterPH", "SurfaceTemp"), names_to = "variable", values_to = "value")

## Species
## read in data
species <- read_xlsx("data/rockydata.xlsx", sheet = "Species")

## print a summary
species

## Getting things tidy
## putting data into wide format
species %>%
  select(Site, Point, WorkingName) %>%
  mutate(Presence = 1) %>% # adds a column called "Presence" filled with "1"
  pivot_wider(names_from = WorkingName, values_from = Presence, values_fill = 0)

## use unite to combine the site and point columns into a new column caled SItePoint 
read_xlsx("data/rockydata.xlsx", sheet = "Species") %>% 
  unite("SitePoint", Site:Point, sep = "_") %>%
  select(SitePoint, WorkingName) %>%
  mutate(Presence = 1) %>% # adds a column called "Presence" filled with "1"
  pivot_wider(names_from = WorkingName, values_from = Presence, values_fill = 0)

## calculate number of species recorded in each site. save it as sr
sr <- read_xlsx("data/rockydata.xlsx", sheet = "Species") %>% 
  unite("SitePoint", Site:Point, sep = "_") %>%
  select(SitePoint, WorkingName) %>% 
  group_by(SitePoint) %>%
  summarize(`Species Number` = n())

sr

##read in site data, select columns and join sr
read_xlsx("data/rockydata.xlsx", sheet = "Sites") %>%
  select(SitePoint, PercentRock, waterPH) %>%
  left_join(sr, by = "SitePoint")

## plot comparisons
read_xlsx("data/rockydata.xlsx", sheet = "Sites") %>%
  select(SitePoint, PercentRock, waterPH) %>%
  left_join(sr, by = "SitePoint") %>%
  GGally::ggpairs(columns = 2:ncol(.))

