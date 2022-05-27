//
//  File.swift
//  
//
//  Created by Azat Kaiumov on 27.05.22.
//

import Foundation

protocol CartRepository {
    func fetchCart(userId: String) async -> Result<Cart, CartUseCaseError>
    func putCart(userId: String, data: Cart) async -> Result<Cart, CartUseCaseError>
}
