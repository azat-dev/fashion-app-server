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

struct ListProductsQueryParams: Content {
    var from: UInt
    var limit: UInt
}

class DefaultListProductsHandler: ListProductsHandler {
    let viewModel: ListProductsViewModel
    
    init(viewModel: ListProductsViewModel) {
        self.viewModel = viewModel
    }
    
    func execute(_ req: Request) async -> Response {
        
        guard
            let queryParams = try? req.query.decode(ListProductsQueryParams.self)
        else {
            return Response(
                status: .badRequest,
                version: .http2
            )
        }
        
        let result = await viewModel.getData(from: queryParams.from, limit: queryParams.limit)
        
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
