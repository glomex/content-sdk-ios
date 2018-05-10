
internal class VideoFetcher {
    private let serviceURL = "https://integration-sdk-eu-west-1.mes.glomex.cloud/video"

    class func fetchVideo(config: ContentConfig, completion: @escaping (Video?, Error?) -> Void) {
        guard let url = URL(string: "\(serviceURL)?\(config.getAsUrlParams())") else {
            completion(nil, ContentSdkError.configError)
            return
        }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
                guard let data = data else {
                    completion(nil, error ?? ContentSdkError.newrorkError)
                    return
                }
                let decoder = JSONDecoder()
                let videoResponceOptional = try? decoder.decode(VideoResponce.self, from: data)
                guard let videoResponce = videoResponceOptional else {
                    completion(nil, ContentSdkError.newrorkError)
                    return
                }
                if let error = videoResponce.error {
                    completion(nil, ContentSdkError.serverError(reason: error))
                    return
                }
                if let error = videoResponce.video?.error_code {
                    completion(nil, ContentSdkError.serverError(reason: error))
                    return
                }
                completion(videoResponce.video, nil)
            }.resume()
    }
}
