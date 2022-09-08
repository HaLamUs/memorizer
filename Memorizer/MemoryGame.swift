//
//  MemoryGame.swift
//  Memorizer
//
//  Created by lamha on 08/09/2022.
//

import Foundation

struct MemoryGame<CardContent> {
    private(set) var cards: Array<Card>
    
    func choose(_ card: Card) {
        
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairItem in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairItem)
            cards.append(Card(content: content))
            cards.append(Card(content: content))
        }
    }
    
    /*
        Why nested cause we'll have this MemoryGame.Card
        incase: PokerGame.Card
     */
    struct Card {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        /*
         why genetic cause we think we can do better version
         */
        var content: CardContent
    }
}
