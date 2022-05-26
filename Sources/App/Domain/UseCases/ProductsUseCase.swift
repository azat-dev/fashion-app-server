//
//  ProductsUseCase.swift
//  
//
//  Created by Azat Kaiumov on 25.05.22.
//

import Foundation

// MARK: - Protocol

enum ProductsUseCaseError: Error {
    case productNotFound
    case internalError
}

protocol ProductsUseCase {
    func fetchProduct(productId: String) async -> Result<Product, ProductsUseCaseError>
    func fetchProducts(with query: FetchProductsQuery) async -> Result<ProductsPage, ProductsUseCaseError>
}

// MARK: - Implementation

class DefaultProductsUseCase {
    
    private let productsRepository: ProductsRepository
    
    init(productsRepository: ProductsRepository) {

        self.productsRepository = productsRepository
    }
}

extension DefaultProductsUseCase: ProductsUseCase {
    
    func fetchProduct(productId: String) async -> Result<Product, ProductsUseCaseError>  {

        return await productsRepository.fetchProduct(productId: productId)
    }
    
    func fetchProducts(with query: FetchProductsQuery) async -> Result<ProductsPage, ProductsUseCaseError>  {
        
        return await productsRepository.fetchProducts(with: query)
    }
}
