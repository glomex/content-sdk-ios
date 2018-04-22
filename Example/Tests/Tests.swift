// https://github.com/Quick/Quick

import Quick
import Nimble
import OHHTTPStubs

@testable import GlomexContentSdk

class TableOfContentsSpec: QuickSpec {
    override func spec() {
        beforeEach {
            stub(condition: isHost("integration-sdk-eu-west-1.dev.mes.glomex.cloud")) { _ in
                let stubPath = OHPathForFile("Content.json", type(of: self))
                return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
            }
        }
        
        afterEach {
           OHHTTPStubs.removeAllStubs()
        }
        
        describe("fetch video resource") {
            it("with valid JSON returns correct value") {
                let expectation = QuickSpec.current.expectation(description: "network call")
                let fetcher = VideoFetcher();
                fetcher.fetchVideo(config: ContentConfig(content_id: "", integration_id: "", page_url: ""), completion: { video in
                    expect(video!.clip_id) == "v-bkjbsi6sv3m9"
                    expect(video!.error_code).to(beNil())
                    expectation.fulfill()
                });
                
                QuickSpec.current.waitForExpectations(timeout: 1)
            }
            
            it("with geoblocked JSON returns correct value") {
                OHHTTPStubs.removeAllStubs()
                stub(condition: isHost("integration-sdk-eu-west-1.dev.mes.glomex.cloud")) { _ in
                    let stubPath = OHPathForFile("GeoblockedContent.json", type(of: self))
                    return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
                }
                
                let expectation = QuickSpec.current.expectation(description: "network call")
                let fetcher = VideoFetcher();
                fetcher.fetchVideo(config: ContentConfig(content_id: "", integration_id: "", page_url: ""), completion: { video in
                    expect(video!.clip_id) == "v-bdjbsi6sv3m9"
                    expect(video!.error_code) == "contentNotFound"
                    expectation.fulfill()
                });
                
                QuickSpec.current.waitForExpectations(timeout: 1)
            }
            
            it("with network error returns nil") {
                OHHTTPStubs.removeAllStubs()
                stub(condition: isHost("integration-sdk-eu-west-1.dev.mes.glomex.cloud")) { _ in
                    let notConnectedError = NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue)
                    return OHHTTPStubsResponse(error:notConnectedError)
                }
                
                let expectation = QuickSpec.current.expectation(description: "network call")
                let fetcher = VideoFetcher();
                fetcher.fetchVideo(config: ContentConfig(content_id: "", integration_id: "", page_url: ""), completion: { video in
                    expect(video).to(beNil())
                    expectation.fulfill()
                });
                
                QuickSpec.current.waitForExpectations(timeout: 1)
            }
        }
    }
}
