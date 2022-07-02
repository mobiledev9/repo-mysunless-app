//
//  ToDoArchiveVC.swift
//  MySunless
//
//  Created by Daydream Soft on 02/07/22.
//

import UIKit
import Alamofire

class ToDoArchiveVC: UIViewController {

    @IBOutlet weak var vw_main: UIView!
    @IBOutlet weak var vw_top: UIView!
    @IBOutlet weak var vw_bottom: UIView!
    @IBOutlet weak var tblToDoArchive: UITableView!
    @IBOutlet weak var btnDelete: UIButton!
    
    var token = String()
    var arrToDoArchive = [ToDoArchiveList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        tblToDoArchive.tableFooterView = UIView()
        tblToDoArchive.register(UINib(nibName: "ToDoArchiveCell", bundle: nil), forCellReuseIdentifier: "ToDoArchiveCell")
    }
    
    func setInitially() {
        vw_main.layer.borderWidth = 1.0
        vw_main.layer.borderColor = UIColor.init("#005CC8").cgColor
        vw_top.layer.cornerRadius = 12
        vw_top.layer.masksToBounds = true
        vw_top.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        vw_bottom.layer.cornerRadius = 12
        vw_bottom.layer.masksToBounds = true
        vw_bottom.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDeleteClick(_ sender: UIButton) {
    }
    

}

extension ToDoArchiveVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblToDoArchive.dequeueReusableCell(withIdentifier: "ToDoArchiveCell", for: indexPath) as! ToDoArchiveCell
        
        return cell
    }
}

extension ToDoArchiveVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
