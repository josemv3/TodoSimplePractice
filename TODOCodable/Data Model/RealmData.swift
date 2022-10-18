//
//  RealmData.swift
//  TODOCodable
//
//  Created by Joey Rubin on 10/18/22.
//

import Foundation
import RealmSwift


class RealmData: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
