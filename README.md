

# An intermediate workshop on modern approaches and workflows to processing data

<!-- TODO: DOI here -->

[![Copier](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/copier-org/copier/master/img/badge/badge-grayscale-inverted-border-teal.json?raw=true.svg)](https://github.com/copier-org/copier)
[![GitHub
License](https://img.shields.io/github/license/rostools/r-cubed-intermediate.svg)](https://github.com/rostools/r-cubed-intermediate/blob/main/LICENSE.md)
[![GitHub
Release](https://img.shields.io/github/v/release/rostools/r-cubed-intermediate.svg)](https://github.com/rostools/r-cubed-intermediate/releases/latest)
[![Build
website](https://github.com/rostools/r-cubed-intermediate/actions/workflows/build-website.yml/badge.svg)](https://github.com/rostools/r-cubed-intermediate/actions/workflows/build-website.yml)
[![pre-commit.ci
status](https://results.pre-commit.ci/badge/github/rostools/r-cubed-intermediate/main.svg)](https://results.pre-commit.ci/latest/github/rostools/r-cubed-intermediate/main)
[![lifecycle](https://lifecycle.r-lib.org/articles/figures/lifecycle-stable.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)

## Description

Reproducibility and open scientific practices are increasingly being
requested or required of scientists and researchers, but training on
these practices has not kept pace. This workshop intends to help bridge
that gap and covers the fundamentals and workflow of data analysis in R,
especially on the data processing side of an analysis.

This repository contains the lesson, lecture, and assignment material
for the workshop, including the website source files and other
associated workshop administration and development files. For more
detail on the workshop, check out the [welcome
page](https://r-cubed-intermediate.rostools.org).

> [!TIP]
>
> This workshop repository was generated from the
> [`template-workshop`](https://github.com/rostools/template-workshop)
> rostools template.

## Instructional Design

The lectures and lessons in this workshop are designed to be presented
primarily with a participatory live-coding approach. This involves an
teacher typing and running code in an editor or similar platform in
front of the class, while the class follows along using their own
computers. Exercises are interspersed in the lesson material, allowing
participants to collaboratively work on smaller coding problems for a
few minutes. All lesson materials are provided ahead of time on the
workshop website for participants to refer to during lectures.

## Lesson content

The teaching material is found mainly in these locations:

- `index.Rmd`: Contains the overview of the workshop.
- `overview/` folder: Contains the files that give an overview to the
  workshop, such as the syllabus and schedule.
- `pre-workshop/`: Contains the files needed before the workshop, like
  the pre-workshop tasks.
- `sessions/`: Contains the files used during the workshop (e.g.
  code-along material).
- `appendix/`: Contains the files used to support the workshop, such as
  code of conduct, changelog, contributing guides, and instructions for
  teachers.
- `slides/`: Contains the lecture slides that are rendered into HTML
  slides from Markdown.

The website is generated with [Quarto](https://quarto.org/), so it
follows the file and folder structure conventions from that package.

## Support and infrastructure files

- `.copier-answers.yml`: Contains the answers you gave when copying the
  project from the template. **You should not modify this file
  directly.**
- `.cz.toml`:
  [Commitizen](https://commitizen-tools.github.io/commitizen/)
  configuration file for managing versions and changelogs.
- `.pre-commit-config.yaml`: [Pre-commit](https://pre-commit.com/)
  configuration file for managing and running checks before each commit.
- `.typos.toml`: [typos](https://github.com/crate-ci/typos) spell
  checker configuration file.
- `.zenodo.json`: Structured citation metadata for your project when
  archived on [Zenodo](https://zenodo.org/). This is used to add the
  metadata to Zenodo when a GitHub release has been uploaded to Zenodo.
- `justfile`: [`just`](https://just.systems/man/en/) configuration file
  for scripting project tasks.
- `.editorconfig`: Editor configuration file for
  [EditorConfig](https://editorconfig.org/) to maintain consistent
  coding styles across different editors and IDEs.
- `CHANGELOG.md`: Changelog file for tracking changes in the project.
- `CONTRIBUTING.md`: Guidelines for contributing to the project.
- `.github/`: Contains GitHub-specific files, such as issue and pull
  request templates, workflows,
  [dependabot](https://docs.github.com/en/code-security/tutorials/secure-your-dependencies/dependabot-quickstart-guide)
  configuration, pull request templates, and a
  [CODEOWNERS](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)
  file.
- `.rumdl.toml`: [rumdl](https://rumdl.dev/) configuration file for
  formatting Markdown files.

## Contributing

If you are interested in contributing to the workshop material, please
refer to the [contributing guidelines](CONTRIBUTING.md). For guidelines
on how to be a helper or teacher, check out the [For
teachers](https://guides.rostools.org/instructors) page.

Please note that the project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By contributing to or being involved in
this project, you agree to abide by its terms.

### Contributors

These are the people who have contributed by submitting changes through
pull requests :tada:

[@lwjohnst86](https://github.com/lwjohnst86),
[@signekb](https://github.com/signekb),
[@AndersAskeland](https://github.com/AndersAskeland),
[@MaleneRevsbech](https://github.com/MaleneRevsbech),
[@hchats](https://github.com/hchats),
[@LouiseEB](https://github.com/LouiseEB),
[@StineScheuer](https://github.com/StineScheuer),
[@krauthn](https://github.com/krauthn)

### Contributors

These are the people who have contributed by submitting changes through
pull requests :tada:

[@lwjohnst86](https://github.com/lwjohnst86),
[@signekb](https://github.com/signekb),
[@AndersAskeland](https://github.com/AndersAskeland),
[@MaleneRevsbech](https://github.com/MaleneRevsbech),
[@hchats](https://github.com/hchats),
[@LouiseEB](https://github.com/LouiseEB),
[@StineScheuer](https://github.com/StineScheuer),
[@krauthn](https://github.com/krauthn)

## Licensing

This project is licensed under the [CC-BY-4.0 License](LICENSE.md).

## Re-use

The workshop is largely designed to be taught in the order given, as
each session builds off of the previous ones. The easiest way to use
this material is to use it as-is, making use of the tips and
instructions found throughout this page. The only thing you might want
to make as your own would be the slides, however, they are also good
enough to use on their own too.

To help with general admin tasks of running the workshop, there is the
[samwise](https://github.com/rostools/samwise) R package.

## Changelog

For a list of changes, see our [changelog](CHANGELOG.md) page.
