//
//  CurrencyAssembly.swift
//  TestiOSCurrency
//
//  Created by Dmitry Grebenschikov on 08/09/2018.
//  Copyright © 2018 dd-team. All rights reserved.
//

import Foundation

class CurrencyAssembly: BaseAssembly {
    
    static func configure() {
        guard let container = defaultContainer() else { return }
        
        container.register(CurrencyViewProtocol.self) { resolver in
            let vc = CurrencyViewController()
            vc.viewModel = resolver.resolve(CurrencyViewModelProtocol.self, argument: vc as CurrencyViewProtocol)!
            return vc
        }
        
        container.register(CurrencyViewModelProtocol.self) { (resolver, view: CurrencyViewProtocol) in
            CurrencyViewModel(view: view,
                              ratesRepo: resolver.resolve(CurrencyRatesRepositoryProtocol.self)!)
        }
    }
}
