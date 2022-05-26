//
//  File.swift
//  
//
//  Created by Azat Kaiumov on 25.05.22.
//

import Foundation
import Vapor

class ProductsEndpoint: RouteEndpoint {
}

class DefaultProductsEndpoint: RouteEndpoint {
    let endpointModel: ProductsEndpointModel
    
    init(endpointModel: ProductsEndpointModel) {
        self.endpointModel = endpointModel
    }
    
    func get(_ req: Request) async -> Response {
        
        guard
            let productId = req.parameters.get("id", as: String.self)
        else {
            return Response(
                status: .badRequest,
                version: .http2
            )
        }
        
        do {
            
            let product = try await endpointModel.getProduct(id: productId)
            return Response(
                status: .ok,
                version: .http2
            )
            
        } catch {
            // FIXME: add implementation
            return Response(
                status: .internalServerError,
                version: .http2
            )
        }
    }
}
