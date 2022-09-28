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
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairItem in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairItem)
            cards.append(Card(content: content, id: pairItem*2))
            cards.append(Card(content: content, id: pairItem*2 + 1))
        }
        cards.shuffle()
    }
    
    /*
     Why nested cause we'll have this MemoryGame.Card
     incase: PokerGame.Card
     */
    struct Card: Identifiable {
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched: Bool = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        /*
         why genetic cause we think we can do better version
         */
        let content: CardContent
        let id: Int // dont allow change after created
        
        // MARK: Bonus time
        
        /*
         this could give matching bonus points
         if the user matches the card
         before a certain amount of time passes during which the card is face up
         */
        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        
        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        // how muc time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit: 0
        }
        
        //whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        
        // whether we are currently faceip, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }

        //called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
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
