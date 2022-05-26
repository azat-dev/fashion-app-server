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
    
    func makeProductEndpointModel() -> ProductEndpointModel {
        return DefaultProductEndpointModel(productsUseCase: makeProductsUseCase())
    }
    
    func makeProductEndpoint() -> RouteEndpoint {
        return DefaultProductEndpoint(endpointModel: makeProductEndpointModel())
    }
    
    func makeRouter() -> Router {
        let routes: [RouteConfiguration] = [
            .init(path: "/products/:id", endpoint: makeProductEndpoint())
        ]
        
        let config = RouterConfiguration(routes: routes)
        
        return Router(configuration: config)
    }
}
