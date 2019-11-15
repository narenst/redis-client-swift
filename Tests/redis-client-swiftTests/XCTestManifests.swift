import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(redis_client_swiftTests.allTests),
    ]
}
#endif
