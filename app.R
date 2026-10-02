# --------------------------------------------------------------
# app.R – Clinical Neuromuscular Diagnostic Key
#           (supranuclear level omitted, pure base‑R + Shiny)
# --------------------------------------------------------------
library(shiny)

# --------------------------------------------------------------
# 1)  Load the flat data frame (unchanged)
# --------------------------------------------------------------
key_df <- structure(
  list(
    supranuclear = c(
      "infra","infra","infra","infra","infra","infra","infra","infra","infra",
      "infra","infra","infra","infra","infra","infra","infra","infra","infra","infra"
    ),
    modality = c(
      "both","motor","motor","motor","motor","motor","motor","motor","motor",
      "motor","motor","motor","sensor","sensor","sensor","sensor","sensor","sensor","sensor"
    ),
    anatomy = c(
      "single nerve","ptosis","ptosis","ptosis","ptosis","ptosis","ptosis","ptosis",
      "only ocular","only ocular","only ocular","only ocular",
      "symmetrical","symmetrical","symmetrical","distal symmetrical",
      "distal symmetrical","distal symmetrical","distal symmetrical"
    ),
    symmetri = c(
      "all possible","unilateral","unilateral","unilateral","unilateral",
      "unilateral","unilateral","bilateral","internal/external","external",
      "external","external m. udtrætning","extensive autonomous symptoms",
      "extensive autonomous symptoms","extensive autonomous symptoms",
      "all modalities","all modalities","all modalities","all modalities"
    ),
    diagnosis = c(
      "Mononeuritis/mononeuropatia","Horner","Facialisparese","CPEO","Congenital ptosis",
      "Dystrophia myotonica type 1","MG","MG","Botulism","CPEO","Miller-Fisher","MG",
      "DM","Amyloidosis","Fabry","HIV","Hepatitis C","SLE","HSN"
    ),
    note = c(
      "","","","","","","","","","","Includes ataxia and areflexia",
      "typically including ptosis","","","","","","",""
    ),
    source = c(
      NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA
    ),
    stringsAsFactors = FALSE
  ),
  class = "data.frame",
  row.names = c(NA, -19L)
)

# --------------------------------------------------------------
# 2)  Build a **nested list that starts at modality** (supranuclear omitted)
# --------------------------------------------------------------
# Level 1 (now modality)
nested_mod <- split(key_df, key_df$modality)

make_leaves <- function(df) {
  lapply(seq_len(nrow(df)), function(i) {
    list(
      diagnosis = df$diagnosis[i],
      note       = df$note[i],
      source     = if (!is.na(df$source[i])) df$source[i] else NULL
    )
  })
}

# Build hierarchy: modality → anatomy → symmetry → leaf list
key_tree <- lapply(nested_mod, function(df1) {
  split_anat <- split(df1, df1$anatomy)
  lapply(split_anat, function(df2) {
    split_sym <- split(df2, df2$symmetri)
    lapply(split_sym, make_leaves)
  })
})

# --------------------------------------------------------------
# 3)  UI ---------------------------------------------------------
# --------------------------------------------------------------
ui <- fluidPage(
  title = "Clinical Neuromuscular diagnostic key",
  tags$head(
    tags$meta(name = "viewport", content = "width=device-width, initial-scale=1"),
    # ---- same lightweight CSS as before ----
    tags$style(HTML("
      @import url('https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap');
      :root{
        --primary:#00695c;   /* teal */
        --bg:#fafafa;        /* light gray */
        --card:#ffffff;      /* white cards */
        --txt:#212121;       /* dark gray */
        --link:#0277bd;      /* bright blue */
      }
      body{
        font-family:'Roboto',Helvetica,Arial,sans-serif;
        background:var(--bg);
        color:var(--txt);
        margin:0;padding:0;
      }
      .container{max-width:800px;margin:auto;padding:1rem;}
      .card{
        background:var(--card);
        border-radius:8px;
        box-shadow:0 2px 6px rgba(0,0,0,.08);
        padding:1rem;
        margin-bottom:1.5rem;
      }
      .card h4{color:var(--primary);margin-top:0;font-weight:500;}
      select{
        width:100%;height:2.7rem;font-size:1rem;
        border-radius:4px;border:1px solid #cfd8dc;
        margin-bottom:1rem;padding:.4rem .6rem;
      }
      table{width:100%;border-collapse:collapse;margin-top:.5rem;}
      th,td{border:1px solid #e0e0e0;padding:.4rem .6rem;vertical-align:top;}
      th{background:#f5f5f5;}
      a.source-link{color:var(--link);text-decoration:underline;font-size:.9rem;}
      a.source-link:hover{opacity:.8;}
      .how ol{padding-left:1.2rem;margin-top:.5rem;}
      .how li{margin-bottom:.8rem;line-height:1.45;}
      .foot{text-align:center;font-size:.85rem;color:#555;margin-top:2rem;
            padding:1rem 0;border-top:1px solid #e0e0e0;}
    "))
  ),

  div(class = "container",
      tags$h2("Clinical neuromuscular diagnostic key",
              style = "color: var(--primary); margin-bottom: .2rem;"),

      # ---------- INPUT CARD (modality → anatomy → symmetry) ----------
      div(class = "card",
          selectInput("moda",
                      label = tagList(icon("sliders-h"), "Modality"),
                      choices = NULL, width = "100%"),
          selectInput("anat",
                      label = tagList(icon("project-diagram"), "Anatomy"),
                      choices = NULL, width = "100%"),
          selectInput("symm",
                      label = tagList(icon("balance-scale"), "Symmetry"),
                      choices = NULL, width = "100%"),
          tags$hr(),
          strong("Possible diagnosis(es):"),
          uiOutput("dx_table")
      ),

      # ---------- EXPLANATION CARD ----------
      div(class = "card how",
          tags$h4("How to use this key"),
          tags$ol(
            tags$li(tags$strong(tagList(icon("sliders-h"),
                                        "Choose the modality – ")),
                    "Select the clinical modality that is abnormal (motor, sensor, or both)."),
            tags$li(tags$strong(tagList(icon("project-diagram"),
                                        "Pick the anatomy – ")),
                    "Select the specific anatomical structure involved."),
            tags$li(tags$strong(tagList(icon("balance-scale"),
                                        "Define the symmetry – ")),
                    "Indicate unilateral, bilateral, symmetrical, etc.")
          )
      )
  ),

  # ---------- FOOTER ----------
  tags$footer(class = "foot",
              "Original key: © 2026 Steffen Birk • ",
              a(href = "https://github.com/agdamsbo/ClinicalNMDkey", "GitHub Repo"))
)

# --------------------------------------------------------------
# 4)  Server -----------------------------------------------------
# --------------------------------------------------------------
server <- function(input, output, session) {

  ## 1️⃣  Populate the **Modality** selector (first level) ----------
  observe({
    mod_vals <- names(key_tree)                 # all modalities present
    updateSelectInput(session, "moda",
                      choices = mod_vals,
                      selected = mod_vals[1])
  })

  ## 2️⃣  When a modality is chosen → fill **Anatomy** ----------------
  observeEvent(input$moda, {
    req(input$moda)
    anat_vals <- names(key_tree[[input$moda]])
    updateSelectInput(session, "anat",
                      choices = anat_vals,
                      selected = anat_vals[1])

    # clear lower selectors / output
    updateSelectInput(session, "symm", choices = NULL, selected = NULL)
    output$dx_table <- renderUI({})
  }, ignoreNULL = TRUE)

  ## 3️⃣  When anatomy is chosen → fill **Symmetry** ----------------
  observeEvent(input$anat, {
    req(input$moda, input$anat)
    sym_vals <- names(key_tree[[input$moda]][[input$anat]])
    updateSelectInput(session, "symm",
                      choices = sym_vals,
                      selected = sym_vals[1])

    output$dx_table <- renderUI({})
  }, ignoreNULL = TRUE)

  ## 4️⃣  When symmetry is chosen → render the result table ----------
  observeEvent(input$symm, {
    req(input$moda, input$anat, input$symm)

    hits <- key_tree[[input$moda]][[input$anat]][[input$symm]]

    if (length(hits) == 0) {
      output$dx_table <- renderUI(tags$em("No matching combination."))
      return()
    }

    # ---- table header ----
    hdr <- tags$tr(
      tags$th("Diagnosis"),
      tags$th("Note"),
      tags$th("Source")
    )

    # ---- table rows ----
    rows <- lapply(hits, function(rec) {
      tags$tr(
        tags$td(rec$diagnosis),
        tags$td(if (nzchar(rec$note)) tags$em(rec$note) else ""),
        tags$td(
          if (!is.null(rec$source) && nzchar(rec$source)) {
            src <- rec$source
            if (!grepl("^https?://", src, ignore.case = TRUE))
              src <- paste0("http://", src)
            tags$a(href = src,
                   target = "_blank",
                   class = "source-link",
                   "[source]")
          } else ""
        )
      )
    })

    output$dx_table <- renderUI(
      tags$table(class = "dx",
                 tags$thead(hdr),
                 tags$tbody(rows))
    )
  }, ignoreNULL = TRUE)
}

# --------------------------------------------------------------
# 5)  Run --------------------------------------------------------
# --------------------------------------------------------------
shinyApp(ui = ui, server = server)
