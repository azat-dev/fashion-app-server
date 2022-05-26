//
//  File.swift
//  
//
//  Created by Azat Kaiumov on 25.05.22.
//

import Foundation

protocol ProductsEndpointModel {
    func getProduct(id: String) async throws -> Product
}
