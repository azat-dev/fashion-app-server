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
    public var app: Application
    private lazy var appConfiguration = AppConfiguration()
    
    public init() {
        
        env = try! Environment.detect()
        try! LoggingSystem.bootstrap(from: &env)
    
        app = Application(env)
        app.http.server.configuration.hostname = appConfiguration.hostName
        
        let routerDIContainer = RouterDIContainer(
            publicDirectory: app.directory.publicDirectory
        )
        
        let router = routerDIContainer.makeRouter()
        router.route(app: app)
    }
    
    public func shutdown() {
        app.shutdown()
    }
    
    public func run() {
        defer { shutdown() }
        
        try! app.run()
    }
}
