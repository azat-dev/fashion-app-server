//
//  File.swift
//  
//
//  Created by Azat Kaiumov on 27.05.22.
//

import Foundation

struct OutputCartItem: Codable {
    var product: OutputProduct
    var amount: Int

    init(cartItem: CartItem) {
        product = OutputProduct(product: cartItem.product)
        amount = cartItem.amount
    }
}

struct OutputCart: Codable {
    var items: [OutputCartItem]

    init(cart: Cart) {
        items = cart.items.map { item in OutputCartItem(cartItem: item) }
    }
}

protocol GetCartViewModel {
    func getData(userId: String) async -> RouteHandlerResponse
}

final class DefaultGetCartViewModel: GetCartViewModel {
    
    private let cartUseCase: CartUseCase
    
    init(cartUseCase: CartUseCase) {
        self.cartUseCase = cartUseCase
    }
    
    func mapUseCaseError(error: CartUseCaseError) -> RouteHandlerResponse {
        switch error {
        case .cartNotFound:
            return RouteHandlerResponse(
                status: .notFound,
                contentType: "plain/text",
                data: "NotFound".data(using: .utf8)!
            )
        case .notEnoughtAmount:
            return RouteHandlerResponse(
                status: .badRequest,
                contentType: "plain/text",
                data: "NotEnoughtAmount".data(using: .utf8)!
            )
            
        default:
            return RouteHandlerResponse(
                status: .internalServerError,
                contentType: "plain/text",
                data: "".data(using: .utf8)!
            )
        }
    }
    
    func getData(userId: String) async -> RouteHandlerResponse {
        let result = await cartUseCase.fetchCart(userId: userId)
        
        if case .failure(_) = result {
            
        }
        
        switch result {
        case .failure(let error):
            return mapUseCaseError(error: error)
        case .success(let cart):
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            let output = OutputCart(cart: cart)
            return RouteHandlerResponse(
                status: .ok,
                contentType: "application/json",
                data: try! encoder.encode(output)
            )
        }
    }
}
