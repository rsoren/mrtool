#
# zzz.R
#
# Reed Sorensen
# February 2021
#

mrtool <- NULL

.onLoad <- function(libname, pkgname) {

  ihme_conda <- "/ihme/code/mscm/miniconda3/bin/conda"
  if (file.exists(ihme_conda)) {
    use_condaenv(condaenv = "mrtool_0.0.2", conda = ihme_conda, required = TRUE)
  }

  if (reticulate::py_module_available("mrtool")) {
    mrtool <<- import("mrtool")
    for (nm in names(mrtool)) assign(nm, mrtool[[nm]], parent.env(environment()))
  } else {
    warning(paste0(
      "Please use reticulate::install_miniconda() and mrtool::install_mrtool() ",
      "to install the Python dependencies for the package"
    ))
  }
}
