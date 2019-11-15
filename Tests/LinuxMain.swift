import XCTest

import redis_client_swiftTests

var tests = [XCTestCaseEntry]()
tests += redis_client_swiftTests.allTests()
XCTMain(tests)
