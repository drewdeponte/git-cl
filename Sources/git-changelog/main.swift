
let gitChangelog = try! GitChangelog()

do {
    try gitChangelog.run()
} catch GitChangelog.Error.invalidArgumentCount {
    print("Default commands are: \n\n git-changelog, --version).")
} catch {
    print("Whoops! An error occurred: \(error)")
}

