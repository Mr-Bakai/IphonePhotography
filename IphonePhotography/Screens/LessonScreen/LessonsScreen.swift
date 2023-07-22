//
//  ContentView.swift
//  IphonePhotography
//
//  Created by Bakai on 26/6/23.
//

import SwiftUI

struct LessonsScreen: View {
    @ObservedObject var viewModel = LessonsViewModelImpl(service: LessonsServiceImpl())
    
    var body: some View {
        VStack {
            
            switch viewModel.state {
            case .loading:
                ProgressView()
                
            case .success(let lessons):
                LessonsListView(lessons: lessons)
                let _ = print("@@ Lessons: \(lessons)")
                
            case .failed(_):
                // TODO: Show Error BottomSheet
                ProgressView()
            }
        }
        .onAppear { viewModel.getLessons() }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LessonsScreen()
    }
}
