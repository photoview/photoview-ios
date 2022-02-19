//
//  MediaGrid.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 28/07/2021.
//

import SwiftUI

struct MediaGrid: View {
    static var mediaColumns: [GridItem] {
        if UIDevice.isLargeScreen {
            return [GridItem(.adaptive(minimum: 140, maximum: 180), spacing: 4, alignment: .center)]
        } else {
            return [GridItem(.adaptive(minimum: 100, maximum: 140), spacing: 4, alignment: .center)]
        }
    }
    
    @EnvironmentObject var mediaEnv: MediaEnvironment
    
    var onMediaAppear: ((_ media: MediaItem) -> Void)? = nil
    var onMediaSelected: ((_ media: MediaItem) -> Void)? = nil
    
    var body: some View {
        LazyVGrid(columns: Self.mediaColumns, alignment: .leading, spacing: 4) {
            if let media = mediaEnv.media {
                ForEach(media, id: \.id) { elem in
                    MediaThumbnailView(media: elem, onMediaSelected: {
                        onMediaSelected?(elem)
                    })
                        .onAppear {
                            onMediaAppear?(elem)
                        }
                }
            }
        }
    }
}

struct MediaGrid_Previews: PreviewProvider {
    static var previews: some View {
        MediaGrid()
    }
}
