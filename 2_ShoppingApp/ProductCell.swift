//
//  ProductCell.swift
//  2_ShoppingApp
//
//  Created by Vicki Yang on 2022/11/1.
//

import Foundation
import UIKit

protocol ProductCellDelegate: AnyObject {
    func stepperClick(type:typeEnum, value: Int)
}

class ProductCell: UITableViewCell {
    static let identifier = "\(ProductCell.self)"
    weak var delegate: ProductCellDelegate?
    var type: typeEnum = .領結型變聲器
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var qty: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    static func nib() -> UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
    
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
    
    @IBAction func stepperClick(_ sender: Any) {
        delegate?.stepperClick(type: type, value: Int(stepper.value))
        qty.text = "Qty: \(Int(stepper.value))"
    }
}
