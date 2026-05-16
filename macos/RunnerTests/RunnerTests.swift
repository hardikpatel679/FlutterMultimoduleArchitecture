import Cocoa
import FlutterMacOS
import XCTest
import integration_test

class RunnerTests: XCTestCase {
    func testIntegrationTest() {
        let expectation = expectation(description: "Integration Test")
        let testRunner = FLTIntegrationTestRunner()
        testRunner.runTest { (result) in
            XCTAssertTrue(result, "Integration tests failed")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 300, handler: nil)
    }
}
