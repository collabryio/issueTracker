library(httr)
library(jsonlite)

# credentials for GITHUB rest api access
# user and token are defined in config.r
source("config.r")

org_name <- "collabryio"

# GitHub API URL for public repos
public_url <- paste0("https://api.github.com/orgs/", org_name, "/repos")

# GitHub API URL for private repos
# private_url <- paste0("https://api.github.com/orgs/", org_name, "/repos?type=private")

# private_url <- paste0('https://api.github.com/orgs/',org_name,'/repos?per_page=1000', auth=(user, token))


private_url <- "https://api.github.com/orgs/collabryio/repos?access_token=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"

# GET request to GitHub API for public repos
public_response <- GET(public_url, headers = headers)

# GET request to GitHub API for private repos
private_response <- GET(private_url, headers = headers)

# Sorgu sonucunu JSON formatında alın
public_repos <- fromJSON(content(public_response, "text"))$name
private_repos <- fromJSON(content(private_response, "text"))$name