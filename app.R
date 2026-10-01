# --------------------------------------------------------------
# app.R – Neuro‑Motor Diagnostic Key (icons + italic notes)
# --------------------------------------------------------------
library(shiny)

# --------------------------------------------------------------
# 1) Load the data -----------------------------------------------
# --------------------------------------------------------------
# data_path <- "nmd_key_basic.csv"
#
# key_df <- read.csv(
#   file = data_path,
#   sep = ";",
#   stringsAsFactors = FALSE,
#   check.names = FALSE,
#   encoding = "UTF-8"
# )

key_df <- structure(
  list(
    supranuclear = c(
      "infra",
      "infra",
      "infra",
      "infra",
      "infra",
      "infra",
      "infra",
      "infra",
      "infra",
      "infra",
      "infra",
      "infra",
      "infra",
      "infra",
      "infra",
      "infra",
      "infra",
      "infra",
      "infra"
    ),
    modality = c(
      "both",
      "motor",
      "motor",
      "motor",
      "motor",
      "motor",
      "motor",
      "motor",
      "motor",
      "motor",
      "motor",
      "motor",
      "sensor",
      "sensor",
      "sensor",
      "sensor",
      "sensor",
      "sensor",
      "sensor"
    ),
    anatomy = c(
      "single nerve",
      "ptosis",
      "ptosis",
      "ptosis",
      "ptosis",
      "ptosis",
      "ptosis",
      "ptosis",
      "only ocular",
      "only ocular",
      "only ocular",
      "only ocular",
      "symmetrical",
      "symmetrical",
      "symmetrical",
      "distal symmetrical",
      "distal symmetrical",
      "distal symmetrical",
      "distal symmetrical"
    ),
    symmetri = c(
      "all possible",
      "unilateral",
      "unilateral",
      "unilateral",
      "unilateral",
      "unilateral",
      "unilateral",
      "bilateral",
      "internal/external",
      "external",
      "external",
      "external m. udtrætning",
      "extensive autonomous symptoms",
      "extensive autonomous symptoms",
      "extensive autonomous symptoms",
      "all modalities",
      "all modalities",
      "all modalities",
      "all modalities"
    ),
    diagnosis = c(
      "Mononeuritis/mononeuropatia",
      "Horner",
      "Facialisparese",
      "CPEO",
      "Congenital ptosis",
      "Dystrophia myotonica type 1",
      "MG",
      "MG",
      "Botulism",
      "CPEO",
      "Miller-Fisher",
      "MG",
      "DM",
      "Amyloidosis",
      "Fabry",
      "HIV",
      "Hepatitis C",
      "SLE",
      "HSN"
    ),
    note = c(
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "Includes ataxia and areflexia",
      "typically including ptosis",
      "",
      "",
      "",
      "",
      "",
      "",
      ""
    ),
    source = c(
      NA,
      NA,
      NA,
      NA,
      NA,
      NA,
      NA,
      NA,
      NA,
      NA,
      NA,
      NA,
      NA,
      NA,
      NA,
      NA,
      NA,
      NA,
      NA
    )
  ),
  class = "data.frame",
  row.names = c(NA, -19L)
)

# Trim any stray blanks
key_df[] <- lapply(key_df, trimws)

# --------------------------------------------------------------
# 2) UI – only the explanatory card is updated
# --------------------------------------------------------------
ui <- fluidPage(
  title = "Clinical Neuromuscular diagnostic key",
  tags$head(
    tags$meta(
      name = "viewport",
      content = "width=device-width, initial-scale=1"
    ),
    # ---- light modern CSS ----------------------------------------
    tags$style(HTML(
      "
      @import url('https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap');

      :root{
        --primary:#00695c;   /* teal */
        --bg:#fafafa;        /* very light gray */
        --card-bg:#ffffff;   /* white cards */
        --text:#212121;      /* dark gray */
        --link:#0277bd;      /* bright blue */
      }

      body{
        font-family:'Roboto',Helvetica,Arial,sans-serif;
        background-color:var(--bg);
        color:var(--text);
        margin:0;padding:0;
      }
      .container{max-width:800px;margin:0 auto;padding:1rem;}
      .card{
        background:var(--card-bg);
        border-radius:8px;
        box-shadow:0 2px 6px rgba(0,0,0,.08);
        padding:1rem;
        margin-bottom:1.5rem;
      }
      .card h4{color:var(--primary);margin-top:0;font-weight:500;}
      .form-control{
        height:2.7rem;font-size:1rem;border-radius:4px;
        border:1px solid #cfd8dc;
      }
      .shiny-input-container{margin-bottom:1rem;}
      .diagnosis-table{width:100%;border-collapse:collapse;margin-top:.5rem;}
      .diagnosis-table th,
      .diagnosis-table td{
        border:1px solid #e0e0e0;
        padding:.4rem .6rem;
        text-align:left;
        vertical-align:top;
      }
      .diagnosis-table th{
        background:#f5f5f5;
        font-weight:500;
      }
      a.source-link{
        color:var(--link);
        text-decoration:underline;
        font-size:.9rem;
      }
      a.source-link:hover{opacity:.8;}
      .how-it-works ol{padding-left:1.2rem;margin-top:.5rem;}
      .how-it-works li{margin-bottom:.8rem;line-height:1.45;}
      .footer{
        text-align:center;
        font-size:.85rem;
        color:#555;
        margin-top:2rem;
        padding:1rem 0;
        border-top:1px solid #e0e0e0;
      }
    "
    ))
  ),

  div(
    class = "container",
    titlePanel(
      tags$h2(
        "Clinical neuromuscular diagnostic key",
        style = "color: var(--primary); margin-bottom: .2rem;"
      )
    ),

    # ------------ INPUT CARD ------------
    div(
      class = "card",
      selectInput(
        "supra",
        label = tagList(icon("layer-group"), "Supranuclear level"),
        choices = NULL,
        width = "100%"
      ),
      selectInput(
        "moda",
        label = tagList(icon("sliders-h"), "Modality"),
        choices = NULL,
        width = "100%"
      ),
      selectInput(
        "anat",
        label = tagList(icon("project-diagram"), "Anatomy"),
        choices = NULL,
        width = "100%"
      ),
      selectInput(
        "symm",
        label = tagList(icon("balance-scale"), "Symmetry"),
        choices = NULL,
        width = "100%"
      ),
      tags$hr(),
      strong("Possible diagnosis(es):"),
      uiOutput("dx_table")
    ),

    # ------------ CLINICIAN‑FOCUSED EXPLANATION ------------
    div(
      class = "card how-it-works",
      tags$h4("How to use this key"),
      tags$ol(
        tags$li(
          tags$strong(tagList(
            icon("layer-group"),
            " 1. Set the supranuclear level – "
          )),
          "Choose the anatomical level (e.g., infra‑nuclear). ",
          "All downstream options will automatically reflect only the diagnoses that can arise from that level."
        ),
        tags$li(
          tags$strong(tagList(icon("sliders-h"), " 2. Choose the modality – ")),
          "Select the clinical modality that is abnormal (motor, sensory, or both). ",
          "The list narrows to the subset of diagnoses that present with that modality at the chosen level."
        ),
        tags$li(
          tags$strong(tagList(
            icon("project-diagram"),
            " 3. Select the anatomy – "
          )),
          "Pick the specific anatomical structure involved (single nerve, ocular, distal, etc.). ",
          "Only diagnoses compatible with the previously selected level + modality will remain."
        ),
        tags$li(
          tags$strong(tagList(
            icon("balance-scale"),
            " 4. Define the symmetry – "
          )),
          "Indicate whether the finding is unilateral, bilateral, symmetrical, etc. ",
          "The final list now shows every possible diagnosis that matches **all** of your selections, ",
          "with any relevant clinical note and a link to the source reference."
        )
      )
    )
  ),

  # ---- Footer ----------------------------------------------------
  tags$footer(class = "footer",
              "Original key: © 2026 Steffen Birk • ",
              a(href = "https://github.com/agdamsbo/ClinicalNMDkey", "GitHub Repo"))
)


# --------------------------------------------------------------
# 3) Server -----------------------------------------------------
# --------------------------------------------------------------
server <- function(input, output, session) {
  ## 1️⃣ Supranuclear -------------------------------------------------
  observe({
    sup_vals <- unique(key_df$supranuclear)
    updateSelectInput(
      session,
      "supra",
      choices = sup_vals,
      selected = sup_vals[1]
    )
  })

  ## 2️⃣ Modality (filtered by supranuclear) -------------------------
  observeEvent(
    input$supra,
    {
      sub1 <- key_df[key_df$supranuclear == input$supra, , drop = FALSE]
      moda_vals <- unique(sub1$modality)
      updateSelectInput(
        session,
        "moda",
        choices = moda_vals,
        selected = moda_vals[1]
      )
    },
    ignoreNULL = TRUE
  )

  ## 3️⃣ Anatomy (filtered by supra + modality) -----------------------
  observeEvent(
    input$moda,
    {
      req(input$supra)
      sub2 <- key_df[
        key_df$supranuclear == input$supra &
          key_df$modality == input$moda,
        ,
        drop = FALSE
      ]
      anat_vals <- unique(sub2$anatomy)
      updateSelectInput(
        session,
        "anat",
        choices = anat_vals,
        selected = anat_vals[1]
      )
    },
    ignoreNULL = TRUE
  )

  ## 4️⃣ Symmetry (filtered by supra + modality + anatomy) ----------
  observeEvent(
    input$anat,
    {
      req(input$supra, input$moda)
      sub3 <- key_df[
        key_df$supranuclear == input$supra &
          key_df$modality == input$moda &
          key_df$anatomy == input$anat,
        ,
        drop = FALSE
      ]
      sym_vals <- unique(sub3$symmetri)
      updateSelectInput(
        session,
        "symm",
        choices = sym_vals,
        selected = sym_vals[1]
      )
    },
    ignoreNULL = TRUE
  )

  ## 5️⃣ Render results as a table ---------------------------------
  output$dx_table <- renderUI({
    req(input$supra, input$moda, input$anat, input$symm)

    hits <- key_df[
      key_df$supranuclear == input$supra &
        key_df$modality == input$moda &
        key_df$anatomy == input$anat &
        key_df$symmetri == input$symm,
      ,
      drop = FALSE
    ]

    if (nrow(hits) == 0) {
      return(tags$em("No matching combination – should never happen."))
    }

    # Build a <table> -------------------------------------------------
    header <- tags$tr(
      tags$th("Possible diagnosis"),
      tags$th("Notes"),
      tags$th("Further reading")
    )

    rows <- lapply(seq_len(nrow(hits)), function(i) {
      dx <- hits$diagnosis[i]
      note <- hits$note[i]
      src <- hits$source[i]

      # Diagnosis cell – plain text
      diag_cell <- tags$td(dx)

      # Note cell – italic if there is a note, otherwise empty
      note_cell <- if (nzchar(note)) {
        tags$td(tags$em(note))
      } else {
        tags$td("") # empty cell
      }

      # Source cell – clickable link only when URL is present
      src_cell <- if (!is.na(src) && nzchar(src)) {
        # ensure protocol is present
        if (!grepl("^https?://", src, ignore.case = TRUE)) {
          src <- paste0("http://", src)
        }
        link_tag <- tags$a(
          href = src,
          target = "_blank",
          class = "source-link",
          "[source]"
        )
        tags$td(link_tag)
      } else {
        tags$td("") # empty cell when no source
      }

      tags$tr(diag_cell, note_cell, src_cell)
    })

    tags$table(class = "diagnosis-table", tags$thead(header), tags$tbody(rows))
  })
}

# --------------------------------------------------------------
# 4) Run --------------------------------------------------------
# --------------------------------------------------------------
shinyApp(ui = ui, server = server)
