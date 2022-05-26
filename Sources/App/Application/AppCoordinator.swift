//
//  File.swift
//  
//
//  Created by Azat Kaiumov on 25.05.22.
//

import Foundation
import Vapor

public final class ServerApp {
    
    private let routerDIContainer: RouterDIContainer
    private var env: Environment
    lazy var appConfiguration = AppConfiguration()
    
    public init() {
        routerDIContainer = RouterDIContainer()
        env = try! Environment.detect()
    }
    
    public func run() {
        let router = routerDIContainer.makeRouter()
        
        try! LoggingSystem.bootstrap(from: &env)
        let app = Application(env)
        defer { app.shutdown() }
        
        router.route(app: app)
        app.http.server.configuration.hostname = appConfiguration.hostName
        
        try! app.run()
    }
}
