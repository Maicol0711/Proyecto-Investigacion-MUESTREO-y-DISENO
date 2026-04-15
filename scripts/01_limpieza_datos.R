# 01_limpieza_datos.R
# Objetivo: Limpiar y preparar los datos de Pruebas Saber 11

# Instalar 'data.table' y 'tidyverse' si no están instalados
if(!require(data.table)) install.packages("data.table")
if(!require(tidyverse)) install.packages("tidyverse")

library(data.table)
library(tidyverse)

# Rutas de archivos
archivo_entrada <- "C:/Users/micha/OneDrive/Documents/proyecto_investigativo_muestreo/Bogota_historico_saber_11_20260414.csv"
archivo_salida <- "C:/Users/micha/OneDrive/Documents/proyecto_investigativo_muestreo/datos_limpios.csv"

cat("Iniciando la carga de datos (puede tomar unos segundos por el volumen)...\n")

# Se usa fread por su altísimo rendimiento para leer grandes CSVs
# Si los nombres de las columnas en tu CSV exacto difieren ligeramente
# (e.g. FAMI_EDUCACIONMADRE en vez de FAMI_AÑOS_ESTUDIO_MADRE), por favor ajusta abajo.
datos_crudos <- tryCatch({
  fread(archivo_entrada, encoding = "UTF-8")
}, error = function(e){
  stop("Error al leer el archivo. Verifica que la ruta o el nombre del archivo origial sean correctos.")
})

n_inicial <- nrow(datos_crudos)
cat("Número inicial de registros cargados:", n_inicial, "\n")

# Proceso de filtrado y limpieza
datos_limpios <- datos_crudos %>%
  # 1. Filtrar solo Bogotá
  filter(grepl("BOGOT", toupper(ESTU_MCPIO_RESIDE)) | ESTU_COD_RESIDE_MCPIO == 11001) %>%
  
  # 2. Mapear niveles educativos a años estimativos y crear las columnas requeridas
  mutate(
    FAMI_AÑOS_ESTUDIO_MADRE = case_when(
      grepl("Ninguno", FAMI_EDUCACIONMADRE, ignore.case = T) ~ 0,
      grepl("Primaria incompleta", FAMI_EDUCACIONMADRE, ignore.case = T) ~ 3,
      grepl("Primaria completa", FAMI_EDUCACIONMADRE, ignore.case = T) ~ 5,
      grepl("Secundaria.*incompleta", FAMI_EDUCACIONMADRE, ignore.case = T) ~ 8,
      grepl("Secundaria.*completa", FAMI_EDUCACIONMADRE, ignore.case = T) ~ 11,
      grepl("Técnica.*incompleta", FAMI_EDUCACIONMADRE, ignore.case = T) ~ 12,
      grepl("Técnica.*completa|profesional incompleta", FAMI_EDUCACIONMADRE, ignore.case = T) ~ 14,
      grepl("profesional completa", FAMI_EDUCACIONMADRE, ignore.case = T) ~ 16,
      grepl("Postgrado", FAMI_EDUCACIONMADRE, ignore.case = T) ~ 18,
      TRUE ~ NA_real_
    ),
    FAMI_AÑOS_ESTUDIO_PADRE = case_when(
      grepl("Ninguno", FAMI_EDUCACIONPADRE, ignore.case = T) ~ 0,
      grepl("Primaria incompleta", FAMI_EDUCACIONPADRE, ignore.case = T) ~ 3,
      grepl("Primaria completa", FAMI_EDUCACIONPADRE, ignore.case = T) ~ 5,
      grepl("Secundaria.*incompleta", FAMI_EDUCACIONPADRE, ignore.case = T) ~ 8,
      grepl("Secundaria.*completa", FAMI_EDUCACIONPADRE, ignore.case = T) ~ 11,
      grepl("Técnica.*incompleta", FAMI_EDUCACIONPADRE, ignore.case = T) ~ 12,
      grepl("Técnica.*completa|profesional incompleta", FAMI_EDUCACIONPADRE, ignore.case = T) ~ 14,
      grepl("profesional completa", FAMI_EDUCACIONPADRE, ignore.case = T) ~ 16,
      grepl("Postgrado", FAMI_EDUCACIONPADRE, ignore.case = T) ~ 18,
      TRUE ~ NA_real_
    )
  ) %>%
  
  # 3. Seleccionar variables de interés solicitadas
  select(
    PUNT_MATEMATICAS,
    PUNT_LECTURA_CRITICA,
    PUNT_INGLES,
    PUNT_SOCIALES_CIUDADANAS,
    PUNT_C_NATURALES,
    PUNT_GLOBAL,
    FAMI_ESTRATOVIVIENDA,
    FAMI_AÑOS_ESTUDIO_PADRE,
    FAMI_AÑOS_ESTUDIO_MADRE
  ) %>%
  
  # 4. Eliminar todos los registros con datos faltantes (NA)
  na.omit() %>%
  
  # 4. Limpiar los valores indeseados o nulos en las categorías ("-", "Sin Estrato", etc.)
  # Asegurar que el estrato sea un número entre 1 y 6
  filter(grepl("Estrato [1-6]", FAMI_ESTRATOVIVIENDA) | FAMI_ESTRATOVIVIENDA %in% as.character(1:6)) %>%
  
  # 5. Crear variable ESTRATO_GRUPO
  mutate(
    ESTRATO_NUM = parse_number(as.character(FAMI_ESTRATOVIVIENDA)),
    ESTRATO_GRUPO = case_when(
      ESTRATO_NUM %in% 1:2 ~ "Bajo",
      ESTRATO_NUM %in% 3:4 ~ "Medio",
      ESTRATO_NUM %in% 5:6 ~ "Alto",
      TRUE ~ NA_character_
    )
  ) %>%
  filter(!is.na(ESTRATO_GRUPO))

n_final <- nrow(datos_limpios)

cat("Número final de registros después de limpieza:", n_final, "\n")
cat("Criterios aplicados: Estudiantes de Bogotá, Variables Completas (Sin NAs), Estratos válidos (1-6)\n")

# Guardar base limpia
fwrite(datos_limpios, archivo_salida)
cat("Base limpia guardada en:", archivo_salida, "\n")
