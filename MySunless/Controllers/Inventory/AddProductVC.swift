//
//  AddProductVC.swift
//  MySunless
//
//  Created by Daydream Soft on 29/03/22.
//

import UIKit
import iOSDropDown
import Alamofire
import Kingfisher

protocol AddProductProtocol {
   // func reloadCollectionViews()
    func callShowProdCatInventoryAPI()
}

class AddProductVC: UIViewController {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet weak var vw_BarcodeId: UIView!
    @IBOutlet weak var txtBarcodeId: UITextField!
    @IBOutlet weak var vw_ProductCategory: UIView!
    @IBOutlet weak var txtProductCategory: DropDown!
    @IBOutlet weak var cltnProductCategory: UICollectionView!
    @IBOutlet weak var vw_Brand: UIView!
    @IBOutlet weak var txtBrand: DropDown!
    @IBOutlet weak var cltnBrand: UICollectionView!
    @IBOutlet weak var vw_ProductName: UIView!
    @IBOutlet weak var txtProductName: UITextField!
    @IBOutlet weak var vw_ProductDescription: UIView!
    @IBOutlet weak var txtProductDescription: UITextView!
    @IBOutlet weak var vw_ItemCost: UIView!
    @IBOutlet weak var txtItemCost: UITextField!
    @IBOutlet weak var vw_SellingPrice: UIView!
    @IBOutlet weak var txtSellingPrice: UITextField!
    @IBOutlet weak var vw_ProductImage: UIView!
    @IBOutlet weak var vw_NoOfProduct: UIView!
    @IBOutlet weak var txtNoOfProduct: UITextField!
    @IBOutlet weak var switchTaxableSales: UISwitch!
    @IBOutlet weak var imgProduct: UIImageView!
    
    var tittle = String()
    var barcode = String()
    var token = String()
    var arrChooseProdCat = [ShowProductCategoryInventory]()
    var selectedProdCat = String()
    var arrProdCat = [String]()
    var arrSelectedProdCatIds = [String]()
    var arrChooseProdBrand = [ShowProductBrand]()
    var selectedProdBrand = String()
    var arrProdBrand = [String]()
    var arrSelectedProdBrandIds = [String]()
    var tap = UITapGestureRecognizer()
    var tap1 = UITapGestureRecognizer()
    var switchValue = Int()
    var arrGetProdByBarcode = [GetProdByBarcode]()
    var isEdit = false
    let imagePicker = UIImagePickerController()
    var productId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setIntially()
        hideKeyboardWhenTappedAround()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        
        if switchTaxableSales.isOn {
            switchValue = 1
        } else {
            switchValue = 0
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callShowProdCatInventoryAPI()
        callShowProdBrandAPI()
    }
    
    func setIntially() {
        vw_BarcodeId.layer.borderWidth = 0.5
        vw_BarcodeId.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_ProductCategory.layer.borderWidth = 0.5
        vw_ProductCategory.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_Brand.layer.borderWidth = 0.5
        vw_Brand.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_Brand.layer.borderWidth = 0.5
        vw_Brand.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_ProductName.layer.borderWidth = 0.5
        vw_ProductName.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_ProductDescription.layer.borderWidth = 0.5
        vw_ProductDescription.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_ItemCost.layer.borderWidth = 0.5
        vw_ItemCost.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_SellingPrice.layer.borderWidth = 0.5
        vw_SellingPrice.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_ProductImage.layer.borderWidth = 0.5
        vw_ProductImage.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_NoOfProduct.layer.borderWidth = 0.5
        vw_NoOfProduct.layer.borderColor = UIColor.init("15B0DA").cgColor
        imgProduct.layer.cornerRadius = 12
        lblTitle.text = tittle
        txtBarcodeId.text = barcode
        
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.delegate = self
        cltnProductCategory?.addGestureRecognizer(tap)
        cltnProductCategory.isHidden = true
        
        tap1.numberOfTapsRequired = 1
        tap1.numberOfTouchesRequired = 1
        tap1.delegate = self
        cltnBrand?.addGestureRecognizer(tap1)
        cltnBrand.isHidden = true
        
        txtProductCategory.delegate = self
        txtBrand.delegate = self
        txtProductName.delegate = self
        txtProductDescription.delegate = self
        txtItemCost.delegate = self
        txtSellingPrice.delegate = self
        txtNoOfProduct.delegate = self
    }
    
    func setValidation() -> Bool {
        if txtProductName.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter product title", viewController: self)
        } else if txtProductDescription.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter product short description", viewController: self)
        } else if txtItemCost.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter cost for employee to bring product in", viewController: self)
        } else if txtSellingPrice.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter selling price to consumer", viewController: self)
        } else if txtNoOfProduct.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter no of product in stock", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func callGetProdByBarcodeAPI(cat: Bool, brand: Bool) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["barcode": barcode]
        if (APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + GET_PROD_BY_BARCODE, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrGetProdByBarcode.removeAll()
                            
                            for dict in response {
                                self.arrGetProdByBarcode.append(GetProdByBarcode(dictionary: dict)!)
                            }
                            for dic in self.arrGetProdByBarcode {
                                if self.arrSelectedProdCatIds.count == 0 {
                                    self.arrSelectedProdCatIds = dic.productCategory?.components(separatedBy: ",") ?? []
                                }
                                self.arrSelectedProdBrandIds = dic.productBrand?.components(separatedBy: ",") ?? []
                                self.txtProductName.text = dic.productTitle
                                self.txtProductDescription.text = dic.productDescription
                                self.txtItemCost.text = "\(dic.companyCost ?? 0)"
                                self.txtSellingPrice.text = "\(dic.sellingPrice ?? 0)"
                                let imgUrl = URL(string: dic.productImage ?? "")
                                self.imgProduct.kf.setImage(with: imgUrl)
                                self.txtNoOfProduct.text = "\(dic.noofPorduct ?? 0)"
                                self.productId = dic.id ?? 0
                                
                                if dic.isactive == 1 {
                                    self.switchTaxableSales.setOn(true, animated: false)
                                } else if dic.isactive == 0 {
                                    self.switchTaxableSales.setOn(false, animated: false)
                                }
                            }
                            if cat {
                                self.addProdCatById()
                            } else if brand {
                                self.addProdBrandById()
                            }
                            
                        }
                    } else {
                        if let message = res.value(forKey: "response") as? String {
                            print(message)
                        }
                    }
                }
            }
        }
    }
    
    func callShowProdBrandAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = [:]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_PRODUCT_BRAND, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrChooseProdBrand.removeAll()
                            for dict in response {
                                self.arrChooseProdBrand.append(ShowProductBrand(dict: dict))
                            }
                            self.didSelectProductBrand()
                            
                            self.callGetProdByBarcodeAPI(cat: false, brand: true)
                        }
                    } else {
                        if let message = res.value(forKey: "response") as? String {
                            print(message)
                        }
                    }
                }
            }
        }
    }
    
    func callProductBarcodeAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        if isEdit {
            params = ["barcode": txtBarcodeId.text ?? "",
                      "category": arrSelectedProdCatIds.joined(separator: ","),
                      "brand": arrSelectedProdBrandIds.joined(separator: ","),
                      "productname": txtProductName.text ?? "",
                      "description": txtProductDescription.text ?? "",
                      "cost": txtItemCost.text ?? "",
                      "price": txtSellingPrice.text ?? "",
                      "taxable": switchValue,
                      "stock": txtNoOfProduct.text ?? "",
                      "prodid": productId
            ]
        } else {
            params = ["barcode": txtBarcodeId.text ?? "",
                      "category": arrSelectedProdCatIds.joined(separator: ","),
                      "brand": arrSelectedProdBrandIds.joined(separator: ","),
                      "productname": txtProductName.text ?? "",
                      "description": txtProductDescription.text ?? "",
                      "cost": txtItemCost.text ?? "",
                      "price": txtSellingPrice.text ?? "",
                      "taxable": switchValue,
                      "stock": txtNoOfProduct.text ?? ""
            ]
        }
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        let img: UIImage = imgProduct.image ?? UIImage()
        let imgData = img.pngData()
        APIUtilities.sharedInstance.UuuploadImage(url: BASE_URL + ADD_PRODUCT, keyName: "prodimage", imageData: imgData, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: message)
                            self.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: message)
                        }
                    }
                }
            }
        }
    }
    
    func didSelectProductCategory() {
        self.txtProductCategory.optionArray = self.arrChooseProdCat.map { $0.Category }
        self.txtProductCategory.optionIds = self.arrChooseProdCat.map { $0.id }
        self.txtProductCategory.didSelect{(selectedText, index ,id) in
            self.txtProductCategory.selectedIndex = index
            self.cltnProductCategory.isHidden = false
            self.selectedProdCat = selectedText
            if !self.arrProdCat.contains(self.selectedProdCat) {
                self.arrProdCat.append(self.selectedProdCat)
                self.arrSelectedProdCatIds.append("\(id)")
            }
            DispatchQueue.main.async {
                self.cltnProductCategory.reloadData()
            }
        }
    }
    
    func didSelectProductBrand() {
        self.txtBrand.optionArray = self.arrChooseProdBrand.map { $0.Brand }
        self.txtBrand.optionIds = self.arrChooseProdBrand.map { $0.id }
        self.txtBrand.didSelect{(selectedText, index, id) in
            self.txtBrand.selectedIndex = index
            self.cltnBrand.isHidden = false
            self.selectedProdBrand = selectedText
            if !self.arrProdBrand.contains(self.selectedProdBrand) {
                self.arrProdBrand.append(self.selectedProdBrand)
                self.arrSelectedProdBrandIds.append("\(id)")
            }
            DispatchQueue.main.async {
                self.cltnBrand.reloadData()
            }
        }
    }
    
    func addProdCatById() {
        var arrCat = [ShowProductCategoryInventory]()
        var array = [String]()
        for i in arrSelectedProdCatIds {
            if !arrChooseProdCat.contains(where: {$0.id == Int(i)}) {
                arrSelectedProdCatIds = arrSelectedProdCatIds.filter{$0 != i}
            }
        }
        if arrSelectedProdCatIds.count == 0 {
            arrProdCat.removeAll()
        } else {
            for i in arrSelectedProdCatIds {
                if arrChooseProdCat.contains(where: {$0.id == Int(i)}) {
                    arrCat = self.arrChooseProdCat.filter{$0.id == Int(i)}
                    array.append(contentsOf: arrCat.map{$0.Category})
                }
            }
            
            if arrProdCat.count == 0 {
                arrProdCat = array
            } else {
                for cat in arrProdCat {
                    if !arrProdCat.contains(cat) {
                        arrProdCat.append(cat)
                    }
                }
            }
        }
        self.txtProductCategory.isHidden = true
        self.cltnProductCategory.isHidden = false
        self.cltnProductCategory.reloadData()
    }
    
    func addProdBrandById() {
        var arrBrand = [ShowProductBrand]()
        for i in arrSelectedProdBrandIds {
            if !arrChooseProdBrand.contains(where: {$0.id == Int(i)}) {
                arrSelectedProdBrandIds = arrSelectedProdBrandIds.filter{$0 != i}
            }
        }
        if arrSelectedProdBrandIds.count == 0 {
            arrProdBrand.removeAll()
        } else {
            for i in self.arrSelectedProdBrandIds {
                if arrChooseProdBrand.contains(where: {$0.id == Int(i)}) {
                    arrBrand = self.arrChooseProdBrand.filter{$0.id == Int(i)}
                    self.arrProdBrand.append(contentsOf: arrBrand.map{$0.Brand})
                }
            }
        }
        self.txtBrand.isHidden = true
        self.cltnBrand.isHidden = false
        self.cltnBrand.reloadData()
    }
    
    @IBAction func switchTaxableValueChanged(_ sender: UISwitch) {
        if switchTaxableSales.isOn {
            switchValue = 1
        } else {
            switchValue = 0
        }
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
     
    @IBAction func btnSelectImageClick(_ sender: UIButton) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func btnSubmitProductClick(_ sender: UIButton) {
        if setValidation() {
            callProductBarcodeAPI()
        }
    }
    
    @IBAction func btnAddNewCategoryClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ProductCategoryVC") as! ProductCategoryVC
        VC.modalPresentationStyle = .overCurrentContext
        VC.modalTransitionStyle = .crossDissolve
        VC.delegate = self
      //  VC.delegateCatList = self
        self.present(VC, animated: true, completion: nil)
    }
    
    @IBAction func btnAddNewBrandClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddBrandVC") as! AddBrandVC
        VC.modalPresentationStyle = .overCurrentContext
        VC.modalTransitionStyle = .crossDissolve
        self.present(VC, animated: true, completion: nil)
    }
    
    @IBAction func btntaxableSaleClick(_ sender: UIButton) {
        AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: "This item will be subject to the sales tax rate you entered in your Company Information page")
    }
    
    @objc func closeProdCatCellClick(_ sender: UIButton) {
        arrProdCat.remove(at: sender.tag)
        arrSelectedProdCatIds.remove(at: sender.tag)
        cltnProductCategory.reloadData()
    }
    
    @objc func closeProdBrandCellClick(_ sender: UIButton) {
        arrProdBrand.remove(at: sender.tag)
        arrSelectedProdBrandIds.remove(at: sender.tag)
        cltnBrand.reloadData()
    }
}

extension AddProductVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cltnProductCategory {
            return arrProdCat.count
        } else if collectionView == cltnBrand {
            return arrProdBrand.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! UserCell
        cell.cellView.layer.cornerRadius = 8
        if collectionView == cltnProductCategory {
            cell.lblName.text = arrProdCat[indexPath.item]
            cell.btnClose.tag = indexPath.item
            cell.btnClose.addTarget(self, action: #selector(closeProdCatCellClick(_:)), for: .touchUpInside)
        } else if collectionView == cltnBrand {
            cell.lblName.text = arrProdBrand[indexPath.item]
            cell.btnClose.tag = indexPath.item
            cell.btnClose.addTarget(self, action: #selector(closeProdBrandCellClick(_:)), for: .touchUpInside)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 38)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cltnProductCategory {
            txtProductCategory.showList()
        } else if collectionView == cltnBrand {
            txtBrand.showList()
        }
    }
}

extension AddProductVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer == tap {
            let point = touch.location(in: cltnProductCategory)
            if let indexPath = cltnProductCategory?.indexPathForItem(at: point),
               let cell = cltnProductCategory?.cellForItem(at: indexPath) {
                return touch.location(in: cell).y > 50
            }
            txtProductCategory.showList()
            return false
        } else if gestureRecognizer == tap1 {
            let point = touch.location(in: cltnBrand)
            if let indexPath = cltnBrand?.indexPathForItem(at: point),
               let cell = cltnBrand?.cellForItem(at: indexPath) {
                return touch.location(in: cell).y > 50
            }
            txtBrand.showList()
            return false
        }
        return true
    }
}

extension AddProductVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtProductName.resignFirstResponder()
        txtItemCost.resignFirstResponder()
        txtSellingPrice.resignFirstResponder()
        txtNoOfProduct.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        txtProductCategory.resignFirstResponder()
        txtBrand.resignFirstResponder()
    }
}

extension AddProductVC: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        txtProductDescription.endEditing(true)
        txtProductDescription.resignFirstResponder()
    }
}

extension AddProductVC: AddProductProtocol {
//    func reloadCollectionViews() {
//        cltnProductCategory.reloadData()
//        cltnBrand.reloadData()
//    }
    
    func callShowProdCatInventoryAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = [:]
        if (APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_PRODUCT_CATEGORY_INVENTORY, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrChooseProdCat.removeAll()
                            for dict in response {
                                self.arrChooseProdCat.append(ShowProductCategoryInventory(dict: dict))
                            }
                            self.didSelectProductCategory()
                            
                            self.callGetProdByBarcodeAPI(cat: true, brand: false)
                        }
                    } else {
                        if let message = res.value(forKey: "response") as? String {
                            print(message)
                        }
                    }
                }
            }
        }
    }
}

//MARK:- ImagePickerController Delegate Methods
extension AddProductVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imgProduct.contentMode = .scaleAspectFill
            imgProduct.image = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgProduct.contentMode = .scaleAspectFill
            imgProduct.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
}
