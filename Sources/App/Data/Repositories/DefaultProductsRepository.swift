//
//  DefaultProductsRepository.swift
//  
//
//  Created by Azat Kaiumov on 25.05.22.
//

import Foundation

final class DefaultProductsRepository: ProductsRepository {
    func fetchProduct(productId: String) async throws -> Product {
        return Product(id: productId, name: "Test", brand: "Nike", description: "sdfd", image: "", price: 10)
        fatalError("Not implemented")
    }
    
    func searchProducts(sort: [SortParams]) async throws -> ProductsPage {
        fatalError("Not implemented")
    }
    
    init() {
        
    }
}
