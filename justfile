@_default:
  just --list --unsorted


# Run all recipes
run-all: install-deps format-all check-all build-all update-all

# Run all formatting
format-all: format-md format-r

# Run all checks
check-all: check-spelling check-urls

# Run all builds
build-all: build-contributors build-readme build-website

# Run all updates
update-all: update-from-template update-quarto-theme

# List all TODOs in the repository.
list-todos:
  grep -R TODO . \
    --exclude-dir=.vscode \
    --exclude-dir=_book \
    --exclude-dir=.quarto \
    --exclude=justfile

# Install or update the pre-commit hooks
install-precommit:
  uvx pre-commit install
  uvx pre-commit autoupdate
  uvx pre-commit run --all-files

# Install workshop's package dependencies
install-deps:
  #!/usr/bin/Rscript
  pak::pak(ask = FALSE)

# Update the Quarto rostools-theme extension
update-quarto-theme:
  # Will also add if it isn't already installed.
  quarto update rostools/rostools-theme --no-prompt
  # Soft link so Revealjs slides can use the extension.
  ln -s _extensions/ slides/

# Check spelling with typos
check-spelling:
  uvx typos

# Install lychee from https://lychee.cli.rs/guides/getting-started/
# Check that URLs work with lychee
check-urls:
  # Ignore GitHub links since they can be rate limited and cause false positives.
  lychee . \
    --verbose \
    --extensions md,qmd \
    --exclude-path "_badges.qmd" \
    --exclude "github\.com"

# Format all R code
format-r:
  uvx --from air-formatter air format .

# Format Markdown files
format-md:
  uvx rumdl fmt --silent
  uvx --from panache-cli panache format . --quiet

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
