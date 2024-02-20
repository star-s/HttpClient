import XCTest
@testable import HttpClient
import CoreServices
import HttpClientUtilities

final class HttpClientTests: XCTestCase {

    func testLoadYandexWebPage() async throws {
		let html: String = try await HTTPClient().get("http://ya.ru", parameters: Parameters.void)
		XCTAssertFalse(html.isEmpty)
    }

	func testPlainTextDecodingUUID() async throws {
		let decoder = PlaintextDecoder(encoding: .ascii)

		let input = UUID()
		guard let uuidData = input.uuidString.data(using: decoder.encoding) else {
			return XCTFail("Can't get data with encoding: \(decoder.encoding)")
		}
		let output = try decoder.decode(UUID.self, from: uuidData)
		XCTAssertEqual(input, output)
	}

	func testPlainTextDecodingURL() async throws {
		let decoder = PlaintextDecoder(encoding: .ascii)

		guard let inputUrl = URL(string: "http://somewere.net") else {
			return XCTFail("Can't create url")
		}
		guard let urlData = inputUrl.absoluteString.data(using: decoder.encoding) else {
			return XCTFail("Can't get data with encoding: \(decoder.encoding)")
		}
		let outputUrl = try decoder.decode(URL.self, from: urlData)
		XCTAssertEqual(inputUrl, outputUrl)
	}

	func testPlainTextDecodingData() async throws {
		let decoder = PlaintextDecoder(encoding: .ascii)

		guard let inputData = "sdfhdscdbcofcjosicjodsc".data(using: decoder.encoding) else {
			return XCTFail("Can't get data with encoding: \(decoder.encoding)")
		}
		let outputData = try decoder.decode(Data.self, from: inputData)
		XCTAssertEqual(inputData, outputData)
	}

	func testAgify() async throws {
		struct Agify: AgifyApi, HttpClientWithBaseUrl {
			typealias Path = String

			let requestEncoder = JsonRequestEncoder()
            let responseDecoder = JSONDecoder().withDefaultResponseValidator()

			let transport = URLSession.shared.withLogger()

			let baseURL: URL = .agifyBaseURL
		}
		let data = try await Agify().getData(name: "bella")
		XCTAssertEqual(data.name, "bella")
	}
	
	func testJsonplaceholder() async throws {
		struct Jsonplaceholder: JsonplaceholderApi, HttpClientWithBaseUrl {
			typealias Path = String

			let requestEncoder = JsonRequestEncoder()
            let responseDecoder = JSONDecoder().withDefaultResponseValidator()

			let transport = URLSession.shared.withLogger()

			let baseURL: URL = .jsonplaceholderBaseURL
		}
		let data = try await Jsonplaceholder().fetchPost(number: 14)
		XCTAssertEqual(data.id, 14)
	}

	func testCustomHeaders() async throws {
        let encoderWithDefaultHeaders = JsonRequestEncoder()


        let requestWithDefaultHeaders = try await encoderWithDefaultHeaders.prepare(get: "http://somewhere.org/", parameters: Parameters.void)
		XCTAssertFalse(requestWithDefaultHeaders.headers.isEmpty)
		
        let encoderWithCustomHeaders = JsonRequestEncoder(headersFactory: HTTPHeaders())

        let requestWithCustomHeader = try await encoderWithCustomHeaders.prepare(get: "http://somewhere.org/", parameters: Parameters.void)
		XCTAssertTrue(requestWithCustomHeader.headers.isEmpty)
	}

	// MARK: - Data URL

	func testPlainTextDataURL() async throws {
		let input = "некоторый текст который мы передадим в виде урла"
		guard let url = input.plainText(encoding: .utf8)?.dataURL() else {
			return XCTFail("Can't create url")
		}
		XCTAssertTrue(url.isDataURL)
		let output: String = try await HTTPClient().get(url, parameters: Parameters.void)
		XCTAssertEqual(input, output)
	}

	func testJsonDataURL() async throws {
		struct TestData: Codable, Equatable {
			var intValue = 234
			var stringValue = "some test"
			var dateValue = Date()
		}
		let input = TestData()
		guard let url = try JSONEncoder().encode(input).urlRepresentation(mimeType: kUTTypeJSON, encoding: .base64) else {
			return XCTFail("Can't create url")
		}
		XCTAssertTrue(url.isDataURL)
		let output: TestData = try await HTTPClient().get(url, parameters: Parameters.void)
		XCTAssertEqual(input, output)
	}

	// MARK: - JSON wrapping

	func testJsonWrappingInt() async throws {
		let value = 244
		let data = Data("\(value)".utf8)
		let decodedValue = try JSONDecoder().decodeWithWrapping(Int.self, from: data)
		XCTAssertEqual(value, decodedValue)
	}

	func testJsonWrappingString() async throws {
		let string = "вдм ьащомшагтмв"
		let data = Data("\"\(string)\"".utf8)
		let decodedString = try JSONDecoder().decodeWithWrapping(String.self, from: data)
		XCTAssertEqual(string, decodedString)
	}

	// MARK: -

	func testImportCookies() {
		let exportedCookies: ExportedCookies = "YnBsaXN0MDCjARIY2AIDBAUGBwgJCgsMDQ4PEBFUUGF0aFZTZWN1cmVXVmVyc2lvbldDcmVhdGVkVVZhbHVlVkRvbWFpblROYW1lV0V4cGlyZXNRL1RUUlVFUTEjQcRA/woAAABfECBQMlEwQnRxNnRDSERtMjZrRmZEeExOallEZmFQSDUyNF4uaW5zdGFncmFtLmNvbVljc3JmdG9rZW4zQcUw8AoAAADYBwQCBQMGCAkTDAoUCxUWF14uaW5zdGFncmFtLmNvbSNBxCZeGAAAAF8QHFlweUVyd0FBQUFIZVlXN3pNbURZN3I0R2dod3NTbWlkM0HGB5GYAAAA2RkIAwkGBwIEBQsaCxcbHAoMFFhIdHRwT25seVZpZ19kaWRfECQ4RTVBODI5RS0xNzQzLTREM0UtQkQ3Ny04N0Q0MjkyQjMxQzleLmluc3RhZ3JhbS5jb20ACAAMAB0AIgApADEAOQA/AEYASwBTAFUAWgBcAGUAiACXAKEAqgC7AMoA0wDyAPYA/wESARsBIgFJAAAAAAAAAgEAAAAAAAAAHQAAAAAAAAAAAAAAAAAAAVg="

		let cookies = exportedCookies.cookies
		XCTAssertFalse(cookies.isEmpty)
	}
}

#if canImport(PDFKit)
import PDFKit

extension HttpClientTests {
	func testLoadPDF() async throws {
		let document = try await PDFDocument(
			data: HTTPClient().get("https://www.rfc-editor.org/rfc/pdfrfc/rfc2045.txt.pdf", parameters: Parameters.void)
		)
		XCTAssertNotNil(document)
	}
}

#endif
