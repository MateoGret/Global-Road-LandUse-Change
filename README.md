# Global Effects of Road Development on Land-Use Change

This repository contains the full workflow and final report for the project analysing how road density relates to built-up land-use change between 1992 and 2010. Three regions are studied: Northern Kazakhstan, the Brazilian Cerrado, and West Kalimantan (Borneo).

## Data

The following datasets were obtained from external sources and are stored in `data_raw/`.

### Land-use (Built-up)
- Esch et al., 2012 – Global Urban Footprint (1992)
- Esch et al., 2020 – Global Urban Footprint / World Settlement Footprint (2010)

### Road density (GRIP)
- Meijer et al., 2018 – Global Road Inventory Project 


## Repository structure
- data_raw/ – original input data  
- data_processed/ – cropped regions and processed tables  
- figs/ – all generated plots  
- scripts/ – analysis scripts (01–06)  
- vignettes/ – final report (report.Rmd + report.html)

## Workflow
1. Define regions  
2. Crop land-use and road data  
3. Compute built-up change (2010–1992)  
4. Merge datasets  
5. Create plots and summary statistics  
6. Compile final report

## How to Reproduce
i. Clone or download the project  
   git clone https://github.com/MateoGret/Global-Road-LandUse-Change.git  

ii. Install required R packages  
   install.packages(c("tidyverse", "terra", "sf", "here", "ggplot2", "dplyr"))  

iii. Download the required datasets  
   (see data_raw/README.md for links and instructions)  

iv. Run the analysis scripts in order  
   01_load_and_prepare_data.R  
   02_compute_landuse_change.R  
   03_merge_datasets.R  
   04_analyze_relationships.R  
   05_generate_plots.R  
   06_analysis.R  

v. Generated outputs  
   fig/  
   analysis/  


## Outputs
- Figures in `figs/`  
- Processed data in `data_processed/`  
- Full report in `vignettes/report.html`

## Dependencies

Install all required R packages by:

```r
use_pkgs <- c(
  "sf",
  "terra",
  "dplyr",
  "purrr",
  "ggplot2"
)

new_pkgs <- use_pkgs[!(use_pkgs %in% installed.packages()[, "Package"])]
if (length(new_pkgs) > 0) install.packages(new_pkgs)