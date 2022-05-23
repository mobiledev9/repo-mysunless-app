//
//  EventListVC.swift
//  MySunless
//
//  Created by iMac on 25/01/22.
//

import UIKit

class EventListVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet var segment: UISegmentedControl!
    @IBOutlet var containerView: UIView!
    
    var token = String()
    
    private lazy var firstViewController: EventsTableListVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "EventsTableListVC") as! EventsTableListVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var secondViewController: EventsGraphVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)    
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "EventsGraphVC") as! EventsGraphVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    static func viewController() -> EventListVC {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventListVC") as! EventListVC
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
                remove(asChildViewController: secondViewController)
            case 1:
                add(asChildViewController: secondViewController)
                remove(asChildViewController: firstViewController)
            default:
                print("Default")
        }
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        updateView()
    }
    
}


