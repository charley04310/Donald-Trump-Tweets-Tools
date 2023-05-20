# Start with a base image containing R and Shiny Server
FROM rocker/shiny:latest

# system libraries of general use
## install debian packages
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libxml2-dev \
    libcairo2-dev \
    libsqlite3-dev \
    libmariadbd-dev \
    libpq-dev \
    libssh2-1-dev \
    unixodbc-dev \
    libcurl4-openssl-dev \
    libssl-dev

# Install R packages required for your Shiny app
RUN R -e "install.packages(c('shiny', 'tidyverse', 'shinydashboard', 'tidytext', 'here'), repos='https://cloud.r-project.org/')" 


# Copy the Shiny app files to the container
COPY . /srv/shiny-server/



# Expose the port that Shiny Server runs on (default is 3838)
EXPOSE 3838

# Set the command to run Shiny Server when the container starts
CMD ["/usr/bin/shiny-server.sh"]
