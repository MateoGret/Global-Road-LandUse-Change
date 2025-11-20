# ======================================================================
# 01_download_data.R
# ======================================================================
# Ziel:
#  - Kopiert vorhandene Dateien aus ../GRIP4_density_total und
#    ../BU-builtup/area in dein Projekt unter data_raw/.
#  - Keine Downloads, alles lokal.
# ======================================================================

ensure_dir <- function(path) {
  if (!dir.exists(path)) dir.create(path, recursive = TRUE)
}

raw_dir <- "data_raw"
ensure_dir(raw_dir)

# ======================================================================
# 1) GRIP – globaler Road-Datensatz (Dichte)
#    Quelle: Ordner ../GRIP4_density_total
# ======================================================================

grip_source_dir <- "../GRIP4_density_total"
grip_target_dir <- file.path(raw_dir, "grip")
ensure_dir(grip_target_dir)

# Diese Dateien liegen laut deinem Screenshot im GRIP4_density_total-Ordner:
grip_files <- c(
  "grip4_area_land_km2.asc",
  "grip4_total_dens_m_km2.asc"
)

for (fname in grip_files) {
  src <- file.path(grip_source_dir, fname)
  dst <- file.path(grip_target_dir, fname)
  
  if (!file.exists(src)) {
    message("⚠️ GRIP-Datei nicht gefunden: ", src)
  } else if (file.exists(dst)) {
    message("✔ GRIP-Datei bereits im Projekt: ", fname)
  } else {
    message("📂 Kopiere GRIP-Datei: ", fname)
    ok <- file.copy(src, dst)
    if (ok) {
      message("   ✔ Kopiert nach ", dst)
    } else {
      message("   ❌ Kopieren fehlgeschlagen für ", fname)
    }
  }
}

# ======================================================================
# 2) LUI / Built-up – nur 1992 und 2010
#    Quelle: Ordner ../BU-builtup/area
# ======================================================================

lui_source_dir <- "../BU-builtup/area"
lui_target_dir <- file.path(raw_dir, "landuse")
ensure_dir(lui_target_dir)

# Laut Screenshot heissen die Dateien z.B.:
# 1992area_km2_BU-builtup.tif
# 2010area_km2_BU-builtup.tif
lui_files <- c(
  "1992area_km2_BU-builtup.tif",
  "2010area_km2_BU-builtup.tif"
)

for (fname in lui_files) {
  src <- file.path(lui_source_dir, fname)
  dst <- file.path(lui_target_dir, fname)
  
  if (!file.exists(src)) {
    message("⚠️ LUI-Datei nicht gefunden: ", src)
  } else if (file.exists(dst)) {
    message("✔ LUI-Datei bereits im Projekt: ", fname)
  } else {
    message("📂 Kopiere LUI-Datei: ", fname)
    ok <- file.copy(src, dst)
    if (ok) {
      message("   ✔ Kopiert nach ", dst)
    } else {
      message("   ❌ Kopieren fehlgeschlagen für ", fname)
    }
  }
}

message("🎉 01_download_data.R – alle Kopieroperationen abgeschlossen.")