//
//  ContentView.swift
//  Uber
//
//  Created by Vivek Sehrawat on 30/08/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        
        ZStack(alignment: .top) {
            UberMapViewRepresentable()
                .ignoresSafeArea()
            LocationSearchActivationView()
                .padding(.top, 72)
            MapViewActionButton()
                .padding(.leading)
        }
    }
} 

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
