//
//  File.swift
//
//
//  Created by Azat Kaiumov on 27.05.22.
//


import Foundation
import XCTest

@testable import App

class GetStocksHandlerModelTests: XCTestCase {
    
    var stocksRepository: StocksRepositoryMock!
    var stocksUseCase: StocksUseCase!
    var getStocksHandlerModel: GetStocksHandlerModel!
    
    override func setUpWithError() throws {
        
        stocksRepository = StocksRepositoryMock()
        stocksUseCase = DefaultStocksUseCase(stocksRepository: stocksRepository)
        getStocksHandlerModel = DefaultGetStocksHandlerModel(stocksUseCase: stocksUseCase)
    }
    
    func test_get_data() async {
        
        let testProductId = "product_0"
        let testStock = 10
        
        let addStockResult = await stocksUseCase.addStocksChange(productId: testProductId, value: testStock)
        guard case .success = addStockResult else {
            XCTAssertFalse(true, "Can't add stock")
            return
        }
        
        let response = await getStocksHandlerModel.getData(productsIds: [testProductId])

        XCTAssertEqual(response.status, .ok)
        XCTAssertNotNil(response.data)
        
        let decoder = JSONDecoder()
        let parsedResponse = try? decoder.decode(OutputStocks.self, from: response.data)
        
        guard let parsedResponse = parsedResponse else {
            XCTAssertNotNil(parsedResponse)
            return
        }
        
        XCTAssertEqual(parsedResponse.count, 1)
        XCTAssertEqual(parsedResponse[testProductId], testStock)
    }
}
