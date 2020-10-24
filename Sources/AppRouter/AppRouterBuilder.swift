//
//  AppRouterBuilder.swift
//
//  Created by Rakesh Chander.
//

import Foundation

struct RouteHandler  {
    let path : String
    let routeHandler : AppRouteHandler
    var isAuthRequired : Bool = true
    
    init(path : String, routeHandler : @escaping AppRouteHandler) {
        self.path = path
        self.routeHandler = routeHandler
    }
}

public typealias AppRouteHandler = (_ payload:[AnyHashable:Any]?) -> Void

public extension AppRouter {
    class Builder {
        
        var routeHandler : RouteHandler
        
        public init(path: String, route: @escaping AppRouteHandler) {
            self.routeHandler = RouteHandler.init(path: path, routeHandler: route)
        }
        
        public func isAuthRequired(isRequired: Bool) -> Builder {
            self.routeHandler.isAuthRequired = isRequired
            return self
        }
        
        public func build(){
            AppRouter.sharedInstance.register(route: self.routeHandler)
        }
        
    }
}
