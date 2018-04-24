internal class ContentImp: Content {
    private let video: Video
    private let contentBeginTracker: EventTracker
    private let adBeginTracker: EventTracker
    private let session: Session

    init?(_ video: Video) {
        guard let _ = video.source else {
            return nil
        }
        self.video = video
        session = Session()
        contentBeginTracker = EventTracker(trackingCalls: video.tracking.contentBegin, session: session)
        adBeginTracker = EventTracker(trackingCalls: video.tracking.adBegin, session: session)
    }

    func getSources() -> [String: String] {
        return video.source!
    }
    func trackContentBegin() {
        contentBeginTracker.track()
    }
    func trackAdBegin(adRollName: AdRollName) {
        adBeginTracker.track()
    }
}
