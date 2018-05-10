import Quick
import Nimble
import OHHTTPStubs

@testable import ContentSDK

class TableOfContentsSpec: QuickSpec {
    let config = ContentConfig(content_id: "", integration_id: "", page_url: "")
    override func spec() {
        afterEach {
           OHHTTPStubs.removeAllStubs()
        }

        describe("ContentSDK load config") {
            it("with valid JSON returns correct value") {
                stub(condition: isHost(VideoFetcher.serviceURL)) { _ in
                    let stubPath = OHPathForFile("Content.json", type(of: self))
                    return fixture(filePath: stubPath!, headers: ["Content-Type": "application/json"])
                }

                let expectation = QuickSpec.current.expectation(description: "network call")
                ContentSdk.load(config: self.config, completion: { (content, _) in
                    expect(content).toNot(beNil())
                    expectation.fulfill()
                })
                QuickSpec.current.waitForExpectations(timeout: 1)
            }

            it("with geoblocked JSON return error") {
                stub(condition: isHost(VideoFetcher.serviceURL)) { _ in
                    let stubPath = OHPathForFile("GeoblockedContent.json", type(of: self))
                    return fixture(filePath: stubPath!, headers: ["Content-Type": "application/json"])
                }

                let expectation = QuickSpec.current.expectation(description: "network call")
                ContentSdk.load(config: self.config, completion: { (content, error) in
                    expect(content).to(beNil())
                    expect(error).to(matchError(ContentSdkError.serverError(reason: "contentGeoblocked")))
                    expectation.fulfill()
                })
                QuickSpec.current.waitForExpectations(timeout: 1)
            }

            it("with network error return error") {
                let notConnectedError = NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue)
                stub(condition: isHost(VideoFetcher.serviceURL)) { _ in
                    return OHHTTPStubsResponse(error: notConnectedError)
                }

                let expectation = QuickSpec.current.expectation(description: "network call")
                ContentSdk.load(config: self.config, completion: { (content, error) in
                    expect(content).to(beNil())
                    expect(error).to(matchError(notConnectedError))
                    expectation.fulfill()
                })
                QuickSpec.current.waitForExpectations(timeout: 1)
            }

            it("with incorrect config return error") {
                stub(condition: isHost(VideoFetcher.serviceURL)) { _ in
                    let stubPath = OHPathForFile("WrongConfigContent.json", type(of: self))
                    return fixture(filePath: stubPath!, headers: ["Content-Type": "application/json"])
                }

                let expectation = QuickSpec.current.expectation(description: "network call")
                ContentSdk.load(config: self.config, completion: { (content, error) in
                    expect(content).to(beNil())
                    expect(error).to(matchError(ContentSdkError.serverError(reason: "Failed to get config")))
                    expectation.fulfill()
                })
                QuickSpec.current.waitForExpectations(timeout: 1)
            }
        }

        describe("ContentSDK trackContentBegin") {
            it("with valid JSON returns correct value") {
                stub(condition: isHost(VideoFetcher.serviceURL)) { _ in
                    let stubPath = OHPathForFile("Content.json", type(of: self))
                    return fixture(filePath: stubPath!, headers: ["Content-Type": "application/json"])
                }

                weak var trackerStub = stub(condition: isHost("player-feedback-mds.glomex.com")) { _ in
                    let stubData = "Hello World!".data(using: String.Encoding.utf8)
                    return OHHTTPStubsResponse(data: stubData!, statusCode: 200, headers: nil)
                }
                trackerStub?.name = "tracking"

                let expectation = QuickSpec.current.expectation(description: "network call")

                var postRequests: Int = 0
                var getRequests: Int = 0
                var totalRequest: Int = 0

                OHHTTPStubs.onStubActivation({ (request, desc, _) in
                    guard let name = desc.name, name == "tracking" else {
                        return
                    }
                    if request.httpMethod == "GET" {
                        getRequests += 1
                    } else {
                       postRequests += 1
                    }
                    totalRequest += 1
                    if totalRequest >= 2 {
                        expect(getRequests) == 1
                        expect(postRequests) == 1
                        expectation.fulfill()
                    }
                })

                ContentSdk.load(config: self.config, completion: { (content, _) in
                    content?.trackContentBegin()
                })
                QuickSpec.current.waitForExpectations(timeout: 10)
            }

            it("with valid JSON returns correct value") {
                stub(condition: isHost(VideoFetcher.serviceURL)) { _ in
                    let stubPath = OHPathForFile("Content.json", type(of: self))
                    return fixture(filePath: stubPath!, headers: ["Content-Type": "application/json"])
                }

                weak var trackerStub = stub(condition: isHost("player-feedback-mds.glomex.com")) { _ in
                    let stubData = "Hello World!".data(using: String.Encoding.utf8)
                    return OHHTTPStubsResponse(data: stubData!, statusCode: 200, headers: nil)
                }
                trackerStub?.name = "tracking"

                let expectation = QuickSpec.current.expectation(description: "network call")

                var postRequests: Int = 0
                var getRequests: Int = 0
                var totalRequest: Int = 0

                OHHTTPStubs.onStubActivation({ (request, desc, _) in
                    guard let name = desc.name, name == "tracking" else {
                        return
                    }
                    if request.httpMethod == "GET" {
                        getRequests += 1
                    } else {
                        postRequests += 1
                    }
                    totalRequest += 1
                    if totalRequest >= 2 {
                        expect(getRequests) == 1
                        expect(postRequests) == 1
                        expectation.fulfill()
                    }
                })

                ContentSdk.load(config: self.config, completion: { (content, _) in
                    content?.trackContentBegin()
                })
                QuickSpec.current.waitForExpectations(timeout: 10)
            }
        }
    }
}
