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
    //                                game.choose(card)
    //                            }
    //                    }
    //                }
    //            }
    //            .foregroundColor(.red)
    //
    //        }
    //        .padding()
    //    }
    
    // To understand protocol we will write ViewCombiner
    var body: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3, content: { card in
            cardView(for: card)
        })
            .foregroundColor(.red)
            .padding()
    }
    
    @ViewBuilder
    private func cardView(for card: EmojiMemoryGame.Card) -> some View {
        if card.isMatched && !card.isFaceUp {
            Rectangle().opacity(0)
        } else {
            CardView(card: card)
                .padding(4)
                .onTapGesture {
                    game.choose(card)
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
    
    
    
}

/*
 Remember: View is immutable, it will rebuild every time
 */
struct CardView: View {
    //    @State var isFaceUp: Bool = true // @State is the pointer, point to outside this view
    
    let card: MemoryGame<String>.Card // we want view using let
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 110-90))
                    .padding(7).opacity(0.5)
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
