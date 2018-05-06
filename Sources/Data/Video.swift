internal struct TrackingCall: Decodable {
    let method: String
    let url: String
    let payload: [String: String]?
}

internal struct Tracking: Decodable {
    let contentBegin: [TrackingCall]
    let adBegin: [TrackingCall]
    let contentError: [TrackingCall]
}

internal struct Video: Decodable {
    let clip_id: String
    let error_code: String?
    let source: [String: String]?
    let tracking: Tracking
}

internal struct VideoResponce: Decodable {
    let video: Video?
    let error: String?
}
