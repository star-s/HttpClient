import XCTest
@testable import HttpClient

final class HttpClientTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(HttpClient().text, "Hello, World!")
    }
}
