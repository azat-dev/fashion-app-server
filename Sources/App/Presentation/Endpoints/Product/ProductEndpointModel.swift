//
// ProductEndpointModel.swift
//  
//
//  Created by Azat Kaiumov on 25.05.22.
//

import Foundation
import Vapor

struct OutputProduct: Encodable {
    var id: String
    var name: String
    
    init(product: Product) {
        id = product.id
        name = product.name
    }
}

protocol ProductEndpointModel {
    func getData(productId: String) async -> ResponseData
}

final class DefaultProductEndpointModel: ProductEndpointModel {
    
    let productsUseCase: ProductsUseCase
    
    init(productsUseCase: ProductsUseCase) {
        self.productsUseCase = productsUseCase
    }
    
    func encodeProduct(_ product: Product) throws -> Data {
        
        let outputProduct = OutputProduct(product: product)
        let encoder = JSONEncoder()
        
        return try! encoder.encode(outputProduct)
    }
    
    func mapError(_ error: ProductsUseCaseError) -> ResponseData {
        
        switch error {
        case .internalError:
            return ResponseData(
                status: .internalServerError,
                contentType: "plain/text",
                data: "InternalError".data(using: .utf8)!
            )
            
        case .productNotFound:
            return ResponseData(
                status: .notFound,
                contentType: "plain/text",
                data: "NotFound".data(using: .utf8)!
            )
        }
    }
    
    func getData(productId: String) async -> ResponseData {
        
        let result = try! await productsUseCase.fetchProduct(productId: productId)
        
        switch result {
        case .success(let product):
            return ResponseData(
                status: .ok,
                contentType: "application/json",
                data: try! encodeProduct(product)
            )
            
        case .failure(let error):
            return mapError(error)
        }
    }
}
