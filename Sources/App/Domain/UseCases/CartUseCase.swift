//
//  File.swift
//  
//
//  Created by Azat Kaiumov on 27.05.22.
//

import Foundation

enum CartUseCaseError: Error {
    case cartNotFound
    case notEnoughtAmount
    case productNotFound
    case internalError
}

protocol CartUseCase {
    func fetchCart(userId: String) async -> Result<Cart, CartUseCaseError>
    func putCart(userId: String, updateData: Cart) async -> Result<Cart, CartUseCaseError>
}

final class DefaultCartUseCase: CartUseCase {
    
    private let cartRepository: CartRepository
    
    init(cartRepository: CartRepository) {
        self.cartRepository = cartRepository
    }
    
    func fetchCart(userId: String) async -> Result<Cart, CartUseCaseError> {
        return await cartRepository.fetchCart(userId: userId)
    }
    
    func putCart(userId: String, updateData: Cart) async -> Result<Cart, CartUseCaseError> {
        return await cartRepository.putCart(userId: userId, data: updateData)
    }
}
