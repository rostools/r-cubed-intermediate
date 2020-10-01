library(desc)
library(tidyverse)
library(zen4R)
library(git2r)

authors_df <- desc_get_field("Authors@R") %>%
    str_remove_all('("|\\(|\\)|,)') %>%
    str_split("person") %>%
    map(str_extract_all, pattern = "(given|family|affiliation|ORCID) = .*") %>%
    flatten() %>%
    map(as_tibble) %>%
    map_dfr(separate, col = "value", into = c("name", "value"), sep = " = ", .id = "id") %>%
    pivot_wider() %>%
    transmute(name = glue::glue("{family}, {given}"),
              affiliation = affiliation,
              orcid = ORCID)

lesson_title <- desc_get_field("Title") %>%
    str_remove_all("\"") %>%
    str_remove_all("\\n") %>%
    str_replace_all(" +", " ") %>%
    str_replace(":", " -")

description_content <- desc_get_field("Description") %>%
    str_remove_all("\\n") %>%
    str_replace_all(" +", " ")

repo <- repository()
repo_version <- str_c("v", as.character(desc::desc_get_version()))
version_tag <- tag(repo, name = repo_version, message = "Teaching material used for the Sept 8-9, 2020 course.")
tag_files <- ls_tree(tree(lookup_commit(version_tag)))
zip("r-cubed-intermediate.zip", str_c(tag_files$path, tag_files$name))

new_record <- ZenodoRecord$new()
pwalk(authors_df, new_record$addCreator)
new_record$setUploadType("other")
new_record$setTitle(str_c("r-cubed: ", lesson_title))
new_record$setDescription(description_content)
new_record$setLicense("cc-by")
new_record$addRelatedIdentifier("isCompiledBy", "https://gitlab.com/rostools/r-cubed-intermediate")
new_record$addRelatedIdentifier("isIdenticalTo", "https://gitlab.com/rostools/r-cubed-intermediate/-/tags/v1.0")

zenodo <- ZenodoManager$new(
    url = "https://zenodo.org/api",
    logger = "INFO"
)

deposited_record <- zenodo$depositRecord(new_record)
zenodo$uploadFile("r-cubed-intermediate.zip", deposited_record$id)
