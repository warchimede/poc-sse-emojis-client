//
//  Event.swift
//  poc-sse-emojis-client
//
//  EventSource by Karim-Pierre Maalej is licensed under CC BY 4.0
//

import Foundation

struct Event {
  var id: String?
  var event: String?
  var data: String?
  var retry: Int?

  init(string eventString: String) {
    let lines = eventString.components(separatedBy: .newlines)
    let eventDictionary = lines.reduce(into: [String: String]()) { (event, line) in
      let (key, value) = parse(line: line)

      if let previousValue = event[key] {
        event[key] = "\(previousValue)\n\(value)"
      } else {
        event[key] = value
      }
    }

    self.id = eventDictionary["id"]
    self.event = eventDictionary["event"]
    self.data = eventDictionary["data"]
    self.retry = eventDictionary["retry"].flatMap { Int($0) }
  }

  private func parse(line: String) -> (key: String, value: String) {
    let parts = line.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: false)
    let key = String(parts[0]).trimmingCharacters(in: .whitespaces)
    let value = String(parts[1]).trimmingCharacters(in: .whitespaces)
    return (key, value)
  }
}
