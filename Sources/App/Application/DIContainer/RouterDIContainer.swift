//
//  RouterDIContainer.swift
//  
//
//  Created by Azat Kaiumov on 25.05.22.
//

import Foundation

final class RouterDIContainer {
    private let publicDirectory: String
    
    init(publicDirectory: String) {
        self.publicDirectory = publicDirectory
    }
    
    func makeProductsRepository() -> ProductsRepository {
        return ProductsRepositoryMock(imagesDirectory: publicDirectory + "/images/products/")
    }
    
    func makeProductsUseCase() -> ProductsUseCase {
        return DefaultProductsUseCase(productsRepository: makeProductsRepository())
    }
    
    func makeGetProductModel() -> GetProductViewModel {
        return DefaultGetProductViewModel(productsUseCase: makeProductsUseCase())
    }
    
    func makeGetProductRouteHandler() -> RouteHandler {
        return DefaultGetProductHandler(viewModel: makeGetProductModel())
    }
    
    func makeRouter() -> Router {
        let routes = [
            RouteConfiguration(
                path: "/products/:id",
                method: .GET,
                handler: makeGetProductRouteHandler()
            )
        ]
        
        let config = RouterConfiguration(routes: routes)
        
        return Router(configuration: config)
    }
}
