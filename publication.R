
shiny::runApp(appDir = ".",launch.browser = TRUE)

renv::install("shinylive")
shinylive::export(appdir = ".", destdir = "_site")
#
httpuv::runStaticServer(dir = "_site")
#
# renv::install("coatless-rpkg/shinyelectron")
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
