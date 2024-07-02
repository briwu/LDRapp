//
//  SessionSelectionView.swift
//  ScreenRivalry
//
//  Created by Brian Wu on 7/1/24.
//

import SwiftUI

struct SessionSelectionView: View {
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 20) {
                    Spacer()
                    NavigationLink(destination: IndividualSessionView()) {
                        Text("Individual Session")
                            .font(.largeTitle)
                            .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.4)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    Spacer()
                    NavigationLink(destination: DuoSessionView()) {
                        Text("Compete Against Friends")
                            .font(.largeTitle)
                            .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.4)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray)
            }
        }
    }
}

#Preview {
    SessionSelectionView()
}
