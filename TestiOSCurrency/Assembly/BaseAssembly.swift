//
//  BaseAssembly.swift
//  TestiOSCurrency
//
//  Created by Dmitry Grebenschikov on 08/09/2018.
//  Copyright © 2018 dd-team. All rights reserved.
//

import Foundation
import Swinject

protocol BaseAssembly {
    static func configure()
}

extension BaseAssembly {
    static func defaultContainer() -> Container? {
        return (UIApplication.shared.delegate as? AppDelegate)?.container
    }
    
    static func resolve<T>(_ serviceType: T.Type) -> T? {
        return defaultContainer()?.resolve(serviceType)
    }
}
