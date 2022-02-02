//
//  API+CustomScalars.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 26/07/2021.
//

import Apollo
import Foundation

enum CustomScalarParserError: Error {
    case invalidTimeFormat
}


public struct `Any` {
    let value: String
}


extension `Any`: JSONDecodable {
    public init(jsonValue value: JSONValue) throws {
        let data = try JSONSerialization.data(withJSONObject: value)
        self.value = String(data: data, encoding: .utf8)!
    }
}

public struct Time: JSONEncodable {
    
    let rawValue: String
    
    public var jsonValue: JSONValue {
        rawValue
    }
    
    static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }
    
    static var isoDateParser: ISO8601DateFormatter {
        let parser = ISO8601DateFormatter()
        parser.formatOptions = [.withFullDate,
                                .withTime,
                                .withDashSeparatorInDate,
                                .withColonSeparatorInTime]
        return parser
    }
    
    var date: Date {
        Self.isoDateParser.date(from: rawValue)!
    }
    
    init(raw: String) {
        self.rawValue = raw
    }
    
    init(date: Date) {
        self.rawValue = Self.dateFormatter.string(from: date)
    }
}

extension Time: JSONDecodable {
    public init(jsonValue value: JSONValue) throws {
        guard let stringVal = value as? String else {
            throw CustomScalarParserError.invalidTimeFormat
        }
        
        self.rawValue = stringVal
    }
}

extension Time: Hashable {
    
}

extension TimelineQuery.Data.MyTimeline: Equatable {
    public static func == (lhs: TimelineQuery.Data.MyTimeline, rhs: TimelineQuery.Data.MyTimeline) -> Bool {
        lhs.id == rhs.id
    }
}
