//
//  GlobalAssembly.swift
//  TestiOSCurrency
//
//  Created by Dmitry Grebenschikov on 08/09/2018.
//  Copyright © 2018 dd-team. All rights reserved.
//

import Foundation
import Swinject

final class GlobalAsslembly: BaseAssembly {
    
    static func configure() {
        CurrencyAssembly.configure()
        RepoAssembly.configure()
        QueryAssembly.configure()
    }
}
