//
//  File.swift
//
//
//  Created by Azat Kaiumov on 27.05.22.
//

@testable import App
import XCTest

//class GetStocksViewModelTests: XCTestCase {
//    
//    var stocksViewModel: GetStocksViewModel!
//    var stocksRepository: StocksRepositoryMock!
//    
//    override func setUpWithError() throws {
//        
//        stocksRepository = StocksRepositoryMock()
//        let stocksUseCase = DefaultStocksUseCase(cartRepository: stocksRepository)
//        stocksViewModel = DefaultGetStocksViewModel(stocksUseCase: stocksUseCase)
//    }
//    
//    func test_getData_success() async {
//        
//        let productId = "test_product_\(Date.now)"
//        let amount = Int.random(in: 1...10000)
//        let _ = await stocksRepository.addStockChange(productId: productId, value: +100)
//        let responseData = await stocksViewModel.getData(productId: productId)
//        
//        XCTAssertEqual(responseData.status, .ok)
//        
//        let decoder = JSONDecoder()
//        
//        let parsedStockData = try! decoder.decode(OutputStock.self, from: responseData.data)
//        
//        XCTAssertEqual(parsedStockData.productId, productId)
//        XCTAssertEqual(parsedStockData.productId, testAmount)
//    }
//}
