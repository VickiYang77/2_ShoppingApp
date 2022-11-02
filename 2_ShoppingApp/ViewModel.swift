//
//  ViewModel.swift
//  2_ShoppingApp
//
//  Created by Vicki Yang on 2022/11/2.
//

import Foundation

enum typeEnum: String, CaseIterable {
//    case none
    case 領結型變聲器
    case 太陽能噴射滑板
    case 手錶型麻醉槍
    case 犯人追蹤眼鏡
    case 增強踢力球鞋
    case 任意射出足球腰帶
    
    var price: Int {
        switch self {
        case .領結型變聲器:
            return 10
        case .太陽能噴射滑板:
            return 20
        case .手錶型麻醉槍:
            return 30
        case .犯人追蹤眼鏡:
            return 5
        case .增強踢力球鞋:
            return 40
        case .任意射出足球腰帶:
            return 77
        default:
            return 0
        }
    }
}

class ViewModel {
    var cartCar: [typeEnum:Int] = [:]
    
    func getTypeList() -> [typeEnum] {
        return typeEnum.allCases
    }
}
