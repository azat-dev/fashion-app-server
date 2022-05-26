//
//  Router.swift
//  
//
//  Created by Azat Kaiumov on 25.05.22.
//

import Foundation
import Vapor

struct RouteConfiguration {
    var path: String
    var endpoint: RouteEndpoint
}

struct RouterConfiguration {
    let routes: [RouteConfiguration]
}

class Router {
    
    let configuration: RouterConfiguration
    
    init(configuration: RouterConfiguration) {
        self.configuration = configuration
    }
    
    func route(app: Application) {
        
        for route in configuration.routes {
            app.get("") { req in
                return Response(status: .ok)
            }
            
            let path = route.path.pathComponents
            
            app.get(path, use: route.endpoint.get)
            app.post(path, use: route.endpoint.post)
            app.put(path, use: route.endpoint.put)
        }
    }
}
