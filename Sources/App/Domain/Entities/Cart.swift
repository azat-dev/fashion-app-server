//
//  Cart.swift
//  
//
//  Created by Azat Kaiumov on 27.05.22.
//

import Foundation

struct CartItem {
    var product: Product
    var amount: Int
    var updateAt: Date
}

struct Cart {
    var items: [CartItem]
}
