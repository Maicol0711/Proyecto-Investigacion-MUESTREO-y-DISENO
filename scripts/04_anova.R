# 04_anova.R
# Objetivo: Diseño Experimental Completamente al Azar (DCA) - ANOVA, Efectos y Tukey

if(!require(tidyverse)) install.packages("tidyverse")
if(!require(agricolae)) install.packages("agricolae")

library(tidyverse)
library(agricolae)

archivo_muestra <- "C:/Users/micha/OneDrive/Documents/proyecto_investigativo_muestreo/muestra_final.csv"
muestra <- read_csv(archivo_muestra, show_col_types = FALSE)

# Definir la variable factor
muestra$ESTRATO_GRUPO <- as.factor(muestra$ESTRATO_GRUPO)

materias <- c("PUNT_MATEMATICAS", "PUNT_LECTURA_CRITICA", "PUNT_INGLES", 
              "PUNT_SOCIALES_CIUDADANAS", "PUNT_C_NATURALES", "PUNT_GLOBAL")

resultados_anova <- data.frame()
resultados_tukey <- list()

for(materia in materias){
  cat("\n========================================\n")
  cat("Materia:", materia, "\n")
  cat("========================================\n")
  
  # Fórmula del modelo Y_ij = μ + τ_i + ε_ij
  formula <- as.formula(paste(materia, "~ ESTRATO_GRUPO"))
  
  # Ajustar Modelo
  modelo <- aov(formula, data = muestra)
  resumen_aov <- summary(modelo)
  print(resumen_aov)
  
  # Extraer datos de la tabla ANOVA
  df_efecto <- resumen_aov[[1]]$Df[1]
  df_error <- resumen_aov[[1]]$Df[2]
  ss_efecto <- resumen_aov[[1]]$`Sum Sq`[1]
  ss_error <- resumen_aov[[1]]$`Sum Sq`[2]
  ss_total <- ss_efecto + ss_error
  f_val <- resumen_aov[[1]]$`F value`[1]
  p_val <- resumen_aov[[1]]$`Pr(>F)`[1]
  
  # Tamaño del efecto (Eta-cuadrado)
  eta2 <- ss_efecto / ss_total
  interpretacion_eta2 <- case_when(
    eta2 < 0.01 ~ "Ninguno",
    eta2 < 0.06 ~ "Pequeño",
    eta2 < 0.14 ~ "Mediano",
    TRUE ~ "Grande"
  )
  
  cat(sprintf("Eta-cuadrado: %.4f (%s)\n", eta2, interpretacion_eta2))
  
  significativo <- ifelse(p_val < 0.05, "Sí", "No")
  
  # Comparaciones Múltiples de Tukey si es significativo
  pares_dif <- "Ninguno"
  if(significativo == "Sí"){
    cat("\nEjecutando Tukey HSD...\n")
    tukey <- HSD.test(modelo, "ESTRATO_GRUPO", group = TRUE)
    print(tukey$groups)
    
    # Extraer pares que son diferentes usando pairwise.t.test ajustado o HSD real
    tukey_full <- TukeyHSD(modelo)
    pares <- as.data.frame(tukey_full$ESTRATO_GRUPO)
    pares_dif <- paste(rownames(pares[pares$`p adj` < 0.05, ]), collapse = ", ")
    
    resultados_tukey[[materia]] <- pares
  }
  
  # Guardar los objetos del modelo para validación posterior
  saveRDS(modelo, file=paste0("C:/Users/micha/OneDrive/Documents/proyecto_investigativo_muestreo/modelo_anova_", materia, ".rds"))
  
  # Agregar a la tabla resumen
  fila <- data.frame(
    Materia = materia,
    F_value = f_val,
    p_value = p_val,
    Df_Estratos = df_efecto,
    Df_Error = df_error,
    Eta_Cuadrado = eta2,
    Tamano_Efecto = interpretacion_eta2,
    Significativo = significativo,
    Pares_Diferentes = pares_dif
  )
  resultados_anova <- bind_rows(resultados_anova, fila)
}

# Guardar Resultados Finales
write_csv(resultados_anova, "C:/Users/micha/OneDrive/Documents/proyecto_investigativo_muestreo/resultados_anova.csv")
cat("\n[!] Tabla maestra de ANOVA guardada con éxito en resultados_anova.csv\n")
