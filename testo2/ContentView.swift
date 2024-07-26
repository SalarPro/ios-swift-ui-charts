//
//  ContentView.swift
//  testo2
//
//  Created by Salar Pro on 6/19/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    Chart1()
                } label: {
                    Text("Chart 1")
                }

            }
        }
    }
}

#Preview {
    ContentView()
}
