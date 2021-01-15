import UIKit

class FinishViewController: UIViewController {

    @IBOutlet weak var sayGoodbyeLabel: UILabel!
    
    var text = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sayGoodbyeLabel.text = text
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
