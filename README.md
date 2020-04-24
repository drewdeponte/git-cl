# git-changelog

A Git command line tool that generates a Markdown Changelog from a defined schema that can be used in your commits.

## Stop fighting CHANGELOG.md conflicts!!!

### Just use the defined schema below in your commits

#### Schema

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

### Example Commits Below

The following are example commits from a test repository. When `git-changelog` is run against these commits it produced the following example [Markdown Changelog Output](https://github.com/uptech/git-changelog/blob/master/example/CHANGELOG.md).

```
commit 3d3982bd9331b77c1caa050339655bb30f8ed0a1
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Fri Apr 24 00:29:48 2020 -0700

    aeuaoeuaeouaeo blob
    
    [changelog]
    release: 1.0.0-build.2

commit 59d3f084ec3de9c5eba94c1979ce1e566951fcab
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Thu Apr 23 23:55:33 2020 -0700

    Added some thing
    
    [changelog]
    added: somethang bad

commit f2caac6d04fddf2440c0be234077b3ff0fc3f8bf
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Thu Apr 23 23:54:05 2020 -0700

    Something
    
    [changelog]
    deprecated: good stuff

commit 9a6261ef26a663b1af7d08c2e974a07c91cffc84
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Thu Apr 23 23:43:01 2020 -0700

    aoeuaoeuaoeu
    
    [changelog]
    release: v2.0.0

commit 2a3506db2f672def37740be8249b6a8ec455a3bc
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Thu Apr 23 23:41:21 2020 -0700

    aeouaoeuaeuaeuaoeau
    
    [changelog]
    deprecated: your name
    removed: your house
    fixed: your car
    security: zoom

commit 18fbf4d02c3120daf213a0725e1afb8e605ad611
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Thu Apr 23 23:23:04 2020 -0700

    Bump version to v1.0.0
    
    [changelog]
    changed: clothes after my shower
    release: v1.0.0

commit 745c8b2030766bafa2b757d29ed2fcb4f9f4ea05
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Thu Apr 23 23:22:07 2020 -0700

    Changed some crap

commit 3e59624957e65232fb8349d8d92256201e9fa7c1
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Thu Apr 23 23:18:23 2020 -0700

    Initial commit
    
    [changelog]
    added: README.md so people could document things
```

## Build & Install

```
make
make install
```
