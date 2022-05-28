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
    
    func fetchCurrentStocks(productId productsIds: [String]) async -> Result<[String: Int], StocksUseCaseError> {
        
        var result = [String: Int]()
        
        result = stocks.reduce([:]) { partialResult, stock in
            
            let productId = stock.productId
            
            guard productsIds.contains(productId) else {
                return partialResult
            }
                
            var newResult = partialResult
            
            newResult[productId] = partialResult[productId, default: 0] + stock.amount
            return newResult
        }
        
        for productId in productsIds {
            
            if result[productId] == nil {
                result[productId] = 0
            }
        }
        
        return .success(result)
    }
}
