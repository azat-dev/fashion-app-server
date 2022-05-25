import Vapor
import Darwin

struct Product: Codable {
    var id: String
    var name: String
    var brand: String
    var description: String
    var image: String
    var price: Double
}

struct ResponseProductsList: Codable {
    var total: Int
    var items: [Product]
}

func getImages(app: Application) -> [String] {
    let imagesDirectoryPath = app.directory.publicDirectory.appending("images/products/")
    
    let files = try! FileManager.default.contentsOfDirectory(atPath: imagesDirectoryPath)
    
    return files.filter { fileName in
        
        let fullPath = imagesDirectoryPath.appending(fileName)
        var isDirectory: ObjCBool = false
        
        let isExists = FileManager.default.fileExists(
            atPath: fullPath,
            isDirectory:  &isDirectory
        )
        
        return isExists && !isDirectory.boolValue
    }
}

func generateProducts(app: Application, length: Int) -> [Product] {
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
    var images = getImages(app: app)
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

fileprivate var products: [Product]!

func initProducts(app: Application) {
    if products == nil {
        products = generateProducts(app: app, length: 1000)
    }
}

struct QueryParamsProducts: Content {
    var from: UInt
    var limit: UInt
}

func handleGetProducts(req: Request) -> Response {
    
    sleep(5)
    var headers = HTTPHeaders()
    
    guard
        let queryParams = try? req.query.decode(QueryParamsProducts.self)
    else {
        headers.contentType = .plainText
        return Response(
            status: .badRequest,
            version: .http2,
            headers: headers,
            body: "Wrong query params"
        )
    }
    
    headers.contentType = .json
    

    var filteredProducts = [Product]()
    
    for index in queryParams.from...(queryParams.from + queryParams.limit) {
        if index >= products.count {
            break
        }
        
        let product = products[Int(index)]
        filteredProducts.append(product)
    }

    let responseData = ResponseProductsList(
        total: products.count,
        items: filteredProducts
    )
    
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    let encodedProducts = try! encoder.encode(responseData)
 
    
    return Response(
        status: .ok,
        version: .http2,
        headers: headers,
        body: .init(string: String(data: encodedProducts, encoding: .utf8)!)
    )
}

func handleGetProduct(req: Request) -> Response {
    
    sleep(5)
    var headers = HTTPHeaders()
    
    let productId = req.parameters.get("id")
    let product = products.first { $0.id == productId }
    
    guard let product = product else {
        headers.contentType = .plainText
        
        return Response(
            status: .notFound,
            version: .http2,
            headers: headers,
            body: "The product isn't found"
        )
    }
    
    headers.contentType = .json
    
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    let encodedProduct = try! encoder.encode(product)
    
    return Response(
        status: .ok,
        version: .http2,
        headers: headers,
        body: .init(data: encodedProduct)
    )
}
