//
//  EmojisStream.swift
//  poc-sse-emojis-client
//
//  Created by William Archimède on 22/03/2021.
//

import Foundation

enum Emoji: String, CustomStringConvertible {
  case clap
  case heart
  case thumbsup
  case flag

  var description: String {
    switch self {
    case .clap: return "👏"
    case .heart: return "❤️"
    case .thumbsup: return "👍"
    case .flag: return "🇫🇷"
    }
  }
}

class EmojiStream: ObservableObject {
  private static let baseURL = "http://localhost:8080"

  @Published var emojis = [Emoji]()
  @Published var state: EventSourceState = .closed

  let eventSource = EventSource(url: URL(string: "\(baseURL)/emojis")!)

  init() {
    eventSource.addEventListener("emoji") { [weak self] (_, _, data) in
      guard let emoji = data.flatMap(Emoji.init(rawValue:)) else { return }
      self?.emojis.append(emoji)
    }
    eventSource.onOpen { self.state = .open }
    eventSource.onComplete { (_, _, _) in self.state = .closed }
    connect()
  }

  func connect() {
    guard state == .closed else { return }
    state = .connecting
    eventSource.connect()
  }

  func send(_ emoji: Emoji) {
    let url = URL(string: "\(Self.baseURL)/send/\(emoji.rawValue)")!
    URLSession.shared.dataTask(with: url).resume()
  }
}
