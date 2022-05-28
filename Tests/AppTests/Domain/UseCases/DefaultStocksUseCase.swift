//
//  File.swift
//  
//
//  Created by Azat Kaiumov on 27.05.22.
//

@testable import App
import Foundation
import XCTest

class DefaultStocksUseCaseTests: XCTestCase {
    
    var stocksRepository: StocksRepositoryMock!
    var stocksUseCase: StocksUseCase!
    
    override func setUpWithError() throws {
        
        stocksRepository = StocksRepositoryMock()
        stocksUseCase = DefaultStocksUseCase(stocksRepository: stocksRepository)
    }
    
    func test_stocks_change() async {
        
        var referenceStocks = [String: Int]()
        var productIds = Set<String>()
        
        for index in 0...100 {
            
            let sign = index % 2 == 0 ? 1 : -1
            let productId = "test_product_\(index % 3)"
            productIds.insert(productId)
            
            let amount = Int.random(in: 0...10000) * sign
            
            referenceStocks[productId] = referenceStocks[productId, default: 0] + amount
            await stocksUseCase.addStocksChange(productId: productId, value: amount)
        }
        
        let result = await stocksUseCase.fetchCurrentStocks(productId: Array(productIds))
        
        guard case .success(let stocks) = result else {
            XCTAssertFalse(true)
            return
        }
        
        XCTAssertEqual(stocks.count, referenceStocks.count)
        XCTAssertEqual(stocks, referenceStocks)
    }
}
