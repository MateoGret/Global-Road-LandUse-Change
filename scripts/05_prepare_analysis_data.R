

library(terra)
library(sf)

ensure_dir <- function(path) {
  if (!dir.exists(path)) dir.create(path, recursive = TRUE)
}

# Ordner
proc_grip_dir <- "data_processed/grip"
proc_lu_dir   <- "data_processed/landuse"
out_dir       <- "data_processed/analysis"

ensure_dir(out_dir)

# Regionen einlesen
regions <- st_read("data_processed/regions.gpkg", layer = "regions", quiet = TRUE)
region_ids <- regions$id


# Funktion


prepare_region_df <- function(region_id) {
  message("---- Bereite Analyse-Daten für Region vor: ", region_id, " ----")
  
  
  file_change <- file.path(proc_lu_dir,   paste0("builtup_change_", region_id, ".tif"))
  file_dens   <- file.path(proc_grip_dir, paste0("grip_dens_",        region_id, ".tif"))
  
  if (!file.exists(file_change)) {
    stop("Change-Raster fehlt für Region: ", region_id, " (", file_change, ")")
  }
  if (!file.exists(file_dens)) {
    stop("Road-Density-Raster fehlt für Region: ", region_id, " (", file_dens, ")")
  }
  
  r_change <- rast(file_change)
  r_dens   <- rast(file_dens)
  
  
  if (!all(res(r_dens) == res(r_change)) || !all(ext(r_dens) == ext(r_change))) {
    message("  ➜ Resample Road-Density auf Grid des Change-Rasters...")
    r_dens <- resample(r_dens, r_change, method = "bilinear")
  }
  
  
  r_stack <- c(r_change, r_dens)
  names(r_stack) <- c("builtup_change", "road_density")
  
  # In Dataframe umwandeln 
  df <- as.data.frame(r_stack, xy = TRUE, na.rm = TRUE)
  # Region-ID hinzufügen
  df$region <- region_id
  
 
  df <- df[complete.cases(df$builtup_change, df$road_density), ]
  
  # speichern
  out_file_region <- file.path(out_dir, paste0("builtup_road_change_", region_id, ".csv"))
  write.csv(df, out_file_region, row.names = FALSE)
  message("  ✔ CSV für Region gespeichert: ", out_file_region)
  message("  ➜ Anzahl Zeilen: ", nrow(df))
  
  return(df)
}



all_list <- lapply(region_ids, prepare_region_df)
all_df   <- do.call(rbind, all_list)


out_file_all <- file.path(out_dir, "builtup_road_change_allregions.csv")
write.csv(all_df, out_file_all, row.names = FALSE)

message(" alle Regionen verarbeitet.")
message(" Kombinierte Datei: ", out_file_all)

