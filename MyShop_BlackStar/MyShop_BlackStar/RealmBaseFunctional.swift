//
//  RealmBaseFunctional.swift
//  MyShop_BlackStar
//
//  Created by Norik on 04.01.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import Foundation

protocol RealmTableFunctional {
    func countAll() -> Int
    func delete(index: Int)
    func remove()
    func listAll() -> [ItemsRealm]
}
