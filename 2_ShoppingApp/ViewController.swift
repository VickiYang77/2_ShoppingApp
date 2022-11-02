//
//  ViewController.swift
//  2_ShoppingApp
//
//  Created by Vicki Yang on 2022/9/5.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var priceLabel: UILabel!
    var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProductCell.nib(), forCellReuseIdentifier: ProductCell.identifier)
        tableView.allowsSelection = false
    }
    
    @IBAction func clearBtnClick(_ sender: Any) {
        priceLabel.text = "0"
        viewModel.cartCar = [:]
        tableView.reloadData()
    }
    
    @IBAction func CartBtnClick(_ sender: Any) {
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getTypeList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemData = viewModel.getTypeList()[indexPath.row]
        let qty = viewModel.cartCar[itemData] ?? 0
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.identifier) as! ProductCell
        cell.delegate = self
        cell.setup(type: itemData, qty: qty)

        return cell
    }
}

extension ViewController: ProductCellDelegate {
    func stepperClick(type:typeEnum, value: Int) {
        viewModel.cartCar[type] = value
        var total = 0
        for (type, value) in viewModel.cartCar {
            total += value * type.price
        }
        priceLabel.text = "\(total)"
    }
 }
 

