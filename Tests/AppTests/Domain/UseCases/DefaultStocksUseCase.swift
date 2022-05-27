//
//  File.swift
//  
//
//  Created by Azat Kaiumov on 27.05.22.
//

@testable import App
import Foundation

class DefaultStocksUseCaseTests: XCTestCase {
    
    var stocksRepository: StocksRepositoryMock!
    var stocksUseCase: StocksUseCase!
    
    override func setUpWithError() throws {
        
        stocksRepository = StocksRepositoryMock()
        stocksUseCase = DefaultStocksUseCase(cartRepository: stocksRepository)
    }
    
    func test_stocks_change() async {
        
        var referenceStocks = [String: Int]()
        
        for index in 0...100 {
            
            let sign = index % 2 == 0 ? 1 : -1
            let productId = "test_product_\(index % 3)"
            let amount = Int.random(in: 0...10000)
            
            await stocksUseCase.addStockChange(productId: productId, value: amount * sign)
        }
        
        let stocks = await stocksUseCase.fetchCurrentStocks(products: [productId])
        XCTAssertEqual(stocks.count, referenceStocks.count)
        XCTAssertEqual(stocks, referenceStocks)
    }
}
