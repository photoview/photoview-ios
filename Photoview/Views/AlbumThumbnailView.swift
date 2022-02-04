//
//  AlbumThumbnailView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 24/07/2021.
//

import SwiftUI

struct AlbumThumbnailView<Destination: View>: View {
    
    let title: String
    let thumbnail: String?
    let blurhash: String?
    let destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(alignment: .leading) {
                ProtectedImageView(url: thumbnail, blurhash: blurhash) { image in
                    AnyView(
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    )
                }
                .frame(width: 160, height: 160)
                .mask(RoundedRectangle(cornerRadius: 4))
                .aspectRatio(contentMode: .fill)
                Text(title)
                    .font(.caption)
                //          .padding(.top, 2)
                    .lineLimit(1)
                    .foregroundColor(.primary)
            }
        }
        //    .buttonStyle(PlainButtonStyle())
        .frame(width: 160)
        //    .padding([.top, .horizontal])
    }
}

struct AlbumThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumThumbnailView(title: "Album title", thumbnail: nil, blurhash: nil, destination: Text(""))
            .previewLayout(.sizeThatFits)
    }
}
