//
//  QueryAssembly.swift
//  TestiOSCurrency
//
//  Created by Dmitry Grebenschikov on 12/09/2018.
//  Copyright © 2018 dd-team. All rights reserved.
//

import Foundation
import Swinject

class QueryAssembly: BaseAssembly {
    
    static func configure() {
        
        defaultContainer()?.register(RatesQueryProtocol.self, factory: { resolver in
            RatesQuery()
        })
        
    }
}
