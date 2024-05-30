# git-cl - Git Changelog

A Git command line tool for managing your CHANGELOG from defined schema entries
in your Git commit messages. If you prefer videos checkout the ~15 min video
where we provide a detailed introduction below. Otherwise skip the video and
get the details from the README.md.

[![Intro Video Thumbnail](http://img.youtube.com/vi/g7xqWKmIUKI/0.jpg)](https://youtu.be/g7xqWKmIUKI)

## Why

We created `git-cl` primarily because of the following:

- conflicts caused by people changing a `CHANGELOG.md` file are **annoying**
- the audience of a CHANGELOG is different than the audience of your commit messages
- wanted Git tags to identify releases so people don't have to change their release workflow

## How

There are a few different ways that you use `git-cl`. First you *Record
Changelog Entries*, then you *Tag a Release*, and then you *Generate/Inspect
Changelog*.

### Record Changelog Entries

The first part of `git-cl` is *Recording Changelog Entries*. This is done
simply be adding entries directly to the git commit message in a specific
format. The idea is that when you make a change you include the Changelog
Entries associated with that change in the Git commit message.

Similar to what you are probably used to with CHANGELOG file formats, with
`git-cl` you include single line entries categorized within the following:
`added`, `changed`, `deprecated`, `removed`, `fixed`, `security`. The
difference is that you place these entries at the end of your Git commit
message body under a section identified via `[changelog]`. 

The following is an example of the schema. You effectively have a section
header of `[changelog]` and then below that you have any of the categorized
entries that follow.

```text
[changelog]
added: some addition you made that you want in your changelog
changed: some change you made that you want in your changelog
deprecated: some deprecation notice you want in your changelog
removed: some removal you want in your changelog
fixed: some fix you want in your changelog
security: some security fix you want in your changelog
```

Still want to get more comfortable? Check out a snapshot of the Git log of this
project [example Git log](https://github.com/drewdeponte/git-changelog/blob/master/example/GIT_LOG.txt).

### Tag a Release

Once you have made a series of commits including their respective Changelog
Entries in the Git commit message. You may be ready to tag a release. This is
probably extremely similar if not exactly the same as what you normally do. You
simply use Git to tag the head commit of your release in the following pattern
(`vX.Y.Z` or `X.Y.Z`). Any other tags that don't match those patterns exactly
including pre-release version patterns (e.g. `v1.2.3-build-123`) will not be
recognized as releases unless you use the (`-p`, `--pre`) switches in supported
commands to indicate you want to include pre-release versions as well.

### Generate/Inspect Changelog

Once you have some Git commits with Changelog Entries you can start to get some
useful things with `git-cl`. If you have a tagged release or two in addition
you can do even more useful things. The following is a list of the various
`git-cl` commands you can run and a short description of what they do.

- `git cl unreleased` - get the unreleased changelog entries when prepping a release
- `git cl unreleased --commits` - get the unreleased commits when prepping a release
- `git cl latest` - get the changelog entries of the latest release
- `git cl latest --commits` - get the commits that are part of the latest release
- `git cl full` - get a full Markdown CHANGELOG based on
  [keepachangelog](https://keepachangelog.com/), useful for automating
  publishing or doing a historical review of a project
- `git cl released <release-id>` - get changelog entries for the specified release
- `git cl released <released-id> --commits` - get commits included in the specified release

Curious to see what the produced Changelog looks like. Checkout our
[CHANGELOG.md](https://github.com/drewdeponte/git-changelog/blob/master/CHANGELOG.md).
We regenerate and publish it to the repository after every release.

## Installation

If you are on a platform other than macOS you will have to build your own
version from source.

### macOS

To install on macOS we provide a [Homebrew](http://brew.sh) tap which provides
the `git-cl` formula. You can use it by doing the following:

#### Add the Tap

```text
$ brew tap "drewdeponte/oss"
```

#### brew install

```text
$ brew install drewdeponte/oss/git-cl
```

### Build from Source

If you are on another platform you will have to build from source. Given
that `git-cl` is managed via [GNU make][]. It can be built as follows:

```text
$ make build
```

Once you have built it successfully you can install it in `/usr/local/bin`
using the following:

```text
$ make install
```

## Development

We use [GNU make][] to manage the developer build process with the following
commands.

- `make build` - build release version of the `git-cl`
- `make install` - install the release build into `/usr/local/bin`
- `make uninstall` - uninstall the release build from `/usr/local/bin`
- `make clean` - clean the build directory

## FAQ

#### Why not use the commit summaries?

We believe that there are **two** distinct audiences involved. Your commit
message and the context and details around them is targeted at the developers
of the project. The other audience is the consumer of the product (library/app)
and they don't care about all the intricate details. They just care about
important things they should know about. In order to protect the value of the
commit message and still support the CHANGELOG audience we decided to support
the above defined schema within commit messages.

#### Why not use a CHANGELOG.md file in your repository?

Well we used to use `CHANGELOG.md` files in our repositories for years and
years. However, we constantly ran into conflicts with the `CHANGELOG.md` file
as we had a policy of every Pull Request should update the `CHANGELOG.md` with
an entry in the Unreleased section. This aided us by having the `CHANGELOG.md`
entry tied to the associated code change. It also made life easier for people
doing the release as they didn't have to dig through all the commits and try
and cobble together a CHANGELOG release last minute.

So using the commit messages we were still able to keep the tight coupling to the
code change while avoiding all of the `CHANGELOG.md` conflicts.

#### What Markdown Changelog Format is followed?

We have used [keep a changelog](https://keepachangelog.com) for a long time and
haven't really seen much better so we decided to use it as the basis for the
output here as well.

## License

`git-cl` is free software, and may be redistributed under the terms specified
in the LICENSE file.

## About

`git-cl` is maintained and funded by [Drew De Ponte][drewdeponte].

[drewdeponte]: https://drewdeponte.com
[Git]: https://git-scm.com
[GNU make]: https://www.gnu.org/software/make/
