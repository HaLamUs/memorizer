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
        GeometryReader(content:  { geometry in
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            ZStack(content: {
                if card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    // toạ độ nó ngc
                    Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 110-90))
                        .padding(7).opacity(0.5)
                    Text(card.content).font(font(in: geometry.size))
                } else if card.isMatched {
                    shape.opacity(0)
                }
                else {
                    shape.fill(.red)
                }
            })
        })
        
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    // we dont want magic number hanging around
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.7
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
