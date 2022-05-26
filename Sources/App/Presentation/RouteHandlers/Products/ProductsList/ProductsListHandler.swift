//
//  File.swift
//  
//
//  Created by Azat Kaiumov on 25.05.22.
//

import Foundation
import Vapor

protocol ListProductsHandler: RouteHandler {
}

class DefaultListProductsHandler: ListProductsHandler {
    let viewModel: ListProductsViewModel
    
    init(viewModel: ListProductsViewModel) {
        self.viewModel = viewModel
    }
    
    func execute(_ req: Request) async -> Response {
        
        guard
            let from = req.parameters.get("from", as: Int.self),
            let limit = req.parameters.get("limit", as: Int.self)
        else {
            return Response(
                status: .badRequest,
                version: .http2
            )
        }
        
        let result = await viewModel.getData(from: from, limit: limit)
        
        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: result.contentType)
        
        return Response(
            status: result.status,
            version: .http2,
            headers: headers,
            body: Response.Body(data: result.data)
        )
    }
}
