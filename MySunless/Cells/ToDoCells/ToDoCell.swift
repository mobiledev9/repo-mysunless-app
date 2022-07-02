//
//  ToDoCell.swift
//  MySunless
//
//  Created by Daydream Soft on 22/06/22.
//

import UIKit
import OnlyPictures
import Kingfisher
import SCLAlertView

class ToDoCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var expandView: UIView!
    @IBOutlet var btnCancelTask: UIButton!
    @IBOutlet var btnEditTask: UIButton!
    @IBOutlet var btnMoveTask: UIButton!
    @IBOutlet var lblTaskTitle: UILabel!
    @IBOutlet var lblTaskDate: UILabel!
    @IBOutlet var btnExpandView: UIButton!
    @IBOutlet var onlyPicturesView: OnlyHorizontalPictures!
    @IBOutlet weak var vw_leading: UIView!
    
    var delegate: ToDoProtocol?
    var arrImgs = [String]()
    var model = NSDictionary()
    var alertTitle = "Are you sure?"
    var alertSubtitle = "Archive: Move all task to Archive List. \n Delete: Permanent Delete Can Not be recover."
    var dictShowCategory = ShowAllTodoCategory(dict: [:])
    var taskId = Int()
    var taskName = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vw_leading.layer.cornerRadius = 12
        vw_leading.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        expandView.layer.cornerRadius = 12
        expandView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        onlyPicturesView.dataSource = self
        
        onlyPicturesView.layer.cornerRadius = 20.0
        onlyPicturesView.layer.masksToBounds = true
       // onlyPictures.delegate = self
        onlyPicturesView.order = .descending
        onlyPicturesView.alignment = .right
        onlyPicturesView.countPosition = .right
        onlyPicturesView.recentAt = .left
       // onlyPicturesView.gap = 20
        onlyPicturesView.spacing = 1
        onlyPicturesView.backgroundColor = UIColor.clear
        
//        onlyPicturesView.spacingColor = UIColor.white
//        onlyPicturesView.backgroundColorForCount = .red
//
//        onlyPicturesView.backgroundColorForCount = UIColor.init(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
//        onlyPicturesView.textColorForCount = .red
//        onlyPicturesView.fontForCount = UIFont(name: "HelveticaNeue", size: 18)!
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell(model: NSDictionary, index: Int) {
        taskId = model.value(forKey: "id") as? Int ?? 0
        taskName = model.value(forKey: "todoTitle") as? String ?? ""
        let colorcode = model.value(forKey: "colorcode") as? String
        cellView.backgroundColor = UIColor.init(colorcode ?? "", alpha: 0.5)
        vw_leading.backgroundColor = UIColor.init(colorcode ?? "")
        lblTaskTitle.text = model.value(forKey: "todoTitle") as? String
        lblTaskDate.text = model.value(forKey: "newduedate") as? String
        lblTaskTitle.textColor = UIColor.init(colorcode ?? "")
        lblTaskDate.textColor = UIColor.init(colorcode ?? "")
    
        var arrUseData = [Usedata]()
        let usedata = model.value(forKey: "usedata") as? [[String:Any]] ?? []
        for dict in usedata {
            arrUseData.append(Usedata(dict: dict))
        }
        arrImgs.removeAll()
        for dic in arrUseData {
            arrImgs.append(dic.userimg)
        }
      //  print("arrImgs:-", arrImgs)
        
        btnEditTask.tag = index
        btnMoveTask.tag = index
        btnCancelTask.tag = index
        
        onlyPicturesView.reloadData()
    }
    
    @IBAction func btnExpandView(_ sender: UIButton) {
    }
    
    @IBAction func btnCancelTask(_ sender: UIButton) {
        let alert = SCLAlertView()
        alert.addButton("Cancel", backgroundColor: UIColor.init("#757575"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {})
        alert.addButton("Delete", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, target: self, selector: #selector(deletePermanently(_:)))
        alert.addButton("Archive", backgroundColor: UIColor.init("#E95268"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, target: self, selector: #selector(archive(_:)))
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertTitle, subTitle: alertSubtitle)
    }
    
    @IBAction func btnEditTask(_ sender: UIButton) {
        delegate?.editTask(model: model, taskId: taskId, catId: dictShowCategory.id)
    }
    
    @IBAction func btnMoveTask(_ sender: UIButton) {
        delegate?.moveTask(taskName: taskName, taskId: taskId)
    }
    
    @objc func deletePermanently(_ sender: UIButton) {
        delegate?.callDeleteTask(deleteId: taskId, action: "delete")
    }
    
    @objc func archive(_ sender: UIButton) {
        delegate?.callDeleteTask(deleteId: taskId, action: "archive")
    }
}

extension ToDoCell: OnlyPicturesDataSource {
    func numberOfPictures() -> Int {
        return arrImgs.count
    }
    
//    func visiblePictures() -> Int {
//        return 6
//    }
    
    func pictureViews(_ imageView: UIImageView, index: Int) {
        let url = URL(string: self.arrImgs[index])
        onlyPicturesView.insertLast(withAnimation: .popup) { (imageView) in
            //  imageView.image = #imageLiteral(resourceName: "defaultProfilePicture")
            imageView.kf.setImage(with: url)
        }
    }
}
