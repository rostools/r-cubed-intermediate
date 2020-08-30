
bookdown::clean_book(TRUE)
# Create the course book
bookdown::render_book('index.Rmd', 'bookdown::gitbook', quiet = TRUE)

# Create necessary folders in public
fs::dir_create(here::here("public", c("resources", "slides", "includes")))

slide_css <- fs::dir_ls("includes", glob = "*.css")
fs::file_copy(slide_css, fs::path("public/", slide_css), overwrite = TRUE)
