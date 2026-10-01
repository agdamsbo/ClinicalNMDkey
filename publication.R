
shiny::runApp(appDir = ".",launch.browser = TRUE)

renv::install("shinylive")
shinylive::export(appdir = ".", destdir = "docs")
#
httpuv::runStaticServer(dir = "docs")
#
renv::install("shinylive")
# library(shinyelectron)
#
# # Check your system
# sitrep_shinyelectron()
#
# # Try a bundled demo
# export(
#   appdir  = ".",
#   destdir = "~/nmd-key",
#   run_after = TRUE
# )
