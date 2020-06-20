# Contributing

Rhasspy's code can be found [on GitHub](https://github.com/rhasspy). Each subproject has its own repository.

## Opening issues

You don't have to be a developer to contribute to Rhasspy. You can help by opening an issue in one of the project repositories if:

* you encounter a bug;
* you see something that can be improved;
* you want to propose a new feature.

If the issue applies to Rhasspy in general, open your [issue in the rhasspy repository](https://github.com/rhasspy/rhasspy/issues). If it applies to a specific component of Rhasspy, open it in that component's repository. If you're not sure or if it applies to multiple components, just open your issue in the rhasspy repository.

Make sure to check first if someone else hasn't opened a relevant issue yet. Maybe you can find the solution to your problem there, or maybe you can add your insight to it to help.

## Setting up a development environment

Rhasspy is actively seeking contributions. If you want to start developing, [fork](https://help.github.com/en/github/getting-started-with-github/fork-a-repo) the repository, clone your fork and install the project's (development) dependencies in a Python virtual environment:

```shell
git clone https://github.com/<your_username>/<repository>.git
cd <repository>
make venv
source .venv/bin/activate
```

TODO: Change this for the new ./configure, make setup

## Run all checks

A good start to check whether your development environment is set up correctly and whether the current code is in working condition is to run the repository's tests:

```shell
make test
```

They shouldn't fail. It's good practice to run the unit tests before and after you work on something.

You should also run some basic checks for code style issues:

```shell
make check
```

Some of the repositories have documentation. You can generate it with:

```shell
make docs
```

## Development practices

* Before starting significant work, please propose it and discuss it first on the issue tracker of the project's GitHub repository.
  Other people may have suggestions, will want to collaborate and will wish to review your code.
* Please work on one piece of conceptual work at a time. Keep each narrative of work in a different [branch](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/about-branches).
* As much as possible, have each commit solve one problem.
* A commit must not leave the project in a non-functional state.
* Check your code (`make check`), run the unit tests (`make test`) and generate the documentation (`make docs`)
  before you create a commit. These three commands should all succeed. If there are errors, try to solve them. If `make check`
  complains about bad formatting, a `make reformat` will reformat the code automatically. If you don't know how to solve an error,
  ask for some help in the project's issue tracker.
* Treat code, tests and documentation as one. If you add functionality, document it in a [docstring](https://www.python.org/dev/peps/pep-0257/) and add a test.
* Create a `pull request`_ from your fork.

## Development workflow

If you want to start working on a specific feature or bug fix, this is an example workflow:

* [Synchronize your fork](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/syncing-a-fork) with the upstream repository and update your fork on GitHub.
* Create a new branch: `git checkout -b <nameofbranch>`.
* Create your changes, including tests and documentation.
* Run all checks: `make check && make test && make docs`.
* Solve any issues the checks find and rerun all checks until there are no errors left.
* Add the changed files with `git add <files>`.
* Commit your changes with `git commit`.
* Push your changes to your fork on GitHub.
* Create a [pull request from your fork](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request-from-a-fork).

## Things to work on

Have a look at the issues in the project's issue tracker, especially the following categories:

* **help wanted**: Issues that could use some extra help.
* **good first issue**: Issues that are good for newcomers to the project.

## License of contributions

By submitting patches to this project, you agree to allow them to be redistributed under the project’s [license](license.md) according to the normal forms and usages of the open source community.

It is your responsibility to make sure you have all the necessary rights to contribute to the project.
