# Use the official R base image
FROM r-base

# Set the working directory to /app
WORKDIR /app

# Install necessary system dependencies
RUN apt-get update && apt-get install -y \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev

# Install required R packages
RUN R -e "install.packages(c('shiny', 'shinydashboard', 'tidyverse', 'tidytext', 'here'), repos='http://cran.rstudio.com/')"

# Copy the app files to the container image
COPY app.r /app/app.r

COPY data/tweets.csv /app/data/tweets.csv

# Expose port 3838 for the Shiny app
EXPOSE 3838

# Run the Shiny app
CMD ["R", "-e", "shiny::runApp('/app/app.r', host='0.0.0.0', port=3838)"]
