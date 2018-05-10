import UIKit
import glomex
import AVKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var debugTextArea: UITextView!
    @IBOutlet weak var versionLabel: UILabel!

    @IBOutlet weak var pageUrl: UITextField!
    @IBOutlet weak var integrationId: UITextField!
    @IBOutlet weak var contentId: UITextField!
    @IBOutlet weak var loadButton: UIButton!
    
    @IBOutlet var contentApiButtons: [GradientButton]!
    var video: Content?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bundle = Bundle(for: ContentSdk.self)
        if let version = bundle.infoDictionary!["CFBundleShortVersionString"] as? String {
            versionLabel.text = "Version: \(version)"
        }
        loadButton.layer.cornerRadius = 5
        loadButton.layer.masksToBounds = true
    }

    @IBAction func loadVideo(_ sender: Any) {
        guard let contentId = self.contentId.text,
            let integrationId = self.integrationId.text,
            let pageUrl = self.pageUrl.text else {
                debugTextArea.text = "Please provide values for config"
                return
        }
        let config = ContentConfig(content_id: contentId, integration_id: integrationId, page_url: pageUrl)

        ContentSdk.load(config: config) { [weak self] (content, error) in
            self?.contentApiButtons.forEach({ (btn) in
                btn.isEnabled = error == nil
            })
            if let error = error {
                switch error {
                case ContentSdkError.configError:
                    self?.debugTextArea.text = "configError"
                case ContentSdkError.newrorkError:
                    self?.debugTextArea.text = "newrorkError"
                case ContentSdkError.serverError(let reason):
                    self?.debugTextArea.text = "serverError: \(reason)"
                default:
                    break
                }
                return
            }
            self?.video = content
            self?.debugTextArea.text = "Valid config. Content Loaded"
        }
    }

    @IBAction func getSources(_ sender: Any) {
        self.debugTextArea.text = video?.getSources().debugDescription
    }

    @IBAction func playHLS(_ sender: Any) {
        guard let hlsURL = video?.getSources()["hls"] else {
            self.debugTextArea.text = "No HLS stream in sources"
            return
        }
        let videoURL = URL(string: hlsURL)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: false) {
            playerViewController.player!.play()
        }
    }
    
    @IBAction func trackContentBegin(_ sender: Any) {
        guard let video = video else {
            self.debugTextArea.text = "please load content"
            return
        }
        video.trackContentBegin()
        self.debugTextArea.text = "tracked ContentBegin"
    }

    @IBAction func trackAdBegin(_ sender: Any) {
        guard let video = video else {
            self.debugTextArea.text = "please load content"
            return
        }
        video.trackAdBegin(adRollName: AdRollName.preroll)
        self.debugTextArea.text = "tracked AdBegin"
    }
}
