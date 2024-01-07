# Install the required packages if not already installed
if (!requireNamespace("httr", quietly = TRUE)) install.packages("httr")
if (!requireNamespace("readxl", quietly = TRUE)) install.packages("readxl")
if (!requireNamespace("writexl", quietly = TRUE)) install.packages("writexl")
if (!requireNamespace("jsonlite", quietly = TRUE)) install.packages("jsonlite")

library(readxl)
library(writexl)
library(httr)
library(jsonlite)

rm(list = ls())

# credentials for GITHUB rest api access
# user and token are defined in config.r
source("config.r")

# Use a personal access token for authentication
auth_token <- sprintf("token %s", token)

current_path <- getwd()
excel_path <- paste0(current_path, "/file.xlsx")

data <- read_excel(excel_path)

org_name <- "collabryio"
repoPath <- "collabryio/issueTracker"

# create repo api call to get the issues
issue_url <- paste0("https://api.github.com/repos/", repoPath, "/issues")

for (i in 1:nrow(data)) {
    # Set the issue details
    issue_title <- paste0(data$task_id[i], "--", data$file_name[i])
    issue_body <- data$todo[i]
    issue_assignee <- data$person_name[i]
    issue_label <- "good first issue"

    payload <- list(title = issue_title, body = issue_body, assignee = issue_assignee, label = issue_label)
    # Convert the list to JSON
    issue_json <- toJSON(payload, auto_unbox = TRUE)

    response <- httr::POST(
        issue_url,
        add_headers(Authorization = auth_token),
        body = issue_json,
        encode = "json",
        content_type("application/json")
    )

    # Check if the request was successful
    if (status_code(response) == 201) {
        cat(paste("Issue '", issue_title, "' created successfully.\n"))
    } else {
        cat(paste("Failed to create issue '", issue_title, "'. Status code: ", status_code(response), ", Response: ", content(response, "text"), "\n"))
    }
}