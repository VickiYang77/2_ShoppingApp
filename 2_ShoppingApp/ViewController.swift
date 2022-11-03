//
//  ViewController.swift
//  2_ShoppingApp
//
//  Created by Vicki Yang on 2022/9/5.
//

import UIKit
import Combine

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var priceLabel: UILabel!
    var viewModel = ViewModel()
    private var cancellableSet: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProductCell.nib(), forCellReuseIdentifier: ProductCell.identifier)
        tableView.allowsSelection = false
    }
    
    @IBAction func clearBtnClick(_ sender: Any) {
        viewModel.cart = [:]
        tableView.reloadData()
    }
    
    func binding() {
        viewModel.$total
            .receive(on: RunLoop.main)
            .sink() { [weak self] in
                self?.priceLabel.text = "\($0)"
            }
            .store(in: &cancellableSet)
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

extension ViewController: ProductCellDelegate {
    func stepperClick(type:typeEnum, value: Int) {
        viewModel.cart[type] = value
    }
 }
 

