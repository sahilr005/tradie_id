import UIKit

class ScreenCaptureBlocker {
    static func blockScreenCapture() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let rootViewController = appDelegate?.window?.rootViewController
        
        let blankView = UIView(frame: UIScreen.main.bounds)
        blankView.backgroundColor = .white
        
        rootViewController?.view.addSubview(blankView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            blankView.removeFromSuperview()
        }
    }
}
