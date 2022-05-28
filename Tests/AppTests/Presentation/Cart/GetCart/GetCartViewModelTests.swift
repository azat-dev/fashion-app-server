//
//  File.swift
//  
//
//  Created by Azat Kaiumov on 27.05.22.
//

@testable import App
import XCTest

class GetCartViewModelTests: XCTestCase {

    var viewModel: GetCartHandlerModel!
    var cartRepository: CartRepositoryMock!

    override func setUpWithError() throws {

        cartRepository = CartRepositoryMock()
        let cartUseCase = DefaultCartUseCase(cartRepository: cartRepository)
        viewModel = DefaultGetCartHandlerModel(cartUseCase: cartUseCase)
    }

    func test_getData_success() async {

        let testProduct = Product(
            id: "test_id \(Date.now)",
            name: "test_name",
            brand: "test_brand",
            description: "test_description",
            image: "",
            price: 10
        )

        let testCart = Cart(
            items: [
                CartItem(
                    product: testProduct,
                    amount: 100,
                    updateAt: .now
                )
            ]
        )

        let _ = await cartRepository.putCart(userId: "test", data: testCart)
        let responseData = await viewModel.getData(userId: "test")

        XCTAssertEqual(responseData.status, .ok)

        let decoder = JSONDecoder()

        let parsedCart = try! decoder.decode(OutputCart.self, from: responseData.data)

        XCTAssertEqual(parsedCart.items.count, testCart.items.count)
        XCTAssertEqual(parsedCart.items.first?.product.id, testCart.items.first?.product.id)
    }
}
