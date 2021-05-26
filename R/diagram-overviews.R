library(DiagrammeRsvg)
library(rsvg)
library(here)
source(here("R/functions.R"))

save_diagram_to_svg <- function(number, output_file) {
    diagram_overview(number) |>
        export_svg() |>
        charToRaw() |>
        rsvg_svg(output_file)
}

save_diagram_to_svg(0, here("images/diagram-overview-0.svg"))
save_diagram_to_svg(1, here("images/diagram-overview-1.svg"))
save_diagram_to_svg(2, here("images/diagram-overview-2.svg"))
save_diagram_to_svg(3, here("images/diagram-overview-3.svg"))
save_diagram_to_svg(4, here("images/diagram-overview-4.svg"))
