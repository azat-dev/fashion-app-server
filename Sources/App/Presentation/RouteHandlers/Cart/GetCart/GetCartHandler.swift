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
    
    private let handlerModel: GetCartHandlerModel
    
    init(handlerModel: GetCartHandlerModel) {
        
        self.handlerModel = handlerModel
    }

    func execute(_ request: Request) async -> Response {
        
        let responseData = await handlerModel.getData(userId: "1")
        
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
