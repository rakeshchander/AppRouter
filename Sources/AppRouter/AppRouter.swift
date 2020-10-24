//
//  AppRouterBuilder.swift
//
//  Created by Rakesh Chander.
//

import Foundation

public class AppRouter{
    
    var targetRoute : (router : RouteHandler, payload: [AnyHashable:Any]?)? = nil
    
    var routerMap : [String: RouteHandler] = [:]
    
    func register(route : RouteHandler){
        self.routerMap[route.path] = route
    }
    
    func handlePendingRoute(){
        if let pendingRoute = self.targetRoute, isAuthenticated {
            pendingRoute.router.routeHandler(pendingRoute.payload)
            self.targetRoute = nil
        }
    }
    
    public static var sharedInstance : AppRouter = AppRouter.init()
    
    public var isAuthenticated : Bool = false {
        didSet{
            self.handlePendingRoute()
        }
    }
    
    public func route(urlPath : String, payload: [AnyHashable: Any]? = nil) {
        if let routeDataSource = self.routerMap[urlPath.path] {
            if !routeDataSource.isAuthRequired || (routeDataSource.isAuthRequired && isAuthenticated)  {
                routeDataSource.routeHandler(payload ?? urlPath.queryParameters)
            } else {
                self.targetRoute = (routeDataSource, payload ?? urlPath.queryParameters)
            }
        }
    }
    
}


extension String {
    var queryParameters: [AnyHashable: Any] {
        guard let url = URL.init(string: self),
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return [:] }
        return queryItems.reduce(into: [AnyHashable: Any]()) { (result, item) in
            result[item.name] = item.value?.removingPercentEncoding
        }
    }
    
    var path: String {
        guard let url = URL.init(string: self),
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                return ""
        }
            return components.path
    }
}
