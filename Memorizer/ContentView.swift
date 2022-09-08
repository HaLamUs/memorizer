//
//  ContentView.swift
//  Memorizer
//
//  Created by lamha on 07/09/2022.
//

import SwiftUI

struct ContentView: View {
    /*
     variable name body has type 'some View' determine as RunTime
     Like sub Lego (some View) inside the Lego (View)
     combiner View
     
     1. Inspector -> Add modifier
     */
    
    //    var emojis = ["🚕", "🚌","🚌", "🚜", "🛵"] // cause it not distinc so got double click
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            ScrollView {
                /*
                 Lazy meaning accessing var body when need
                 */
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
                    ForEach(viewModel.cards) { card in
                        CardView(card: card)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                viewModel.choose(card)
                            }
                    }
                }
            }
            .foregroundColor(.red)
            
        }
        .padding()
        
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
        let shape = RoundedRectangle(cornerRadius: 20)
        
        ZStack(content: {
            if card.isFaceUp {
                shape.strokeBorder(lineWidth: 3)
                Text(card.content)
                    .font(.largeTitle)
            } else if card.isMatched {
                shape.opacity(0)
            }
            else {
                shape.fill(.red)
            }
        })
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
