import Vapor

func routes(_ app: Application) throws {
    initProducts(app: app)
    
    app.get { req in
        return "It works!"
    }

    app.get("products", use: handleGetProducts)
    app.get("products", ":id", use: handleGetProduct)
}
