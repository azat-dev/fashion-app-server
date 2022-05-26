//
//  ProductsRepository.swift
//  
//
//  Created by Azat Kaiumov on 25.05.22.
//

import Foundation

enum SortDirection {
    case ascending
    case descending
}

protocol SortParams {
    var path: KeyPath<Product, Any> { get }
    var direction: SortDirection { get }
}


protocol ProductsRepository {
    func fetchProduct(productId: String) async -> Result<Product, ProductsUseCaseError>
    func searchProducts(sort: [SortParams]) async throws -> ProductsPage
}
