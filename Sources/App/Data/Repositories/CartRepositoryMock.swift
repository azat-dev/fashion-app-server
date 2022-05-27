//
//  File.swift
//  
//
//  Created by Azat Kaiumov on 27.05.22.
//

import Foundation

class CartRepositoryMock: CartRepository {
    var cart = Cart(items: [])
    
    func fetchCart(userId: String) async -> Result<Cart, CartUseCaseError> {
        return .success(cart)
    }
    func putCart(userId: String, data: Cart) async -> Result<Cart, CartUseCaseError> {
        self.cart = data
        return .success(cart)
    }
}
