//
//  MemoryGame.swift
//  Memorizer
//
//  Created by lamha on 08/09/2022.
//

import Foundation

/*
    CardContent is dont care type BUT it must behave like like Equatable
 */
struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    
    private var thePreviousOne: Int?
    
    mutating func choose(_ card: Card) {
        //        if let chosenIndex = index(of: card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }), !cards[chosenIndex].isFaceUp,
            !cards[chosenIndex].isMatched {
            /*
             1. theOne mean the previous
             2. chosenIndex mean the current
             */
            if let thePrevious = thePreviousOne { // mean you choose ONE before
                // check if match
                if cards[thePrevious].content == cards[chosenIndex].content {
                    cards[thePrevious].isMatched = true
                    cards[chosenIndex].isMatched = true
                }
                thePreviousOne = nil
            } else {
                /*
                 3 steps
                 1. Face down all
                 2. Keep the current
                 3. store the current
                 */
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                thePreviousOne = chosenIndex
            }
            cards[chosenIndex].isFaceUp.toggle()
        }
    }
    
    //    func index(of card: Card) -> Int? {
    //        for index in 0..<cards.count {
    //            if card.id == cards[index].id  {
    //                return index
    //            }
    //        }
    //        return nil
    //    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairItem in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairItem)
            cards.append(Card(content: content, id: pairItem*2))
            cards.append(Card(content: content, id: pairItem*2 + 1))
        }
    }
    
    /*
     Why nested cause we'll have this MemoryGame.Card
     incase: PokerGame.Card
     */
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        /*
         why genetic cause we think we can do better version
         */
        var content: CardContent
        var id: Int
    }
}
