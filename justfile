@_default:
  just --list --unsorted

@_formats: format-md format-r
@_checks: check-spelling check-urls check-commits
@_builds: build-contributors build-readme build-website
@_updates: update-from-template update-quarto-theme

# Run all recipes
run-all: install-dependencies _formats _checks _builds

# List all TODOs in the repository.
list-todos:
  grep -R TODO . \
    --exclude-dir=.vscode \
    --exclude-dir=_book \
    --exclude-dir=.quarto \
    --exclude=justfile

# Install or update the pre-commit hooks
install-precommit:
  # Install pre-commit hooks
  uvx pre-commit install
  # Update versions of pre-commit hooks
  uvx pre-commit autoupdate
  # Run pre-commit hooks on all files
  uvx pre-commit run --all-files

# Install package dependencies
install-dependencies:
  #!/usr/bin/Rscript
  pak::pak(ask = FALSE)

# Update the Quarto rostools-theme extension
update-quarto-theme:
  # Will also add if it isn't already installed.
  quarto update rostools/rostools-theme --no-prompt

# Check spelling with typos
check-spelling:
  uvx typos

# Install lychee from https://lychee.cli.rs/guides/getting-started/
# Check that URLs work with lychee
check-urls:
  lychee . \
    --verbose \
    --extensions md,qmd \
    --exclude-path "_badges.qmd"

# Format R code
format-r:
  uvx --from air-formatter air format .

# Format Markdown files
format-md:
  panache format .
  uvx rumdl fmt --silent

# Build Quarto website
build-website:
  quarto render

# Re-build the README file from the Quarto version
build-readme:
  uvx --from quarto quarto render README.qmd --to gfm

# Generate a Quarto include file with the contributors
build-contributors:
  sh ./tools/get-contributors.sh rostools/r-cubed-intermediate > includes/_contributors.qmd

# Check for and apply updates from the template
update-from-template:
  uvx copier update --trust --defaults

# Reset repo changes to match the template
reset-from-template:
  uvx copier recopy --trust --defaults

# Clean up some auto-generated files
cleanup:
  find . -type f -name "*.vdoc.*.r" -delete
