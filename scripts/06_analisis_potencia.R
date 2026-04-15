# 06_analisis_potencia.R
# Objetivo: Realizar el análisis de potencia del diseño a posteriori.

if(!require(tidyverse)) install.packages("tidyverse")
if(!require(pwr)) install.packages("pwr")

library(tidyverse)
library(pwr)

archivo_muestra <- "C:/Users/micha/OneDrive/Documents/proyecto_investigativo_muestreo/muestra_final.csv"
muestra <- read_csv(archivo_muestra, show_col_types = FALSE)

# Parámetros del experimento
delta <- 10  # Diferencia mínima relevante pedida
alpha <- 0.05
k <- 3 # 3 grupos: Bajo, Medio, Alto

materias <- c("PUNT_MATEMATICAS", "PUNT_LECTURA_CRITICA", "PUNT_INGLES", 
              "PUNT_SOCIALES_CIUDADANAS", "PUNT_C_NATURALES", "PUNT_GLOBAL")

resultados_potencia <- data.frame()

for(materia in materias){
  
  # Calcular varianza por estrato para hallar el Sigma Pooled
  var_estratos <- muestra %>%
    group_by(ESTRATO_GRUPO) %>%
    summarise(var = var(get(materia), na.rm=TRUE), n = n())
  
  # Sigma pooled (promediado aproximado considerando muestra desbalanceada)
  # Fórmula clásica de Varianza Combinada
  sp_squared <- sum((var_estratos$n - 1) * var_estratos$var) / sum(var_estratos$n - 1)
  sigma_pooled <- sqrt(sp_squared)
  
  n_promedio <- mean(var_estratos$n) # Usamos un promedio del tamaño muestral para la estimación de potencia estándar
  
  # Calcular Tamaño de Efecto de Cohen f
  f_efecto <- delta / sigma_pooled
  
  # Calculo de la potencia actual
  test_potencia <- pwr.anova.test(k = k, n = n_promedio, f = f_efecto, sig.level = alpha)
  potencia_actual <- test_potencia$power
  
  interpretacion <- ifelse(potencia_actual >= 0.80, "Suficiente (>=80%)", "Insuficiente (<80%)")
  
  # Si es insuficiente, calculamos n necesario por grupo
  n_necesario <- NA
  replicas_adicionales_por_grupo <- 0
  if(potencia_actual < 0.80){
    calc_n <- pwr.anova.test(k = k, power = 0.80, f = f_efecto, sig.level = alpha)
    n_necesario <- ceiling(calc_n$n)
    replicas_adicionales_por_grupo <- n_necesario - round(n_promedio)
    if(replicas_adicionales_por_grupo < 0) replicas_adicionales_por_grupo <- 0
  }
  
  fila <- data.frame(
    Materia = materia,
    Sigma_Pooled = sigma_pooled,
    Delta = delta,
    Efecto_f = f_efecto,
    Potencia = potencia_actual,
    Interpretacion = interpretacion,
    N_necesario_por_grupo = ifelse(is.na(n_necesario), "No requiere", n_necesario),
    Replicas_Adicionales = replicas_adicionales_por_grupo
  )
  
  resultados_potencia <- bind_rows(resultados_potencia, fila)
}

write_csv(resultados_potencia, "C:/Users/micha/OneDrive/Documents/proyecto_investigativo_muestreo/resultados_potencia.csv")

cat("\nAnálisis de potencia completado. Resultados guardados.\n")
print(resultados_potencia %>% select(Materia, Delta, Potencia, Interpretacion))
