//
//  FaceThumbnailView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 29/07/2021.
//

import SwiftUI

struct FaceThumbnailView: View {
  
  static let THUMBNAIL_SIZE: CGFloat = 100
  static let SCALE_MULTIPLIER: CGFloat = 0.65
  
  let face: MyFacesThumbnailsQuery.Data.MyFaceGroup
  
  var thumbnailScale: CGSize {
    guard let faceRect = face.imageFaces.first?.rectangle else { return CGSize(width: 1, height: 1) }
    guard let faceThumbnail = face.imageFaces.first?.media.thumbnail else { return CGSize(width: 1, height: 1) }
    
    let faceWidth = faceRect.maxX - faceRect.minX
    let faceHeight = faceRect.maxY - faceRect.minY
    
    let scaleFactor: CGFloat = CGFloat(1/max(faceWidth, faceHeight)) * Self.SCALE_MULTIPLIER
    
    let aspectRatio = CGFloat(faceThumbnail.width) / CGFloat(faceThumbnail.height)
    if aspectRatio >= 1 {
      return CGSize(width: scaleFactor * aspectRatio, height: scaleFactor)
    } else {
      return CGSize(width: scaleFactor, height: scaleFactor * 1/aspectRatio)
    }
    
  }
  
  var thumbnailOffset: CGSize {
    guard let faceRect = face.imageFaces.first?.rectangle else { return CGSize(width: 1, height: 1) }

    let width = (0.5 - CGFloat(faceRect.minX+faceRect.maxX)/2) * Self.THUMBNAIL_SIZE
    let height = (0.5 - CGFloat(faceRect.minY+faceRect.maxY)/2) * Self.THUMBNAIL_SIZE
    
    return CGSize(width: width, height: height)
  }
  
  var thumbnailCenter: CGSize {
    guard let faceRect = face.imageFaces.first?.rectangle else { return CGSize(width: 1, height: 1) }
    
    let width = CGFloat(faceRect.minX+faceRect.maxX)/2
    let height = CGFloat(faceRect.minY+faceRect.maxY)/2
    
    return CGSize(width: width, height: height)
  }
  
  var body: some View {
    ZStack {
      Rectangle()
        .fill(Color("PlaceholderBackground"))
      ProtectedImageView(url: face.imageFaces.first?.media.thumbnail?.url) { image in
        AnyView(
          Image(uiImage: image)
            .resizable()
            .offset(thumbnailOffset)
            .scaleEffect(thumbnailScale)
        )
      }
    }
    .frame(width: Self.THUMBNAIL_SIZE, height: Self.THUMBNAIL_SIZE)
    .clipShape(Circle())
  }
}

struct FaceThumbnailView_Previews: PreviewProvider {
  static var previews: some View {
    FaceThumbnailView(face: .init(id: "123", label: "Sample Person", imageFaceCount: 102, imageFaces: [.init(id: "321", rectangle: .init(minX: 0, maxX: 100, minY: 0, maxY: 100), media: .init(id: "444"))]))
  }
}
