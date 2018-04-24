class Session {
    let sessionId: String
    let clientInfo: String

    init() {
        sessionId = UUID().uuidString
        let bundle = Bundle(for: type(of: self))
        var sdkVersion = ""
        if let version = bundle.infoDictionary!["CFBundleShortVersionString"] as? String {
            sdkVersion = "\(version)"
        }
        clientInfo = "iOS \(UIDevice.current.systemVersion), \(UIDevice.current.name), \(sdkVersion)"
    }

    func payload() -> [String: String] {
        return [
            "id": sessionId,
            "client": clientInfo
        ]
    }
}
