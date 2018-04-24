internal class EventTracker {
    private let trackingCalls: [TrackingCall]
    private let session: Session

    init(trackingCalls: [TrackingCall], session: Session) {
        self.trackingCalls = trackingCalls
        self.session = session
    }

    func track(runtimePayload: [String: String] = [:]) {
        let mergedPayload = runtimePayload.merging(session.payload(), uniquingKeysWith: { (first, _) in first })
        for trackingCall in trackingCalls {
            let payload =  preparaPayload(trackingCall, runtimePayload: mergedPayload)
            emitEvent(trackingCall: trackingCall, payload: payload)
        }
    }

    private func sendPostRequest(_ trackingCall: TrackingCall, payload: [String: String]) {
        let url = URL(string: trackingCall.url)
        guard let trackURL = url  else {
            return
        }
        var request = URLRequest(url: trackURL)
        request.httpMethod = trackingCall.method
        let paramData = try? JSONSerialization.data(withJSONObject: payload, options: [])
        request.httpBody = paramData
        URLSession.shared.dataTask(with: request).resume()
    }

    private func sendRegularRequest(_ trackingCall: TrackingCall, payload: [String: String]) {
        let components = URLComponents(string: trackingCall.url)
        guard var trackUrlComponents = components  else {
            return
        }
        trackUrlComponents.queryItems = payload.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        var request = URLRequest(url: trackUrlComponents.url!)
        request.httpMethod = trackingCall.method
        URLSession.shared.dataTask(with: request).resume()
    }

    private func preparaPayload(_ trackingCall: TrackingCall, runtimePayload: [String: String]) -> [String: String] {
        if let payload = trackingCall.payload {
            return runtimePayload.merging(payload, uniquingKeysWith: { (first, _) in first })
        } else {
            return runtimePayload
        }
    }

    private func emitEvent(trackingCall: TrackingCall, payload: [String: String]) {
        switch trackingCall.method.lowercased() {
        case "post":
            sendPostRequest(trackingCall, payload: payload)
        default:
            sendRegularRequest(trackingCall, payload: payload)
        }
    }

}
