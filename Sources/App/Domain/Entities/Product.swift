//
//  Product.swift
//  
//
//  Created by Azat Kaiumov on 25.05.22.
//

import Foundation

struct Product {
    var id: String
    var name: String
    var brand: String
    var description: String
    var image: String
    var price: Double
}

struct ProductsPage {
    var total: Int
    var items: [Product]
}
