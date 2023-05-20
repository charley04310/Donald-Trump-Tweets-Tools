# Dockerfile
# Use the official R base image
FROM r-base:latest

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev

# Install R packages
RUN R -e "install.packages(c('shiny', 'shinydashboard', 'tidyverse', 'tidytext', 'here'), repos='http://cran.rstudio.com/')"

# Create and set the working directory
RUN mkdir /app
WORKDIR /app

# Copy the app files to the container
COPY app.R /app/app.R
COPY data/tweets.csv /app/data/tweets.csv

# Expose port 3838 for the Shiny app
EXPOSE 3838

# Set the command to run the Shiny app
CMD ["R", "-e", "shiny::runApp('/app', host = '0.0.0.0', port = 3838)"]
