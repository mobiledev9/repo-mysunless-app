//
//  SideMenuCell.swift
//  CustomSideMenuiOSExample
//
//  Created by John Codeos on 2/7/21.
//

import UIKit

class SideMenuCell: UITableViewCell {
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var expandImageView: UIImageView!
    @IBOutlet var iconImageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var expandImgTrailingConstraint: NSLayoutConstraint!
   // @IBOutlet var iconImgCenterConstraint: NSLayoutConstraint!
    
  /*  private let containerView = UIStackView()
    private let detailView = CustomTableDetailView()
    
    func setUI(with index: Int) {
        detailView.setUI(with: "A", image: UIImage(named: "dashboard")!)
    }
    
    func commonInit() {
        selectionStyle = .none
        detailView.isHidden = true
        
        containerView.axis = .vertical
        
        contentView.addSubview(containerView)
      //  containerView.addArrangedSubview(cellView)
        containerView.addArrangedSubview(detailView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
     //   cellView.translatesAutoresizingMaskIntoConstraints = false
        detailView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 60).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
       // containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        containerView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -80).isActive = true
    }    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
     //   commonInit()
    }
}

/*extension SideMenuCell {
    var isDetailViewHidden: Bool {
        return detailView.isHidden
    }
    
    func showDetailView() {
        detailView.isHidden = false
    }
    
    func hideDetailView() {
        detailView.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if isDetailViewHidden, selected {
            showDetailView()
        } else {
            hideDetailView()
        }
    }
    
}   */

