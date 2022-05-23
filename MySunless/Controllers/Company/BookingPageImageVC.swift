//
//  BookingPageImageVC.swift
//  MySunless
//
//  Created by Daydream Soft on 07/03/22.
//

import UIKit
import Alamofire
import DKImagePickerController

class BookingPageImageVC: UIViewController {

    @IBOutlet var vw_mainView: UIView!
    @IBOutlet var vw_top: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblImageName: UILabel!
    @IBOutlet var txtVwBookingText: UITextView!
    @IBOutlet var colview: UICollectionView!
    
    var token = String()
    var pickerController: DKImagePickerController!
    var assets: [DKAsset]?
    var arrImgs = [UIImage]()
    var isForBanner = false
    var isForGallary = false
    var delegate: UpdateBannerAndGallary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setInitially()
        hideKeyboardWhenTappedAround()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isForBanner {
            lblTitle.text = "Booking Page Banner Image"
            lblImageName.text = "Banner Image"
        }
        if isForGallary {
            lblTitle.text = "Booking Page Gallary Image"
            lblImageName.text = "Gallary Image"
        }
    }
    
    func setInitially() {
        vw_mainView.layer.borderWidth = 1.0
        vw_mainView.layer.borderColor = UIColor.init("#005CC8").cgColor
        vw_top.layer.cornerRadius = 12
        vw_top.layer.masksToBounds = true
        vw_top.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let attributedString = NSMutableAttributedString.init(string: txtVwBookingText.text)
        let range = (txtVwBookingText.text as NSString).range(of: "Booking")
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init("#15B0DA"), range: range)
        txtVwBookingText.attributedText = attributedString
        txtVwBookingText.font = UIFont(name: "Roboto-Regular", size: 15)
        txtVwBookingText.textAlignment = .justified
        txtVwBookingText.isUserInteractionEnabled = true
        txtVwBookingText.isEditable = false
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapResponse(recognizer:)))
        tapGesture.numberOfTapsRequired = 1
        txtVwBookingText.addGestureRecognizer(tapGesture)
    }
    
    func validation() -> Bool {
        if assets?.count == 0 {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please Select Image", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func callAddBannerImageAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = [:]

        APIUtilities.sharedInstance.uploadMultipleImages(url: BASE_URL + ADD_BANNER_IMAGE, keyName: "bannerImage[]", imageArrData: arrImgs, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? String {
                           // AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.alert(message: response)
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                        }
                    }
                }
            }
        }
    }
    
    func callAddGallaryImageAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = [:]
        
        APIUtilities.sharedInstance.uploadMultipleImages(url: BASE_URL + ADD_GALLARY_IMAGE, keyName: "gallaryImage[]", imageArrData: arrImgs, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? String {
                          //  AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.alert(message: response)
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                        }
                    }
                }
            }
        }
    }
    
    func alert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        let action1 = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) { (dd) -> Void in
            
            if self.isForBanner {
                self.dismiss(animated: true) {
                    self.delegate?.updateBannerAndGallaryList(bannerImageList: true, galleryImageList: false)
                }
            } else if self.isForGallary {
                self.dismiss(animated: true) {
                    self.delegate?.updateBannerAndGallaryList(bannerImageList: false, galleryImageList: true)
                }
            }
            
        }
        alert.addAction(action1)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showImagePicker() {
        if let assets = self.assets {
            pickerController.select(assets: assets)
        }
        pickerController.exportStatusChanged = { status in
            switch status {
                case .exporting:
                    print("exporting")
                case .none:
                    print("none")
            }
        }
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            self.updateAssets(assets: assets)
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            pickerController.modalPresentationStyle = .formSheet
        }
        if pickerController.UIDelegate == nil {
            pickerController.UIDelegate = AssetClickHandler()
        }
        if pickerController.inline {
            self.showInlinePicker()
        } else {
            self.present(pickerController, animated: true) {}
        }
    }
    
    func updateAssets(assets: [DKAsset]) {
      //  print("didSelectAssets")
        self.assets = assets
        self.colview?.reloadData()
        if pickerController.exportsWhenCompleted {
            for asset in assets {
                if let error = asset.error {
                    print("exporterDidEndExporting with error:\(error.localizedDescription)")
                } else {
                    print("exporterDidEndExporting:\(asset.localTemporaryPath!)")
                }
            }
        }
    }
    
    // MARK: - Inline Mode
    func showInlinePicker() {
        let pickerView = self.pickerController.view!
        pickerView.frame = CGRect(x: 0, y: 170, width: self.view.bounds.width, height: 200)
        self.view.addSubview(pickerView)
        
        let doneButton = UIButton(type: .custom)
        doneButton.setTitleColor(UIColor.blue, for: .normal)
        doneButton.addTarget(self, action: #selector(done), for: .touchUpInside)
        doneButton.frame = CGRect(x: 0, y: pickerView.frame.maxY, width: pickerView.bounds.width / 2, height: 50)
        self.view.addSubview(doneButton)
        self.pickerController.selectedChanged = { [unowned self] in
            self.updateDoneButtonTitle(doneButton)
        }
        self.updateDoneButtonTitle(doneButton)
        
        let albumButton = UIButton(type: .custom)
        albumButton.setTitleColor(UIColor.blue, for: .normal)
        albumButton.setTitle("Album", for: .normal)
        albumButton.addTarget(self, action: #selector(showAlbum), for: .touchUpInside)
        albumButton.frame = CGRect(x: doneButton.frame.maxX, y: doneButton.frame.minY, width: doneButton.bounds.width, height: doneButton.bounds.height)
        self.view.addSubview(albumButton)
    }
    
    func updateDoneButtonTitle(_ doneButton: UIButton) {
        doneButton.setTitle("Done(\(self.pickerController.selectedAssets.count))", for: .normal)
    }
    
    @objc func done() {
        self.updateAssets(assets: self.pickerController.selectedAssets)
    }
    
    @objc func showAlbum() {
        let pickerController = DKImagePickerController()
        pickerController.maxSelectableCount = self.pickerController.maxSelectableCount
        pickerController.select(assets: self.pickerController.selectedAssets)
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            self.updateAssets(assets: assets)
            self.pickerController.setSelectedAssets(assets: assets)
        }
        self.present(pickerController, animated: true, completion: nil)
    }
    
    @objc func tapResponse(recognizer: UITapGestureRecognizer) {
        let location: CGPoint = recognizer.location(in: txtVwBookingText)
        let position: CGPoint = CGPoint(x: location.x, y: location.y)
        let tapPosition: UITextPosition? = txtVwBookingText.closestPosition(to: position)
        if tapPosition != nil {
            let textRange: UITextRange? = txtVwBookingText.tokenizer.rangeEnclosingPosition(tapPosition!, with: UITextGranularity.word, inDirection: UITextDirection(rawValue: 1))
            if textRange != nil {
                let tappedWord: String? = txtVwBookingText.text(in: textRange!)
                if (tappedWord == "Booking") {
                    print("tapped word : ", tappedWord ?? "")
                    //                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "ManageEmployeeVC") as! ManageEmployeeVC
                    //                    self.navigationController?.pushViewController(VC, animated: true)
                }
            }
        }
    }
    
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSelectImageClick(_ sender: UIButton) {
        arrImgs.removeAll()
        showImagePicker()
    }
    
    @IBAction func btnUploadImageClick(_ sender: UIButton) {
        if isForBanner {
            if validation() {
                callAddBannerImageAPI()
            }
        } else if isForGallary {
            if validation() {
                callAddGallaryImageAPI()
            }
        }
    }
}

//MARK:- UICollectionview DataSource Methods
extension BookingPageImageVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assets?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colview.dequeueReusableCell(withReuseIdentifier: "BookingPageImageCell", for: indexPath) as! BookingPageImageCell
        cell.imgView.layer.cornerRadius = 12
        
        let asset = self.assets![indexPath.row]
        let layout = colview.collectionViewLayout as! UICollectionViewFlowLayout
        asset.fetchImage(with: layout.itemSize.toPixel(), completeBlock: { image, info in
            cell.imgView.image = image
            
        })
        self.arrImgs.append(cell.imgView.image ?? UIImage())
        
        return cell
    }
}

//MARK:- UICollectionview Delegate Methods
extension BookingPageImageVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (colview.frame.width/3.0) - 5, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

// MARK: - DKImagePickerControllerBaseUIDelegate
class AssetClickHandler: DKImagePickerControllerBaseUIDelegate {
    override func imagePickerController(_ imagePickerController: DKImagePickerController, didSelectAssets: [DKAsset]) {
        //tap to select asset
        //use this place for asset selection customisation
       // print("didClickAsset for selection")
    }
    
    override func imagePickerController(_ imagePickerController: DKImagePickerController, didDeselectAssets: [DKAsset]) {
        //tap to deselect asset
        //use this place for asset deselection customisation
       // print("didClickAsset for deselection")
    }
}


class BookingPageImageCell: UICollectionViewCell {
    
    @IBOutlet var cellView: UIView!
    @IBOutlet var imgView: UIImageView!
    
}
