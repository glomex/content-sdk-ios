internal struct TrackingFunction: Decodable {
    let method: String;
    let url: String;
    let payload: [String: String]?;
}

internal struct Tracking: Decodable {
    let contentBegin: [TrackingFunction];
    let adBegin: [TrackingFunction];
    let contentError: [TrackingFunction]
}

internal struct Video: Decodable {
    let clip_id: String;
    let error_code: String?;
    let source: [String: String]?;
    let tracking: Tracking;
}

internal struct VideoResponce: Decodable {
    let video: Video;
}
