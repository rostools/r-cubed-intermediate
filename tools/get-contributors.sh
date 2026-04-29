#!/usr/bin/env bash

# Get a list of contributors to this repository and save it to
# _contributors.qmd file (overwritten if it exists). It also:
#
# - Formats users into Markdown links to their GitHub profiles.
# - Removes any usernames with the word "bot" in them.
# - Removes the trailing comma from the list.
repo_spec=${1}
contributors=$(gh api \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  /repos/$repo_spec/contributors \
  --template '{{range .}}[\@{{.login}}]({{.html_url}}){{"\n"}}{{end}}' | \
  grep -v "\[bot\]" | \
  sort | \
  tr '\n' ', ' | \
  sed -e 's/,$/\n/' | \
  sed -e 's/,/,\n/g'
)

echo "The following people have contributed to this project by submitting pull\nrequests :tada:\n\n${contributors}"
