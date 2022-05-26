//
//  DefaultProductsRepository.swift
//  
//
//  Created by Azat Kaiumov on 25.05.22.
//

import Foundation

final class ProductsRepositoryMock {
    private let imagesDirectory: String
    private let products: [Product]
    
    init(imagesDirectory: String) {
        self.imagesDirectory = imagesDirectory
        self.products = Self.generateProducts(imagesDirectory: imagesDirectory, length: 1000)
    }
}


extension ProductsRepositoryMock: ProductsRepository {
    func fetchProduct(productId: String) async -> Result<Product, ProductsUseCaseError> {
        guard
            let product = products.first(where: { $0.id == productId })
        else {
            return .failure(.productNotFound)
        }
     
        return .success(product)
    }
    
    func searchProducts(sort: [SortParams]) async throws -> ProductsPage {
        fatalError("Not implemented")
    }
}


extension ProductsRepositoryMock {
    static func generateProducts(imagesDirectory: String, length: Int) -> [Product] {
        let descriptions = [
            """
            The jacket features the Tommy Hilfiger signature flag on the left chest and the “Hilfiger” name on the back of the collar; Hilfiger logo patch on arm for added flair;
            Also features a front zipper closure, two side pockets with zipper closures, and an interior hidden zipper pocket
            """,
            """
            The jacket features the Tommy Hilfiger signature flag on the left chest and the “Hilfiger” name on the back of the collar; Hilfiger logo patch on arm for added flair
            Also features a front zipper closure, two side pockets with zipper closures, and an interior hidden zipper pocket
            """
        ]
        
        let brands = ["NIKE", "Adidas", "Columbia", "Tommy Po", "Cool Jack", "Cool Brand", "Uncle Po"]
        let names = ["Rain Jacket", "Cool Jacket", "Trucker Jacket", "Interchange Jacket", "Flat Jacket", "Comfort Jacket"]
        var images = getImages(imagesDirectory: imagesDirectory)
        images.shuffle()
        
        var result = [Product]()
        
        var imageIndex = 0
        
        for index in 0..<length {
            if imageIndex >= images.count {
                imageIndex = 0
            }
            
            let product = Product(
                id: "id-\(index)",
                name: names.randomElement()!,
                brand: brands.randomElement() ?? brands.first!,
                description: descriptions.randomElement() ?? descriptions.first!,
                image: "/images/products/" + images[imageIndex],
                price: Double.random(in: 30...300)
            )
            
            result.append(product)
            
            imageIndex += 1
        }
        
        return result
    }
    
    static func getImages(imagesDirectory: String) -> [String] {

        let files = try! FileManager.default.contentsOfDirectory(atPath: imagesDirectory)

        return files.filter { fileName in

            let fullPath = imagesDirectory.appending(fileName)
            var isDirectory: ObjCBool = false

            let isExists = FileManager.default.fileExists(
                atPath: fullPath,
                isDirectory:  &isDirectory
            )

            return isExists && !isDirectory.boolValue
        }
    }
}
