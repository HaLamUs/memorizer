//
//  MemorizerApp.swift
//  Memorizer
//
//  Created by lamha on 07/09/2022.
//

import SwiftUI

@main
struct MemorizerApp: App {
    /*
     Only the pointer is let, the one it point is NOT
     */
    let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
