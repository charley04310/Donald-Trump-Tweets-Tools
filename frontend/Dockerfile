# Use the official shiny base image
FROM rocker/shiny:4.1.0

# Install additional system dependencies if required
# For example, if your app requires additional libraries, you can install them here

# Install required R packages
RUN R -e "install.packages(c('shiny', 'shinydashboard', 'tidyverse', 'tidytext', 'here'), repos='http://cran.rstudio.com/')"

# Copy the app files to the container image
COPY app.R /srv/shiny-server/app.R
COPY data/tweets.csv /srv/shiny-server/data/tweets.csv

# Expose port 3838 for the Shiny app
EXPOSE 3838

# Run the Shiny Server
CMD ["/usr/bin/shiny-server.sh"]
