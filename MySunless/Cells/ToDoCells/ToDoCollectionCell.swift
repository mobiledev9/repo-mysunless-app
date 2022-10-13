//
//  ToDoCollectionCell.swift
//  MySunless
//
//  Created by Daydream Soft on 07/07/22.
//

import UIKit
import SwiftReorder

//protocol ToDoTaskProtocol {
//    func callShowAllTodoCategory()
//    func editTask(model: NSDictionary, taskId: Int, catId: Int)
//    func callDeleteTask(deleteId: Int, action: String)
//    func moveTask(taskName: String, taskId: Int)
//    func addTask(catId: Int)
//    func editCategory(catId: Int, catName: String)
//    func deleteCategory(catId: Int)
//}

class ToDoCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var tblToDo: UITableView!
    
    var parent = ToDoVC()
    var dict = ShowAllTodoCategory(dict: [:])
    var delegate: ToDoProtocol?
    var arrShowAllCategory = [ShowAllTodoCategory]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tblToDo.tableFooterView = UIView()
        tblToDo.register(UINib(nibName: "ToDoHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "ToDoHeaderView")
        tblToDo.register(UINib(nibName: "ToDoFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "ToDoFooterView")
        tblToDo.register(UINib(nibName: "ToDoCell", bundle: nil), forCellReuseIdentifier: "ToDoCell")
//        let dummyViewHeight = CGFloat(40)
//        tblToDo.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tblToDo.bounds.size.width, height: dummyViewHeight))
//        tblToDo.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
        tblToDo.reorder.delegate = self
        tblToDo.allowsSelection = false
        tblToDo.delegate = self
        tblToDo.dataSource = self
    }
    
    @objc func btnAddTask(_ sender: UIButton) {
        delegate?.addTask(catId: dict.id)
    }
    
    @objc func btnEditCategory(_ sender: UIButton) {
        delegate?.editCategory(catId: dict.id, catName: dict.catname)
    }
    
    @objc func btnDeleteCategory(_ sender: UIButton) {
        delegate?.deleteCategory(catId: dict.id)
    }
    
}

extension ToDoCollectionCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dict.todoTasks.count
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tblToDo.dequeueReusableHeaderFooterView(withIdentifier: "ToDoFooterView") as! ToDoFooterView
        if dict.catname == "To-do" {
           parent.isToDoCat = true
        } else {
            parent.isToDoCat = false
        }
        footerView.btnAdd.tag = section
        parent.selectedCatName = footerView.lblTitle.text ?? ""
        footerView.btnAdd.addTarget(self, action: #selector(btnAddTask(_:)), for: .touchUpInside)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tblToDo.dequeueReusableHeaderFooterView(withIdentifier: "ToDoHeaderView") as! ToDoHeaderView
        if dict.catname == "To-do" {
            headerView.lblTitle.text = "TODO (SELF)"
            headerView.btnEdit.isHidden = true
            headerView.btnCancel.isHidden = true
            headerView.btnAddTrailingConstraint.constant = 10
            parent.isToDoCat = true
        } else {
            headerView.lblTitle.text = dict.catname
            headerView.btnEdit.isHidden = false
            headerView.btnCancel.isHidden = false
            headerView.btnAddTrailingConstraint.constant = 78
            parent.isToDoCat = false
        }
        headerView.btnAdd.tag = section
        headerView.btnEdit.tag = section
        headerView.btnCancel.tag = section
        
        parent.selectedCatName = headerView.lblTitle.text ?? ""
        headerView.btnEdit.addTarget(self, action: #selector(btnEditCategory(_:)), for: .touchUpInside)
        headerView.btnCancel.addTarget(self, action: #selector(btnDeleteCategory(_:)), for: .touchUpInside)
        headerView.btnAdd.addTarget(self, action: #selector(btnAddTask(_:)), for: .touchUpInside)
        
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let spacer = tblToDo.reorder.spacerCell(for: indexPath) {
            return spacer
        }
        let cell = tblToDo.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoCell
        cell.delegate = delegate
      //  let model:NSDictionary = parent.arrShowAllCategory[indexPath.section].todoTasks[indexPath.row] as NSDictionary
        let model:NSDictionary = dict.todoTasks[indexPath.row] as NSDictionary
        cell.model = model
        cell.dictShowCategory = dict
        cell.setCell(model: model, index: indexPath.row)
        
        return cell
    }
    
}

extension ToDoCollectionCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ToDoCollectionCell: TableViewReorderDelegate {
    func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = arrShowAllCategory[sourceIndexPath.section].todoTasks[sourceIndexPath.row]
        let sourceItem:NSDictionary = arrShowAllCategory[sourceIndexPath.section].todoTasks[sourceIndexPath.row] as NSDictionary
        let sourceTaskId = sourceItem.value(forKey: "id") as? Int ?? 0
        let destCatId = arrShowAllCategory[destinationIndexPath.section].id

        arrShowAllCategory[sourceIndexPath.section].todoTasks.remove(at: sourceIndexPath.row)
        arrShowAllCategory[destinationIndexPath.section].todoTasks.insert(item, at: destinationIndexPath.row)

        delegate?.callChangeCategory(destCategoryId: destCatId, sourceTaskId: sourceTaskId)
    }
}
