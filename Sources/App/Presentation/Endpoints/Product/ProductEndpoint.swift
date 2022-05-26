//
//  File.swift
//  
//
//  Created by Azat Kaiumov on 25.05.22.
//

import Foundation
import Vapor

class ProductEndpoint: RouteEndpoint {
}

class DefaultProductEndpoint: RouteEndpoint {
    let endpointModel: ProductEndpointModel
    
    init(endpointModel: ProductEndpointModel) {
        self.endpointModel = endpointModel
    }
    
    func get(_ req: Request) async -> Response {
        guard
            let productId = req.parameters.get("id", as: String.self)
        else {
            return Response(status: .badRequest, version: .http2)
        }
//
        do {
            let result = try await endpointModel.getData(productId: productId)

            var headers = HTTPHeaders()
            headers.add(name: "Content-Type", value: result.mime)
            
            return Response(
                status: .ok,
                version: .http2,
                headers: headers,
                body: Response.Body(data: result.data)
            )

        } catch {
            return Response(status: .internalServerError)
        }
    }
}
