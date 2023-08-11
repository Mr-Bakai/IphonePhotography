//
//  ContentView.swift
//  IphonePhotography
//
//  Created by Bakai on 26/6/23.
//

import SwiftUI

struct LessonsScreen: View {
    @StateObject var lessonViewModel = LessonsViewModelImpl(service: LessonsServiceImpl())
    
    var body: some View {
        VStack {
            
            switch lessonViewModel.state {
            case .loading:
                ProgressView()
                
            case .success(let lessons):
                LessonsListView(lessons: lessons)
                
            case .failed(let message):
                let _ = print("ErrorMessage: \(message)")
                // TODO: Show Error BottomSheet
                ProgressView()
            }
        }
        .onAppear { lessonViewModel.getLessons() }
        .environmentObject(lessonViewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LessonsScreen()
    }
}
