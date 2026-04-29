# Contributing

Check out the [Contributing
Guide](https://guides.rostools.org/contributing) for more details on how
to contribute. For guidelines on how to be a helper or teacher, check
out the [For teachers](https://guides.rostools.org/instructors) page. As
always, make sure to adhere to the [Code of
Conduct](CODE_OF_CONDUCT.md).

## :bug: Issues and bugs

The easiest way to contribute is to report issues or bugs that you might
find while using or reading the workshop material. You can do this by
creating a new issue on our GitHub repository.

## :pencil2: Adding or modifying content

To contribute to the workshop, you first need to install
[uv](https://docs.astral.sh/uv/) and
[justfile](https://just.systems/man/en/packages.html). We use uv and
justfile to manage our project, such as to run checks and build the
workshop website. Both the uv and justfile websites have a more detailed
guide on using uv, but below are some simple instructions to get you
started.

It's easiest to [install uv](https://docs.astral.sh/uv/) first and then
install justfile using uv. Then, to install justfile, run:

```bash
uv tool install rust-just
```

We keep all our development workflows in the `justfile`, so you can
explore it to see what commands are available. To see a list of commands
available, run:

```bash
just
```

As you contribute, make sure your changes will pass our checks by
opening a terminal so that the working directory is the root of this
workshop's parent/root folder and running:

```bash
just run-all
```

When committing changes, please try to follow [Conventional
Commits](https://decisions.seedcase-project.org/why-conventional-commits/)
as Git messages. Using this convention allows us to be able to
automatically create a release based on the commit message by using
[Commitizen](https://decisions.seedcase-project.org/why-semantic-release-with-commitizen/).
If you don't use Conventional Commits when making a commit, we will
revise the pull request title to follow that format, as we use squash
merges when merging pull requests. This way, the commits in the pull
request will be squashed into one commit.

## :file_folder: Support and infrastructure files

- `.copier-answers.yml`: Contains the answers you gave when copying the
  project from the template. **You should not modify this file
  directly.**
  - `.cz.toml`:
    [Commitizen](https://commitizen-tools.github.io/commitizen/)
    configuration file for managing versions and changelogs.
- `CHANGELOG.md`: Changelog file for tracking changes in the project.
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
- `CONTRIBUTING.md`: Guidelines for contributing to the project.
- `.github/`: Contains GitHub-specific files, such as issue and pull
  request templates, workflows,
  [dependabot](https://docs.github.com/en/code-security/tutorials/secure-your-dependencies/dependabot-quickstart-guide)
  configuration, pull request templates, and a
  [CODEOWNERS](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)
  file.
- `.rumdl.toml`: [rumdl](https://rumdl.dev/) configuration file for
  formatting Markdown files.
- `.panache.toml`: [panache](https://panache.bz/) configuration file for
  formatting Quarto files and the code within the chunks of these files.
