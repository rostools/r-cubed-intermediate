# Reproducible Research in R: An intermediate workshop on modern approaches and workflows to processing data

[![License: CC BY
4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4061900.svg)](https://doi.org/10.5281/zenodo.4061900)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://github.com/pre-commit/pre-commit)

## Description

Reproducibility and open scientific practices are increasingly being
requested or required of scientists and researchers, but training on
these practices has not kept pace. This workshop intends to help bridge
that gap and covers the fundamentals and workflow of data analysis in R.

This repository contains the educational material (code-alongs,
exercises, activities, presentations), including the website source
files and other associated workshop administration files.

For more detail on the workshop, check out the
[syllabus](https://r-cubed-intermediate.rostools.org/preamble/syllabus.html).

## Instructional Design

The workshop is designed primary for in-person teaching with a
participatory live-coding approach. This involves an teacher typing
and running code in [RStudio](https://www.rstudio.com/) in front of the
class, while participants follow along using their own computers. A
variety of learning activities, like hands-on exercises, discussion
time, reading tasks, and group project work, are interspersed throughout
the material in order to reinforce learning. All the material is
provided ahead of time on the workshop website for participants to refer
to during and after the workshop. Throughout the workshop, participants
sit in small groups to get to know one another and to do the activities
together.

## Educational content

The material is found mainly in the folders:

-   `preamble/`: Contains the syllabus and the schedule files.
-   `sessions/`: Contains the code-along teaching material, as well as
    associated links to the presentation slides.
-   `slides/`: Contains the slides, created as Revealjs HTML slides by
    using Quarto.

The website is generated from [Quarto](https://quarto.org), so it
follows Quarto's structure and conventions.

## Installing necessary packages

Packages used and depended on for this workshop are included in the
`DESCRIPTION` file. To install the packages, run this function in the
root directory (where the `r-cubed-intermediate.Rproj` file is located):

``` r
# install.packages("pak")
pak::pak()
```

## Contributing

If you are interested in contributing to the workshop material, please
refer to the [contributing guidelines](CONTRIBUTING.md). Please note
that the project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By contributing to this project, you agree
to abide by its terms.

## Acknowledgements

Much of the lesson material was taken and modified from multiple sources
(most of which I've created, been involved in, or contributed to),
including:

-   [UofTCoders Reproducible Quantitative Methods for
    EEB](https://uoftcoders.github.io/rcourse/)
-   [Software and Data Carpentry](https://carpentries.org/) workshop
    material
-   [UofTCoders
    material](https://uoftcoders.github.io/studyGroup/lessons/)
