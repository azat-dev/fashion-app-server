//
//  File.swift
//  
//
//  Created by Azat Kaiumov on 27.05.22.
//

import Foundation
import Vapor

// MARK: - Interfaces

protocol GetCartHandler : RouteHandler {
}

// MARK: - Implementations

final class DefaultGetCartHandler: GetCartHandler {
    
    private let viewModel: GetCartHandlerModel
    
    init(viewModel: GetCartHandlerModel) {
        
        self.viewModel = viewModel
    }

    func execute(_ request: Request) async -> Response {
        
        let responseData = await viewModel.getData(userId: "1")
        
        var headers = HTTPHeaders()
        headers.add(name: .contentType, value: responseData.contentType)
        
        return Response(
            status: responseData.status,
            version: .http2,
            headers: headers,
            body: Response.Body(data: responseData.data)
        )
    }
}
