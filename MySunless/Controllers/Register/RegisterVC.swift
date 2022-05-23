//
//  RegisterVC.swift
//  MySunless
//
//  Created by iMac on 09/10/21.
//

import UIKit
import StepView

class RegisterVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var stepView: StepView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var vw_Main: UIView!
    
    static var shareInst = RegisterVC()
    
    //MARK:- Variable Declarations
    private var pageViewController: UIPageViewController!
    
    fileprivate lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: String.init(describing: CreateAccountVC.self)),
            self.getViewController(withIdentifier: String.init(describing: AccountVerifyVC.self)),
            self.getViewController(withIdentifier: String.init(describing: PersonalInfoVC.self)),
            self.getViewController(withIdentifier: String.init(describing: CompanyInfoVC.self)),
            self.getViewController(withIdentifier: String.init(describing: CompanyServiceVC.self)),
            self.getViewController(withIdentifier: String.init(describing: ChoosePackageVC.self))
        ]
    }()
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControllers()
        
    }
    
    //MARK:- User-Defined Functions
    private func setupControllers() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.view.frame = containerView.bounds
        containerView.addSubview(pageViewController.view)
        
        if let firstController = pages.first {
            pageViewController.setViewControllers([firstController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
     
    private func getControllerToShow(from index: Int) -> UIViewController? {
        if index - 1 < pages.count {
            return pages[index - 1]
        } else {
            print("Index is out of range")
            return nil
        }
    }

    //MARK:- Actions
   /* @IBAction func btnNextClick(_ sender: UIButton) {
        stepView.showNextStep()

        if let controllerToShow = getControllerToShow(from: stepView.selectedStep) {
            pageViewController.setViewControllers([controllerToShow], direction: .forward, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        if stepView.selectedStep == 1 {
            self.navigationController?.popViewController(animated: true)
        } else {
            stepView.showPreviousStep()
            
            if let controllerToShow = getControllerToShow(from: stepView.selectedStep) {
                pageViewController.setViewControllers([controllerToShow], direction: .reverse, animated: true, completion: nil)
            }
        }
    }     */

}


