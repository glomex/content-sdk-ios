open class ContentSdk: NSObject {
    /**
     - returns: dictionary with sources
     - parameter config: your content config
     - parameter completion: operation result closure can contain Content object or error.
     
     Method return Content object or error.
     */
    @objc public class func load(config: ContentConfig, completion: @escaping (Content?, Error?) -> Void) {
        VideoFetcher.fetchVideo(config: config) { video, error  in
            DispatchQueue.main.async {
                guard let videoContent = video, error == nil else {
                    completion(nil, error)
                    return
                }
                completion(ContentImp(videoContent), nil)
            }
        }
    }
}
