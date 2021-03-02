#
# functions_for_installation_and_updates.R
#
# Reed Sorensen
# February 2021
#


check_env <- function(py_current = reticulate::py_config()$python) {
  if (!(grepl("r-miniconda", py_current) & grepl("r-reticulate", py_current) )) {
    stop(paste0(
      "Current conda environment is not 'r-reticulate'; ",
      "to switch, please restart the R session and re-load the package"
    ))
  }
}


install_mrtool <- function() {

  if (file.exists("/ihme/code/mscm/miniconda3/bin/conda")) {
    stop("Custom installation of 'mrtool' on the IHME cluster is not permitted")
  }

  py_current <- reticulate::py_config()$python
  check_env()

  if (reticulate::py_module_available("mrtool")) {
    cat("Module 'mrtool' is already available for Python:", py_current,
        "\nUse the update_mrtool() function to change the version"
    )
  } else {

    # install libgmp3-dev
    system("sudo apt-get -y install libgmp3-dev")

    # install mrtool
    cmd_mrtool <- paste0(
      py_config()$python, " -m pip install --user ",
      "git+https://github.com/ihmeuw-msca/mrtool.git@v0.0.1#egg=mrtool"
    )
    system(cmd_mrtool)

    require(reticulate)
    if (!py_module_available("dataclasses")) conda_install(packages = "dataclasses")
    if (!py_module_available("cyipopt")) conda_install(packages = "cyipopt", forge = TRUE)
    if (!py_module_available("pycddlib")) py_install(packages = "pycddlib", pip = TRUE)

    cmd_limetr <- paste0(
      py_config()$python, " -m pip install --user ",
      "git+https://github.com/zhengp0/limetr.git@master"
    )
    system(cmd_limetr)

    warning(paste0(
      "To use the newly downloaded 'mrtool' module, ", "please restart the R session and re-load this package"
    ))
  }
}


update_mrtool <- function(module_location = "git+https://github.com/ihmeuw-msca/mrtool.git@v0.0.1#egg=mrtool") {

  if (file.exists("/ihme/code/mscm/miniconda3/bin/conda")) {
    stop("Custom updates of 'mrtool' on the IHME cluster are not permitted")
  }

  py_current <- reticulate::py_config()$python
  check_env()

  cmd1 <- paste0(py_current, " -m pip install --user -e ")
  cmd2 <- paste0(cmd1, module_location)
  system(cmd2)

  warning(paste0(
    "To use the newly updated 'mrtool' module, ", "please restart the R session and re-load the package"
  ))

}
