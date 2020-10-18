FROM rocker/r-ver:4.0.2
RUN apt-get update && apt-get install -y  git-core libcurl4-openssl-dev libgit2-dev libssh2-1-dev libssl-dev libxml2-dev make pandoc pandoc-citeproc zlib1g-dev && rm -rf /var/lib/apt/lists/*
RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl')" >> /usr/local/lib/R/etc/Rprofile.site

RUN R -e 'install.packages("remotes")'
RUN R -e 'remotes::install_github("r-lib/remotes", ref = "97bbf81")'
RUN Rscript -e 'remotes::install_version("shiny",upgrade="never", version = "1.5.0")'
RUN Rscript -e 'remotes::install_version("config",upgrade="never", version = "0.3")'
RUN Rscript -e 'remotes::install_version("pagedown",upgrade="never", version = "0.11")'
RUN Rscript -e 'remotes::install_version("golem",upgrade="never", version = "0.2.1")'
RUN Rscript -e 'remotes::install_github("tidyverse/magrittr@0221e18523b1da1b050faac9da36891f8e5dce49")'
RUN Rscript -e 'remotes::install_github("rstudio/rmarkdown@1707d0b5189e3f12caf16a6cd53391f5be2b2f08")'
RUN Rscript -e 'remotes::install_github("daattali/shinyjs@a17c29d52a09308c2d747d49ee6b608ed2dacbe5")'
RUN Rscript -e 'remotes::install_version("ggplot2",upgrade="never", version = "3.3.2")'

## install chrome
RUN apt-get update && apt-get install -y curl
RUN curl -LO https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get install -y ./google-chrome-stable_current_amd64.deb
RUN rm google-chrome-stable_current_amd64.deb 

ENV no_proxy="127.0.0.1"

RUN mkdir /build_zone
ADD . /build_zone
WORKDIR /build_zone
RUN R -e 'remotes::install_local(upgrade="never")'
EXPOSE 3838
CMD  ["R", "-e", "options('shiny.port'=3838,shiny.host='0.0.0.0');golem.reprex::run_app()"]
