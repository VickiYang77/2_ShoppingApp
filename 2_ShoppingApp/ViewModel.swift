//
//  ViewModel.swift
//  2_ShoppingApp
//
//  Created by Vicki Yang on 2022/11/2.
//

import Foundation
import Combine

enum typeEnum: String, CaseIterable {
    case 領結型變聲器
    case 太陽能噴射滑板
    case 手錶麻醉槍
    case 耳環式行動電話
    case 追蹤眼鏡
    case 增強踢力球鞋
    case 少年偵探團徽章
    case 伸縮吊帶
    case 足球腰帶
    
    var price: Int {
        switch self {
        case .領結型變聲器:
            return 10
        case .太陽能噴射滑板:
            return 20
        case .手錶麻醉槍:
            return 30
        case .耳環式行動電話:
            return 50
        case .追蹤眼鏡:
            return 99
        case .增強踢力球鞋:
            return 40
        case .少年偵探團徽章:
            return 60
        case .伸縮吊帶:
            return 9
        case .足球腰帶:
            return 77
        }
    }
}

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
    
    func getTypeList() -> [typeEnum] {
        return typeEnum.allCases
    }
}
