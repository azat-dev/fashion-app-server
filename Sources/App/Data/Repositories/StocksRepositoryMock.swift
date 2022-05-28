//
//  File.swift
//  
//
//  Created by Azat Kaiumov on 28.05.22.
//

import Foundation

struct Stock {
    var createdAt: Date
    var productId: String
    var amount: Int
}

class StocksRepositoryMock: StocksRepository {
    private var stocks = [Stock]()
    
    func addStocksChange(productId: String, value: Int) async -> Result<Void, StocksUseCaseError> {
        
        let stock = Stock(
            createdAt: .now,
            productId: productId,
            amount: value
        )
        stocks.append(stock)
        
        return .success(())
    }
    
    func fetchCurrentStocks(productId: [String]) async -> Result<[String: Int], StocksUseCaseError> {
        
        var result = [String: Int]()
        
        stocks.forEach { stock in
            let productId = stock.productId
            result[productId] = result[productId, default: 0] + stock.amount
        }
        
        return .success(result)
    }
}
