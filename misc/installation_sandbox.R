

# https://stackoverflow.com/questions/13685920/install-specific-git-commit-with-pip

install.packages("remotes")
library(remotes)
install_github("rsoren/mrtool")
reticulate::install_miniconda()
mrtool::install_mrtool()

mrtool::update_mrtool("git+https://github.com/ihmeuw-msca/mrtool.git@v0.0.1#egg=mrtool")

conda_install(packages = "cyipopt", forge = TRUE)
py_install(packages = "pycddlib", pip = TRUE)

cmd1 <- paste0(py_config()$python, " -m pip install --user ")
version_default <- "git+https://github.com/zhengp0/limetr.git@master"
# version_default <- "git+https://github.com/ihmeuw-msca/mrtool.git"
cmd2 <- paste0(cmd1, version_default)
system(cmd2)


cmd1 <- paste0(py_config()$python, " -m pip install --user ")
version_default <- "git+https://github.com/zhengp0/limetr.git@master"
# version_default <- "git+https://github.com/ihmeuw-msca/mrtool.git"
cmd2 <- paste0(cmd1, version_default)
system(cmd2)


# take dockerfile from rocker/rstudio,
# modify it so the package is pre-installed
# apt-get install libgmp3-dev
#
# RUN command will give sudo permission
#


# 3.7 or 3.8 will avoid dataclasses dependency

