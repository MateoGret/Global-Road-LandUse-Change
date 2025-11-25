# ======================================================================
# 04_landuse_change.R
# ======================================================================
# Ziel:
#  - Für jede Region (kazakhstan, cerrado, borneo)
#    die Veränderung der bebauten Fläche berechnen:
#       Delta = BU_2010 - BU_1992
#  - Ergebnis als Raster speichern
#  - einfache Zusammenfassung (Summe der Zunahme in km²) ausgeben
# ======================================================================

library(terra)
library(sf)

ensure_dir <- function(path) {
  if (!dir.exists(path)) dir.create(path, recursive = TRUE)
}

# Ordner
proc_lu_dir   <- "data_processed/landuse"
ensure_dir(proc_lu_dir)

# Regionen aus der regions.gpkg holen (damit wir keine Namen tippen müssen)
regions <- st_read("data_processed/regions.gpkg", layer = "regions", quiet = TRUE)
region_ids <- regions$id

# ----------------------------------------------------------------------
# Funktion: Land-Use-Change für eine Region berechnen
# ----------------------------------------------------------------------

compute_change_for_region <- function(region_id) {
  message("---- Berechne Land-Use-Change für Region: ", region_id, " ----")
  
  # Dateinamen zusammensetzen
  file_1992 <- file.path(proc_lu_dir, paste0("builtup_1992_", region_id, ".tif"))
  file_2010 <- file.path(proc_lu_dir, paste0("builtup_2010_", region_id, ".tif"))
  
  if (!file.exists(file_1992)) {
    stop("1992 Raster fehlt für Region: ", region_id, " (", file_1992, ")")
  }
  if (!file.exists(file_2010)) {
    stop("2010 Raster fehlt für Region: ", region_id, " (", file_2010, ")")
  }
  
  bu1992 <- rast(file_1992)
  bu2010 <- rast(file_2010)
  
  # Sicherheitscheck: gleiche Auflösung und Extent
  if (!all(res(bu1992) == res(bu2010))) {
    stop("Auflösung von 1992 und 2010 stimmt nicht überein für Region: ", region_id)
  }
  if (!all(ext(bu1992) == ext(bu2010))) {
    stop("Extent von 1992 und 2010 stimmt nicht überein für Region: ", region_id)
  }
  
  # Change berechnen: 2010 - 1992
  bu_change <- bu2010 - bu1992
  
  # Ergebnis speichern
  out_file <- file.path(proc_lu_dir, paste0("builtup_change_", region_id, ".tif"))
  writeRaster(bu_change, filename = out_file, overwrite = TRUE)
  
  # Einfache Zusammenfassung: Summe der Zunahme (nur positive Werte)
  vals <- values(bu_change, na.rm = TRUE)
  increase <- vals[vals > 0]
  total_increase <- sum(increase, na.rm = TRUE)
  
  message("  ➜ Gesamtzunahme der bebauten Fläche (nur positive Differenzen): ",
          round(total_increase, 2), " km²")
  message("  ✔ Change-Raster gespeichert als: ", out_file)
  
  invisible(list(
    region = region_id,
    total_increase_km2 = total_increase
  ))
}

# ----------------------------------------------------------------------
# Schleife über alle Regionen
# ----------------------------------------------------------------------

results_list <- lapply(region_ids, compute_change_for_region)

# Ergebnis-Tabelle für die Konsole
results_df <- do.call(rbind, lapply(results_list, as.data.frame))
print(results_df)

message("🎉 04_landuse_change.R – Land-Use-Change für alle Regionen berechnet.")