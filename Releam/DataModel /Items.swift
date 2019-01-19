//
//  Items.swift
//  Releam
//
//  Created by Mohamed Elsayed on 1/18/19.
//  Copyright © 2019 Sayedovic. All rights reserved.
//


import Foundation
import RealmSwift


class Items: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
