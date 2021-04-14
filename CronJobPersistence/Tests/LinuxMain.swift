import XCTest

import CronJobPersistenceTests

var tests = [XCTestCaseEntry]()
tests += CronJobPersistenceTests.allTests()
XCTMain(tests)
