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

# Install R packages required for your Shiny app
RUN install2.r --error --skipinstalled \
    shiny \
    jsonlite \
    ggplot2 \
    htmltools \
    shinydashboard \
    tidyverse \
    tidytext \
    here

# Copy the app files to the container
COPY app.R /srv/shiny-server/app.R
COPY data/tweets.csv /srv/shiny-server/data/tweets.csv

USER shiny

EXPOSE 3838

CMD ["/usr/bin/shiny-server"]
