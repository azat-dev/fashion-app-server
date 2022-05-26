//
// ProductEndpointModel.swift
//  
//
//  Created by Azat Kaiumov on 25.05.22.
//

import Foundation

struct OutputProduct: Encodable {
    var id: String
    var name: String
    
    init(product: Product) {
        id = product.id
        name = product.name
    }
}

protocol ProductEndpointModel {
    func getData(productId: String) async throws -> (mime: String, data: Data)
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
    
    func getData(productId: String) async throws -> (mime: String, data: Data) {
        
        let product = try! await productsUseCase.getProduct(productId: productId)
        return (
            mime: "application/json",
            data: try! encodeProduct(product)
        )
    }
}
