//
//  RepoAssembly.swift
//  TestiOSCurrency
//
//  Created by Dmitry Grebenschikov on 12/09/2018.
//  Copyright © 2018 dd-team. All rights reserved.
//

import Foundation
import Swinject

final class RepoAssembly: BaseAssembly {
    
    static func configure() {
        
        defaultContainer()?.register(CurrencyRatesRepositoryProtocol.self, factory: { resolver in
            CurrencyRatesRepository(ratesQuery: resolver.resolve(RatesQueryProtocol.self)!)
        })
        
    }
}
