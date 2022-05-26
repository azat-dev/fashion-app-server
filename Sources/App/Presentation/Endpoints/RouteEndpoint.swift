//
//  File.swift
//  
//
//  Created by Azat Kaiumov on 25.05.22.
//

import Foundation
import Vapor

protocol RouteEndpoint {
    func get(_ req: Request) async -> Response
    func post(_ req: Request) async -> Response
    func put(_ req: Request) async -> Response
}

struct ResponseData {
    let status: HTTPStatus
    let contentType: String
    let data: Data
}

extension RouteEndpoint {
    func get(_ req: Request) async -> Response {
        return Response(
            status: .notImplemented,
            version: .http2
        )
    }
    
    func post(_ req: Request) async -> Response {
        return Response(
            status: .notImplemented,
            version: .http2
        )
    }
    
    func put(_ req: Request) async -> Response {
        return Response(
            status: .notImplemented,
            version: .http2
        )
    }
}
