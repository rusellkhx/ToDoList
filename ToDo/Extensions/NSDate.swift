//
//  NSDate.swift
//  ToDo
//
//  Created by Rusell on 08.02.2021.
//

import Foundation

extension NSDate: Comparable {
    static public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
        return lhs === rhs || lhs.compare(rhs as Date) == .orderedSame
    }

    static public func <(lhs: NSDate, rhs: NSDate) -> Bool {
        return lhs.compare(rhs as Date) == .orderedAscending
    }
}
