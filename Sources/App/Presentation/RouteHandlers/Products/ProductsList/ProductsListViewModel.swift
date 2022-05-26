//
//  File.swift
//  
//
//  Created by Azat Kaiumov on 25.05.22.
//

import Foundation

struct OutputPage: Encodable {
    var total: Int
    var items: OutputProduct
}

protocol ListProductsViewModel {
    func getData(from: Int, limit: Int) async -> RouteHandlerResponse
}

