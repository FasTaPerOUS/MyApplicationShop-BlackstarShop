import Foundation
import UIKit

struct ActivityIndicator {
    var backgorundView = UIView()
    var activityIndicator = UIActivityIndicatorView(style: .large)
    
    init(view: UIView) {
        self.backgorundView.frame = view.frame
        self.backgorundView.center = view.center
        self.activityIndicator.center = view.center
        self.activityIndicator.alpha = 0.5
        self.backgorundView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.1)
    }
}

protocol AIFunctional {
    func startAnimating()
    func stopAnimating()
}
