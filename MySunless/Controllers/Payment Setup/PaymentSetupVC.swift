//
//  PaymentSetupVC.swift
//  MySunless
//
//  Created by iMac on 07/05/22.
//

import UIKit

class PaymentSetupVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet var segment: UISegmentedControl!
    @IBOutlet var vw_container: UIView!
    
    //MARK:- Variable Declarations
    private lazy var firstViewController: SquarePaymentVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "SquarePaymentVC") as! SquarePaymentVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var secondViewController: StripePaymentVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "StripePaymentVC") as! StripePaymentVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    static func viewController() -> PaymentSetupVC {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaymentSetupVC") as! PaymentSetupVC
    }
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        updateView()
    }
    
    //MARK:- User-Defined Functions
    func setInitially() {
        segment.selectedSegmentIndex = 0
        segment.backgroundColor = .clear
        segment.tintColor = .clear
        segment.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Roboto-Bold", size: 18)!,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ], for: .normal)
        segment.backgroundColor = UIColor.clear
        segment.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Roboto-Bold", size: 18)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .selected)
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)
        
        // Add Child View as Subview
        vw_container.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = vw_container.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    private func updateView() {
        switch segment.selectedSegmentIndex {
            case 0:
                add(asChildViewController: firstViewController)
                remove(asChildViewController: secondViewController)
            case 1:
                add(asChildViewController: secondViewController)
                remove(asChildViewController: firstViewController)
            default:
                print("Default")
        }
    }
    
    //MARK:- Actions
    @IBAction func segValueChanged(_ sender: UISegmentedControl) {
        updateView()
    }

}
