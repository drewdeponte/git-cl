import XCTest

import git_changelogTests

var tests = [XCTestCaseEntry]()
tests += GitCLTests.allTests()
XCTMain(tests)
