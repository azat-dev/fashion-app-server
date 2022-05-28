//
// ProductEndpointModel.swift
//  
//
//  Created by Azat Kaiumov on 25.05.22.
//

import Foundation

// MARK: - Interfaces

struct OutputProduct: Codable {
    var id: String
    var name: String
    var brand: String
    var price: Double
    var image: String
    var description: String
    
    init(product: Product) {
        id = product.id
        name = product.name
        brand = product.brand
        image = product.image
        price = product.price
        description = product.description
    }
}

protocol GetProductHandlerModel {
    func getData(productId: String) async -> RouteHandlerResponse
}

// MARK: - Implementations

final class DefaultGetProductHandlerModel: GetProductHandlerModel {
    
    let productsUseCase: ProductsUseCase
    
    init(productsUseCase: ProductsUseCase) {
        self.productsUseCase = productsUseCase
    }
    
    func encodeProduct(_ product: Product) throws -> Data {
        
        let outputProduct = OutputProduct(product: product)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        return try! encoder.encode(outputProduct)
    }
    
    func mapError(_ error: ProductsUseCaseError) -> RouteHandlerResponse {
        
        switch error {
        case .internalError:
            return RouteHandlerResponse(
                status: .internalServerError,
                contentType: "plain/text",
                data: "InternalError".data(using: .utf8)!
            )
            
        case .productNotFound:
            return RouteHandlerResponse(
                status: .notFound,
                contentType: "plain/text",
                data: "NotFound".data(using: .utf8)!
            )
        }
    }
    
    func getData(productId: String) async -> RouteHandlerResponse {
        
        let result = await productsUseCase.fetchProduct(productId: productId)
        
        switch result {
        case .success(let product):
            return RouteHandlerResponse(
                status: .ok,
                contentType: "application/json",
                data: try! encodeProduct(product)
            )
            
        case .failure(let error):
            return mapError(error)
        }
    }
}
