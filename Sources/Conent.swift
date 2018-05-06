/** Content interface. Used to get sources and track events. */
@objc public protocol Content: class {
    /**
     - returns: dictionary with sources
     
     Method returns dictionary where key is source type (progressive or HLS) and value is stream url
     */
    func getSources() -> [String: String]

    /**
     Method should be called when content start playing
     */
    func trackContentBegin()

    /**
     - parameter adRollName: pass the type of adRoll (preroll or postroll)
     
     Method should be called when adRoll start playing
     */
    func trackAdBegin(adRollName: AdRollName)
}

@objc public enum AdRollName: Int {
    case preroll
    case postroll

    internal func description() -> String {
        switch self {
        case .preroll:
            return "preroll"
        case .postroll:
            return "postroll"
        }
    }
}
