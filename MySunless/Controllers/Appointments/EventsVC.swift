//
//  EventsVC.swift
//  MySunless
//
//  Created by Daydream Soft on 02/04/22.
//

import UIKit

protocol chnageEventProtocol {
    func callLoadCalenderView()
    
}

class EventsVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var containerView: UIView!
    
    //MARK:- Variable Declarations
    private lazy var firstViewController: EventCalendarVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "EventCalendarVC") as! EventCalendarVC
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    private lazy var secondViewController: EventListViewVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "EventListViewVC") as! EventListViewVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    private lazy var thirdViewController: RequestedEventListVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "RequestedEventListVC") as! RequestedEventListVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        add(asChildViewController: firstViewController)
    }
    
    //MARK:- User-Defined Functions
    func setInitially() {
        segmentedControl.selectedSegmentIndex = 0
        setSegmentController()
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
            case 2:
                add(asChildViewController: thirdViewController)
                remove(asChildViewController: firstViewController)
                remove(asChildViewController: secondViewController)
                thirdViewController.delegate = self
            default:
                print("Default")
        }
    }
    
    func setSegmentController() {
        let textAttributes = [NSAttributedString.Key.font: UIFont(name: "Roboto-Bold",size:16)!,
                              NSAttributedString.Key.foregroundColor: UIColor.init("#6D778E")
                             ]
        let selectedTextAttributes = [NSAttributedString.Key.font: UIFont(name:"Roboto-Bold",size:16)!,
                                      NSAttributedString.Key.foregroundColor: UIColor.white
                                     ]
        segmentedControl.setTitleTextAttributes(textAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
    }
    
    //MARK:- Actions
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        updateView()
    }

}

extension EventsVC : chnageEventProtocol {
    func callLoadCalenderView() {
        segmentedControl.selectedSegmentIndex = 0
        updateView()
    }
}


