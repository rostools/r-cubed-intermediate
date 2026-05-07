# Changelog

Since we follow [Conventional
Commits](https://decisions.seedcase-project.org/why-conventional-commits/)
when writing commit messages, we're able to automatically create formal
"releases" of the workshop based on the commit messages. Releases in the
context of workshops are simply snapshots in time of the workshop
content. The releases are published to Zenodo for easier discovery,
archival, and citation purposes. We use
[Commitizen](https://decisions.seedcase-project.org/why-semantic-release-with-commitizen/)
to be able to automatically create these releases, which uses
[SemVar](https://semverdoc.org) as the version numbering scheme.

Because releases are created based on commit messages, we release quite
often, sometimes several times in a day. This also means that any
individual release will not have many changes within it. Below is a list
of the releases we've made so far, along with what was changed within
each release.

If you attended a workshop or used the workshop material as some point
in time, you can always refer to this changelog page to find out what
has been changed since you last used it.

## 8.6.2 (2026-05-07)

### Fix

- ✏️ add feedback survey link to end of project work

## 8.6.1 (2026-05-07)

### Fix

- ✏️ clarify about `left_join()` vs `full_join()`
- ✏️ should manually download the project data
- ✏️ time should be longer in last pivot exercise
- ✏️ should say "two" packages not "three"

## 8.6.0 (2026-05-07)

### Feat

- ✨ add introducing paragraph to joins session

### Fix

- 🐛 ensure citations are included in the slides

### Refactor

- ♻️ remove and simplify some of the what next slides

## 8.5.5 (2026-05-07)

### Fix

- ✏️ time for exercise should be longer
- ✏️ remove leftover old text from pivots

## 8.5.4 (2026-05-06)

### Fix

- ✏️ forgot to add `use_package()` for stringr and dplyr

## 8.5.3 (2026-05-06)

### Fix

- ✏️ should be called `collection_datetime`
- 🐛 fix table formatting
- ✏️ clarify different values as input but same type

## 8.5.2 (2026-05-05)

### Fix

- ✏️ should be longer (8 min) reading task

## 8.5.1 (2026-05-04)

### Fix

- ✏️ forgot to remove the lookaround regex
- 💄 wider first column in regex table
- 🐛 don't show extra solutions in code appendix
- 🐛 small fixes to svg images, they're comma's were offset

## 8.5.0 (2026-05-03)

### Feat

- 📝 add roxygen docs to `dime.R` script

### Fix

- ✏️ small edits during review
- 🐛 Panache was incorrectly formatting `!expr` by removing it

## 8.4.1 (2026-05-03)

### Fix

- 🐛 correct build issues

## 8.4.0 (2026-05-03)

### Feat

- ✨ include potential code for processing DIME
- ✨ expand on some specific tasks and tips in project work

### Refactor

- ♻️ switch to using nurses stress in joins session

## 8.3.0 (2026-05-01)

### Feat

- ✨ use callout blocks as solution chunks
- ✨ add button link to feedback survey
- ✨ add slides about AI and some walking activities
- 📝 add 404 page

### Fix

- 🐛 need to group by `id` and `datetime` when summarising

### Refactor

- 🎨 reformat slides
- ♻️ update intro session to add discussion about design
- 🚚 move case when content into extras appendix

## 8.2.0 (2026-05-01)

## 8.1.3 (2026-04-26)

### Fix

- :pencil2: small fixes from build

### Refactor

- **sessions**: :pencil2: simplify pivot session name
- **overview**: :recycle: update schedule to match venue
- **sessions**: :recycle: switch to using nurses stress in pivots

## 8.1.2 (2026-04-17)

### Fix

- **sessions**: :pencil2: correct broken links
- **pre-workshop**: :pencil2: edit minor typos in pre-workshop tasks
- **sessions**: :fire: no longer cover NSE

### Refactor

- **sessions**: :recycle: switch to using nurses stress data in SAC
  session
- **sessions**: :recycle: execute code in `regex.qmd`
- **sessions**: :truck: rename to `regex` to focus on regular
  expressions
- **sessions**: :recycle: switch to nurses stress data in characters
  session
- **sessions**: :truck: split session to be on regex, move dates into
  later session
- **sessions**: :fire: remove NSE content, not needed and is too
  complicated

## 8.1.1 (2026-04-07)

### Fix

- :heavy_plus_sign: add remotes to `DESCRIPTION` to trigger linking

### Refactor

- **overview**: :recycle: improvements to learning design from template

## 8.1.0 (2026-04-07)

### Feat

- **sessions**: :sparkles: add intro motivating paragraphs for first
  four sessions
- **sessions**: :sparkles: add analogy of paper and functionals
- **sessions**: :sparkles: describe design pattern of "do it once, do it
  for all"
- **sessions**: :sparkles: add extra, optional exercises in functionals
- **pre-workshop**: :recycle: switch to using nurses' stress in
  pre-workshop
- **pre-workshop**: :sparkles: create both a learning and cleaning
  Quarto docs
- **pre-workshop**: :sparkles: install r3 from r-universe, not pak
- **appendix**: :sparkles: add "For Teachers" appendix
- **pre-workshop**: :sparkles: add learner code of conduct
- **overview**: :sparkles: add learning design page
- :sparkles: logos for SDCA, DDEA, and AU
- :sparkles: add "includes" files from template

### Fix

- **pre-workshop**: :bug: can't download with R from Proton Drive
- :lipstick: load packages for correct downlit linking
- :pencil2: revisions during editorial review
- :bug: resolve build issues from changes
- **sessions**: :pencil2: switch learning objectives between functions
  and robustness
- **sessions**: :pencil2: correct sentence of key takeaway, it was
  incomplete
- :pencil2: align on `@returns` with an `s`
- **appendix**: :fire: remove `importing` solution from appendix
- **sessions**: :pencil2: replace `read`, not `import`
- **sessions**: :pencil2: 'instructor' to 'teacher'
- **pre-workshop**: :pencil2: state to install Rtools before trying pak
- **pre-workshop**: :pencil2: include URL to CRAN in install
  instructions
- **sessions**: :bug: close div that was incorrectly formatted
- **pre-workshop**: :bug: include code to execute 'download data'
  session
- :bug: correct cross-refs to sections
- **sessions**: :bug: update to use `rostools-theme` for slides
- **sessions**: :fire: remove Discord text and link
- :bug: correct or remove broken links
- **sessions**: :pencil2: correct links to code appendix includes

### Refactor

- **pre-workshop**: :pencil2: clarify to commit after downloading the
  data
- **overview**: :lipstick: aesthetically nicer layout of logos
- **sessions**: :construction: set sections as WIP and hidden until
  finalised
- :recycle: use "stable" badge to indicate the material is stable
- **sessions**: :recycle: switch to using DIME for project work
- **sessions**: :pencil2: rename to be "robust and reusable" for session
- **appendix**: :fire: remove `solutions` appendix
- **sessions**: :recycle: use nurses stress data in functionals
- **pre-workshop**: :fire: `untar()` will still run if exdir exists,
  don't need `fs` anymore
- **sessions**: :recycle: use nurses stress in robustness
- **sessions**: :recycle: use nurses stress data in functions
- **sessions**: :recycle: switch to using nurses stress in importing
  session
- **sessions**: :recycle: use `.by` instead of `group_by()`
- **sessions**: :pencil2: clarify declarative vs imperative
- **pre-workshop**: :recycle: moved GitHub setup into pre-workshop tasks
- **pre-workshop**: :recycle: minor revisions to Git pre-workshop tasks
- **pre-workshop**: :fire: doc doesn't need YAML header execute options
- **sessions**: :fire: learning design is now in pre-workshop tasks, not
  intro
- **overview**: :recycle: use `meta` tag for feedback survey links in
  schedule
- **sessions**: :fire: keep "star us" on landing page only
- :recycle: formatting updates from template
- :wrench: update `_quarto.yml` with changes to file names
- **pre-workshop**: :truck: split pre-workshop tasks into several files
- **overview**: :recycle: updates to landing page from template
- **overview**: :recycle: move syllabus in `overview/` and split into
  two files
- **overview**: :truck: moved schedule into `overview/`
- **sessions**: :recycle: forgot to `ungroup()` after `complete()`
  (#194)

## v2025.05.06 (2025-05-25)

### Feat

- :sparkles: add teacher comment about project work
- :sparkles: code to tidy up the project work data a bit
- **sessions**: :sparkles: move solutions into own document, plus as
  includes
- :sparkles: add pre-commit badge to landing page and readme
- :sparkles: add learning design section
- **sessions**: :sparkles: star us callout block in landing page too
- **sessions**: :sparkles: update the intro session
- **sessions**: :sparkles: callout block about starring the repo
- **sessions**: :sparkles: callout block about using Quarto to write
  notes
- **sessions**: :sparkles: include a discussion activity to review
  previous day
- **sessions**: :sparkles: add teacher note to remind about small data
  size
- **sessions**: :sparkles: add paragraph to git ignore Quarto output
- :sparkles: split out regex and add using lubridate (#167)
- :sparkles: use DIME data in pre-workshop tasks (#145)
- **preamble**: :sparkles: create the schedule with the new sessions
  (#139)
- :card_file_box: add new data to use for workshop (#112)

### Fix

- **sessions**: :pencil2: should be "wider" not "longer"
- :fire: forgot to remove these `reduce()` references
- **sessions**: :pencil2: should have return at end
- **sessions**: :pencil2: link to cheat sheet should be in section above
- **sessions**: :pencil2: prevent these from showing in the code
  appendix
- **sessions**: :bug: use {{{ in objectives too
- :bug: need to use {{{ for showing curly curly
- **preamble**: :pencil2: don't actually need to delete dir when
  unzipping
- **sessions**: :pencil2: this was leftover from previous material
- :bug: should not show solutions
- :pencil2: wrong name for saved image
- **sessions**: :pencil2: this should be a reading section
- :pencil2: clarify paragraph in robustness (#189)
- :pencil2: small fixes to functions text (#186)
- :pencil2: small typos in importing (#185)
- :pencil2: small edits (#180)
- :pencil2: changes from an editorial review (#179)
- :pencil2: small build and aesthetic fixes
- **sessions**: :bug: wrong output name used
- :bug: forgot to remove these chunks
- :pencil2: missed this, always use pipe
- **sessions**: :pencil2: forgot to write to use `{{ }}`
- **sessions**: :bug: use normal code chunks so it gets added to code
  appendix
- **sessions**: :pencil2: forgot to use `return()`
- **preamble**: :pencil2: update and fix schedule, it was slightly off
- :pencil2: should save image the same name as the file
- :pencil2: spell check changes
- **sessions**: :pencil2: small edits to intro session
- :pencil2: replace 'doc' with 'docs'
- :pencil2: replace instruct with teach
- **preamble**: :memo: update schedule to match the place's times
- **preamble**: :pencil2: wrong time for survey
- :bug: forgot to remove this `eval: true`
- :pencil2: did an editing pass
- :bug: remove `eval: true` from chunks
- :bug: fix build error issues
- add working link to murder mystery

### Refactor

- **sessions**: :fire: remove `reduce()` section (#193)
- **sessions**: :recycle: convert exercise into code-along
- **sessions**: :recycle: simplify what next slides
- **sessions**: :recycle: move discussion activity to previous session
- **sessions**: :recycle: convert exercise to code-along
- **sessions**: :recycle: remove case-when session and create final
  dataset in joins
- :recycle: update case-when session
- **sessions**: :recycle: clarify discussion activity tasks
- **sessions**: :recycle: make break a bit longer, and mention to go
  outside
- :recycle: add GitHub use throughout (#182)
- :recycle: tell to put snakecase in setup a bit further down
- :recycle: update the project work with another dataset (#178)
- :fire: remove text from project work session
- **sessions**: :recycle: simplify and shorten intro slides
- **sessions**: :recycle: move workflow descriptions closer to where
  they are used
- :fire: don't need these in setup chunk anymore
- **sessions**: :recycle: remove '...' from reduce
- **sessions**: :recycle: update joins session to use DIME data (#174)
- **sessions**: :recycle: update pivots session to use DIME (#173)
- :page_facing_up: update license year
- **sessions**: :recycle: pipe into functions, missed in split session
- **sessions**: :recycle: don't actually need to store the files anymore
- **sessions**: :recycle: always pipe into functions, even for paths
- **sessions**: :recycle: standardise the ends of sessions
- **sessions**: :recycle: clarify what a string is and use it regularly
- **sessions**: :recycle: updated split-apply-combine to use DIME (#171)
- :recycle: replace Instructor with Teacher
- **sessions**: :recycle: revise functionals session to use DIME (#162)
- **sessions**: :fire: don't need these in setup chunk anymore
- **appendix**: :recycle: rearrange sections in extras doc
- **sessions**: :recycle: new robustness session from split functions
  (#159)
- **sessions**: :recycle: revise functions session to use DIME data
  (#158)
- **sessions**: :fire: remove all content related to `data-raw` script
- **sessions**: :recycle: split functionals into two sessions (#157)
- **sessions**: :fire: don't delete everything in Quarto
- **sessions**: :fire: remove use of `kable()`
- :recycle: split but nothing else, functions into two sessions (#155)
- :recycle: simplify code appendix section into a `##` header
- **sessions**: :recycle: shorten importing session (#154)
- **sessions**: :fire: remove overview diagrams, they are very outdated
  (#149)
- **sessions**: :recycle: revise intro session to use DIME and mermaid
  diagrams (#148)
- :recycle: simplify learner description of landing page
- :construction: more edits and drafting of pre-workshop content
- **sessions**: :fire: remove mention and use of `spec()` (#140)
- :recycle: revise syllabus, mainly around objectives (#137)
- :recycle: review and revise landing page (#122)
- :recycle: review and revise README (#119)

## v2024.05.06 (2025-03-07)

### Fix

- remove `.delim`
- add "using"
- a component -> components
- remove "..." since they are shown as "···" and not as regular periods
- this code should be commented out. Closes #42
- typo in function, should be intermediate. Closes #28
- sleep the code for a bit since it can cause problems sometimes
- need to use cat with the r3admin functions
- the name was changed, so fixed it

## v2023.06.19 (2023-06-29)

## v2023.06.06 (2023-06-14)

## v2022.06 (2022-07-05)

## v2021.10 (2022-05-03)

## v1.0 (2020-10-01)
