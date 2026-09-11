import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var stackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0 ..< 30 {
            let label = UILabel()
            label.text = "Label \(i)"
            stackView.addArrangedSubview(label)
        }
    }


}

