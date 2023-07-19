//
//  LessonsCollection.swift
//  IphonePhotography
//
//  Created by Bakai on 15/7/23.
//

import SwiftUI

struct LessonsListView: View {
    
    var lessons: [Lesson]
    
    init(lessons: [Lesson]) {
        self.lessons = lessons
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(lessons, id: \.id) { item in
                    NavigationLink(destination: makeLessonDetailsVC()) {
                        HStack {
                            ImagePlaceholder(lesson: item)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(item.name ?? "")
                                    .fontWeight(.semibold)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.5)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Lessons")
        }
    }
    
    private func makeLessonDetailsVC() -> some View {
        LessonDetailsViewControllerView()
            .navigationBarTitleDisplayMode(.inline)
            .edgesIgnoringSafeArea(.bottom)
            .toolbar { getToolbar() }
    }
    
    func getToolbar() -> some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // Start downloading
                    let _ = print("download tapped")
                } label: {
                    HStack {
                        Image("cloud_download")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 24, height: 24)
                            .foregroundColor(.blue)
                        
                        Text("Download")
                    }
                }
            }
        }
    }
}

struct LessonsCollection_Previews: PreviewProvider {
    static var previews: some View {
        LessonsListView(lessons: Lesson.data)
    }
}
