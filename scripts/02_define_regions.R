# ======================================================================
# 02_define_regions.R
# ======================================================================
# Ziel:
#  - Definiert drei Studienregionen (Kazakhstan, Cerrado, Borneo)
#  - jede Region als Bounding Box (Rechteck) in Lon/Lat (EPSG:4326)
#  - speichert das Ergebnis als sf-Layer in data_processed/regions.gpkg
# ======================================================================

library(sf)

# kleine Hilfsfunktion, falls du sie noch nicht hast
ensure_dir <- function(path) {
  if (!dir.exists(path)) dir.create(path, recursive = TRUE)
}

# Ausgabeverzeichnis
out_dir <- "data_processed"
ensure_dir(out_dir)

# --------------------------------------------------
# 1) Parameter der Bounding Boxes
#    (xmin = Längengrad min, xmax = Längengrad max,
#     ymin = Breitengrad min, ymax = Breitengrad max)
# --------------------------------------------------

regions_df <- data.frame(
  id   = c("kazakhstan",       "cerrado",          "borneo"),
  name = c("Northern Kazakhstan",
           "Brazilian Cerrado",
           "West Kalimantan, Borneo"),
  xmin = c(62,   -46, 109),
  xmax = c(64,   -44, 111),
  ymin = c(52, -13.5,   0),
  ymax = c(54, -11.5,   2),
  stringsAsFactors = FALSE
)

# --------------------------------------------------
# 2) Aus Bounding Boxes sf-Polygone bauen
# --------------------------------------------------

# EPSG:4326 = WGS84, Grad (Lon/Lat)
crs_ll <- 4326

regions_list <- lapply(seq_len(nrow(regions_df)), function(i) {
  row <- regions_df[i, ]
  
  # Bounding Box definieren
  bbox <- st_bbox(
    c(
      xmin = row$xmin,
      xmax = row$xmax,
      ymin = row$ymin,
      ymax = row$ymax
    ),
    crs = crs_ll
  )
  
  geom <- st_as_sfc(bbox)  # macht aus dem bbox ein Rechteck-Polygon
  
  st_sf(
    id   = row$id,
    name = row$name,
    geom = geom
  )
})

# Einzelne sf-Objekte zu einem zusammenfügen
regions_sf <- do.call(rbind, regions_list)

# --------------------------------------------------
# 3) Als GeoPackage speichern
# --------------------------------------------------

out_file <- file.path(out_dir, "regions.gpkg")

# Falls die Datei/Layer schon existiert, überschreiben wir den Layer
st_write(regions_sf, out_file, layer = "regions", delete_layer = TRUE)

message("🎉 Regionen gespeichert in: ", out_file)
print(regions_sf)