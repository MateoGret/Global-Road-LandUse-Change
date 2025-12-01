

ensure_dir <- function(path) {
  if (!dir.exists(path)) dir.create(path, recursive = TRUE)
}

raw_dir <- "data_raw"
ensure_dir(raw_dir)



grip_source_dir <- "../GRIP4_density_total"
grip_target_dir <- file.path(raw_dir, "grip")
ensure_dir(grip_target_dir)


grip_files <- c(
  "grip4_area_land_km2.asc",
  "grip4_total_dens_m_km2.asc"
)

for (fname in grip_files) {
  src <- file.path(grip_source_dir, fname)
  dst <- file.path(grip_target_dir, fname)
  
  if (!file.exists(src)) {
    message("GRIP-Datei nicht gefunden: ", src)
  } else if (file.exists(dst)) {
    message("GRIP-Datei bereits im Projekt: ", fname)
  } else {
    message("Kopiere GRIP-Datei: ", fname)
    ok <- file.copy(src, dst)
    if (ok) {
      message(" Kopiert nach ", dst)
    } else {
      message(" Kopieren fehlgeschlagen für ", fname)
    }
  }
}



lui_source_dir <- "../BU-builtup/area"
lui_target_dir <- file.path(raw_dir, "landuse")
ensure_dir(lui_target_dir)


lui_files <- c(
  "1992area_km2_BU-builtup.tif",
  "2010area_km2_BU-builtup.tif"
)

for (fname in lui_files) {
  src <- file.path(lui_source_dir, fname)
  dst <- file.path(lui_target_dir, fname)
  
  if (!file.exists(src)) {
    message("LUI-Datei nicht gefunden: ", src)
  } else if (file.exists(dst)) {
    message("LUI-Datei bereits im Projekt: ", fname)
  } else {
    message("Kopiere LUI-Datei: ", fname)
    ok <- file.copy(src, dst)
    if (ok) {
      message(" Kopiert nach ", dst)
    } else {
      message(" Kopieren fehlgeschlagen für ", fname)
    }
  }
}

message("alle Kopieroperationen abgeschlossen.")