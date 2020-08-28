
# Create the course book
bookdown::render_book('index.Rmd', 'bookdown::gitbook', quiet = TRUE)

# Create necessary folders in public
fs::dir_create(here::here("public", c("resources", "slides")))

# Move mmash page html file into public
fs::file_copy(here::here("resources/mmash-page.html"),
              here::here("public/resources/mmash-page.html"))

slide_files <- fs::dir_ls("slides", glob = "*.html")
fs::file_copy(slide_files, fs::path("public/", slide_files))

slide_css <- fs::dir_ls("resources", glob = "*.css")
fs::file_copy(slide_css, fs::path("public/", slide_css))

logo_files <- fs::dir_ls("images", regexp = ".*logo.*")
fs::file_copy(logo_files, fs::path("public/", logo_files))
