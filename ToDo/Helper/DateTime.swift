//
//  DateTime.swift
//  ToDo
//
//  Created by Rusell on 07.02.2021.
//

import Foundation

public func takeDateTime(dateTime: NSDate) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.YYYY HH:mm"
    formatter.timeZone = TimeZone(secondsFromGMT: 3)
    let formattedDate = formatter.string(from: dateTime as Date)
    return formattedDate
}
