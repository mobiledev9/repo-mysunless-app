//
//  OrderListVC.swift
//  MySunless
//
//  Created by iMac on 22/02/22.
//

import UIKit

class OrderListVC: UIViewController {
    
    @IBOutlet var segment: UISegmentedControl!
    @IBOutlet var containerView: UIView!
    
    var token = String()
    
    private lazy var firstViewController: CompletedOrderVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "CompletedOrderVC") as! CompletedOrderVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var secondViewController: PendingOrderVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "PendingOrderVC") as! PendingOrderVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var thirdViewController: SalesGraphVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "SalesGraphVC") as! SalesGraphVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var fourthViewController: OverviewVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "OverviewVC") as! OverviewVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    static func viewController() -> OrderListVC {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderListVC") as! OrderListVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        updateView()
    }
    
    func setInitially() {
        segment.selectedSegmentIndex = 0
        segment.backgroundColor = .clear
        segment.tintColor = .clear
        segment.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Roboto-Bold", size: 13)!,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ], for: .normal)
        segment.backgroundColor = UIColor.clear
        segment.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Roboto-Bold", size: 13)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .selected)
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
                remove(asChildViewController: fourthViewController)
                remove(asChildViewController: thirdViewController)
                remove(asChildViewController: secondViewController)
            case 1:
                add(asChildViewController: secondViewController)
                remove(asChildViewController: firstViewController)
                remove(asChildViewController: thirdViewController)
                remove(asChildViewController: fourthViewController)
            case 2:
                add(asChildViewController: thirdViewController)
                remove(asChildViewController: firstViewController)
                remove(asChildViewController: secondViewController)
                remove(asChildViewController: fourthViewController)
            case 3:
                add(asChildViewController: fourthViewController)
                remove(asChildViewController: firstViewController)
                remove(asChildViewController: secondViewController)
                remove(asChildViewController: thirdViewController)
            default:
                print("Default")
        }
    }

    @IBAction func btnEventListClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "EventListVC") as! EventListVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnPlaceNewOrder(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddOrderVC") as! AddOrderVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        updateView()
    }
}
