

library(terra)
library(sf)

ensure_dir <- function(path) {
  if (!dir.exists(path)) dir.create(path, recursive = TRUE)
}

# Ordner
raw_grip_dir    <- "data_raw/grip"
raw_lu_dir      <- "data_raw/landuse"
proc_grip_dir   <- "data_processed/grip"
proc_lu_dir     <- "data_processed/landuse"

ensure_dir("data_processed")
ensure_dir(proc_grip_dir)
ensure_dir(proc_lu_dir)


regions <- st_read("data_processed/regions.gpkg", layer = "regions", quiet = TRUE)
regions_v <- vect(regions)  # sf -> SpatVector für terra

region_ids <- regions$id



# GRIP
grip_area <- rast(file.path(raw_grip_dir, "grip4_area_land_km2.asc"))
grip_dens <- rast(file.path(raw_grip_dir, "grip4_total_dens_m_km2.asc"))

# Built-up 1992 und 2010
bu1992 <- rast(file.path(raw_lu_dir, "1992area_km2_BU-builtup.tif"))
bu2010 <- rast(file.path(raw_lu_dir, "2010area_km2_BU-builtup.tif"))


message("GRIP CRS: ", crs(grip_dens))
message("Built-up CRS: ", crs(bu1992))



crop_for_region <- function(region_id) {
  message("---- Bearbeite Region: ", region_id, " ----")
  
  roi <- regions_v[regions_v$id == region_id, ]
  
 
  grip_area_crop <- mask(crop(grip_area, roi), roi)
  grip_dens_crop <- mask(crop(grip_dens, roi), roi)
  

  bu1992_crop <- mask(crop(bu1992, roi), roi)
  bu2010_crop <- mask(crop(bu2010, roi), roi)
  
 
  writeRaster(
    grip_area_crop,
    filename = file.path(proc_grip_dir, paste0("grip_area_", region_id, ".tif")),
    overwrite = TRUE
  )
  writeRaster(
    grip_dens_crop,
    filename = file.path(proc_grip_dir, paste0("grip_dens_", region_id, ".tif")),
    overwrite = TRUE
  )
  writeRaster(
    bu1992_crop,
    filename = file.path(proc_lu_dir, paste0("builtup_1992_", region_id, ".tif")),
    overwrite = TRUE
  )
  writeRaster(
    bu2010_crop,
    filename = file.path(proc_lu_dir, paste0("builtup_2010_", region_id, ".tif")),
    overwrite = TRUE
  )
  
  message("Fertig mit Region: ", region_id)
}


for (rid in region_ids) {
  crop_for_region(rid)
}

message("Zuschnitt für alle Regionen abgeschlossen.")