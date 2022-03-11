//
//  ER_Variable.swift
//  Pods
//
//  Created by Allan Vialatte on 05/03/2017.
//

import Foundation
import Realm
import RealmSwift

public extension EasyRealm where T: Object {
    var isManaged: Bool {
        return (self.base.realm != nil)
    }

    var managed: T? {
        guard let realm = try? Realm(), let key = T.primaryKey() else { return nil }
        let object = realm.object(ofType: T.self, forPrimaryKey: self.base.value(forKey: key))
        return object
    }

    var unmanaged: T {
        return self.base.easyDetached()
    }

    internal func detached() -> T {
        return self.base.easyDetached()
    }
}

private extension Object {
    func easyDetached() -> Self {
        let detached = type(of: self).init()
        for property in objectSchema.properties {
            guard let value = value(forKey: property.name) else { continue }
            if let detachable = value as? Object {
                detached.setValue(detachable.easyDetached(), forKey: property.name)
            } else if let detachable = value as? EasyRealmList {
                detached.setValue(detachable.children().compactMap { $0.easyDetached() }, forKey: property.name)
            } else {
                detached.setValue(value, forKey: property.name)
            }
        }
        return detached
    }
}
