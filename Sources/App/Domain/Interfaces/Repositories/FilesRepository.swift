//
//  File.swift
//  
//
//  Created by Azat Kaiumov on 27.05.22.
//

import Foundation

protocol FilesRepository {
    func isFileExists(path: String) async -> Result<Bool, FilesUseCaseError>
}
