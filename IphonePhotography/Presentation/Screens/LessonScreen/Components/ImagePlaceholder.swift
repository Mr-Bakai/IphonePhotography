//
//  ImagePlaceholder.swift
//  IphonePhotography
//
//  Created by Bakai on 16/7/23.
//

import SwiftUI
import URLImage

struct ImagePlaceholder: View {
    let lesson: Lesson
    
    var body: some View {
        
        VStack {
            if let url = lesson.thumbnail,
               let url = URL(string: url) {
                
                URLImage(
                    url: url,
                    options: URLImageOptions(
                        identifier: String(lesson.id),
                        cachePolicy: .returnCacheElseLoad(
                            cacheDelay: nil,
                            downloadDelay: 0.25
                        )
                    ),
                    failure: { error, _ in
                        EmptyView()
                        // TODO: Show error view or error bottom sheet
                    },
                    content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .scaledToFit()
                    })
            } else {
                // TODO: Show error view or error bottom sheet
            }
        }
    }
}
