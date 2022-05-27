//
//  File.swift
//  
//
//  Created by Azat Kaiumov on 26.05.22.
//

import Foundation

enum FilesUseCaseError: Error {
    case fileNotFound
    case accessForbiden
    case internalError
}

typealias AbsoluteFilePath = String

protocol FilesUseCase {
    func getFile(path: String) -> Result<AbsoluteFilePath, FilesUseCaseError>
}

final class DefaultFilesUseCase: FilesUseCase {
    
    private let rootDirectory: String
    
    init(rootDirectory: String) {
        
        self.rootDirectory = rootDirectory
    }
    
    func getFile(path: String) -> Result<AbsoluteFilePath, FilesUseCaseError> {
        
        let absolutePath = "\(rootDirectory)/\(path)"
        return .success(absolutePath)
    }
}
