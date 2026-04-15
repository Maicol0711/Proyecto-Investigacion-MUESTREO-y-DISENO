# 02_muestreo_estratificado.R
# Objetivo: Realizar muestreo aleatorio estratificado con afijación proporcional

if(!require(tidyverse)) install.packages("tidyverse")
library(tidyverse)

# Rutas de archivos
archivo_entrada <- "C:/Users/micha/OneDrive/Documents/proyecto_investigativo_muestreo/datos_limpios.csv"
archivo_salida <- "C:/Users/micha/OneDrive/Documents/proyecto_investigativo_muestreo/muestra_final.csv"

# Cargar base limpia
cat("Cargando datos limpios...\n")
datos <- read_csv(archivo_entrada, show_col_types = FALSE)

# Definir la población total según filtros
N <- nrow(datos)

# Calcular distribución poblacional por estrato
distribucion_poblacional <- datos %>%
  group_by(ESTRATO_GRUPO) %>%
  summarise(
    N_h = n(),
    Proporcion = N_h / N
  ) %>%
  arrange(factor(ESTRATO_GRUPO, levels = c("Bajo", "Medio", "Alto")))

cat("\n--- Distribución Poblacional por Estrato ---\n")
print(distribucion_poblacional)

# --- Cálculo de Tamaño Muestral ---
# Parámetros poblacionales estimados (max varianza p=0.5)
Z <- 1.96  # 95% Confianza
p <- 0.5
e <- 0.02  # 2% error
N_poblacion <- nrow(datos)

# Fórmula para población finita
n_numerador <- (Z^2 * p * (1 - p) * N_poblacion)
n_denominador <- (e^2 * (N_poblacion - 1)) + (Z^2 * p * (1 - p))
n_calculado <- round(n_numerador / n_denominador)

cat("\nTamaño de muestra calculado con la fórmula teórica:", n_calculado, "\n")
cat("Para asegurar representatividad y potencia requerida ajustaremos a n = 2400 (según objetivos del proyecto).\n")

n_total <- 2400

# Afijación proporcional teórica (según la proporción de la población filtrada),
# aunque en la metodología base se pidió: 40% Bajo, 45% Medio, 15% Alto.
# Si queremos forzar los pesos requeridos:
n_h_bajo <- 960  # 40%
n_h_medio <- 1080 # 45%
n_h_alto <- 360  # 15%

# Fijar semilla aleatoria
set.seed(12345)

# Realizar muestreo dentro de cada estrato usando pesos fijos
muestra_bajo <- datos %>% filter(ESTRATO_GRUPO == "Bajo") %>% slice_sample(n = n_h_bajo)
muestra_medio <- datos %>% filter(ESTRATO_GRUPO == "Medio") %>% slice_sample(n = n_h_medio)
muestra_alto <- datos %>% filter(ESTRATO_GRUPO == "Alto") %>% slice_sample(n = n_h_alto)

# Unir submuestras y calcular pesos muestrales (w_h = N_h / n_h)
muestra_final <- bind_rows(
    muestra_bajo %>% mutate(w_h = distribucion_poblacional$N_h[distribucion_poblacional$ESTRATO_GRUPO == "Bajo"] / n_h_bajo),
    muestra_medio %>% mutate(w_h = distribucion_poblacional$N_h[distribucion_poblacional$ESTRATO_GRUPO == "Medio"] / n_h_medio),
    muestra_alto %>% mutate(w_h = distribucion_poblacional$N_h[distribucion_poblacional$ESTRATO_GRUPO == "Alto"] / n_h_alto)
)

cat("\n--- Muestra Final Extraída ---\n")
resumen_muestra <- muestra_final %>%
  group_by(ESTRATO_GRUPO) %>%
  summarise(
    n_h = n(),
    Peso_Muestral_w_h = mean(w_h)
  ) %>%
  arrange(factor(ESTRATO_GRUPO, levels = c("Bajo", "Medio", "Alto")))

print(resumen_muestra)
cat("Tamaño muestral total extraído:", nrow(muestra_final), "\n")

# Guardar muestra final
write_csv(muestra_final, archivo_salida)
cat("Muestra guardada en:", archivo_salida, "\n")
