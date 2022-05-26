//
//  File.swift
//  
//
//  Created by Azat Kaiumov on 26.05.22.
//

import Foundation

protocol OutputEncoder {
    func encode(_ product: Product) throws -> Data
}

