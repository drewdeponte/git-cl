# git-cl

A Git command line tool for managing your CHANGELOG from defined schema entries in your commits.

## Why

We created `git-cl` primarily because of the following:

- conflicts caused by people changing a `CHANGELOG.md` file are **annoying**
- the audience of a CHANGELOG is different than the audience of your commit messages
- having the concept of a `release` in a commit message unlocks extremly useful abilities

## How

You use it on two ends. First you have to record your CHANGELOG entries.

### Record CHANGELOG Entries

Similar to what you are probably used to with CHANGELOG file formats, with `git-cl` you include single line entries categorized within the following: `release`, `added`, `changed`, `deprecated`, `removed`, `fixed`, `security`. The difference is that you place these entries at the end of your Git commit message body under a section identified via `[changelog]`. 

The following is an example of the schema. You effectively have a section header of `[changelog]` and then below that you have any of the categorized entries that follow.

*Note:* If you include both a `release` entry as well as other entries. If the other entries are below the `release` entry they will be included as part of that release. If they are above the `release` entry they will be included as part of the Unreleased category.

```text
[changelog]
release: v2.4.8
added: some addition you made that you want in your changelog
changed: some change you made that you want in your changelog
deprecated: some deprecation notice you want in your changelog
removed: some removal you want in your changelog
fixed: some fix you want in your changelog
security: some security fix you want in your changelog
```

Still want to get more comfortable? Check out this [example Git log](https://github.com/uptech/git-changelog/blob/master/example/GIT_LOG.md)

### Get CHANGELOG Info

After youh ave been recording your CHANGELOG entries you can use `git-cl` to do a number of useful things.

- `git cl unreleased` - get the unreleased changelog entries when prepping a release
- `git cl unreleased --commits` - get the unreleased commits when prepping a release
- `git cl latest` - get the changelog entries of the latest release
- `git cl latest --commits` - get the commits that are part of the latest release
- `git cl full` - get a full Markdown CHANGELOG based on [keepachangelog](https://keepachangelog.com/), useful for automating publishing or doing a historical review of a project
- `git cl released <release-id>` - get changelog entries for the specified release
- `git cl released <released-id> --commits` - get commits included in the specified release


## Installation

If you are on a platform other than macOS you will have to build your own
version from source.

### macOS

To install on macOS we provide a [Homebrew](http://brew.sh) tap which provides
the `git-cl` formula. You can use it by doing the following:

#### Add the Tap

```
brew tap "uptech/homebrew-oss"
```

#### brew install

```
brew install uptech/oss/git-cli
```

### Build from Source

If you are on another platform you will have to build from source. Given
that `git-cl` is managed via [GNU make][]. It can be built as follows:

```
$ make build
```

Once you have built it successfully you can install it in `/usr/local/bin` using the following:

```
$ make install
```

## Development

We use [GNU make][] to manage the developer build process with the following commands.

- `make build` - build release version of the `git-cl`
- `make install` - install the release build into `/usr/local/bin`
- `make uninstall` - uninstall the release build from `/usr/local/bin`
- `make clean` - clean the build directory

## FAQ

#### Why not use the commit summaries?

We believe that there are **two** distinct audiences involved. Your commit message and the context and details around them is targeted at the developers of the project. The other audience is the consumer of the product (library/app) and they don't care about all the intricate details. They just care about important things they should know about. In order to protect the value of the commit message and still support the CHANGELOG audience we decided to support the above defined schema within commit messages.

#### Why not use a CHANGELOG.md file in your repository?

Well we used to use CHANGELOG.md files in our repositories for years and years. However, we constantly ran into conflicts with the CHANGELOG.md file as we had a policy of most every Pull Request should update the CHANGELOG.md with an entry in the Unreleased section. This aided us by having the CHANGELOG.md entry tied to the associated code change. It also made life easier for people doing the release as they didn't have to dig through all the commits and try and coble together a CHANGELOG release last minute.

So use the commit messages we were still able to keep the tight coupling to the code change while avoiding all of the CHANGELOG.md conflicts.

#### What Markdown Changelog Format is followd?

We have used [keep a changelog](https://keepachangelog.com) for a long time and haven't really seen much better so we decided to use it as the basis for the output here as well.

## License

`git-cl` is Copyright © 2020 UpTech Works, LLC. It is free software, and
may be redistributed under the terms specified in the LICENSE file.

## About <img src="http://upte.ch/img/logo.png" alt="uptech" height="48">

`git-cl` is maintained and funded by [UpTech Works, LLC][uptech], a software
design & development agency & consultancy.

We love open source software. See [our other projects][community] or
[hire us][hire] to design, develop, and grow your product.

[Git]: https://git-scm.com
[GNU make]: https://www.gnu.org/software/make/
[community]: https://github.com/uptech
[hire]: http://upte.ch
[uptech]: http://upte.ch
