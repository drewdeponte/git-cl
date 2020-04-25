import XCTest

import ReleaseTests

var tests = [XCTestCaseEntry]()
tests += ChangelogTests.allTests()
XCTMain(tests)
