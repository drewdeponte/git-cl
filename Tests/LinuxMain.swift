import XCTest

import git_changelogTests

var tests = [XCTestCaseEntry]()
tests += git_changelogTests.allTests()
XCTMain(tests)
