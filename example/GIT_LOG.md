commit d6d4c124e74a2e6fcb0d8f09b84818e6261f9077 (tag: v3.0.0)
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Wed Apr 29 14:38:43 2020 -0700

    Bump version to v3.0.0

commit a98a072c602595ed16f55900a03914cd4a2e3700
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Wed Apr 29 14:21:55 2020 -0700

    Change releases to be identified by tags
    
    I did this because we found there were issues with releases being
    identified by information in the commit message body. For example if a
    release: v1.2.3 was included in a commit message body and then that
    commit was cherry picked to another branch. Should that other branch
    have the release v1.2.3. The answer is know and it breaks things. So, we
    thought about it more and decided the correct thing to do was switch to
    tags matching the pattern of ^v?\d+\.\d+\.\d+$ identifying a releases.
    Tags that don't match that pattern are just ignored.
    
    [changelog]
    removed: 'release' commit message body entries as supported entry types
    changed: to identify releases by Git tags matching pattern: ^v?\d+\.\d+\.\d+$
    
    ps-id: F6FED912-DE05-48AB-89A4-AB5E88DFFF01

commit 43776395ab9b7b39f4fe99a9ff2fbdcc66138f10
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Wed Apr 29 13:29:45 2020 -0700

    Add tags to Commit
    
    So that we would be able to use tags to identify releases in the future
    rather than identifying a release a release via a "release" entry in the
    commit. We want to do this because when you cherry pick commits with
    "release" entries in the commits it breaks releases. This made us
    re-asses and determine that tags are the appropriate thing to determine
    releases. Also this has the added benefit of reducing duplicative effort
    when cutting a release. It also simplifies things as it will make it so
    commits contain changelog entries just for the changes made in them.
    
    ps-id: 69620D7A-537C-4948-9BA1-4BBB88590707

commit 8962b5e132e38264c8c36f2c5d99feddb5ee9a33
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Mon Apr 27 12:36:11 2020 -0700

    Fix typo in homebrew install instructions
    
    I did this so hopefully people don't have issues installing.

commit 591d7c146631a4d4645fa5a4fb4d8e3eed3affae (tag: v2.0.0)
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Mon Apr 27 12:20:49 2020 -0700

    Bump version to v2.0.0

commit 112d004a5d611bd24fb9593f1480ed5986ad6ac4
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Mon Apr 27 12:15:12 2020 -0700

    Rewrite `released` sub-command
    
    I did this to make it work properly but also to get rid of the use of
    the ChangelogAction and MarkdownAction objects as it was the last hold
    out still using those classes.
    
    [changelog]
    fixed: released sub-command so it works correctly
    
    ps-id: DD42756E-8C53-4220-8301-EBD9C57B3267

commit d2b461e602e052f9e9cee17517fa0458f9dc1838
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Mon Apr 27 11:40:52 2020 -0700

    Remove some cruft that is no longer used
    
    I did this just to keep our code base clean and try and get rid of stuff
    that isn't used anymore.
    
    ps-id: 00597894-3525-4732-BB45-82F46F684758

commit e8b6990d1055c1ea0fcbac245c83be3c26451da9
Author: Anthony Castelli <hello@anthonyc.dev>
Date:   Mon Apr 27 09:34:37 2020 -0700

    Fix up the diff links
    
    This effectively rewrites the `full` sub-command to make it work with
    the new ChangelogCommits sequence and take into account the link
    referencing in the markdown file so that users can quickly get the diffs
    of the changes they are looking for in github.
    
    [changelog]
    fixed: Diff links now display all releases and the headers of each section correctly links to the diff.
    
    ps-id: 65A9B70B-BE53-42B8-B35C-621E238124C4

commit 1ecb0d48f9da0a7559d631236d7e0cad2af95722
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Mon Apr 27 01:39:20 2020 -0700

    Make `released` sub-command require release-id
    
    We did this because we weren't sure of what the use case was for getting
    all of the released changelog entries or commits. Also we couldn't get
    Apple's CLI parser lib to properly allow the release id argument to be
    optional. It would allow us to set it and report it as optional in the
    help. However, when you would run it without that argument it would
    error out saying it was missing a required argument. So, since we didn't
    think the use case without the release id was valuable we just
    eliminated it.
    
    [changelog]
    removed: variant of released with no release-id argument
    
    ps-id: 91612DCD-CFC9-4916-8ECF-E5B9AC7F19B4

commit b10d9a7f5b7f905a28f21d22fe067d1676c76ad1
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Mon Apr 27 01:08:32 2020 -0700

    Update the README.md
    
    So that users would have a better understanding of what it can do and
    how to use it.
    
    ps-id: CF3382A2-6F09-4DEB-8B82-C5D20BB3B6B9

commit 58d6d264f35c2acb51b9cb2c1b73d13f60f7fcad
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Mon Apr 27 00:01:35 2020 -0700

    Add the `latest` sub-command
    
    I did this so that users would be able to just get the latest release
    information or latest release commits easily.
    
    [changelog]
    added: latest sub-command to allow users to get the latest release info
    
    ps-id: CA49DF04-A3DD-4954-B600-5651B3DC86A1

commit 39aad923df32344caa8b5ad8a7a7ef3276934590
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Sun Apr 26 23:35:15 2020 -0700

    Refactor unreleased to use ChangelogCommits sequence
    
    I did this because it should be more performant as it only processes and
    parses the commits that it needs to.
    
    This does this by introducing a new ChangelogCommits sequence type that
    exposes a ChangelogCommit type that includes a new concept of
    ChangelogEntry.
    
    [changlog]
    changed: improved performance of unreleased sub-command
    
    ps-id: A6C91CCB-3666-4AF7-9652-7DF276A5D3DF

commit ce0c06a5e616e76333d550dcf9399c1383186712
Author: Anthony Castelli <hello@anthonyc.dev>
Date:   Sun Apr 26 12:43:37 2020 -0700

    Implements SwiftArgumentParser for command line options
    
    This implements additional subcommands that allow for quick and easy
    parsing.
    
    This implements a new action system and flow to handle subcommands with
    additional parameters.
    
    [changelog]
    added: Swift Argument Parser to allow for a cleaner appraoch to command line arguments.
    added: Implemented support for full, released <optional_version> and unreleased
    added: Implemented a --commits and to released and unreleased to allow all of the commit info to be returned
    removed: Removed all of the sub commands options that were present
    changed: Refactored some code and cleaned things up
    
    ps-id: 871C7F84-1801-4681-9EED-5396CA29F7D2

commit 430320c56c55c41722a9cf95c818dea2fa43c7b1
Author: Anthony Castelli <hello@anthonyc.dev>
Date:   Sun Apr 26 18:48:34 2020 -0700

    Implement support for diff links at the bottom of the changelog
    
    This implements diff links to the repository from the origin url. This
    bring this up to spec with the keepachangelog.com
    
    [changelog]
    added: Added Diff Links to the bottom of the markdown file
    
    ps-id: 155DA5E3-5D46-4B26-83D4-945C7C06E765

commit e7fe8b277a8b841b28fcd09c5f98c736194177b4
Author: Anthony Castelli <hello@anthonyc.dev>
Date:   Sun Apr 26 10:15:08 2020 -0700

    Rename the Project and source files from git-changelog to git-cl
    
    This just renames everthing from git-changelog to git-cl
    
    [chaneglog]
    changed: Renamed the project from git-changelog to git-cl. This was part of the repo change name.
    changed: Cleaned up everything and removed a bunch of code that wasn't used.
    
    ps-id: 5EA1D48F-C1BA-4465-B679-17DF8FB10D12

commit 9f6a4ddfacb486baccc0fc662d68596a0f687190
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Sat Apr 25 23:14:52 2020 -0700

    Fix bug where first commit was being reprocessed
    
    I did this because it was causing the end-user to see double the
    changelog entries for the first commit in some cases. This is a crappy
    experience and doesn't build trust so I decided to fix it.
    
    This was happening because we were missing a guard statement at the top
    of the next() method in the Iterator that checked if we had already
    exhausted the content.
    
    Beyond that I removed a conditional in one of the logic paths that is no
    longer needed because of the new guard statement.
    
    [changelog]
    fixed: bug where double the first commit entries would show up

commit fa77047a7399f2352f1e6ca079807e7d7ee0903c
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Sat Apr 25 12:52:36 2020 -0700

    Add summary to the Commit type
    
    I did this so that we could use it to implement the planned `--commits`
    switch to show the list of commit sha1s and summary for each of the
    commits in either unreleased, or latest sub-commands.
    
    Note: I am not leaving a changelog entry in this commit because it is an
    intern only change. There is no user facing impact with this change.
    
    ps-id: FB807990-9E31-44D7-BE23-CE81E5028FFD

commit cc8eab1373c96f0c7485cd2c97bdf16d5298eb8f
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Fri Apr 24 23:38:55 2020 -0700

    Switch to iterator get commits & fix blocking run
    
    I did this for performance reasons. First I switch to a Sequence based
    iterator solution so that it only parses commits as needed on demand.
    
    After adding the iterator we were still having a weird hanging issue so
    we dug further in and found out that we had a weird blocking issue with
    larger output. So we switched to a stream processing model for the
    output and it resolved this blocking issue.
    
    I also made the default max infinite instead of 300 as it isn't needed
    anymore thanks to the permission fixes.
    
    ps-id: 815BD163-71F5-4F9D-AC48-3F8B07A79EB2
    
    [changelog]
    fixed: issue blocking git commands with large output
    changed: fetch commits to return Sequence w/ an Iterator, not an Array

commit 12828a57f8a8e71bcf18097227badf80b84d4951 (tag: v1.1.0)
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Fri Apr 24 13:55:22 2020 -0700

    Bump version to v1.1.0

commit 717a41b40c1d151a9b8ca47d08301d48f0f46753
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Fri Apr 24 13:51:29 2020 -0700

    Set the default max to 300 instead of 500
    
    I did this because I was seeing something weird happen when we try and
    hit the 500 hundred max mark. It was just hanging and taking forever. It
    is weird because I ran some local tests with a very big repo and got the
    following results.
    
    I just ran with max, 100, then 200, then 300, then 400 and they resulted
    in 0.04s, 0.05s, 0.07s, 0.08s, and then 500 literally hangs for like
    more than then 10 mins. I haven't even waited long enough to see it end.
    
    Hence as a stopgap for usability I am setting the limit to something
    safer, 300 until we can figure out what is going on exactly.
    
    [changelog]
    changed: default max from 500 commits to 300 commits

commit ba50c9dca5fab9bafac524bc5ca13b4d9daa8416
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Fri Apr 24 12:34:33 2020 -0700

    Update README with Homebrew install
    
    I did this so that people would know how to install the package from our
    Homebrew tap.

commit 0dc87b8e631bea2ee7dd936de86dd225e6d36c8f
Author: Anthony Castelli <hello@anthonyc.dev>
Date:   Fri Apr 24 09:28:57 2020 -0700

    Add a default range of 500 commits
    
    This adds a default max coount when fetching commits to 500. You can
    specifiy a custom amount by passing --max/-m or you can specifiy the
    range to generate from via the --from/-f command. This will allow you to
    generate a changelog from a tag to the HEAD or to a specific via the
    --to/-t subcommand.
    
    [changelog]
    added: Implemented a way to fetch commits from a tag [#3](https://github.com/uptech/git-changelog/issues/3)
    added: Added support for fetching between tag [#6](https://github.com/uptech/git-changelog/issues/3)
    added: Implemented a way to limit the number of commits fetched
    fixed: Large commit repositories would take forever to load, so
    specifying a default limit of 500 was still fast enough.
    
    ps-id: 7C1F044D-CAC0-40D8-9527-79A1273ECC3C

commit a439d66e7dcc234db7ba6b89a5f1f1c624a4c460
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Fri Apr 24 01:34:55 2020 -0700

    Add FAQ about the output format
    
    I did this so that people could find out what format we use as a basis.

commit 59f063bd3a0d160ad51c17978dfa2432a8cb12a1
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Fri Apr 24 01:29:28 2020 -0700

    Add some FAQs to the README.md
    
    I did this so that people could get answers from some of the commonly
    asked questions.

commit c4326a84f8092d1a3d111220b6519e30ad326eda
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Fri Apr 24 01:22:51 2020 -0700

    Fix silly copy pasta typo in README.md

commit b56570175c70136bb88c8db671bf58e9907a6bb1
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Fri Apr 24 01:21:46 2020 -0700

    Add license info & about to README.md
    
    I did this so people would be more aware of the license and so they
    would be more aware of who brought the product to them.

commit 0259d7f2cdacdd462214e9a2e02f8bdcde863202
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Fri Apr 24 01:11:38 2020 -0700

    Add link to the example output
    
    So that users could more easily see what is produced.

commit 699792b1e82fc0762252588346a52ed7abc129dc
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Fri Apr 24 01:09:05 2020 -0700

    Add example produced with commits from example
    
    I did this so that people could see what sort of Markdown changelog
    output it produces.

commit 90b966ba0cef66838f0c1ce1bd33a86963db620a
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Fri Apr 24 00:48:49 2020 -0700

    Fix small typo in README.md

commit 3e27a81d0bb8f7a96f19a804a59f78bed94dee60 (tag: v1.0.0)
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Fri Apr 24 00:47:23 2020 -0700

    Bump to version 1.0.0

commit 976dfa88858c5c2ee0e8a25c4331f9810488fa49
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Fri Apr 24 00:44:45 2020 -0700

    Add README.md
    
    So people have some understanding of what it is, how to use it, and how
    to build and install it.

commit 348104517e5d8637a7def4b94e5070f72709c9ec
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Fri Apr 24 00:33:38 2020 -0700

    Add LICENSE file
    
    I did this so people would know how this project is licensed.
    [changelog]
    added: LICENSE file so people understand how it is legally licensed

commit de40b46581f1d72777be5a209202ca74cd3ac796
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Fri Apr 24 00:30:46 2020 -0700

    Add initial working version of app
    
    This is more of a spike than a fully featured application. However, it
    is fully functional in the scope of it's minimal viableness.
    
    [changelog]
    added: ability to parse defined changelog schema entries out of commits
    added: markdown based changelog generation

commit 79e9191fdce435143eabcafdc2c27e0c9d1dad8b
Author: Andrew De Ponte <cyphactor@gmail.com>
Date:   Thu Apr 23 21:03:20 2020 -0700

    Initial SPM skeleton
