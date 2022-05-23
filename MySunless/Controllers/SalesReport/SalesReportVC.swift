//
//  SalesReportVC.swift
//  MySunless
//
//  Created by Daydream Soft on 13/04/22.
//

import UIKit

class SalesReportVC: UIViewController {
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var containerView: UIView!
  //  @IBOutlet var vw_mainHeight: NSLayoutConstraint!     //1200
    
    private lazy var firstViewController: ProductReportVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "ProductReportVC") as! ProductReportVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    private lazy var secondViewController: CategoryReportVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "CategoryReportVC") as! CategoryReportVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    private lazy var thirdViewController: SalesProfitGraphVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "SalesProfitGraphVC") as! SalesProfitGraphVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
    }
    
    func setInitially() {
        segmentedControl.selectedSegmentIndex = 0
        updateView()
        setSegmentController()
    }
    
    func setSegmentController() {
        let textAttributes = [NSAttributedString.Key.font : UIFont(name: "Roboto-Bold",size:16)!,
                              NSAttributedString.Key.foregroundColor:UIColor.init("#6D778E")
                             ]
        let selectedTextAttributes = [NSAttributedString.Key.font : UIFont(name:"Roboto-Bold",size:16)!,
                                      NSAttributedString.Key.foregroundColor:UIColor.white
                                     ]
        segmentedControl.setTitleTextAttributes(textAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        updateView()
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
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                add(asChildViewController: firstViewController)
                remove(asChildViewController: thirdViewController)
                remove(asChildViewController: secondViewController)
            case 1:
                add(asChildViewController: secondViewController)
                remove(asChildViewController: firstViewController)
                remove(asChildViewController: thirdViewController)
              //  vw_mainHeight.constant = view.bounds.height
            case 2:
                add(asChildViewController: thirdViewController)
                remove(asChildViewController: firstViewController)
                remove(asChildViewController: secondViewController)
             //   vw_mainHeight.constant = 400
            default:
                print("Default")
        }
    }
}

