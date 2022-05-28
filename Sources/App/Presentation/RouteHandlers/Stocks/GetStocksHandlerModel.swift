//
//  File.swift
//  
//
//  Created by Azat Kaiumov on 28.05.22.
//

import Foundation

// MARK: - Interfaces

typealias OutputStocks = [String: Int]

protocol GetStocksHandlerModel {
    func getData(productsIds: [String]) async -> RouteHandlerResponse
}


// MARK: - Implementation

final class DefaultGetStocksHandlerModel {
    
    private let stocksUseCase: StocksUseCase

    init(stocksUseCase: StocksUseCase) {
        self.stocksUseCase = stocksUseCase
    }
}

extension DefaultGetStocksHandlerModel: GetStocksHandlerModel {
    
    func getData(productsIds: [String]) async -> RouteHandlerResponse {
        
        let result = await stocksUseCase.fetchCurrentStocks(productId: productsIds)
        
        guard case .success(let stocks) = result else {
            return RouteHandlerResponse(
                status: .internalServerError,
                contentType: "plain/text",
                data: "InternalError".data(using: .utf8)!
            )
        }
        
        let encoder = JSONEncoder()
        
        return RouteHandlerResponse(
            status: .ok,
            contentType: "application/json",
            data: try! encoder.encode(stocks)
        )
    }
}
