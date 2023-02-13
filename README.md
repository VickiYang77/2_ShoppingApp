# #2 ShoppingApp

![2_ShoppingApp_g0](https://user-images.githubusercontent.com/25075180/218511542-543f7be5-dade-4c62-b4e1-2cc959afc599.gif)

## Learning Goal

- 基本 MVVM 架構
- 基本 Combine
- Cell xib
- 自訂 Protocol
- Enum

## Highlight

- 直接將 Main storyboard 視為主頁面來開發

- 基本MVVM架構區分檔案

![image](https://user-images.githubusercontent.com/25075180/218511845-0ab7f9ce-edf0-4053-84c3-fddcf44cd368.png)

- 建立 Enum
  - 需遵從 Protocol CaseIterable，才可使用 typeEnum.allCases 方法
    
    ```swift
    enum typeEnum: String, CaseIterable {
        case 領結型變聲器
        case 太陽能噴射滑板
        
    		// 利用 swift enum 特性，將 price 用變數的方式建立資料
        var price: Int {
            switch self {
            case .領結型變聲器:
                return 10
            case .太陽能噴射滑板:
                return 20
            }
        }
    }
    
    class ViewModel {
        func getTypeList() -> [typeEnum] {
            return typeEnum.allCases   // 取得 Enum 中的所有 case
        }
    }
    ```
- 基本 MVVM + Combine
  - 在 ViewController Class 中宣告 VM 和 AnyCancellable(存放 combine 訂閱事件的集合)

    ```swift
    class ViewController: UIViewController {
        var viewModel = ViewModel()
        private var cancellableSet: Set<AnyCancellable> = []
        ...
    }
    ```
        
    
  - viewDidLoad 時 binding(訂閱) VM 中需要更新 UI 的事件
        
    ```swift
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
        ...
    }

    func binding() {
            viewModel.$total
                // 更新 UI 需注意要使用主執行序
                .receive(on: RunLoop.main)

                // 資料處理
                .sink() { [weak self] in
                    self?.priceLabel.text = "\($0)"
                }

                // 將訂閱事件加入 cancellableSet 集合中
                .store(in: &cancellableSet)
    }
    ```
        

  - VM init 時 binding(訂閱)，只需邏輯處理，不需更新UI的事件
    
    ```swift
    class ViewModel {
        private var cancellableSet: Set<AnyCancellable> = []
        @Published var cart: [typeEnum:Int] = [:]
        @Published var total: Int = 0
        
        init() {
            binding()
        }
        
        private func binding() {
            $cart
                .sink() { [weak self] items in
                    var total = 0
                    for (type, value) in items {
                        total += value * type.price
                    }
                    self?.total = total
                    
                }.store(in: &cancellableSet)
        }
    }
    ```
    

  - 在 VC 的 extension 中實作 TableView delegate，並使用 VM 當作資料來源
    
    ```swift
    class ViewController: UIViewController {
    		var viewModel = ViewModel()
    		...
    
    		override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(ProductCell.nib(), forCellReuseIdentifier: ProductCell.identifier)
            tableView.allowsSelection = false
        }
    }
    
    extension ViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.getTypeList().count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.identifier) as! ProductCell
            let itemData = viewModel.getTypeList()[indexPath.row]
            let qty = viewModel.cart[itemData] ?? 0
            cell.delegate = self
            cell.setup(type: itemData, qty: qty)
    
            return cell
        }
    }
    ```
    

  - 創建 Cell xib
      - 創建同名的 .swift 與 .xib 檔案
    
      - 在 VC viewDidLoad 中 Register TableView Cell
        
        ```swift
        //  ProductCell.swift
        
        class ProductCell: UITableViewCell {
            static let identifier = "\(ProductCell.self)"
        
        		static func nib() -> UINib {
                return UINib(nibName: self.identifier, bundle: nil)
            }
        		...
        }
        
        -----------------------------------------------------------
        // ViewController.swift
        
        class ViewController: UIViewController {
        		var viewModel = ViewModel()
        		...
        
        		override func viewDidLoad() {
                super.viewDidLoad()
                
                tableView.delegate = self
                tableView.dataSource = self
                tableView.register(ProductCell.nib(), forCellReuseIdentifier: ProductCell.identifier)
                tableView.allowsSelection = false
            }
        }
        ```
        
    
      - 在 Cell awakeFromNib 中定義各屬性的初始值設定，並定義 Cell setup 方法讓 delegate cellForRowAt 呼叫
        
        ```swift
        //  ProductCell.swift
        
        class ProductCell: UITableViewCell {
        		@IBOutlet weak var productImageView: UIImageView!
            @IBOutlet weak var name: UILabel!
            @IBOutlet weak var price: UILabel!
            @IBOutlet weak var qty: UILabel!
            @IBOutlet weak var stepper: UIStepper!
        
        		override func awakeFromNib() {
                super.awakeFromNib()
                productImageView.layer.masksToBounds = true
                productImageView.layer.cornerRadius = 40
                stepper.maximumValue = 100
                stepper.minimumValue = 0
                stepper.autorepeat = true
                stepper.isContinuous = true
            }
            
            func setup(type: typeEnum, qty: Int) {
                self.type = type
                self.name.text = type.rawValue
                self.price.text = "$ \(type.price)"
                self.qty.text = "Qty: \(qty)"
                stepper.value = Double(qty)
                self.productImageView.image = UIImage(named: type.rawValue)
            }
        }
        ```
        
    
      - 自訂 Cell Protocol 並在 VC 中遵從與實作
        
        ```swift
        //  ProductCell.swift
        
        protocol ProductCellDelegate: AnyObject {
            func stepperClick(type:typeEnum, value: Int)
        }
        
        class ProductCell: UITableViewCell {
        	@IBAction func stepperClick(_ sender: Any) {
        	    delegate?.stepperClick(type: type, value: Int(stepper.value))
        	    qty.text = "Qty: \(Int(stepper.value))"
        	}
        }
        
        -----------------------------------------------------------
        // ViewController.swift
        
        extension ViewController: UITableViewDelegate, UITableViewDataSource {
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.identifier) as! ProductCell
                let itemData = viewModel.getTypeList()[indexPath.row]
                let qty = viewModel.cart[itemData] ?? 0
                cell.delegate = self
                cell.setup(type: itemData, qty: qty)
        
                return cell
            }
        }
        
        extension ViewController: ProductCellDelegate {
        	func stepperClick(type:typeEnum, value: Int) {
              viewModel.cart[type] = value
          }
        }
        ```
