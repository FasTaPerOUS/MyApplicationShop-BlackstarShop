import Foundation
import AlamofireImage

class AlamofireImageClass {
    
    func setImage(image: UIImageView, url: URL) -> UIImageView {
        image.af.setImage(withURL: url)
        return image
    }
}
