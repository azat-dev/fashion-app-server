//
//  File.swift
//  
//
//  Created by Azat Kaiumov on 25.05.22.
//

import Foundation

// MARK: - Interfaces

struct OutputPage: Encodable {
    var total: Int
    var items: [OutputProduct]
    
    init(page: ProductsPage) {
        total = page.total
        items = page.items.map { OutputProduct(product: $0) }
    }
}

protocol ListProductsHandlerModel {
    func getData(from: UInt, limit: UInt) async -> RouteHandlerResponse
}

// MARK: - Implementations

final class DefaultListProductsHandlerModel: ListProductsHandlerModel {
    let productsUseCase: ProductsUseCase
    
    init(productsUseCase: ProductsUseCase) {
        self.productsUseCase = productsUseCase
    }
    
    func encodePage(_ page: ProductsPage) -> Data {
        let output = OutputPage(page: page)
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try! encoder.encode(output)
    }
    
    func getData(from: UInt, limit: UInt) async -> RouteHandlerResponse {
        
        let query = FetchProductsQuery(
            from: from,
            limit: limit
        )
        
        let result = await productsUseCase.fetchProducts(with: query)
        
        switch result {
        case .success(let page):
            return RouteHandlerResponse(
                status: .ok,
                contentType: "application/json",
                data: encodePage(page)
            )
            
        case .failure(_):
            return RouteHandlerResponse(
                status: .internalServerError,
                contentType: "application/json",
                data: "".data(using: .utf8)!
            )
        }
    }
}
