//
//  ContentView.swift
//  Shared
//
//  Created by Michael Dales on 28/06/2022.
//

import SwiftUI

struct ContentView: View {
//    @State private var year = 0.0
    @EnvironmentObject private var model: ImageCompositionModel

    var body: some View {
        VStack {
            GeometryReader {frame in
                HStack {
                    Spacer()
                    LossyearView()
                        .frame(width: min(frame.size.width, frame.size.height), height: min(frame.size.width, frame.size.height), alignment: .center)
                    Spacer()
                }
            }
            Spacer()
            HStack {
                Slider(value: $model.year, in: 0.0...21.0, step: 1) {
                    Text("Year")
                }
                Text(String(format: "%d", Int(model.year + 2000)))
            }.padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
