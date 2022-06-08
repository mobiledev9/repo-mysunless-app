//
//  PrrofileVC.swift
//  MySunless
//
//  Created by Daydream Soft on 08/06/22.
//

import UIKit
import ScrollableSegmentedControl

class PrrofileVC: UIViewController {

    @IBOutlet weak var segment: ScrollableSegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    var arrSegments = ["Personal Info", "Change Avatar", "Change Password", "Subscription", "My Signature", "My Goals"]
    
    //MARK:- Variable Declarations
    private lazy var firstViewController: PerrsonalInfoVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "PerrsonalInfoVC") as! PerrsonalInfoVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    private lazy var secondViewController: ChangeAvatarVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "ChangeAvatarVC") as! ChangeAvatarVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    private lazy var thirdViewController: ChangePasswordVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var fourthViewController: SubscriptionVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "SubscriptionVC") as! SubscriptionVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var fifthViewController: MySignatureVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "MySignatureVC") as! MySignatureVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var sixthViewController: MyGoalsVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "MyGoalsVC") as! MyGoalsVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setSegmentController()
        add(asChildViewController: firstViewController)
    }
    
    func setSegmentController() {
        segment.segmentStyle = .textOnly
        for i in 0..<arrSegments.count {
            segment.insertSegment(withTitle: arrSegments[i], at: i)
        }
        segment.underlineHeight = 2.0
        segment.underlineSelected = true
        segment.selectedSegmentIndex = 0
       // tittle = segment.titleForSegment(at: segment.selectedSegmentIndex)!
        segment.fixedSegmentWidth = false
        segment.backgroundColor = UIColor.init("#E5E4E2")
        let largerBlueTextAttributes = [NSAttributedString.Key.font : UIFont(name: "Roboto-Bold",size:17)!,
                                        NSAttributedString.Key.foregroundColor:UIColor.init("#6D778E")
        ]
        let SelectedTextAttributes = [NSAttributedString.Key.font : UIFont(name:"Roboto-Bold",size:17)!,
                                      NSAttributedString.Key.foregroundColor:UIColor.init("#15B0DA")
        ]
        segment.setTitleTextAttributes(largerBlueTextAttributes, for: .normal)
        segment.setTitleTextAttributes(largerBlueTextAttributes, for: .highlighted)
        segment.setTitleTextAttributes(SelectedTextAttributes, for: .selected)
        segment.addTarget(self, action: #selector(segmentSelected(_:)), for: .valueChanged)
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)
        
        // Add Child View as Subview
        containerView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = containerView.bounds
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
                remove(asChildViewController: thirdViewController)
                remove(asChildViewController: secondViewController)
                remove(asChildViewController: fourthViewController)
                remove(asChildViewController: fifthViewController)
                remove(asChildViewController: sixthViewController)
            case 1:
                add(asChildViewController: secondViewController)
                remove(asChildViewController: firstViewController)
                remove(asChildViewController: thirdViewController)
                remove(asChildViewController: fourthViewController)
                remove(asChildViewController: fifthViewController)
                remove(asChildViewController: sixthViewController)
            case 2:
                add(asChildViewController: thirdViewController)
                remove(asChildViewController: firstViewController)
                remove(asChildViewController: secondViewController)
                remove(asChildViewController: fourthViewController)
                remove(asChildViewController: fifthViewController)
                remove(asChildViewController: sixthViewController)
            case 3:
                add(asChildViewController: fourthViewController)
                remove(asChildViewController: firstViewController)
                remove(asChildViewController: secondViewController)
                remove(asChildViewController: thirdViewController)
                remove(asChildViewController: fifthViewController)
                remove(asChildViewController: sixthViewController)
            case 4:
                add(asChildViewController: fifthViewController)
                remove(asChildViewController: firstViewController)
                remove(asChildViewController: secondViewController)
                remove(asChildViewController: fourthViewController)
                remove(asChildViewController: thirdViewController)
                remove(asChildViewController: sixthViewController)
            case 5:
                add(asChildViewController: sixthViewController)
                remove(asChildViewController: firstViewController)
                remove(asChildViewController: secondViewController)
                remove(asChildViewController: fourthViewController)
                remove(asChildViewController: fifthViewController)
                remove(asChildViewController: thirdViewController)
            default:
                print("Default")
        }
    }
   
    @objc func segmentSelected(_ sender: ScrollableSegmentedControl) {
        updateView()
    }

}
