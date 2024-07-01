//
//  StartPageView.swift
//  ScreenRivalry
//
//  Created by Brian Wu on 7/1/24.
//

import SwiftUI

struct StartPageView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                NavigationLink(destination: SessionSelectionView()) {
                    Text("Start a screen time session")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                        .background(Color.blue)
                        .cornerRadius(10)
                }

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    StartPageView()
}

