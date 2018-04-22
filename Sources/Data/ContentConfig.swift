open class ContentConfig: NSObject {
    let content_id: String;
    let integration_id: String;
    let page_url: String;

    init(content_id: String, integration_id: String, page_url: String) {
        self.content_id = content_id;
        self.integration_id = integration_id;
        self.page_url = page_url;
    }
    
    internal func getAsUrlParams() -> String {
        return "content_id=\(content_id)&integration_id=\(integration_id)&page_url=\(page_url)"
            .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}
