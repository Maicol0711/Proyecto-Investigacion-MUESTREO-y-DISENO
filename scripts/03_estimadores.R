# 03_estimadores.R
# Objetivo: Calcular estimadores simples, de razón y comparar su eficiencia

if(!require(tidyverse)) install.packages("tidyverse")
if(!require(survey)) install.packages("survey")

library(tidyverse)
library(survey)

# Rutas de archivos
archivo_poblacional <- "C:/Users/micha/OneDrive/Documents/proyecto_investigativo_muestreo/datos_limpios.csv"
archivo_muestra <- "C:/Users/micha/OneDrive/Documents/proyecto_investigativo_muestreo/muestra_final.csv"

# Cargar base de muestra (y cargar la poblacional solo para obtener X barra poblacional general)
muestra <- read_csv(archivo_muestra, show_col_types = FALSE)
datos_poblacion <- read_csv(archivo_poblacional, col_select = c(FAMI_AÑOS_ESTUDIO_MADRE, ESTRATO_GRUPO), show_col_types = FALSE)

# Definir la variable auxiliar: Años de estudio de la madre
# Nota: Si vienen en texto o rangos, asegúrese que en limpieza se convirtieron a numérico. 
# Para efectos de la fórmula asumimos que es una variable numérica continua.

X_bar_Poblacional <- mean(datos_poblacion$FAMI_AÑOS_ESTUDIO_MADRE, na.rm = TRUE)
cat("Media Poblacional Auxiliar (Años Estudio Madre):", X_bar_Poblacional, "\n\n")

# --- Creación del objeto de encuesta (survey object) ---
# Usar los pesos w_h que calculamos para el Muestreo Estratificado
diseno_estratificado <- svydesign(
  id = ~1,                # Muestreo Aleatorio Simple dentro de cada estrato (sin conglomerados)
  strata = ~ESTRATO_GRUPO, 
  weights = ~w_h, 
  data = muestra
)

# 1. Estimador Simple (Media Estratificada para PUNT_GLOBAL)
estimador_simple <- svymean(~PUNT_GLOBAL, design = diseno_estratificado)
var_simple <- vcov(estimador_simple)[1]
ic_simple <- confint(estimador_simple)

cat("=== 1. Estimador Simple (Media Estratificada PUNT_GLOBAL) ===\n")
cat("Media:", coef(estimador_simple), "\n")
cat("Varianza:", var_simple, "\n")
cat("IC 95%:", ic_simple[1], "-", ic_simple[2], "\n\n")

# 2. Estimador de Razón usando variable auxiliar (Años de estudio madre)
# Utilizamos svyratio para obtener la razón r = Y_bar_muestral / X_bar_muestral
razon_est <- svyratio(~PUNT_GLOBAL, ~FAMI_AÑOS_ESTUDIO_MADRE, design = diseno_estratificado)
r_valor <- coef(razon_est)

# Multiplicando por la X_bar real de la población
estimador_razon_media <- r_valor * X_bar_Poblacional

# Calculando Varianza aproximada del estimador de razón: (X_bar_Poblacional)^2 * Var(r)
var_razon <- (X_bar_Poblacional^2) * as.numeric(vcov(razon_est))
ic_razon_inferior <- estimador_razon_media - 1.96 * sqrt(var_razon)
ic_razon_superior <- estimador_razon_media + 1.96 * sqrt(var_razon)

cat("=== 2. Estimador de Razón (usando FAMI_AÑOS_ESTUDIO_MADRE) ===\n")
cat("Media Estimada por Razón:", estimador_razon_media, "\n")
cat("Varianza de Razón:", var_razon, "\n")
cat("IC 95%:", ic_razon_inferior, "-", ic_razon_superior, "\n\n")

# 3. Comparación de Eficiencia
eficiencia <- (var_simple / var_razon) * 100

cat("=== 3. Comparación de Eficiencia ===\n")
cat(sprintf("Eficiencia: %.2f%%\n", eficiencia))
if(eficiencia > 100) {
  cat("El estimador de razón es MÁS eficiente que el simple.\n")
} else {
  cat("El estimador simple fue más eficiente dados los datos.\n")
}

# --- Exportar los resultados a CSV para usarlos en el dashboard y el documento ---
resultados_estimadores <- data.frame(
  Estimador = c("Simple", "De Razón"),
  Media = c(coef(estimador_simple), estimador_razon_media),
  Varianza = c(var_simple, var_razon),
  IC_Inferior = c(ic_simple[1], ic_razon_inferior),
  IC_Superior = c(ic_simple[2], ic_razon_superior),
  Eficiencia_vs_Razón = c(NA, eficiencia)
)

write_csv(resultados_estimadores, "C:/Users/micha/OneDrive/Documents/proyecto_investigativo_muestreo/resultados_estimadores.csv")
cat("\nResultados guardados en: resultados_estimadores.csv\n")
