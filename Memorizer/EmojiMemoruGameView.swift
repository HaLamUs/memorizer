//
//  EmojiMemoruGameView.swift
//  Memorizer
//
//  Created by lamha on 07/09/2022.
//

import SwiftUI

struct EmojiMemoruGameView: View {
    /*
     variable name body has type 'some View' determine as RunTime
     Like sub Lego (some View) inside the Lego (View)
     combiner View
     
     1. Inspector -> Add modifier
     */
    
    //    var emojis = ["🚕", "🚌","🚌", "🚜", "🛵"] // cause it not distinc so got double click
    @ObservedObject var game: EmojiMemoryGame
    
    //    var body: some View {
    //        VStack {
    //            ScrollView {
    //                /*
    //                 Lazy meaning accessing var body when need
    //                 */
    //                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
    //                    ForEach(game.cards) { card in
    //                        CardView(card: card)
    //                            .aspectRatio(2/3, contentMode: .fit)
    //                            .onTapGesture {
    //                                 game.choose(card)
    //                            }
    //                    }
    //                }
    //            }
    //            .foregroundColor(.red)
    //
    //        }
    //        .padding()
    //    }
    
    @Namespace private var dealingNamespace
    
    // To understand protocol we will write ViewCombiner
    var body: some View {
        // Để như thế này xoay ngang nó ko lấy hết view rất chán
//        VStack{
//            gameBody
//            deckBody
//            HStack {
//                shuffle
//                Spacer()
//                restart
//            }
//            .padding(.horizontal)
//        }
        /*
         Use ZStack in case 1 view appear other disappear
         */
        ZStack(alignment: .bottom) {
            VStack{
                gameBody
                HStack {
                    shuffle
                    Spacer()
                    restart
                }
                .padding(.horizontal)
            }
            deckBody
        }
        .padding()
    }
    
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3, content: { card in
            cardView(for: card)
        })
           
            .foregroundColor(CardConstants.color)
    }
    
    var shuffle: some View {
        Button("Shuffle") {
            withAnimation {
                game.shuffle()
            }
        }
    }
    
    var restart: some View {
        Button("Restart") {
            withAnimation{
                deal = []
                game.restart()
            }
        }
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter (isUnDeal)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(for: card))
            }
        }
        .frame(width: CardConstants.undealWidth, height: CardConstants.undealHeight)
        .foregroundColor(CardConstants.color)
        .onTapGesture {
            // "deal" cards
            for card in game.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    
    // State mean tempory we dont need store this in Model
    @State private var deal = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGame.Card) {
        deal.insert(card.id)
    }
    
    private func isUnDeal(_ card: EmojiMemoryGame.Card) -> Bool {
        !deal.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id } ) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeIn(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(for card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    @ViewBuilder
    private func cardView(for card: EmojiMemoryGame.Card) -> some View {
        if isUnDeal(card) || (card.isMatched && !card.isFaceUp) {
//            Rectangle().opacity(0)
            Color.clear
        } else {
            CardView(card: card)
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .padding(4)
//                .transition(AnyTransition.scale.animation(Animation.easeIn(duration: 2))
                .transition(AnyTransition.asymmetric(insertion: .identity, removal: .opacity))//.animation(Animation.easeIn(duration: 2)))
                /*
                    Like above, the anim not working cause the card come along with the container (AspectVGrid)
                 Fix: onApear
                 */
                .zIndex(zIndex(for: card))
                .onTapGesture {
                    withAnimation() {
                        game.choose(card)
                    }
                }
        }
    }
    
    // When it so simple we dont want create NEW struct for it
    //    var addButton: some View {
    //        Button(action: {
    //            emojiCount += 1
    //        }, label: {
    //            Image(systemName: "plus.circle")
    //        })
    //    }
    
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealHeight: CGFloat = 90
        static let undealWidth: CGFloat = undealHeight * aspectRatio
    }
    
}

/*
 Remember: View is immutable, it will rebuild every time
 */
struct CardView: View {
    //    @State var isFaceUp: Bool = true // @State is the pointer, point to outside this view
    
    let card: MemoryGame<String>.Card // we want view using let
    
    //cause we want it anim continuely BUT it cant anim the future so we are the state
    @State private var animatedBonusRemaining: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1 - animatedBonusRemaining)*360-90))
                            .onAppear{
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1 - card.bonusRemaining)*360-90))
                    }
                }
                    .padding(5)
                    .opacity(0.5)
                // Like this the font not do the anim
//                Text(card.content)
//                    .rotationEffect(Angle(degrees: card.isMatched ? 360: 0))
//                    .animation(.linear(duration: 1).repeatForever(autoreverses: false))
//                    .font(font(in: geometry.size))
                // Like this the font not do the anim
                Text(card.content)
                    .rotationEffect(Angle(degrees: card.isMatched ? 360: 0))
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false))
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFit: geometry.size))
                    
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
        
    }
    
    private func scale(thatFit size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    // we dont want magic number hanging around
    private struct DrawingConstants {
        static let fontScale: CGFloat = 0.7
        static let fontSize: CGFloat = 32
    }
}













//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//            .preferredColorScheme(.dark)
////        ContentView()
////            .preferredColorScheme(.light)
//    }
//}
