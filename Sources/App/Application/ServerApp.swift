//
//  File.swift
//  
//
//  Created by Azat Kaiumov on 25.05.22.
//

import Foundation
import Vapor

public final class ServerApp {
    
    private var env: Environment
    lazy var appConfiguration = AppConfiguration()
    
    public init() {
        
        env = try! Environment.detect()
    }
    
    public func run() {
        
        try! LoggingSystem.bootstrap(from: &env)
        let app = Application(env)
        defer { app.shutdown() }
        app.http.server.configuration.hostname = appConfiguration.hostName
        
        let routerDIContainer = RouterDIContainer(
            publicDirectory: app.directory.publicDirectory
        )
        
        let router = routerDIContainer.makeRouter()
        router.route(app: app)
        
        try! app.run()
    }
}
