//
//  File.swift
//  
//
//  Created by Azat Kaiumov on 27.05.22.
//

import Foundation


// MARK: - Protocol

enum StocksUseCaseError: Error {
    case internalError
}

protocol StocksUseCase {
    func addStocksChange(productId: String, value: Int) async -> Result<Void, StocksUseCaseError>
    func fetchCurrentStocks(productId: [String]) async -> Result<[String: Int], StocksUseCaseError>
}

// MARK: - Implementation

class DefaultStocksUseCase {
    
    private let stocksRepository: StocksRepository
    
    init(stocksRepository: StocksRepository) {

        self.stocksRepository = stocksRepository
    }
}

extension DefaultStocksUseCase: StocksUseCase {
    
    func addStocksChange(productId: String, value: Int) async -> Result<Void, StocksUseCaseError> {
        
        return await stocksRepository.addStocksChange(productId: productId, value: value)
    }
    
    func fetchCurrentStocks(productId: [String]) async -> Result<[String: Int], StocksUseCaseError> {
        
        return await stocksRepository.fetchCurrentStocks(productId: productId)
    }
}
