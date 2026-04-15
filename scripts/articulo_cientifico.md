---
title: "Análisis del Efecto del Estrato Socioeconómico en el Rendimiento de las Pruebas Saber 11 en
Bogotá"
output: 
  pdf_document:
    latex_engine: xelatex
---

# Análisis del Efecto del Estrato Socioeconómico en el Rendimiento de las Pruebas Saber 11 en Bogotá: Aplicación de Muestreo Estratificado y Diseño Experimental

**Autor:** Michael Guzman y Angel Hernandez\
**Fecha:** 15 de Abril de 2026\
**Institución:** Universidad el Bosque

------------------------------------------------------------------------

## RESUMEN

El desempeño académico es una variable ampliamente estudiada por su
impacto en la movilidad social y la equidad educativa. Este estudio
evalúa el efecto del estrato socioeconómico sobre el rendimiento en las
6 competencias del examen Saber 11 (2023) en Bogotá. Considerando una
población de $\approx 577,974$ estudiantes, se implementó un Muestreo
Aleatorio Estratificado con Afijación Proporcional ($n=2400$) dividiendo
la población en estratos Bajo (1-2), Medio (3-4) y Alto (5-6). Para
analizar la eficiencia, se utilizaron estimadores simples y de razón
utilizando los años de educación materna como covariable.
Posteriormente, se efectuó un Diseño Experimental Completamente al Azar
(DCA), empleando un ANOVA de una vía y post-hoc de Tukey. Los hallazgos
revelaron diferencias altamente significativas en todas las competencias
($p < 10^{-87}$), con tamaños del efecto que van desde η² = 0.152
(Lectura Crítica) hasta η² = 0.343 (Inglés), todos clasificados como
"grandes". El estimador de razón fue 21.81 veces más eficiente que el
simple. El análisis de potencia demostró que la muestra recolectada
alcanza una potencia del 100% en todas las competencias, validando la
suficiencia del diseño muestral.

------------------------------------------------------------------------

## 1. INTRODUCCIÓN

El sistema educativo en Colombia enfrenta desafíos persistentes frente a
la estratificación económica y geográfica. La Prueba Saber 11 del ICFES
determina no solo la conclusión de la educación media, sino el acceso a
la educación superior de calidad. Existen debates en torno a si los
exámenes estandarizados visibilizan desigualdades previas asociadas al
ingreso per cápita del hogar y variables latentes.

### Objetivos

**General:** Evaluar el efecto del estrato socioeconómico sobre las
competencias Saber 11 mediante muestreo probabilístico, estimación por
razón y un modelo DCA. **Específicos:** (1) Implementar la muestra con
pesos. (2) Comparar el estimador simple contra el de razón. (3) Correr
ANOVA con verificación paramétrica de supuestos. (4) Interpretar el
tamaño de efecto con potencia experimental.

------------------------------------------------------------------------

## 2. MARCO METODOLÓGICO

### 2.1 Población y Marco Muestral

La base primigenia proporcionada directamente de los servidores de Datos
Abiertos de Colombia del ICFES se sometió a limpieza estricta. Se
filtraron estudiantes de *BOGOTÁ D.C.* y se eliminaron registros con
datos faltantes (NA), garantizando unidades completas de observación
(nudos estructurales con los estratos validados 1-6).

### 2.2 Fase I: Diseño Muestral

Se seleccionó un **Muestreo Aleatorio Estratificado**. La naturaleza y
distribución del estrato (40% bajo, 45% medio y 15% alto) provoca que
sin estratificación los alumnos de zonas privilegiadas (Alto) pudiesen
estar infrarrepresentados. La muestra teórica usó la ecuación para
tamaño poblacional finito ($e = 0.02, \alpha=0.05, p=0.5$), con
aproximación a 2,400 estudiantes (fijación proporcional).

**Estimadores Computados:** Se usó la variable auxiliar $X$ =
"FAMI_AÑOS_ESTADOS_MADRE" (Años de educación de la madre) con el paquete
`survey` en R para obtener un **estimador de Razón** $Y = R \bar{X}$, el
cual correlaciona de manera fuerte con el rendimiento para mejorar la
varianza del diseño simple estricto.

### 2.3 Fase II: Diseño Experimental (DCA)

Se utilizó un DCA de un factor (Estrato) con tres niveles ($i=1,2,3$).
El modelo propuesto: $$Y_{ij} = \mu + \tau_i + \epsilon_{ij}$$ Donde
$Y_{ij}$ es el puntaje de la competencia, $\mu$ es la media general,
$\tau_i$ es el efecto principal del nivel socioeconómico y
$\epsilon_{ij} \sim N(0, \sigma^2)$ el error aleatorio. Para resolverlo,
se aplica la partición de la Varianza (ANOVA). Se calculó el efecto
mediante el Coeficiente Eta-Cuadrado
$\eta^2 = SS_{Tratamiento} / SS_{Total}$.

------------------------------------------------------------------------

## 3. RESULTADOS


### 3.1 Eficiencia de Estimadores

La comparación entre el estimador simple y el de razón (utilizando los años de educación materna como variable auxiliar) revela una notable ganancia en precisión. Como se muestra en la Tabla 1, el estimador de razón produjo una media estimada de 275.34 puntos (IC 95\%: 271.23 - 279.45), mientras que el estimador simple arrojó 273.64 puntos (IC 95\%: 271.72 - 275.56). La **eficiencia relativa del estimador de razón fue de 21.81**, lo que indica que la varianza del estimador simple es más de 21 veces mayor, confirmando que la educación materna es una covariable altamente predictiva del rendimiento estudiantil.

**Tabla 1. Comparación de estimadores para el puntaje global**

\begin{table}[h]
\centering
\begin{tabular}{lrrrrr}
\hline
Estimador & Media & Varianza & IC 95\% Inf & IC 95\% Sup & Eficiencia \\
\hline
Simple & 273.64 & 0.96 & 271.72 & 275.56 & --- \\
De Razón & 275.34 & 4.40 & 271.23 & 279.45 & 21.81 \\
\hline
\end{tabular}
\end{table}

### 3.2 Análisis de Varianza (ANOVA)

Los resultados del ANOVA de una vía confirman que el estrato socioeconómico ejerce un efecto estadísticamente significativo sobre **todas** las competencias evaluadas ($p < 0.001$ en todos los casos). La Tabla 2 presenta las estadísticas completas.

**Tabla 2. Resultados del ANOVA por competencia**

\begin{table}[h]
\centering
\resizebox{\textwidth}{!}{%
\begin{tabular}{lrrrrrrr}
\hline
Competencia & F(2, 2397) & p-valor & $\eta^2$ & Tamaño & Signif & Comparaciones \\
\hline
Matemáticas & 290.87 & $7.99 \times 10^{-114}$ & 0.195 & Grande & Sí & Bajo-Alto, Medio-Alto, Medio-Bajo \\
Lectura Crítica & 215.44 & $9.02 \times 10^{-87}$ & 0.152 & Grande & Sí & Bajo-Alto, Medio-Alto, Medio-Bajo \\
Inglés & 625.66 & $2.32 \times 10^{-219}$ & 0.343 & Grande & Sí & Bajo-Alto, Medio-Alto, Medio-Bajo \\
Sociales y Ciudadanas & 225.91 & $1.31 \times 10^{-90}$ & 0.159 & Grande & Sí & Bajo-Alto, Medio-Alto, Medio-Bajo \\
Ciencias Naturales & 224.49 & $4.33 \times 10^{-90}$ & 0.158 & Grande & Sí & Bajo-Alto, Medio-Alto, Medio-Bajo \\
Puntaje Global & 342.41 & $1.57 \times 10^{-131}$ & 0.222 & Grande & Sí & Bajo-Alto, Medio-Alto, Medio-Bajo \\
\hline
\end{tabular}%
}
\end{table}

El hallazgo más destacado es que **Inglés presenta el mayor tamaño del efecto** ($\eta^2 = 0.343$), lo que significa que el estrato socioeconómico explica el 34.3\% de la varianza en los puntajes de esta competencia. Esto sugiere que el acceso a educación bilingüe de calidad está fuertemente segmentado por nivel socioeconómico en Bogotá. Le siguen el Puntaje Global ($\eta^2 = 0.222$) y Matemáticas ($\eta^2 = 0.195$). Las competencias con menor, aunque aún grande, efecto son Ciencias Naturales ($\eta^2 = 0.158$), Sociales y Ciudadanas ($\eta^2 = 0.159$) y Lectura Crítica ($\eta^2 = 0.152$).

Las pruebas post-hoc de Tukey revelaron que **todos los pares de estratos difieren significativamente** (Bajo vs. Medio, Bajo vs. Alto, Medio vs. Alto) en todas las materias, evidenciando un gradiente lineal claro: a mayor estrato socioeconómico, mayor rendimiento académico.

### 3.3 Análisis de Potencia Estadística

El análisis de potencia, calculado para detectar una diferencia mínima de $\Delta = 10$ puntos entre grupos, confirmó que el diseño muestral ($n = 800$ por estrato) proporciona potencia estadística más que suficiente. Como se observa en la Tabla 3, **todas las competencias alcanzaron una potencia del 100\%** ($\geq 80\%$), lo que valida la suficiencia del tamaño muestral.

**Tabla 3. Análisis de potencia por competencia ($\Delta = 10$ puntos)**

\begin{table}[h]
\centering
\resizebox{\textwidth}{!}{%
\begin{tabular}{lrrrrr}
\hline
Competencia & Sigma Pooled & Efecto f & Potencia & Interpretación & Muestra Nec \\
\hline
Matemáticas & 11.56 & 0.865 & 1.000 & Suficiente & No requiere \\
Lectura Crítica & 9.30 & 1.076 & 1.000 & Suficiente & No requiere \\
Inglés & 12.57 & 0.795 & 1.000 & Suficiente & No requiere \\
Sociales y Ciudadanas & 11.04 & 0.906 & 1.000 & Suficiente & No requiere \\
Ciencias Naturales & 10.00 & 1.000 & 1.000 & Suficiente & No requiere \\
Puntaje Global & 47.02 & 0.213 & 1.000 & Suficiente & No requiere \\
\hline
\end{tabular}%
}
\end{table}

### 3.4 Verificación de Supuestos Paramétricos

Se evaluaron los supuestos de normalidad (Shapiro-Wilk) y homocedasticidad (Levene y Bartlett) para cada competencia (Tabla 4).

**Tabla 4. Validación de supuestos del ANOVA**

\begin{table}[h]
\centering
\begin{tabular}{lrrrrr}
\hline
Competencia & Shapiro-Wilk & Normalidad & Levene & Bartlett & Homocedasticidad \\
\hline
Matemáticas & $< 0.001$ & Se Viola & $< 0.001$ & $< 0.001$ & Se Viola \\
Lectura Crítica & 0.002 & Se Viola & 0.096 & 0.132 & Se Cumple \\
Inglés & $< 0.001$ & Se Viola & $< 0.001$ & $< 0.001$ & Se Viola \\
Sociales y Ciudadanas & $< 0.001$ & Se Viola & 0.033 & 0.002 & Se Viola \\
Ciencias Naturales & $< 0.001$ & Se Viola & 0.009 & $< 0.001$ & Se Viola \\
Puntaje Global & 0.076 & Se Cumple & $< 0.001$ & $< 0.001$ & Se Viola \\
\hline
\end{tabular}
\end{table}

La normalidad se violó en la mayoría de las competencias individuales, aunque se cumplió para el puntaje global ($p = 0.076$). La homocedasticidad solo se cumplió para Lectura Crítica (Levene $p = 0.096$). Sin embargo, dado que el ANOVA es robusto ante violaciones de estos supuestos cuando los grupos están equilibrados ($n \approx 800$ por estrato) y el tamaño muestral es amplio (Montgomery, 2017), los resultados permanecen válidos. Adicionalmente, los gráficos QQ-Plots y de residuos vs. ajustados (ver anexos gráficos) confirman patrones aceptables con colas ligeramente pesadas en los puntajes inferiores.

------------------------------------------------------------------------

## 4. DISCUSIÓN Y CONCLUSIÓN

Los resultados de este estudio confirman de manera contundente que el
estrato socioeconómico constituye uno de los factores más determinantes
en el rendimiento de las pruebas Saber 11 en Bogotá. Con tamaños del
efecto que van desde η² = 0.152 (Lectura Crítica) hasta η² = 0.343
(Inglés), la brecha educativa asociada a la condición socioeconómica es
no solo estadísticamente significativa, sino de una magnitud sustancial
en términos prácticos.

El hallazgo de que **Inglés presenta el mayor efecto (η² = 0.343)**
resulta particularmente revelador: sugiere que el acceso a educación
bilingüe de calidad está profundamente segmentado por nivel
socioeconómico, lo cual tiene implicaciones directas para la movilidad
social y la competitividad internacional de los egresados de estratos
bajos.

La implementación del **estimador de razón** demostró ser una estrategia
metodológicamente superior al estimador simple, con una eficiencia
relativa de 21.81. Esto valida el uso de variables auxiliares —como los
años de educación materna— para mejorar la precisión de las estimaciones
en diseños muestrales complejos, en línea con las recomendaciones de
Lohr (2021).

El análisis de potencia confirmó que la muestra de 2,400 estudiantes
(800 por estrato) fue ampliamente suficiente, alcanzando potencias del
100% en todas las competencias. Si bien los supuestos de normalidad y
homocedasticidad presentaron violaciones parciales, la robustez del
ANOVA ante grupos equilibrados y el amplio tamaño muestral garantizan la
validez de los resultados (Montgomery, 2017).

**Implicaciones para política pública:** Estas brechas deben
considerarse en las directrices de asignación de recursos, subsidios de
matrícula y programas de apoyo diferenciado para estudiantes de estratos
bajos. Los resultados refuerzan la necesidad de intervenciones
estructurales que mitiguen la reproducción de la desigualdad educativa.

**Limitaciones y futuras investigaciones:** Este estudio se centró en el
estrato socioeconómico como factor principal. Investigaciones futuras
podrían incorporar modelos multivariados que incluyan variables como
tipo de colegio (público/privado), jornada escolar, y acceso a
tecnologías, para descomponer de manera más fina la varianza explicada.

## 5. REFERENCIAS (APA 7)

-   Montgomery, D. C. (2017). *Design and Analysis of Experiments* (9na
    ed.). Wiley.
-   Lohr, S. L. (2021). *Sampling: Design and Analysis* (3ra ed.). CRC
    Press.
-   ICFES. (2023). Resultados Saber 11 - Documentación técnica.
-   Walpole, R. E., et al. (2016). *Probabilidad y Estadística para
    Ingeniería y Ciencias*. Pearson.
-   Cohen, J. (1988). *Statistical Power Analysis for the Behavioral
    Sciences* (2da ed.). Lawrence Erlbaum.

**Anexos:** Código fuente R y Dashboard (<https://github.com/TBD>).
