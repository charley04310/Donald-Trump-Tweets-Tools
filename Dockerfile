# Start with a base R image
FROM r-base:latest

# Install necessary system dependencies
RUN apt-get update && apt-get install -y \
    libssl-dev \
    libcurl4-gnutls-dev \
    libxml2-dev \
    libfontconfig1 \
    libcairo2-dev

# Install R packages required for your Shiny app
RUN R -e "install.packages(c('shiny', 'tidyverse', 'shinydashboard', 'tidytext', 'here'), repos='https://cloud.r-project.org/')"

# Copy the Shiny app files to the container
COPY app.R /app.R

# Expose the port that Shiny app runs on (default is 3838)
EXPOSE 3838

# Set the command to run the Shiny app when the container starts
CMD ["R", "-e", "shiny::runApp('/app.R', host='0.0.0.0', port=3838)"]
