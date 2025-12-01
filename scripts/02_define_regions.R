

library(sf)

# Hilfsfunktion
ensure_dir <- function(path) {
  if (!dir.exists(path)) dir.create(path, recursive = TRUE)
}


out_dir <- "data_processed"
ensure_dir(out_dir)



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




crs_ll <- 4326

regions_list <- lapply(seq_len(nrow(regions_df)), function(i) {
  row <- regions_df[i, ]
  
  # Bounding Box 
  bbox <- st_bbox(
    c(
      xmin = row$xmin,
      xmax = row$xmax,
      ymin = row$ymin,
      ymax = row$ymax
    ),
    crs = crs_ll
  )
  
  geom <- st_as_sfc(bbox)  
  
  st_sf(
    id   = row$id,
    name = row$name,
    geom = geom
  )
})


regions_sf <- do.call(rbind, regions_list)



out_file <- file.path(out_dir, "regions.gpkg")


st_write(regions_sf, out_file, layer = "regions", delete_layer = TRUE)

message(" Regionen gespeichert in: ", out_file)
print(regions_sf)