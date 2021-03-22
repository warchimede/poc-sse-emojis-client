//
//  EventStreamParser.swift
//  poc-sse-emojis-client
//
//  EventSource by Karim-Pierre Maalej is licensed under CC BY 4.0
//

import Foundation

final class EventStreamParser {
  private var buffer = Data()
  private let delimiters = ["\r\n", "\n", "\r"].map { "\($0)\($0)".data(using: .utf8)! }

  func append(data: Data) -> [Event] {
    buffer.append(data)
    let eventStrings = buffer
      .extractData(separatedBy: delimiters)
      .compactMap { String(data: $0, encoding: .utf8) }
      .map { Event(string: $0) }
    return eventStrings
  }
}


extension Data {
  mutating func extractData(separatedBy delimiters: [Data]) -> [Data] {
    var eventsData = [Data]()
    while let delimiterRange = firstRange(of: delimiters) {
      eventsData.append(subdata(in: startIndex ..< delimiterRange.lowerBound))
      removeSubrange(startIndex ..< delimiterRange.upperBound)
    }
    return eventsData
  }

  func firstRange(of delimiters: [Data]) -> Range<Index>? {
    for delimiter in delimiters {
      if let foundRange = firstRange(of: delimiter) {
        return foundRange
      }
    }
    return nil
  }
}
