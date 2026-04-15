---
editor_options:
  markdown:
    wrap: sentence
output: pdf_document
---

# Documento Metodológico Complementario

**Proyecto:** Análisis del Efecto del Estrato Socioeconómico en el Rendimiento de las Pruebas Saber 11 en Bogotá.

------------------------------------------------------------------------

## 1. Justificación del Diseño Muestral

Se seleccionó el **Muestreo Aleatorio Estratificado con Afijación Proporcional** en lugar de otros métodos (como el Aleatorio Simple o por Conglomerados) dictaminado por la naturaleza demográfica intrínseca de los datos académicos nacionales.
\* **Aleatorio Simple:** Habría corrido el riesgo estadístico severo de obtener muy escasos estudiantes del "Estrato Alto" debido a su baja participación porcentual en la masa general del país y ciudad, lo cual habría sesgado la varianza del ANOVA por tamaño muestral desbalanceado extremo.
\* **Sistemático / Conglomerados:** Podría ser viable (usando colegios como conglomerados), pero el "efecto intra-clase" (estudiantes del mismo colegio sacan notas más parecidas entre sí que los estudiantes de diferentes colegios) hubiese requerido modelado Multinivel Mixto, lo que excede el modelo simple DCA solicitado para el análisis.
**Cálculos del Tamaño de la Muestra:**\
El tamaño $n$ se determinó por la ecuación sobre el universo $N \approx 577,974$: $n = \frac{Z^2 \cdot p(1-p) \cdot N}{e^2 \cdot (N-1) + Z^2 \cdot p(1-p)}$ Asumiendo un $2\%$ de margen de error estricto ($e=0.02$) para proteger la potencia de las estimaciones, e infiriendo varianza máxima $p=0.5$, el despeje produjo $\approx 2400$.

## 2. Justificación del Diseño Experimental (DCA)

Se planteó un DCA (Diseño Completamente al Azar) como estructura base para observar "si un factor único" (el estrato socioeconómico catalogado en tres bloques netamente categóricos) mueve la media.
\* ¿Por qué no Diseño en Bloques (DBCA) al mismo tiempo?
Se consideró un DBCA bloqueando por el "Tipo de Colegio" (Público/Privado).
Si bien este aporta menos error residual y explicaría mucho mejor la varianza poblacional, el objetivo primario de la clase y el proyecto exige someter un único tratamiento para medir las pruebas de Potencia asimétricas simples.

## 3. Decisiones Metodológicas Relevantes

**Agrupación de Estratos:** Se determinó categorizarlos en (1-2 Bajo, 3-4 Medio, 5-6 Alto) para garantizar homogeneidad inter-bloques económica en Colombia.
**Variable Auxiliar:** (FAMI_AÑOS_ESTUDIO_MADRE).
Estudios latinoamericanos de movilidad educativa de la UNESCO y la bibliografía (Lohr, 2021) revelan que los años de escuela formal de la madre tienen una r-Pearson \> 0.60 pura con los desempeños del chico, convirtiéndolo en un extraordinario ancla para un *Estimador de Razón*.
Demostramos que usar este estimador acorta los IC y baja enormemente la Varianza.

## 4. Cálculos Detallados de Estimadores

Para el Estimador de Razón Combinado en Muestreo Estratificado ($\hat{Y}_{rc}$): Se estiman primero el ratio:\
$r = \frac{\sum_{h} W_h \bar{y}_h}{\sum_{h} W_h \bar{x}_h}$ Se toma la media real poblacional general de la educación de madres ($X_{pobl}$ calculada dinámicamente) y la ecuación arroja el estimador medio $\hat{\mu} = r X_{pobl}$.

La varianza del estimador asintótico del paquete R es una aproximación generada por la serie de Taylor en los diferenciales de ratios a través del diseño `svyratio`.

## 5. Reflexión sobre Uso de IA

Esta sección es obligatoria y se maneja con honestidad académica completa.

### 5.1 Herramientas Utilizadas

Se ha empleado **Gemini 1.5 Pro** (Antigravity Workspace Tools) como Pair Programmer en todo el ciclo de código y formato desde un enfoque "agente guiado", en el ID de Rstudio local indirectamente.

### 5.2 Tipo de Asistencia por Etapa

| Etapa           | Tipo de ayuda                                 | Validación humana         |
|------------------------|------------------------|------------------------|
| Diseño muestral | Revisión de fórmulas, sugerencias de paquetes | Verificación manual       |
| Estimadores     | Explicación conceptual, código base           | Contraste con referencias |
| ANOVA           | Generación de código                          | Validación con teoría     |
| Validación      | Sugerencias de pruebas                        | Análisis crítico          |
| Redacción       | Mejoras de estilo                             | Personalización           |

### 5.3 Errores o Problemas Encontrados

-   **Código incorrecto / Limitaciones Sistémicas de R:** La IA propuso un test de Normalidad completo con la función base `shapiro.test()`. Este falla en las muestras donde N supera las 5000 observaciones de golpe, si el usuario manipula a N=10,000 en el backend sin previo aviso el código base crashea.
-   **Omisión de Supuestos Inicial:** Al armar la regresión en la librería `car` de R, la varianza combinada para variables desbalanceadas puede perder estabilidad asintótica y el IA inicialmente puede promediar mal las colas si uno no especifica Type-III error en Anova.
-   **Sugerencias Metodológicas:** La IA en cierto punto intentó ejecutar bloques para conglomerados asumiendo el colegio, esto oscurecía el DCA de la clase base.

### 5.4 Cómo se Validó la Información

Se verificaron los estimadores estandarizados con el Libro "Design and Analysis" de (Montgomery).
La función interna del submuestreo de dplyr generada fue verificada a pulso en foros comunitarios R de sintaxis de tidyverse.

### 5.5 Valor Agregado del Pensamiento Crítico

El analista humano decidió priorizar el estrato de vivienda real por agrupaciones sociales puras y exigir los *Años Madre* descartando *Años Padre*, ya que literaturas previas asumen mayor fuerza de apego formativo infantil de forma genérica o bien una muestra con menos datos Na en ese rubro de la Sabana Bogotana ICFES.

### 5.6 Reflexión Final

¿La IA facilitó el trabajo?
**Sí, abismalmente frente a la construcción procedural base y sintaxis repetitiva.** ¿Se delegó totalmente?
**NO.** La ruta epistemológica analítica y la definición teórica fue impuesta al bot.
¿Se comprendió todo el proceso?
**SÍ.** **Limitaciones encontradas:** Su capacidad para ejecutar e "interpretar gráficos estáticos visualizados" sin supervisión en la pantalla es precaria, y requiere confirmación técnica constante.
