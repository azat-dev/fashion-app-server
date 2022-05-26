//
//  File.swift
//  
//
//  Created by Azat Kaiumov on 25.05.22.
//

import Foundation
import Vapor

protocol GetProductHandler: RouteHandler {
}

class DefaultGetProductHandler: GetProductHandler {
    let viewModel: GetProductViewModel
    
    init(viewModel: GetProductViewModel) {
        self.viewModel = viewModel
    }
    
    func execute(_ req: Request) async -> Response {
        guard
            let productId = req.parameters.get("id", as: String.self)
        else {
            return Response(status: .badRequest, version: .http2)
        }
        
        let responseData = await viewModel.getData(productId: productId)

        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: responseData.contentType)
        
        return Response(
            status: responseData.status,
            version: .http2,
            headers: headers,
            body: Response.Body(data: responseData.data)
        )
    }
}
