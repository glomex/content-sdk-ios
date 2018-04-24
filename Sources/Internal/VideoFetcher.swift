internal class VideoFetcher {
    class func fetchVideo(config: ContentConfig, completion: @escaping (Video?, Error?) -> Void) {
        guard let url = URL(string: "https://integration-sdk-eu-west-1.dev.mes.glomex.cloud/video?\(config.getAsUrlParams())") else {
            completion(nil, ContentSdkError.configError)
            return
        }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
                guard let data = data else {
                    completion(nil, ContentSdkError.newrorkError)
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
