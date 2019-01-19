//
//  Category.swift
//  Releam
//
//  Created by Mohamed Elsayed on 1/18/19.
//  Copyright © 2019 Sayedovic. All rights reserved.
//

import Foundation
import RealmSwift


class Category: Object{
    @objc dynamic var name: String = ""
    
    let items = List<Items>()
    
}
