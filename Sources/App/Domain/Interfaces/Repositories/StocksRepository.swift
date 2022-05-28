//
//  File.swift
//  
//
//  Created by Azat Kaiumov on 28.05.22.
//

import Foundation

protocol StocksRepository {
    
    func addStocksChange(productId: String, value: Int) async -> Result<Void, StocksUseCaseError>
    
    func fetchCurrentStocks(productId: [String]) async -> Result<[String: Int], StocksUseCaseError>
}
