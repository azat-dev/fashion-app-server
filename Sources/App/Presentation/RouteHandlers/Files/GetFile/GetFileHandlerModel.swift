//
//  File.swift
//  
//
//  Created by Azat Kaiumov on 26.05.22.
//

import Foundation

struct GetFileResponseData {
    var status: Int
    var contentType: String?
    var data: Data?
    var fileAbsolutePath: String?
}

protocol GetFileHandlerModel {
    func getFile(path: String) async -> GetFileResponseData
}

final class DefaultGetFileHandlerModel: GetFileHandlerModel {
    
    private let filesUseCase: FilesUseCase
    
    init(filesUseCase: FilesUseCase) {
        
        self.filesUseCase = filesUseCase
    }
    
    func getFile(path: String) async -> GetFileResponseData {
        
        let result = filesUseCase.getFile(path: path)
        
        switch result {
        case .failure(_):
            return GetFileResponseData(
                status: 404,
                contentType: nil,
                data: nil,
                fileAbsolutePath: nil
            )
            
        case .success(let absolutePath):
            return GetFileResponseData(
                status: 200,
                contentType: nil,
                data: nil,
                fileAbsolutePath: absolutePath
            )
        }
    }
}
