//
//  ListObject.swift
//  TestiOSCurrency
//
//  Created by Dmitry Grebenschikov on 12/09/2018.
//  Copyright © 2018 dd-team. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

public protocol ListObjectDelegatable: class { }

public protocol ListObject {
    static var identifier: String { get }
    func configure(with viewModel: ListObjectModel, delegate: ListObjectDelegatable?)
}

public extension ListObject {
    static var identifier: String {
        return String(describing: self)
    }
}

public protocol ListObjectModel {
    static var associatedListObject: ListObject.Type { get }
    var id: String? { get }
}

extension ListObjectModel {
    
    var identifier: String {
        return type(of: self).associatedListObject.identifier
    }
    
    public var id: String? {
        get {
            return nil
        }
    }
}
