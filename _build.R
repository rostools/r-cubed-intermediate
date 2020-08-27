
# Create the course book
bookdown::render_book('index.Rmd', 'bookdown::gitbook', quiet = TRUE)

# Move mmash page html file into public
fs::dir_create(here::here("public/resources/"))
fs::file_copy(here::here("resources/mmash-page.html"),
              here::here("public/resources/mmash-page.html"))
