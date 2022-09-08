//
//  EmojiMemoryGame.swift
//  Memorizer
//
//  Created by lamha on 08/09/2022.
//

import Foundation

//func makeCardContent(index: Int) -> String {
//    return "🛰"
//}

class EmojiMemoryGame {
    
    /*
     1.  Its global BUt with scope
     2. Static belong to type NOT instance 
     */
    static let emojis = ["🚕", "🚌", "🚜", "🛵", "🚙", "🚎", "🛻", "🏎", "🚗", "🚘", "🏍", "🚆", "🚡", "✈️", "🚁", "🛺", "⛵️", "🚤", "🛥", "🛰"]
    
    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 4) {
            pairIndex in
            EmojiMemoryGame.emojis[pairIndex]
        }
    }
    
    /*
     1. VM will create Model
     2. We choose String cause this is Emoji VM
     */
    private var model: MemoryGame<String> =
//    MemoryGame<String>(numberOfPairsOfCards: 4, createCardContent: makeCardContent)
//    MemoryGame<String>(numberOfPairsOfCards: 4, createCardContent: {(index: Int) -> String in
//        return "🛰"
//    })
//    MemoryGame<String>(numberOfPairsOfCards: 4) {
//        pairIndex in
//        EmojiMemoryGame.emojis[pairIndex]
//    }
    createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card> {
        // this way READONly 
        return model.cards
    }
}
