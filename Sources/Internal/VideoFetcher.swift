internal class VideoFetcher {
    func fetchVideo(config: ContentConfig, completion: @escaping (Video?) -> Void) {
        guard let gitUrl = URL(string: "https://integration-sdk-eu-west-1.dev.mes.glomex.cloud/video?\(config.getAsUrlParams())") else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: gitUrl) { (data, _, _) in
            guard let data = data else {
                completion(nil)
                return
            }
            do {
                let decoder = JSONDecoder()
                let videoResponce = try decoder.decode(VideoResponce.self, from: data)
                completion(videoResponce.video)
            } catch {
                completion(nil)
            }
            }.resume()
    }
}
