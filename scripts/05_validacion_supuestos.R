# 05_validacion_supuestos.R
# Objetivo: Validar Normalidad, Homocedasticidad e Independencia de los modelos

if(!require(tidyverse)) install.packages("tidyverse")
if(!require(car)) install.packages("car")

library(tidyverse)
library(car)

materias <- c("PUNT_MATEMATICAS", "PUNT_LECTURA_CRITICA", "PUNT_INGLES", 
              "PUNT_SOCIALES_CIUDADANAS", "PUNT_C_NATURALES", "PUNT_GLOBAL")
muestra <- read_csv("C:/Users/micha/OneDrive/Documents/proyecto_investigativo_muestreo/muestra_final.csv", show_col_types = FALSE)
muestra$ESTRATO_GRUPO <- as.factor(muestra$ESTRATO_GRUPO)

resultados_supuestos <- data.frame()

for(materia in materias){
  cat("\nAnalizando supuestos para:", materia, "\n")
  modelo <- readRDS(paste0("C:/Users/micha/OneDrive/Documents/proyecto_investigativo_muestreo/modelo_anova_", materia, ".rds"))
  
  residuos <- residuals(modelo)
  ajustados <- fitted(modelo)
  
  # 1. NORMALIDAD
  # La prueba Shapiro-Wilk admite máximo n=5000. Nuestra muestra es n=2400 (Válido)
  shap <- shapiro.test(residuos)
  
  # Gráfico QQ-Plot
  png(paste0("C:/Users/micha/OneDrive/Documents/proyecto_investigativo_muestreo/qqplot_", materia, ".png"), width = 600, height = 500)
  qqnorm(residuos, main = paste("QQ-Plot de Residuos -", materia))
  qqline(residuos, col = "red", lwd = 2)
  dev.off()
  
  # Histograma
  png(paste0("C:/Users/micha/OneDrive/Documents/proyecto_investigativo_muestreo/hist_", materia, ".png"), width = 600, height = 500)
  hist(residuos, freq = FALSE, main = paste("Histograma de Residuos -", materia), col = "lightblue", xlab="Residuos")
  curve(dnorm(x, mean=mean(residuos), sd=sd(residuos)), add=TRUE, col="darkblue", lwd=2)
  dev.off()
  
  # 2. HOMOCEDASTICIDAD
  # Prueba de Levene y Bartlett
  lev <- leveneTest(modelo)
  lev_p <- lev$`Pr(>F)`[1]
  
  bart <- bartlett.test(residuos ~ muestra$ESTRATO_GRUPO)
  
  # Gráfico Residuos vs Ajustados
  png(paste0("C:/Users/micha/OneDrive/Documents/proyecto_investigativo_muestreo/res_vs_fit_", materia, ".png"), width = 600, height = 500)
  plot(ajustados, residuos, main = paste("Residuos vs Ajustados -", materia), xlab="Ajustados", ylab="Residuos", pch=20)
  abline(h=0, col="red")
  dev.off()
  
  # 3. INDEPENDENCIA (Garantizada por diseño, pero mostramos residual vs indice)
  png(paste0("C:/Users/micha/OneDrive/Documents/proyecto_investigativo_muestreo/independencia_", materia, ".png"), width = 600, height = 500)
  plot(residuos, type="l", main=paste("Residuos Secuenciales -", materia), ylab="Residuos", xlab="Orden")
  abline(h=0, col="red")
  dev.off()
  
  # Conclusiones
  normalidad_c <- ifelse(shap$p.value > 0.05, "Se Cumple", "Se Viola")
  homocedasticidad_c <- ifelse(lev_p > 0.05, "Se Cumple", "Se Viola")
  
  fila <- data.frame(
    Materia = materia,
    Shapiro_Est = shap$statistic,
    Shapiro_P = shap$p.value,
    Normalidad = normalidad_c,
    Levene_P = lev_p,
    Bartlett_P = bart$p.value,
    Homocedasticidad = homocedasticidad_c
  )
  resultados_supuestos <- bind_rows(resultados_supuestos, fila)
}

write_csv(resultados_supuestos, "C:/Users/micha/OneDrive/Documents/proyecto_investigativo_muestreo/resultados_supuestos.csv")
cat("\nSe completaron las pruebas de supuestos. Imágenes PNG exportadas al directorio raíz.\n")
