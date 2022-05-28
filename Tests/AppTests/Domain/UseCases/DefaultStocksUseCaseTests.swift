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
            let result = await stocksUseCase.addStocksChange(productId: productId, value: amount)
            
            guard case .success() = result else {
                XCTAssertFalse(true)
                return
            }
        }
        
        let result = await stocksUseCase.fetchCurrentStocks(productId: Array(productIds))
        
        guard case .success(let stocks) = result else {
            XCTAssertFalse(true)
            return
        }
        
        XCTAssertEqual(stocks.count, referenceStocks.count)
        XCTAssertEqual(stocks, referenceStocks)
    }
    
    func test_get_stocks_return_only_requested_stocks() async {
        
        for index in 0...10 {
            let productId = "product_\(index)"
            let result = await stocksUseCase.addStocksChange(productId: productId, value: index)
            
            guard case .success() = result else {
                XCTAssertFalse(true, "Can't add stock")
                return
            }
        }
        
        let result = await stocksUseCase.fetchCurrentStocks(productId: ["product_0"])
        
        guard case .success(let stocks) = result else {
            XCTAssertFalse(true)
            return
        }
        
        XCTAssertEqual(stocks.count, 1)
        XCTAssertEqual(stocks["product_0"], 10)
    }
    
    func test_get_stocks_for_zero_products() async {
        
        for index in 0...10 {
            let productId = "product_\(index)"
            let result = await stocksUseCase.addStocksChange(productId: productId, value: index)
            
            guard case .success() = result else {
                XCTAssertFalse(true, "Can't add stock")
                return
            }
        }
        
        let result = await stocksUseCase.fetchCurrentStocks(productId: [])
        
        guard case .success(let stocks) = result else {
            XCTAssertFalse(true)
            return
        }
        
        XCTAssertEqual(stocks.count, 0)
    }

    
    func test_get_stocks_return_0_for_not_existing_stock() async {
        
        let productsIds = ["test1", "test2", "test3"]
        
        let referenceStocks: [String: Int] = productsIds.reduce([:]) { result, productId in
            var newResult = result
            newResult[productId] = 0
            return newResult
        }
        
        let result = await stocksUseCase.fetchCurrentStocks(productId: productsIds)
        
        guard case .success(let stocks) = result else {
            XCTAssertFalse(true)
            return
        }
        
        XCTAssertEqual(stocks.count, referenceStocks.count)
        XCTAssertEqual(stocks, referenceStocks)
    }
}
