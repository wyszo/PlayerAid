import UIKit
import MGSpotyViewController

final class NewProfileViewController: MGSpotyViewController {
    var viewModel: NewProfileViewModel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let transparentStub = UIImage(named: "transparent")
        setupWithMainImage(transparentStub, tableScrollingType: .Normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = NewProfileViewModel()
        blurRadius = 5.0
        
        // TODO: update tint color as per designs
        // TOOD: extract this to ColorsHelper
        self.tintColor = UIColor(red: 0.0/255.0, green: 0/255.0, blue: 255.0/255.0, alpha: 0.3)
        
        viewModel.fetchProfileImage { [unowned self] (image) in
            self.setMainImage(image)
        }
    }
}
