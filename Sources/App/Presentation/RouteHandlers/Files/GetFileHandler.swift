//
//  File.swift
//  
//
//  Created by Azat Kaiumov on 26.05.22.
//

import Foundation
import Vapor

protocol GetFileHandler: RouteHandler {
}

final class DefaultGetFileHandler: GetFileHandler {
    
    private let viewModel: GetFileViewModel
    
    init(viewModel: GetFileViewModel) {
        self.viewModel = viewModel
    }
    
    func splitFilePath(requestPath: String, routeComponents: [PathComponent]) -> String? {
        let requestComponents = requestPath.pathComponents
        let catchallIndex = routeComponents.lastIndex { item in
            if case .catchall = item {
                return true
            }

            return false
        }
        
        guard let catchallIndex = catchallIndex else {
            return nil
        }

        
        return requestComponents[catchallIndex...].string
    }

    func execute(_ request: Request) async -> Response {

        guard let route = request.route else {
            return Response(status: .internalServerError)
        }
        
        guard
            let filePath = splitFilePath(requestPath: request.url.path, routeComponents: route.path)
        else {
            return Response(status: .internalServerError)
        }
        
        let responseData = await self.viewModel.getFile(path: filePath)
        
        guard let absolutePath = responseData.fileAbsolutePath else {
            return Response(
                status: HTTPResponseStatus(statusCode: responseData.status)
            )
        }
        
        return request.fileio.streamFile(at: absolutePath)
    }
}
