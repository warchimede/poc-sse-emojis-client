//
//  ContentView.swift
//  poc-sse-emojis-client
//
//  Created by William Archimède on 22/03/2021.
//

import SwiftUI

struct ContentView: View {
  @ObservedObject var dataSource = EmojiStream()

  var body: some View {
    ConnectButton(state: dataSource.state, viewModel: dataSource)
    ForEach((0..<dataSource.emojis.count), id: \.self) { index in
      EmojiView(emoji: dataSource.emojis[index])
        .animation(.default)
    }

    HStack {
      EmojiButton(emoji: .thumbsup, viewModel: dataSource)
      EmojiButton(emoji: .clap, viewModel: dataSource)
      EmojiButton(emoji: .heart, viewModel: dataSource)
      EmojiButton(emoji: .flag, viewModel: dataSource)
    }
  }
}

struct EmojiView: View {
  let emoji: Emoji

  var body: some View {
    Text(emoji.description)
  }
}

struct ConnectButton: View {
  var state: EventSourceState
  var viewModel: EmojiStream

  var body: some View {
    HStack {
      Text(state.description)

      if state == .closed {
        Text("-")
        Button("se reconnecter") {
          viewModel.connect()
        }
      }
    }
  }
}

struct EmojiButton: View {
  var emoji: Emoji
  var viewModel: EmojiStream

  var body: some View {
    Button(emoji.description) {
      viewModel.send(emoji)
    }
  }
}

extension EventSourceState {
  var description: String {
    switch self {
    case .closed: return "déconnecté"
    case .connecting: return "connexion..."
    case .open: return "connecté"
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
