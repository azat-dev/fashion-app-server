//
//  File.swift
//  
//
//  Created by Azat Kaiumov on 25.05.22.
//

import Foundation
import Vapor

protocol RouteHandler {
    func execute(_ req: Request) async -> Response
}

struct RouteHandlerResponse {
    let status: HTTPStatus
    let contentType: String
    let data: Data
}
