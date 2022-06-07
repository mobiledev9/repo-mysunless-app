import TreeTableView

protocol SideMenuViewControllerDelegate {
        func selectedCell(_ row: Int)
    }

class SideMenuVC: UIViewController {
    
    @IBOutlet private weak var treeTableView: TreeTableView!
    
    var delegate: SideMenuViewControllerDelegate?

    var adminCategories: [Category] = [Category(name: "Dashboard", image: UIImage(named: "dashboard")!, subcategories: []),
                                  Category(name: "Clients", image: UIImage(named: "clients")!, subcategories: []),
                                  Category(name: "Appointments", image: UIImage(named: "appointment")!, subcategories: []),
                                  Category(name: "Packages", image: UIImage(named: "package")!, subcategories: []),
                                  Category(name: "List of Subscribers", image: UIImage(named: "list")!, subcategories: []),
                                  Category(name: "Posts", image: UIImage(named: "post")!, subcategories: []),
                                  Category(name: "Manage Coupon", image: UIImage(named: "coupon")!, subcategories: []),
                                  Category(name: "Get Help!", image: UIImage(named: "help")!, subcategories: []),
                                  Category(name: "Reports", image: UIImage(named: "report")!, subcategories: [Category(name: "Subscription", image: UIImage(named: "subscription")!, subcategories: []),
                                                                            Category(name: "Auto-Renew", image: UIImage(named: "auto-renew")!, subcategories: []),
                                                                            Category(name: "Event List", image: UIImage(named: "appointment")!, subcategories: []),
                                                                            Category(name: "Order List", image: UIImage(named: "orderlist")!, subcategories: []),
                                                                            Category(name: "Sales Report", image: UIImage(named: "salesReport")!, subcategories: []),
                                                                            Category(name: "Bug Report", image: UIImage(named: "bug-report")!, subcategories: []),
                                                                            Category(name: "Payment List", image: UIImage(named: "payment-list")!, subcategories: []),
                                                                            Category(name: "Login Log", image: UIImage(named: "login-log")!, subcategories: [])
                                  ]),
                                  Category(name: "API", image: UIImage(named: "api")!, subcategories:  [Category(name: "Email Setting", image: UIImage(named: "email-setting")!, subcategories: []),
                                                                         Category(name: "Payment Setup", image: UIImage(named: "payment-list")!, subcategories: []),
                                                                         Category(name: "SMS Setup", image: UIImage(named: "sms-setup")!, subcategories: [])
                                  ]),
                                  Category(name: "Page Setting", image: UIImage(named: "pageSetting")!, subcategories:  [Category(name: "Dashboard Settings", image: UIImage(named: "speed-dashboard")!, subcategories: []),
                                                                                  Category(name: "Tutorial Permission", image: UIImage(named: "help")!, subcategories: []),
                                                                                  Category(name: "Tutorials", image: UIImage(named: "help")!, subcategories: []),
                                                                                  Category(name: "Client", image: UIImage(named: "clients")!, subcategories: []),
                                                                                  Category(name: "Appointment", image: UIImage(named: "appointment")!, subcategories: []),
                                                                                  Category(name: "Product", image: UIImage(named: "salesReport")!, subcategories: []),
                                                                                  Category(name: "Services", image: UIImage(named: "services")!, subcategories: []),
                                                                                  Category(name: "Membership", image: UIImage(named: "membership")!, subcategories: []),
                                                                                  Category(name: "Order", image: UIImage(named: "order")!, subcategories: [Category(name: "Order Settings", image: UIImage(named: "sent")!, subcategories: []),
                                                                                                                          Category(name: "List of Order", image: UIImage(named: "list")!, subcategories: [])
                                                                                  ]),
                                                                                  Category(name: "To-Do", image: UIImage(named: "to-do")!, subcategories: []),
                                                                                  Category(name: "Profile", image: UIImage(named: "user-profile")!, subcategories: []),
                                                                                  Category(name: "Note", image: UIImage(named: "notes")!, subcategories: []),
                                                                                  Category(name: "Communication", image: UIImage(named: "communications")!, subcategories: []),
                                                                                  Category(name: "Api", image: UIImage(named: "api")!, subcategories: []),
                                                                                  Category(name: "Data Backup", image: UIImage(named: "data-backup")!, subcategories: []),
                                                                                  Category(name: "Employees", image: UIImage(named: "employees")!, subcategories: []),
                                                                                  Category(name: "FAQS", image: UIImage(named: "help")!, subcategories: [])
                                  ]),
                                  Category(name: "Tutorial", image: UIImage(named: "tutorial")!, subcategories: [])
    ]
    
    var subscriberCategories: [Category] = [Category(name: "Dashboard", image: UIImage(named: "dashboard")!, subcategories: []),
                                       Category(name: "Clients", image: UIImage(named: "clients")!, subcategories: []),
                                       Category(name: "Appointments", image: UIImage(named: "appointment")!, subcategories: []),
                                       Category(name: "Order", image: UIImage(named: "sent")!, subcategories: []),
                                       Category(name: "Memberships", image: UIImage(named: "package")!, subcategories: []),
                                       Category(name: "ToDo", image: UIImage(named: "to-do")!, subcategories: []),
                                       Category(name: "Inventory", image: UIImage(named: "inventory")!, subcategories: []),
                                       Category(name: "Analytics", image: UIImage(named: "analytics")!, subcategories: [Category(name: "Orders", image: UIImage(named: "orderlist")!, subcategories: []),
                                                                                                                   Category(name: "Sales Report", image: UIImage(named: "salesReport")!, subcategories: []),
                                                                                                                   Category(name: "Payment List", image: UIImage(named: "payment-list")!, subcategories: [])
                                       ]),
                                       Category(name: "Company Settings", image: UIImage(named: "company-settings")!, subcategories: [Category(name: "Information", image: UIImage(named: "information")!, subcategories: []),
                                                                                                                              Category(name: "Website", image: UIImage(named: "website")!, subcategories: []),
                                                                                                                              Category(name: "List Of Services", image: UIImage(named: "list")!, subcategories: []),
                                                                                                                              Category(name: "Member's Package", image: UIImage(named: "package")!, subcategories: []),
                                                                                                                              Category(name: "Performance", image: UIImage(named: "performance")!, subcategories: []),
                                                                                                                              Category(name: "Login Log", image: UIImage(named: "login-log")!, subcategories: [])
                                       ]),
                                       Category(name: "Communication", image: UIImage(named: "sms-setup")!, subcategories: [Category(name: "Templates", image: UIImage(named: "list")!, subcategories: []),
                                                                                                                            Category(name: "Email Templates", image: UIImage(named: "email-setting")!, subcategories: []),
                                                                                                                            Category(name: "Appointment", image: UIImage(named: "appointment")!, subcategories: [])
                                       ]),
                                       Category(name: "API Setting", image: UIImage(named: "api")!, subcategories: [Category(name: "Email", image: UIImage(named: "email-setting")!, subcategories: []),
                                                                                                                        Category(name: "SMS", image: UIImage(named: "sms-setup")!, subcategories: []),
                                                                                                                        Category(name: "Payment Setup", image: UIImage(named: "payment")!, subcategories: [])
                                       ]),
                                       Category(name: "Import/Export", image: UIImage(named: "importexport")!, subcategories: [Category(name: "Export Contacts", image: UIImage(named: "export")!, subcategories: []),
                                                                                                                    Category(name: "Import Contacts", image: UIImage(named: "import")!, subcategories: [])
                                       ]),
                                       Category(name: "My Account", image: UIImage(named: "user-profile")!, subcategories: [Category(name: "Archive List", image: UIImage(named: "archive-list")!, subcategories: []),
                                                                                                                    Category(name: "Manage Employee", image: UIImage(named: "employees")!, subcategories: [])
                                       ])
    ]
    
    private var nodes: [Node] = []
    var usertype = String()
    var revealSideMenuOnTop: Bool = true
    var sideMenuTrailingConstraint: NSLayoutConstraint!
    var sideMenuRevealWidth: CGFloat = 260
    let paddingForRotation: CGFloat = 150
    var isExpanded: Bool = false
    var sideMenuShadowView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTreeTableView()
        usertype = UserDefaults.standard.value(forKey: "usertype") as? String ?? ""
        
    }
    
    private func configureTreeTableView() {
        treeTableView.register(SideMenuCell.nib, forCellReuseIdentifier: SideMenuCell.identifier)
        treeTableView.treeDataSource = self
        treeTableView.treeDelegate = self
        treeTableView.tableFooterView = UIView()
    }
    
    private func addNode(from category: Category) {
        let node = Node(name: category.name, image: category.image)
        nodes.append(node)
        category.subcategories.forEach {
            addSubnodes(from: $0, to: node)
        }
    }
    
    private func addSubnodes(from category: Category, to parentNode: Node) {
        let node = Node(name: category.name, image: category.image)
        node.parentNode = parentNode
        nodes.append(node)
        category.subcategories.forEach {
            addSubnodes(from: $0, to: node)
        }
    }
    
}

//MARK: - TreeTableViewDataSource implementation
extension SideMenuVC: TreeTableViewDataSource {
    func configureNodes() -> [Node] {
        usertype = UserDefaults.standard.value(forKey: "usertype") as? String ?? ""
        if usertype == "subscriber" {
            subscriberCategories.forEach {
                addNode(from: $0)
            }
        } else if usertype == "Admin" {
            adminCategories.forEach {
                addNode(from: $0)
            }
        }
        return nodes
    }
}

//MARK: - TreeTableViewDelegate implementation
extension SideMenuVC: TreeTableViewDelegate {
    func treeTableView(_ treeTableView: TreeTableView, cellForRowAt indexPath: IndexPath, node: Node) -> UITableViewCell {
        let cell = treeTableView.dequeueReusableCell(withIdentifier: SideMenuCell.identifier, for: indexPath) as! SideMenuCell
        cell.titleLabel.text = node.name
        cell.iconImageView.image = node.image
        
        cell.expandImageView.isHidden = true
            
        if usertype == "subscriber" {
            switch node.name {
                case "Dashboard", "Clients", "ToDo", "Inventory":
                    if UserDefaults.standard.bool(forKey: "currentSubscription") == true {
                        cell.vw_lock.isHidden = true
                        cell.isUserInteractionEnabled = true
                    } else {
                        cell.vw_lock.isHidden = false
                        cell.isUserInteractionEnabled = false
                    }
                case "Analytics":
                    cell.iconImageLeadingConstraint.constant = 16
                    cell.expandImageView.isHidden = false
                    cell.vw_lock.isHidden = true
                case "API Setting":
                    cell.iconImageLeadingConstraint.constant = 16
                    cell.expandImageView.isHidden = false
                    if UserDefaults.standard.bool(forKey: "currentSubscription") == true {
                        cell.vw_lock.isHidden = true
                        cell.isUserInteractionEnabled = true
                    } else {
                        cell.vw_lock.isHidden = false
                        cell.isUserInteractionEnabled = false
                    }
                case "Import/Export":
                    cell.iconImageLeadingConstraint.constant = 16
                    cell.expandImageView.isHidden = false
                    if UserDefaults.standard.bool(forKey: "currentSubscription") == true {
                        cell.vw_lock.isHidden = true
                        cell.isUserInteractionEnabled = true
                    } else {
                        cell.vw_lock.isHidden = false
                        cell.isUserInteractionEnabled = false
                    }
                case "Export Contacts":
                    cell.iconImageLeadingConstraint.constant = 35
                    cell.vw_lock.isHidden = true
                case "Import Contacts":
                    cell.iconImageLeadingConstraint.constant = 35
                    cell.vw_lock.isHidden = true
                case "Orders":
                    cell.iconImageLeadingConstraint.constant = 35
                    if UserDefaults.standard.bool(forKey: "currentSubscription") == true {
                        cell.vw_lock.isHidden = true
                        cell.isUserInteractionEnabled = true
                    } else {
                        cell.vw_lock.isHidden = false
                        cell.isUserInteractionEnabled = false
                    }
                case "Member's Package":
                    cell.iconImageLeadingConstraint.constant = 35
                    if UserDefaults.standard.bool(forKey: "currentSubscription") == true {
                        cell.vw_lock.isHidden = true
                        cell.isUserInteractionEnabled = true
                    } else {
                        cell.vw_lock.isHidden = false
                        cell.isUserInteractionEnabled = false
                    }
                case "Company Settings":
                    cell.iconImageLeadingConstraint.constant = 16
                    cell.expandImageView.isHidden = false
                    cell.vw_lock.isHidden = true
                case "My Account":
                    cell.iconImageLeadingConstraint.constant = 16
                    cell.expandImageView.isHidden = false
                    if UserDefaults.standard.bool(forKey: "currentSubscription") == true {
                        cell.vw_lock.isHidden = true
                        cell.isUserInteractionEnabled = true
                    } else {
                        cell.vw_lock.isHidden = false
                        cell.isUserInteractionEnabled = false
                    }
                case "Order":
                    cell.iconImageLeadingConstraint.constant = 16
                    if UserDefaults.standard.bool(forKey: "currentSubscription") == true {
                        cell.vw_lock.isHidden = true
                        cell.isUserInteractionEnabled = true
                    } else {
                        cell.vw_lock.isHidden = false
                        cell.isUserInteractionEnabled = false
                    }
                case "Sales Report":
                    cell.iconImageLeadingConstraint.constant = 35
                    cell.vw_lock.isHidden = true
                case "Payment List":
                    cell.iconImageLeadingConstraint.constant = 35
                    cell.vw_lock.isHidden = true
                case "Performance":
                    cell.iconImageLeadingConstraint.constant = 35
                    cell.vw_lock.isHidden = true
                case "Login Log":
                    cell.iconImageLeadingConstraint.constant = 35
                    cell.vw_lock.isHidden = true
                    cell.isUserInteractionEnabled = true
                case "Information":
                    cell.iconImageLeadingConstraint.constant = 35
                    cell.vw_lock.isHidden = true
                case "Templates":
                    cell.iconImageLeadingConstraint.constant = 35
                    cell.vw_lock.isHidden = true
                case "Website":
                    cell.iconImageLeadingConstraint.constant = 35
                    if UserDefaults.standard.bool(forKey: "currentSubscription") == true {
                        cell.vw_lock.isHidden = true
                        cell.isUserInteractionEnabled = true
                    } else {
                        cell.vw_lock.isHidden = false
                        cell.isUserInteractionEnabled = false
                    }
                case "List Of Services":
                    cell.iconImageLeadingConstraint.constant = 35
                    if UserDefaults.standard.bool(forKey: "currentSubscription") == true {
                        cell.vw_lock.isHidden = true
                        cell.isUserInteractionEnabled = true
                    } else {
                        cell.vw_lock.isHidden = false
                        cell.isUserInteractionEnabled = false
                    }
                case "Memberships":
                    cell.iconImageLeadingConstraint.constant = 16
                    if UserDefaults.standard.bool(forKey: "currentSubscription") == true {
                        cell.vw_lock.isHidden = true
                        cell.isUserInteractionEnabled = true
                    } else {
                        cell.vw_lock.isHidden = false
                        cell.isUserInteractionEnabled = false
                    }
                case "Communication":
                    cell.iconImageLeadingConstraint.constant = 16
                    cell.expandImageView.isHidden = false
                    if UserDefaults.standard.bool(forKey: "currentSubscription") == true {
                        cell.vw_lock.isHidden = true
                        cell.isUserInteractionEnabled = true
                    } else {
                        cell.vw_lock.isHidden = false
                        cell.isUserInteractionEnabled = false
                    }
                case "Archive List":
                    cell.iconImageLeadingConstraint.constant = 35
                    cell.vw_lock.isHidden = true
                case "Manage Employee":
                    cell.iconImageLeadingConstraint.constant = 35
                    cell.vw_lock.isHidden = true
                case "Email":
                    cell.iconImageLeadingConstraint.constant = 35
                    cell.vw_lock.isHidden = true
                case "Email Templates":
                    cell.iconImageLeadingConstraint.constant = 35
                    cell.vw_lock.isHidden = true
                case "Appointments":
                    cell.iconImageLeadingConstraint.constant = 16
                    if UserDefaults.standard.bool(forKey: "currentSubscription") == true {
                        cell.vw_lock.isHidden = true
                        cell.isUserInteractionEnabled = true
                    } else {
                        cell.vw_lock.isHidden = false
                        cell.isUserInteractionEnabled = false
                    }
                case "Appointment":
                    cell.iconImageLeadingConstraint.constant = 35
                    cell.vw_lock.isHidden = true
                case "SMS":
                    cell.iconImageLeadingConstraint.constant = 35
                    cell.vw_lock.isHidden = true
                case "Payment Setup":
                    cell.iconImageLeadingConstraint.constant = 35
                    cell.vw_lock.isHidden = true
                default:
                    cell.iconImageLeadingConstraint.constant = 16
                    cell.expandImageView.isHidden = true
                    cell.vw_lock.isHidden = false
            }
        } else if usertype == "Admin" {
            switch node.name {
                case "Subscription":
                    cell.iconImageLeadingConstraint.constant = 35
                case "Auto-Renew":
                    cell.iconImageLeadingConstraint.constant = 35
                case "Event List":
                    cell.iconImageLeadingConstraint.constant = 35
                case "Order List":
                    cell.iconImageLeadingConstraint.constant = 35
                case "Sales Report":
                    cell.iconImageLeadingConstraint.constant = 35
                case "Bug Report":
                    cell.iconImageLeadingConstraint.constant = 35
                case "Payment List":
                    cell.iconImageLeadingConstraint.constant = 35
                case "Login Log":
                    cell.iconImageLeadingConstraint.constant = 35
                case "Email Setting":
                    cell.iconImageLeadingConstraint.constant = 35
                case "Payment Setup":
                    cell.iconImageLeadingConstraint.constant = 35
                case "SMS Setup":
                    cell.iconImageLeadingConstraint.constant = 35
                case "Dashboard Settings":
                    cell.iconImageLeadingConstraint.constant = 35
                case "Tutorial Permission":
                    cell.iconImageLeadingConstraint.constant = 35
                case "Tutorials":
                    cell.iconImageLeadingConstraint.constant = 35
                case "Client":
                    cell.iconImageLeadingConstraint.constant = 35
                case "Appointment":
                    cell.iconImageLeadingConstraint.constant = 35
                case "Product":
                    cell.iconImageLeadingConstraint.constant = 35
                case "Services":
                    cell.iconImageLeadingConstraint.constant = 35
                case "Membership":
                    cell.iconImageLeadingConstraint.constant = 35
                case "Order":
                    cell.iconImageLeadingConstraint.constant = 35
                    cell.expandImageView.isHidden = false
                case "To-Do":
                    cell.iconImageLeadingConstraint.constant = 35
                case "Profile":
                    cell.iconImageLeadingConstraint.constant = 35
                case "Note":
                    cell.iconImageLeadingConstraint.constant = 35
                case "Communication":
                    cell.iconImageLeadingConstraint.constant = 35
                case "Api":
                    cell.iconImageLeadingConstraint.constant = 35
                case "Data Backup":
                    cell.iconImageLeadingConstraint.constant = 35
                case "Employees":
                    cell.iconImageLeadingConstraint.constant = 35
                case "FAQS":
                    cell.iconImageLeadingConstraint.constant = 35
                case "Order Settings":
                    cell.iconImageLeadingConstraint.constant = 50
                case "List of Order":
                    cell.iconImageLeadingConstraint.constant = 50
                case "Reports":
                    cell.expandImageView.isHidden = false
                    cell.iconImageLeadingConstraint.constant = 16
                case "API":
                    cell.expandImageView.isHidden = false
                    cell.iconImageLeadingConstraint.constant = 16
                case "Page Setting":
                    cell.expandImageView.isHidden = false
                    cell.iconImageLeadingConstraint.constant = 16
                default:
                    cell.iconImageLeadingConstraint.constant = 16
                    cell.expandImageView.isHidden = true
            }
        }
        
        return cell
    }
    
    func treeTableView(_ treeTableView: TreeTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func treeTableView(_ treeTableView: TreeTableView, didExpandRowAt indexPath: IndexPath, node: Node) {
        treeTableView.deselectRow(at: indexPath, animated: true)
      //  print("Did expand node '\(node.name)' at indexPath \(indexPath)")
        
    }
    
    func treeTableView(_ treeTableView: TreeTableView, didCollapseRowAt indexPath: IndexPath, node: Node) {
        treeTableView.deselectRow(at: indexPath, animated: true)
      //  print("Did collapse node '\(node.name)' at indexPath \(indexPath)")
    }
    
    func treeTableView(_ treeTableView: TreeTableView, didSelectRowAt indexPath: IndexPath, node: Node) {
        treeTableView.deselectRow(at: indexPath, animated: true)
      //  print("Did select node '\(node.name)' at indexPath \(indexPath)")
        if usertype == "subscriber" {
            switch node.name {
                case "Dashboard":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Clients":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "ClientsVC") as! ClientsVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Appointments":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "EventsVC") as! EventsVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Order":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddOrderVC") as! AddOrderVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Memberships":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "MemberShipListVC") as! MemberShipListVC
                    self.navigationController?.pushViewController(VC, animated: true)
//                case "ToDo":
//                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
//                    self.navigationController?.pushViewController(VC, animated: true)
                case "Inventory":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "ProductsListVC") as! ProductsListVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Orders":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "OrderListVC") as! OrderListVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Sales Report":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "SalesReportVC") as! SalesReportVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Payment List":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentHistoryVC") as! PaymentHistoryVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Information":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "CompanyInformationVC") as! CompanyInformationVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Website":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "WebSiteVC") as! WebSiteVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "List Of Services":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "ServicesListVC") as! ServicesListVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Member's Package":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "PackagesListVC") as! PackagesListVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Performance":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "PerformanceListVC") as! PerformanceListVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Login Log":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "LoginLogVC") as! LoginLogVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Templates":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "TemplatesVC") as! TemplatesVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Email Templates":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "EmailTemplateListVC") as! EmailTemplateListVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Appointment":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "EventReminderSettingVC") as! EventReminderSettingVC
                    self.navigationController?.pushViewController(VC, animated: true)
//                case "Email":
//                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
//                    self.navigationController?.pushViewController(VC, animated: true)
//                case "SMS":
//                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
//                    self.navigationController?.pushViewController(VC, animated: true)
                case "Payment Setup":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentSetupVC") as! PaymentSetupVC
                    self.navigationController?.pushViewController(VC, animated: true)
//                case "Export Contacts":
//                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
//                    self.navigationController?.pushViewController(VC, animated: true)
//                case "Import Contacts":
//                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
//                    self.navigationController?.pushViewController(VC, animated: true)
                case "Archive List":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "ArchiveListVC") as! ArchiveListVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Manage Employee":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "ManageEmployeeVC") as! ManageEmployeeVC
                    self.navigationController?.pushViewController(VC, animated: true)
                    
                default:
                    print("Default")
            }
        } else if usertype == "Admin" {
            switch node.name {
                case "Dashboard":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Clients":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "ClientsVC") as! ClientsVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Packages":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "PackagesListVC") as! PackagesListVC
                    self.navigationController?.pushViewController(VC, animated: true)
             /*   case "Appointments":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Packages":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "List of Subscribers":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Posts":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Manage Coupon":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Get Help!":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Subscription":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Auto-Renew":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Event List":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Order List":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Sales Report":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Bug Report":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Payment List":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Login Log":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Email Setting":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Payment Setup":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "SMS Setup":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Dashboard Settings":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Tutorial Permission":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Tutorials":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Client":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Appointment":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Product":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Services":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Membership":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Order Settings":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "List of Order!":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "To-Do":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Profile":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Note":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Communication":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Api":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Data Backup":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Employees":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "FAQS":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)
                case "Tutorial":
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(VC, animated: true)       */
                    
                default:
                    //                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    //                    self.navigationController?.pushViewController(VC, animated: true)
                    print("Default")
            }
        }
        
    }
    
}
