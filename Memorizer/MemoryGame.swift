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
    private(set) var cards: Array<Card> // (1)
    
    //    private var thePreviousOne: Int? // (2)
    
    /*
     Potential bug
     (1) có thể chứa thằng đc chọn
     (2) chứa index thằng đc chọn
     Lỡ code sai ko sync thì có vấn đề
     Fix: dùng computed
     */
    private var thePreviousOne: Int? {
        get {
//            var faceUpCardIndices = [Int]()
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    faceUpCardIndices.append(index)
//                }
//            }
//            if faceUpCardIndices.count == 1 {
//                return faceUpCardIndices.first
//            }
//            return nil
            
//            var faceUpCardIndices = cards.indices.filter({ index in cards[index].isFaceUp })
//            var faceUpCardIndices = cards.indices.filter({ cards[$0].isFaceUp })
//            return faceUpCardIndices.oneAndOnly
            cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
            
        }
        set {
//            for index in cards.indices {
//                if index != newValue {
//                    cards[index].isFaceUp = false
//                } else {
//                    cards[index].isFaceUp = true
//                }
//            }
            cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) }
        }
        
    }
    
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
                cards[chosenIndex].isFaceUp = true // we want face it up
            } else {
                /*
                 3 steps
                 1. Face down all --> check the set 
                 2. Keep the current
                 3. store the current
                 */
                thePreviousOne = chosenIndex
            }
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
        let content: CardContent
        let id: Int // dont allow change after created
    }
}

extension Array {
    var oneAndOnly: Element? { // cmd + click to see Dont care type
        if count == 1 {
            return self.first
        }
        return nil
    }
}
