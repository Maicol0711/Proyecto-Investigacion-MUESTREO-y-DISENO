# Script maestro para ejecutar todo el proyecto
setwd("C:/Users/micha/OneDrive/Documents/proyecto_investigativo_muestreo")

cat("=== EJECUTANDO SCRIPT 1: LIMPIEZA ===\n")
source("01_limpieza_datos.R")

cat("=== EJECUTANDO SCRIPT 2: MUESTREO ===\n")
source("02_muestreo_estratificado.R")

cat("=== EJECUTANDO SCRIPT 3: ESTIMADORES ===\n")
source("03_estimadores.R")

cat("=== EJECUTANDO SCRIPT 4: ANOVA ===\n")
source("04_anova.R")

cat("=== EJECUTANDO SCRIPT 5: SUPUESTOS ===\n")
source("05_validacion_supuestos.R")

cat("=== EJECUTANDO SCRIPT 6: POTENCIA ===\n")
source("06_analisis_potencia.R")

cat("\n=== ¡PROCESO COMPLETADO! ===\n")
cat("Revisa la carpeta para ver todos los resultados.\n")

#---------------------------------------------------------------------------------------------

setwd("C:/Users/micha/OneDrive/Documents/proyecto_investigativo_muestreo")

# Ver archivos CSV de resultados
list.files(pattern = "\\.csv$")

# Cargar y ver resultados
resultados_anova <- read.csv("resultados_anova.csv")
print("=== ANOVA ===")
print(resultados_anova)

resultados_est <- read.csv("resultados_estimadores.csv")
print("=== ESTIMADORES ===")
print(resultados_est)

resultados_pot <- read.csv("resultados_potencia.csv")
print("=== POTENCIA ===")
print(resultados_pot)


#----------------------------------------------------------------------------------

setwd("C:/Users/micha/OneDrive/Documents/proyecto_investigativo_muestreo")
shiny::runApp("dashboard_app.R")


source("C:/Users/micha/OneDrive/Documents/proyecto_investigativo_muestreo/dashboard_app.R")







