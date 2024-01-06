library(httr)
library(jsonlite)

rm(list = ls())

# credentials for GITHUB rest api access
# user and token are defined in config.r
source("config.r")

org_name <- "collabryio"
repoPath <- "collabryio/issueTracker"

# create repo api call to get the issues
issue_url <- paste0("https://api.github.com/repos/", repoPath, "/issues")

# GET request to GitHub API for issues on the repo
issues <- GET(issue_url)

# list issues depending on their title
issue_list <- fromJSON(content(issues, "text"))$title

# Set the issue details
issue_title <- "New Issue #2"
issue_body <- "This is the body for New Issue #2."

payload <- list(title = issue_title, body = issue_body)
# Convert the list to JSON
issue_json <- toJSON(payload, auto_unbox = TRUE)

# Use a personal access token for authentication
auth_token <- sprintf("token %s", token)

response <- httr::POST(
  issue_url,
  add_headers(Authorization = auth_token),
  body = issue_json,
  encode = "json",
  content_type("application/json")
)

# GET request to GitHub API for issues on the repo
issues <- GET(issue_url)

# list issues depending on their title
issue_list <- fromJSON(content(issues, "text"))$title