# ==============================================================================
# DASHBOARD INTERACTIVO - ANÁLISIS SABER 11 vs ESTRATO SOCIOECONÓMICO
# Diseño moderno para presentación del proyecto investigativo
# ==============================================================================

if(!require(shiny)) install.packages("shiny")
if(!require(bslib)) install.packages("bslib")
if(!require(tidyverse)) install.packages("tidyverse")
if(!require(plotly)) install.packages("plotly")

library(shiny)
library(bslib)
library(tidyverse)
library(plotly)

# ==============================================================================
# CARGA DE DATOS
# ==============================================================================
ruta_base <- "C:/Users/micha/OneDrive/Documents/proyecto_investigativo_muestreo/"

cargar_csv <- function(archivo) {
  ruta <- file.path(ruta_base, archivo)
  if(file.exists(ruta)) read_csv(ruta, show_col_types = FALSE) else NULL
}

df_muestra     <- cargar_csv("muestra_final.csv")
df_anova       <- cargar_csv("resultados_anova.csv")
df_estimadores <- cargar_csv("resultados_estimadores.csv")
df_potencia    <- cargar_csv("resultados_potencia.csv")
df_supuestos   <- cargar_csv("resultados_supuestos.csv")

# Preparar resumen de pesos
pesos_resumen <- if(!is.null(df_muestra)) {
  df_muestra %>%
    group_by(ESTRATO_GRUPO) %>%
    summarise(
      `Tamaño Muestra (n_h)` = n(),
      `Peso Promedio (w_h)` = round(mean(w_h, na.rm = TRUE), 2),
      `.groups` = "drop"
    ) %>%
    mutate(ESTRATO_GRUPO = factor(ESTRATO_GRUPO, levels = c("Bajo", "Medio", "Alto"))) %>%
    arrange(ESTRATO_GRUPO)
}

# ==============================================================================
# UI - DISEÑO MODERNO CON BSLIB
# ==============================================================================
ui <- page_navbar(
  theme = bs_theme(
    version = 5,
    bootswatch = "flatly",
    primary = "#1a365d",
    secondary = "#2b6cb0",
    success = "#38a169",
    info = "#38b2ac",
    danger = "#e53e3e",
    warning = "#d69e2e",
    "font-scale" = 1.1
  ),
  title = "📊 Análisis Saber 11 - Bogotá 2023",
  window_title = "Dashboard Saber 11",
  bg = "#1a365d",

  # CSS personalizado
  tags$head(
    tags$style(HTML("
      /* Fondo con gradiente sutil */
      body {
        background: linear-gradient(135deg, #f5f7fa 0%, #e8ecf1 100%);
      }

      /* Navbar moderna */
      .navbar {
        box-shadow: 0 4px 20px rgba(0,0,0,0.15) !important;
        padding: 10px 0 !important;
      }
      .navbar-title {
        font-weight: 800 !important;
        letter-spacing: 0.5px;
      }

      /* Tabs modernos */
      .nav-tabs {
        gap: 8px;
        border: none !important;
      }
      .nav-tabs > li > a {
        border: none !important;
        border-radius: 12px !important;
        padding: 10px 20px !important;
        font-weight: 600 !important;
        color: #1a365d !important;
        background: white !important;
        box-shadow: 0 2px 8px rgba(0,0,0,0.08) !important;
        transition: all 0.3s ease !important;
      }
      .nav-tabs > li > a:hover {
        transform: translateY(-2px) !important;
        box-shadow: 0 4px 15px rgba(0,0,0,0.12) !important;
        background: #38b2ac !important;
        color: white !important;
      }
      .nav-tabs > li.active > a,
      .nav-tabs > li.active > a:focus,
      .nav-tabs > li.active > a:hover {
        background: linear-gradient(135deg, #1a365d, #2b6cb0) !important;
        color: white !important;
        border: none !important;
        box-shadow: 0 4px 15px rgba(26,54,93,0.3) !important;
      }

      /* Cards modernas */
      .card {
        border: none !important;
        border-radius: 16px !important;
        box-shadow: 0 4px 20px rgba(0,0,0,0.08) !important;
        transition: all 0.3s ease !important;
        overflow: hidden;
        margin-bottom: 24px;
      }
      .card:hover {
        transform: translateY(-3px) !important;
        box-shadow: 0 8px 30px rgba(0,0,0,0.12) !important;
      }
      .card-header {
        border-radius: 16px 16px 0 0 !important;
        border: none !important;
        font-weight: 700 !important;
        padding: 16px 20px !important;
        color: white !important;
      }
      .card-body {
        padding: 20px !important;
      }

      /* Value boxes */
      .valor-box {
        border-radius: 16px !important;
        padding: 24px !important;
        color: white !important;
        position: relative;
        overflow: hidden;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1) !important;
        transition: all 0.3s ease !important;
      }
      .valor-box:hover {
        transform: translateY(-5px) scale(1.02) !important;
        box-shadow: 0 8px 25px rgba(0,0,0,0.2) !important;
      }
      .valor-box::after {
        content: '';
        position: absolute;
        top: -50%;
        right: -50%;
        width: 200px;
        height: 200px;
        background: rgba(255,255,255,0.1);
        border-radius: 50%;
      }
      .valor-titulo {
        font-size: 0.9rem;
        opacity: 0.9;
        margin-bottom: 5px;
      }
      .valor-numero {
        font-size: 2.5rem;
        font-weight: 800;
        margin: 8px 0;
      }
      .valor-icono {
        font-size: 3rem;
        opacity: 0.3;
        position: absolute;
        right: 20px;
        top: 50%;
        transform: translateY(-50%);
      }

      /* Tablas modernas */
      table.dataframe {
        border-radius: 12px !important;
        overflow: hidden !important;
        width: 100% !important;
      }
      table.dataframe thead th {
        background: linear-gradient(135deg, #1a365d, #2b6cb0) !important;
        color: white !important;
        border: none !important;
        padding: 12px 14px !important;
        font-weight: 600 !important;
        text-transform: uppercase !important;
        font-size: 0.8rem !important;
        letter-spacing: 0.5px !important;
      }
      table.dataframe tbody td {
        padding: 10px 14px !important;
        border-color: #edf2f7 !important;
      }
      table.dataframe tbody tr:hover {
        background-color: #ebf8ff !important;
      }

      /* Títulos */
      h1, h2, h3 {
        color: #1a365d !important;
        font-weight: 800 !important;
      }
      h1 { font-size: 2rem !important; }
      h2 { font-size: 1.6rem !important; }

      /* Hero section */
      .hero-section {
        background: linear-gradient(135deg, #1a365d 0%, #2b6cb0 100%);
        color: white;
        padding: 40px;
        border-radius: 20px;
        margin-bottom: 30px;
        box-shadow: 0 10px 40px rgba(26,54,93,0.3);
        position: relative;
        overflow: hidden;
      }
      .hero-section::before {
        content: '';
        position: absolute;
        top: -100px;
        right: -100px;
        width: 300px;
        height: 300px;
        background: rgba(255,255,255,0.05);
        border-radius: 50%;
      }
      .hero-section h1 {
        color: white !important;
        margin-bottom: 10px !important;
      }

      /* Hallazgo items */
      .hallazgo-item {
        padding: 14px 18px;
        background: white;
        border-left: 4px solid #38b2ac;
        border-radius: 8px;
        margin-bottom: 10px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        transition: all 0.2s ease;
      }
      .hallazgo-item:hover {
        transform: translateX(5px);
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
      }

      /* Separador */
      .divider-gradient {
        height: 3px;
        background: linear-gradient(to right, transparent, #38b2ac, transparent);
        margin: 25px 0;
        border: none;
      }

      /* Selectize input moderno */
      .selectize-input {
        border-radius: 10px !important;
        border: 2px solid #e2e8f0 !important;
        padding: 8px 12px !important;
      }
      .selectize-input.focus {
        border-color: #38b2ac !important;
        box-shadow: 0 0 0 3px rgba(56,178,172,0.2) !important;
      }

      /* Footer */
      .footer-custom {
        text-align: center;
        padding: 20px;
        color: #718096;
        font-size: 0.9rem;
        margin-top: 40px;
      }

      /* Highlight box */
      .highlight-box {
        background: linear-gradient(135deg, #f0fff4, #c6f6d5);
        padding: 20px;
        border-radius: 12px;
        border-left: 4px solid #38a169;
      }

      /* Stat highlight */
      .stat-highlight {
        text-align: center;
        padding: 20px;
        background: white;
        border-radius: 12px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.08);
      }
      .stat-number {
        font-size: 2.2rem;
        font-weight: 800;
        color: #1a365d;
      }
      .stat-label {
        font-size: 0.9rem;
        color: #718096;
        margin-top: 5px;
      }
    "))
  ),

  # ============================================================================
  # TAB 1: INICIO
  # ============================================================================
  nav_panel(
    title = "🏠 Inicio",
    div(class = "container-fluid", style = "max-width: 1200px; margin: 0 auto; padding-top: 80px;",

      # Hero
      div(class = "hero-section",
        h1("📊 Efecto del Estrato Socioeconómico en Saber 11"),
        p("Muestreo Aleatorio Estratificado y Diseño Experimental para analizar las brechas educativas en Bogotá · 577,974 estudiantes · Año 2023")
      ),

      # Stats
      layout_columns(
        col_widths = c(3, 3, 3, 3),
        div(class = "valor-box", style = "background: linear-gradient(135deg, #3182ce, #63b3ed);",
          div(class = "valor-icono", "🏙️"),
          div(class = "valor-titulo", "Población Total"),
          div(class = "valor-numero", "577,974"),
          div(style = "font-size: 0.85rem; opacity: 0.85;", "Estudiantes ICFES 2023")
        ),
        div(class = "valor-box", style = "background: linear-gradient(135deg, #38a169, #68d391);",
          div(class = "valor-icono", "👥"),
          div(class = "valor-titulo", "Muestra Extraída"),
          div(class = "valor-numero", "2,400"),
          div(style = "font-size: 0.85rem; opacity: 0.85;", "Afijación Proporcional")
        ),
        div(class = "valor-box", style = "background: linear-gradient(135deg, #805ad5, #b794f4);",
          div(class = "valor-icono", "📊"),
          div(class = "valor-titulo", "Estratos Analizados"),
          div(class = "valor-numero", "3"),
          div(style = "font-size: 0.85rem; opacity: 0.85;", "Bajo (1-2) · Medio (3-4) · Alto (5-6)")
        ),
        div(class = "valor-box", style = "background: linear-gradient(135deg, #e53e3e, #fc8181);",
          div(class = "valor-icono", "⚡"),
          div(class = "valor-titulo", "Potencia Alcanzada"),
          div(class = "valor-numero", "100%"),
          div(style = "font-size: 0.85rem; opacity: 0.85;", "Δ = 10 puntos")
        )
      ),

      hr(class = "divider-gradient"),

      # Objetivos y Hallazgos
      layout_columns(
        col_widths = c(6, 6),
        # Objetivos
        div(class = "card",
          div(class = "card-header", style = "background: linear-gradient(135deg, #38a169, #68d391);",
            "🎯 Objetivos del Estudio"
          ),
          div(class = "card-body",
            tags$ul(
              tags$li("Implementar muestreo estratificado con pesos y estimadores de razón"),
              tags$li("Ejecutar ANOVA para diferencias entre estratos Bajo, Medio y Alto"),
              tags$li("Comparar estimador simple vs razón usando educación materna"),
              tags$li("Evaluar potencia del diseño experimental")
            )
          )
        ),
        # Hallazgos
        div(class = "card",
          div(class = "card-header", style = "background: linear-gradient(135deg, #3182ce, #63b3ed);",
            "💡 Hallazgos Clave"
          ),
          div(class = "card-body",
            div(class = "hallazgo-item",
              "✅ Efecto altamente significativo en todas las competencias (p < 10⁻⁸⁷)"
            ),
            div(class = "hallazgo-item", style = "border-left-color: #e53e3e;",
              "⭐ Mayor efecto en Inglés (η² = 0.343) - el estrato explica 34.3% de varianza"
            ),
            div(class = "hallazgo-item", style = "border-left-color: #d69e2e;",
              "📊 Ambos estimadores producen intervalos consistentes (273.64 y 275.34)"
            ),
            div(class = "hallazgo-item", style = "border-left-color: #805ad5;",
              "📊 Todos los pares de estratos difieren significativamente"
            )
          )
        )
      ),

      div(class = "footer-custom",
        "Proyecto de Investigación · Muestreo y Diseño Experimental · 2026"
      )
    )
  ),

  # ============================================================================
  # TAB 2: FASE I - MUESTREO
  # ============================================================================
  nav_panel(
    title = "📋 Fase I: Muestreo",
    div(class = "container-fluid", style = "max-width: 1200px; margin: 0 auto; padding-top: 80px;",
      h2("📋 Diseño Muestral Estratificado"),
      p(class = "text-muted", "Muestreo Aleatorio Estratificado con Afijación Proporcional (40% Bajo, 45% Medio, 15% Alto)"),

      hr(class = "divider-gradient"),

      # Distribución y Pesos
      layout_columns(
        col_widths = c(7, 5),
        # Gráfico de distribución
        div(class = "card",
          div(class = "card-header", style = "background: linear-gradient(135deg, #3182ce, #63b3ed);",
            "📊 Distribución de la Muestra por Estrato"
          ),
          div(class = "card-body",
            plotlyOutput("plot_dist_muestra", height = "350px")
          )
        ),
        # Tabla de pesos
        div(class = "card",
          div(class = "card-header", style = "background: linear-gradient(135deg, #805ad5, #b794f4);",
            "⚖️ Pesos Muestrales Calculados"
          ),
          div(class = "card-body",
            p(class = "text-muted", style = "font-size: 0.85rem;",
              "Peso w_h = N_h / n_h (Factor de expansión del estrato)"),
            tableOutput("tabla_pesos"),
            hr(),
            div(class = "highlight-box",
              HTML("<strong>Nota:</strong> Los pesos permiten expandir los resultados de la muestra a la población total de Bogotá.")
            )
          )
        )
      ),

      # Estimadores
      hr(class = "divider-gradient"),
      div(class = "card",
        div(class = "card-header", style = "background: linear-gradient(135deg, #38a169, #68d391);",
          "⚖️ Comparación de Estimadores (Puntaje Global)"
        ),
        div(class = "card-body",
          p(class = "text-muted", style = "font-size: 0.85rem; margin-bottom: 15px;",
            "Comparación entre el estimador simple (media ponderada con pesos muestrales) y el estimador de razón (usando FAMI_AÑOS_ESTUDIO_MADRE como variable auxiliar)."),
          tableOutput("tabla_estimadores"),
          hr(),
          div(style = "background: linear-gradient(135deg, #ebf8ff, #bee3f8); padding: 18px; border-radius: 12px; border-left: 5px solid #3182ce;",
            HTML(paste0(
              "<strong>📌 Nota metodológica:</strong> ",
              "El estimador de razón ajusta la estimación incorporando información auxiliar (años de educación materna). ",
              "La media del estimador de razón (275.34) es ligeramente superior a la del estimador simple (273.64), ",
              "lo que refleja el efecto positivo de la educación materna sobre el rendimiento estudiantil. ",
              "Ambos intervalos de confianza se superponen ampliamente, indicando consistencia entre métodos. ",
              "En este caso particular, la varianza del estimador simple fue menor debido a que los pesos muestrales ",
              "ya incorporan la información de estratificación de manera eficiente."
            ))
          )
        )
      )
    )
  ),

  # ============================================================================
  # TAB 3: FASE II - ANOVA
  # ============================================================================
  nav_panel(
    title = "🔬 Fase II: ANOVA",
    div(class = "container-fluid", style = "max-width: 1200px; margin: 0 auto; padding-top: 80px;",
      h2("🔬 Diseño Completamente al Azar (DCA)"),
      p(class = "text-muted", "ANOVA de una vía: Efecto del estrato socioeconómico sobre el rendimiento académico"),

      hr(class = "divider-gradient"),

      # Selector
      div(style = "text-align: center; margin-bottom: 25px;",
        selectizeInput("selector_materia", "Seleccionar Competencia:",
          choices = c(
            "Matemáticas" = "PUNT_MATEMATICAS",
            "Lectura Crítica" = "PUNT_LECTURA_CRITICA",
            "Inglés" = "PUNT_INGLES",
            "Sociales y Ciudadanas" = "PUNT_SOCIALES_CIUDADANAS",
            "Ciencias Naturales" = "PUNT_C_NATURALES",
            "Puntaje Global" = "PUNT_GLOBAL"
          ),
          selected = "PUNT_INGLES"
        )
      ),

      # ANOVA detalle
      div(class = "card",
        div(class = "card-header", style = "background: linear-gradient(135deg, #e53e3e, #fc8181);",
          "📋 Tabla ANOVA - Competencia Seleccionada"
        ),
        div(class = "card-body",
          tableOutput("tabla_anova_detalle")
        )
      ),

      # Resumen todas las materias
      hr(class = "divider-gradient"),
      div(class = "card",
        div(class = "card-header", style = "background: linear-gradient(135deg, #3182ce, #63b3ed);",
          "📊 Resumen ANOVA - Todas las Competencias"
        ),
        div(class = "card-body",
          plotlyOutput("plot_eta_cuadrado", height = "400px")
        )
      ),

      # Supuestos
      hr(class = "divider-gradient"),
      div(class = "card",
        div(class = "card-header", style = "background: linear-gradient(135deg, #d69e2e, #ecc94b);",
          "✓ Validación de Supuestos Paramétricos"
        ),
        div(class = "card-body",
          p(class = "text-muted", "Normalidad (Shapiro-Wilk) y Homocedasticidad (Levene y Bartlett)"),
          tableOutput("tabla_supuestos")
        )
      )
    )
  ),

  # ============================================================================
  # TAB 4: POTENCIA
  # ============================================================================
  nav_panel(
    title = "⚡ Potencia",
    div(class = "container-fluid", style = "max-width: 1200px; margin: 0 auto; padding-top: 80px;",
      h2("⚡ Análisis de Potencia Estadística"),
      p(class = "text-muted", "Evaluación de la capacidad del diseño para detectar diferencias de Δ = 10 puntos"),

      hr(class = "divider-gradient"),

      layout_columns(
        col_widths = c(6, 6),
        # Tabla de potencia
        div(class = "card",
          div(class = "card-header", style = "background: linear-gradient(135deg, #38a169, #68d391);",
            "✓ Resultados de Potencia por Competencia"
          ),
          div(class = "card-body",
            tableOutput("tabla_potencia")
          )
        ),
        # Gráfico efecto Cohen
        div(class = "card",
          div(class = "card-header", style = "background: linear-gradient(135deg, #805ad5, #b794f4);",
            "📈 Efecto de Cohen (f) por Materia"
          ),
          div(class = "card-body",
            plotlyOutput("plot_efecto_cohen", height = "350px")
          )
        )
      ),

      # Conclusión potencia
      div(class = "card", style = "background: linear-gradient(135deg, #f0fff4, #c6f6d5);",
        div(class = "card-body", style = "text-align: center;",
          div(style = "font-size: 3rem;", "🏆"),
          h3(style = "color: #276749; margin: 10px 0;", "Potencia del 100% en todas las competencias"),
          p(style = "color: #2f855a; font-size: 1.05rem;",
            "La muestra de 2,400 estudiantes (800 por estrato) es ampliamente suficiente para detectar diferencias significativas. No se requieren réplicas adicionales."),
          p(class = "text-muted", style = "font-size: 0.85rem;",
            "Umbral mínimo aceptable: 80% · Todos los modelos superaron ampliamente este criterio")
        )
      )
    )
  ),

  # ============================================================================
  # TAB 5: CONCLUSIONES
  # ============================================================================
  nav_panel(
    title = "🏁 Conclusiones",
    div(class = "container-fluid", style = "max-width: 1200px; margin: 0 auto; padding-top: 80px;",
      h2("🏁 Resultados y Conclusiones"),

      hr(class = "divider-gradient"),

      # Gráfico promedios
      div(class = "card",
        div(class = "card-header", style = "background: linear-gradient(135deg, #38a169, #68d391);",
          "📊 Puntaje Global Promedio por Estrato Socioeconómico"
        ),
        div(class = "card-body",
          plotlyOutput("plot_promedios", height = "400px")
        )
      ),

      # Conclusiones en columnas
      hr(class = "divider-gradient"),
      layout_columns(
        col_widths = c(4, 4, 4),
        # Hallazgos ANOVA
        div(class = "card",
          div(class = "card-header", style = "background: linear-gradient(135deg, #e53e3e, #fc8181);",
            "🔬 Hallazgos ANOVA"
          ),
          div(class = "card-body",
            div(class = "hallazgo-item",
              "<strong>Significancia:</strong> Todas las competencias muestran p < 10⁻⁸⁷"
            ),
            div(class = "hallazgo-item", style = "border-left-color: #e53e3e;",
              "<strong>Mayor efecto:</strong> Inglés (η² = 0.343)"
            ),
            div(class = "hallazgo-item",
              "<strong>Efecto global:</strong> Puntaje Global η² = 0.222"
            ),
            div(class = "hallazgo-item",
              "<strong>Gradiente:</strong> A mayor estrato, mayor rendimiento"
            )
          )
        ),
        # Eficiencia
        div(class = "card",
          div(class = "card-header", style = "background: linear-gradient(135deg, #3182ce, #63b3ed);",
            "⚖️ Comparación de Estimadores"
          ),
          div(class = "card-body",
            div(class = "hallazgo-item", style = "border-left-color: #3182ce;",
              "<strong>Estimador simple:</strong> Media = 273.64, Var = 0.96"
            ),
            div(class = "hallazgo-item",
              "<strong>Estimador de razón:</strong> Media = 275.34, Var = 4.40"
            ),
            div(class = "hallazgo-item",
              "<strong>IC ambos:</strong> Se superponen (271-279 aprox.)"
            ),
            div(class = "hallazgo-item",
              "<strong>Interpretación:</strong> Consistentes entre sí"
            )
          )
        ),
        # Validez
        div(class = "card",
          div(class = "card-header", style = "background: linear-gradient(135deg, #805ad5, #b794f4);",
            "🛡️ Validez del Diseño"
          ),
          div(class = "card-body",
            div(class = "hallazgo-item", style = "border-left-color: #38a169;",
              "<strong>Potencia:</strong> 100% en todas las materias"
            ),
            div(class = "hallazgo-item",
              "<strong>Supuestos:</strong> ANOVA robusto pese a violaciones"
            ),
            div(class = "hallazgo-item",
              "<strong>Normalidad:</strong> Cumple solo en Global (p=0.076)"
            ),
            div(class = "hallazgo-item",
              "<strong>Homocedasticidad:</strong> Solo Lectura Crítica cumple"
            )
          )
        )
      ),

      # Implicaciones
      hr(class = "divider-gradient"),
      div(class = "card", style = "background: linear-gradient(135deg, #fffbeb, #fef3c7);",
        div(class = "card-header", style = "background: linear-gradient(135deg, #d69e2e, #ecc94b);",
          "🏛️ Implicaciones para Política Pública"
        ),
        div(class = "card-body",
          layout_columns(
            col_widths = c(6, 6),
            div(
              h4(style = "color: #975a16;", "⚠️ Problemática Identificada"),
              tags$ul(
                tags$li("Brecha educativa profundamente segmentada por estrato"),
                tags$li("Inglés como materia más afectada (acceso desigual a educación bilingüe)"),
                tags$li("Reproducción sistemática de la desigualdad educativa")
              )
            ),
            div(
              h4(style = "color: #975a16;", "💡 Recomendaciones"),
              tags$ul(
                tags$li("Asignación diferenciada de recursos para estratos bajos"),
                tags$li("Programas de apoyo académico focalizados"),
                tags$li("Subsidios de matrícula para educación de calidad")
              )
            )
          )
        )
      )
    )
  )
)

# ==============================================================================
# SERVER
# ==============================================================================
server <- function(input, output, session) {

  # --- Gráfico distribución de muestra ---
  output$plot_dist_muestra <- renderPlotly({
    if(is.null(df_muestra)) return(NULL)

    conteo <- df_muestra %>%
      count(ESTRATO_GRUPO) %>%
      mutate(
        ESTRATO_GRUPO = factor(ESTRATO_GRUPO, levels = c("Bajo", "Medio", "Alto")),
        Porcentaje = round(n / sum(n) * 100, 1)
      ) %>%
      arrange(ESTRATO_GRUPO)

    fig <- plot_ly(conteo, x = ~ESTRATO_GRUPO, y = ~n,
                   type = 'bar',
                   marker = list(color = c('#4299e1', '#48bb78', '#ed8936'),
                                line = list(color = 'white', width = 2)),
                   text = ~paste0(n, ' estudiantes (', Porcentaje, '%)'),
                   textposition = 'outside',
                   hoverinfo = 'text',
                   hovertext = ~paste0('<b>Estrato:</b> ', ESTRATO_GRUPO,
                                      '<br><b>Muestra:</b> ', n,
                                      '<br><b>Porcentaje:</b> ', Porcentaje, '%'))

    fig %>%
      layout(
        xaxis = list(title = 'Estrato Socioeconómico', tickfont = list(size = 14)),
        yaxis = list(title = 'Número de Estudiantes', tickfont = list(size = 14)),
        margin = list(l = 60, r = 20, t = 20, b = 60)
      )
  })

  # --- Tabla de pesos muestrales ---
  output$tabla_pesos <- renderTable({
    if(!is.null(pesos_resumen)) {
      pesos_resumen
    } else {
      data.frame(Mensaje = "Ejecute 02_muestreo_estratificado.R primero")
    }
  }, rownames = FALSE)

  # --- Tabla de estimadores ---
  output$tabla_estimadores <- renderTable({
    if(!is.null(df_estimadores)) {
      df_est <- df_estimadores %>%
        mutate(
          Media = round(Media, 2),
          Varianza = round(Varianza, 2),
          IC_Inferior = round(IC_Inferior, 2),
          IC_Superior = round(IC_Superior, 2),
          Eficiencia_vs_Razón = ifelse(is.na(Eficiencia_vs_Razón), "---", round(Eficiencia_vs_Razón, 2))
        ) %>%
        rename(
          "Media Est." = Media,
          "Varianza" = Varianza,
          "IC Inf." = IC_Inferior,
          "IC Sup." = IC_Superior,
          "Eficiencia (%)" = Eficiencia_vs_Razón
        )
      df_est
    } else {
      data.frame(Mensaje = "Ejecute 03_estimadores.R primero")
    }
  }, rownames = FALSE)

  # --- Tabla ANOVA detallada para materia seleccionada ---
  output$tabla_anova_detalle <- renderTable({
    if(!is.null(df_anova)) {
      df_anova %>%
        filter(Materia == input$selector_materia) %>%
        mutate(
          F_value = round(F_value, 2),
          p_value = ifelse(p_value < 0.001, format(p_value, scientific = TRUE), round(p_value, 4)),
          Eta_Cuadrado = round(Eta_Cuadrado, 3)
        ) %>%
        select(Materia, F_value, p_value, Df_Estratos, Df_Error, Eta_Cuadrado, Tamano_Efecto, Significativo, Pares_Diferentes)
    } else {
      data.frame(Mensaje = "Ejecute 04_anova.R primero")
    }
  }, rownames = FALSE)

  # --- Gráfico Eta cuadrado todas las materias ---
  output$plot_eta_cuadrado <- renderPlotly({
    if(is.null(df_anova)) return(NULL)

    # Mapeo de nombres cortos
    nombres_cortos <- c(
      "PUNT_MATEMATICAS" = "Matemáticas",
      "PUNT_LECTURA_CRITICA" = "Lectura",
      "PUNT_INGLES" = "Inglés",
      "PUNT_SOCIALES_CIUDADANAS" = "Sociales",
      "PUNT_C_NATURALES" = "Ciencias",
      "PUNT_GLOBAL" = "Global"
    )

    df_plot <- df_anova %>%
      mutate(
        Materia_Corta = nombres_cortos[Materia],
        Interpretacion = case_when(
          Eta_Cuadrado >= 0.14 ~ "Grande",
          Eta_Cuadrado >= 0.06 ~ "Mediano",
          TRUE ~ "Pequeño"
        )
      )

    colores_eta <- c("Grande" = "#e53e3e", "Mediano" = "#d69e2e", "Pequeño" = "#38a169")

    fig <- plot_ly(df_plot, x = ~Materia_Corta, y = ~Eta_Cuadrado,
                   type = 'bar',
                   marker = list(color = colores_eta[df_plot$Interpretacion],
                                line = list(color = 'white', width = 2)),
                   text = ~paste0('η² = ', round(Eta_Cuadrado, 3)),
                   textposition = 'outside',
                   hoverinfo = 'text',
                   hovertext = ~paste0('<b>Materia:</b> ', Materia_Corta,
                                      '<br><b>η²:</b> ', round(Eta_Cuadrado, 3),
                                      '<br><b>Tamaño:</b> ', Interpretacion))

    fig %>%
      layout(
        xaxis = list(title = 'Competencia', tickfont = list(size = 12)),
        yaxis = list(title = expression(eta^2), range = c(0, 0.4), tickfont = list(size = 12)),
        margin = list(l = 60, r = 20, t = 20, b = 80),
        showlegend = FALSE
      )
  })

  # --- Tabla de supuestos ---
  output$tabla_supuestos <- renderTable({
    if(!is.null(df_supuestos)) {
      df_supuestos %>%
        mutate(
          Shapiro_P_fmt = ifelse(Shapiro_P < 0.001, "< 0.001", formatC(Shapiro_P, format = "e", digits = 3)),
          Levene_P_fmt = ifelse(Levene_P < 0.001, "< 0.001", formatC(Levene_P, format = "f", digits = 4)),
          Bartlett_P_fmt = ifelse(Bartlett_P < 0.001, "< 0.001", formatC(Bartlett_P, format = "e", digits = 3))
        ) %>%
        select(Materia, Shapiro_Est, Shapiro_P_fmt, Normalidad, Levene_P_fmt, Bartlett_P_fmt, Homocedasticidad) %>%
        rename(
          "Shapiro-Wilk (p)" = Shapiro_P_fmt,
          "Levene (p)" = Levene_P_fmt,
          "Bartlett (p)" = Bartlett_P_fmt
        )
    } else {
      data.frame(Mensaje = "Ejecute 05_validacion_supuestos.R primero")
    }
  }, rownames = FALSE)

  # --- Tabla de potencia ---
  output$tabla_potencia <- renderTable({
    if(!is.null(df_potencia)) {
      df_potencia %>%
        mutate(
          Sigma_Pooled = round(Sigma_Pooled, 2),
          Efecto_f = round(Efecto_f, 3),
          Potencia = round(Potencia, 4)
        )
    } else {
      data.frame(Mensaje = "Ejecute 06_analisis_potencia.R primero")
    }
  }, rownames = FALSE)

  # --- Gráfico efecto Cohen ---
  output$plot_efecto_cohen <- renderPlotly({
    if(is.null(df_potencia)) return(NULL)

    nombres_cortos <- c(
      "PUNT_MATEMATICAS" = "Matemáticas",
      "PUNT_LECTURA_CRITICA" = "Lectura",
      "PUNT_INGLES" = "Inglés",
      "PUNT_SOCIALES_CIUDADANAS" = "Sociales",
      "PUNT_C_NATURALES" = "Ciencias",
      "PUNT_GLOBAL" = "Global"
    )

    df_plot <- df_potencia %>%
      mutate(Materia_Corta = nombres_cortos[Materia])

    fig <- plot_ly(df_plot, x = ~Materia_Corta, y = ~Efecto_f,
                   type = 'bar',
                   marker = list(color = c('#4299e1', '#48bb78', '#ed8936', '#9f7aea', '#e53e3e', '#38b2ac'),
                                line = list(color = 'white', width = 2)),
                   text = ~paste0('f = ', round(Efecto_f, 3)),
                   textposition = 'outside')

    fig %>%
      layout(
        xaxis = list(title = 'Competencia', tickfont = list(size = 12)),
        yaxis = list(title = 'Efecto f (Cohen)', tickfont = list(size = 12)),
        margin = list(l = 60, r = 20, t = 20, b = 80),
        showlegend = FALSE
      )
  })

  # --- Gráfico promedios por estrato ---
  output$plot_promedios <- renderPlotly({
    if(is.null(df_muestra)) return(NULL)

    df_promedio <- df_muestra %>%
      group_by(ESTRATO_GRUPO) %>%
      summarise(
        Media = round(mean(PUNT_GLOBAL, na.rm = TRUE), 1),
        DE = round(sd(PUNT_GLOBAL, na.rm = TRUE), 1),
        `.groups` = "drop"
      ) %>%
      mutate(ESTRATO_GRUPO = factor(ESTRATO_GRUPO, levels = c("Bajo", "Medio", "Alto")))

    fig <- plot_ly(df_promedio, x = ~ESTRATO_GRUPO, y = ~Media,
                   type = 'bar',
                   marker = list(color = c('#4299e1', '#48bb78', '#ed8936'),
                                line = list(color = 'white', width = 2)),
                   text = ~paste0('Media: ', Media, ' ± ', DE),
                   textposition = 'outside',
                   error_y = list(type = 'data', array = ~DE, visible = TRUE, color = '#1a365d', thickness = 2))

    fig %>%
      layout(
        xaxis = list(title = 'Estrato Socioeconómico', tickfont = list(size = 14)),
        yaxis = list(title = 'Puntaje Global Promedio', tickfont = list(size = 14)),
        margin = list(l = 60, r = 20, t = 20, b = 60)
      )
  })
}

# ==============================================================================
# EJECUTAR APP
# ==============================================================================
shinyApp(ui = ui, server = server)
