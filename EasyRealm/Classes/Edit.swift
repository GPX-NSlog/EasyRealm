//
//  ER_Edit.swift
//  Pods
//
//  Created by Allan Vialatte on 23/11/16.
//
//

import Foundation
import Realm
import RealmSwift

public extension EasyRealm where T: Object {
    func edit(_ closure: @escaping (_ T: T) -> Void) throws {
        self.isManaged ? try managed_edit(closure) : try unmanaged_dit(closure)
    }
}

private extension EasyRealm where T: Object {
    func managed_edit(_ closure: @escaping (_ T: T) -> Void) throws {
        guard let rq = EasyRealmQueue() else { throw EasyRealmError.RealmQueueCantBeCreate }
        let ref = ThreadSafeReference(to: self.base)
        try rq.queue.sync {
            guard let object = rq.realm.resolve(ref) else { throw EasyRealmError.ObjectCantBeResolved }
            try rq.realm.write { closure(object) }
        }
    }

    func unmanaged_dit(_ closure: @escaping (_ T: T) -> Void) throws {
        closure(self.base)
    }
}
