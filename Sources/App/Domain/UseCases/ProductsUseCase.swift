//
//  ProductsUseCase.swift
//  
//
//  Created by Azat Kaiumov on 25.05.22.
//

import Foundation

// MARK: - Protocol

protocol ProductsUseCase {
    func getProduct(productId: String) async throws -> Product
}

// MARK: - Implementation

class DefaultProductsUseCase {
    
    private let productsRepository: ProductsRepository
    
    init(productsRepository: ProductsRepository) {
        self.productsRepository = productsRepository
    }
}

extension DefaultProductsUseCase: ProductsUseCase {
    
    func getProduct(productId: String) async throws -> Product {
        return try! await productsRepository.fetchProduct(productId: productId)
    }
}
