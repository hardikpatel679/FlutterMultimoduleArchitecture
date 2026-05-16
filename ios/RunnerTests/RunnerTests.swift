import Flutter
import UIKit
import XCTest
import integration_test

class RunnerTests: XCTestCase {
    func testIntegrationTest() {
        let expectation = expectation(description: "Integration Test")
        // This is the bridge that tells Xcode to run the Dart integration tests
        let testRunner = FLTIntegrationTestRunner()
        testRunner.runTest { (result) in
            XCTAssertTrue(result, "Integration tests failed")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 300, handler: nil)
    }
}
