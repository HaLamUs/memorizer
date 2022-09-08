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
    var emojis = ["🚕", "🚌", "🚜", "🛵", "🚙", "🚎", "🛻", "🏎", "🚗", "🚘", "🏍", "🚆", "🚡", "✈️", "🚁", "🛺", "⛵️", "🚤", "🛥", "🛰"]
    @State var emojiCount = 8
    
    var body: some View {
        VStack {
            ScrollView {
                /*
                 Lazy meaning accessing var body when need 
                 */
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                    ForEach(emojis[0..<emojiCount], id: \.self, content: { emoji in
                        CardView(content: emoji).aspectRatio(2/3, contentMode: .fit)
                    })
                }
            }
            .foregroundColor(.red)
            Spacer()
            HStack {
                addButton
                Spacer()
                removeButton
            }
            .font(.largeTitle)
            .padding(.horizontal)
        
        }
        .padding()
        
    }
    
    // When it so simple we dont want create NEW struct for it
    var addButton: some View {
        Button(action: {
            emojiCount += 1
        }, label: {
            Image(systemName: "plus.circle")
        })
    }
    
    var removeButton: some View {
        Button(action: {
            emojiCount -= 1
        }, label: {
            Image(systemName: "minus.circle")
        })
    }
    
}

/*
 Remember: View is immutable, it will rebuild every time
 */
struct CardView: View {
    var content: String
//    var isFaceUp: Bool = true //{ return false }
    @State var isFaceUp: Bool = true // @State is the pointer, point to outside this view
    
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 20)
        
        ZStack(content: {
            if isFaceUp {
            shape.fill(.white)
            shape.stroke(lineWidth: 3)
            Text(content)
                .font(.largeTitle)
            } else {
                shape.fill(.red)
            }
        })
            .onTapGesture {
                isFaceUp = !isFaceUp
            }
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
