FROM rocker/shiny:4.0.5

# Install system requirements for index.R as needed
RUN apt-get update && apt-get install -y \
    --no-install-recommends \
    git-core \
    libssl-dev \
    libcurl4-gnutls-dev \
    curl \
    libsodium-dev \
    libxml2-dev \
    libicu-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV _R_SHLIB_STRIP_=true

COPY ./* /etc/R

# Install R packages required for your Shiny app
RUN R -e "install.packages(c('shiny', 'tidyverse', 'shinydashboard', 'tidytext', 'here'), repos='https://cloud.r-project.org/')" 

COPY ./* /srv/shiny-server/

USER shiny

EXPOSE 3838

CMD ["/usr/bin/shiny-server"]

