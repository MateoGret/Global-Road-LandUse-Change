# ======================================================================
# 06_analysis.R
# ======================================================================
# Ziel:
#  - Analyse der Beziehung zwischen Land-Use-Change und Straßendichte
#  - Deskriptive Statistiken
#  - Scatterplots, Boxplots, Trendlinien
#  - Aufteilung nach Region
#  - Speichern von Plots in figs/
# ======================================================================

library(ggplot2)
library(dplyr)
library(readr)

ensure_dir <- function(path) {
  if (!dir.exists(path)) dir.create(path, recursive = TRUE)
}

# Ordner für Figuren
fig_dir <- "figs"
ensure_dir(fig_dir)

# ----------------------------------------------------------------------
# 1) Daten einlesen
# ----------------------------------------------------------------------

df <- read_csv("data_processed/analysis/builtup_road_change_allregions.csv")

# Daten prüfen
print("Datenvorschau:")
print(head(df))

# ----------------------------------------------------------------------
# 2) Deskriptive Statistik
# ----------------------------------------------------------------------

summary_stats <- df %>%
  group_by(region) %>%
  summarise(
    mean_change = mean(builtup_change, na.rm = TRUE),
    median_change = median(builtup_change, na.rm = TRUE),
    mean_road_density = mean(road_density, na.rm = TRUE),
    n = n()
  )

print("Zusammenfassung pro Region:")
print(summary_stats)

write.csv(summary_stats, "figs/summary_stats_regions.csv", row.names = FALSE)

# ----------------------------------------------------------------------
# 3) Scatterplot: Change vs. Road Density
# ----------------------------------------------------------------------

p1 <- ggplot(df, aes(x = road_density, y = builtup_change, color = region)) +
  geom_point(alpha = 0.3, size = 1) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1) +
  labs(
    title = "Land-Use-Change vs. Straßendichte",
    x = "Straßendichte (m Straße pro km²)",
    y = "Zunahme bebaute Fläche (2010–1992)"
  ) +
  theme_minimal()

ggsave("figs/scatter_change_vs_road.png", p1, width = 8, height = 5)

# ----------------------------------------------------------------------
# 4) Boxplot nach Region
# ----------------------------------------------------------------------

p2 <- ggplot(df, aes(x = region, y = builtup_change, fill = region)) +
  geom_boxplot(outlier.alpha = 0.4) +
  labs(
    title = "Verteilung des Land-Use-Change pro Region",
    y = "Built-up Change",
    x = ""
  ) +
  theme_minimal()

ggsave("figs/boxplot_change_by_region.png", p2, width = 7, height = 5)

# ----------------------------------------------------------------------
# 5) Beziehung innerhalb jeder Region
# ----------------------------------------------------------------------

p3 <- ggplot(df, aes(x = road_density, y = builtup_change)) +
  geom_point(alpha = 0.2) +
  geom_smooth(method = "lm", color = "red", linewidth = 1.2) +
  facet_wrap(~ region, scales = "free") +
  labs(
    title = "Zusammenhang zwischen Straßen und Land-Use-Change (je Region)",
    x = "Straßendichte",
    y = "Built-up Change"
  ) +
  theme_minimal()

ggsave("figs/facet_change_vs_road.png", p3, width = 8, height = 6)

# ----------------------------------------------------------------------
# Ende
# ----------------------------------------------------------------------

message("🎉 Schritt 6 abgeschlossen – Plots gespeichert in /figs/")