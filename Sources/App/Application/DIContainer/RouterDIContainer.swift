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
    
    func makeListProductsModel() -> ListProductsHandlerModel {
        return DefaultListProductsHandlerModel(productsUseCase: makeProductsUseCase())
    }
    
    func makeListProductsHandler() -> RouteHandler {
        return DefaultListProductsHandler(viewModel: makeListProductsModel())
    }
    
    func makeImagesFilesUseCase() -> FilesUseCase {
        return DefaultFilesUseCase(rootDirectory: "\(publicDirectory)/images")
    }
    
    func makeGetImageHandler() -> GetFileHandlerModel {
        return DefaultGetFileHandlerModel(filesUseCase: makeImagesFilesUseCase())
    }
    
    func makeGetImageRouteHandler() -> RouteHandler {
        return DefaultGetFileHandler(viewModel: makeGetImageHandler())
    }
    
    func makeCartRepository() -> CartRepository {
        return CartRepositoryMock()
    }
    
    func makeCartUseCase() -> CartUseCase {
        return DefaultCartUseCase(cartRepository: makeCartRepository())
    }
    
    func makeGetCartViewModel() -> GetCartHandlerModel {
        return DefaultGetCartHandlerModel(cartUseCase: makeCartUseCase())
    }
    
    func makeGetCartHandler() -> GetCartHandler {
        return DefaultGetCartHandler(viewModel: makeGetCartViewModel())
    }
    
    func makeRouter() -> Router {
        let routes = [
            RouteConfiguration(
                path: "/products/:id",
                method: .GET,
                handler: makeGetProductRouteHandler()
            ),
            
            RouteConfiguration(
                path: "/products",
                method: .GET,
                handler: makeListProductsHandler()
            ),
            
            RouteConfiguration(
                path: "/images/**",
                method: .GET,
                handler: makeGetImageRouteHandler()
            ),
            
            RouteConfiguration(
                path: "/cart",
                method: .GET,
                handler: makeGetCartHandler()
            )
        ]
        
        let config = RouterConfiguration(routes: routes)
        
        return Router(configuration: config)
    }
}
