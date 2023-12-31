//
//  UberApp.swift
//  Uber
//
//  Created by Vivek Sehrawat on 30/08/23.
//

import SwiftUI

@main
struct UberApp: App {
    @StateObject var locationViewModel = LocationSearchViewModel()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(locationViewModel)
        }
    }
}
 
