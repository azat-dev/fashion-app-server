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

struct FetchProductsQuery {
    var from: UInt
    var limit: UInt
}

protocol ProductsRepository {
    func fetchProduct(productId: String) async -> Result<Product, ProductsUseCaseError>
    func fetchProducts(with: FetchProductsQuery) async -> Result<ProductsPage, ProductsUseCaseError>
}
