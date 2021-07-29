//
//  FaceGrid.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 29/07/2021.
//

import SwiftUI

struct FaceGrid: View {
  static let faceColumns = [GridItem(.adaptive(minimum: FaceThumbnailView.THUMBNAIL_SIZE), alignment: .center)]
  
  let faceGroups: [MyFacesThumbnailsQuery.Data.MyFaceGroup]
  
  var body: some View {
    LazyVGrid(columns: Self.faceColumns, alignment: .leading, spacing: 20) {
      ForEach(faceGroups, id: \.id) { face in
        VStack {
          FaceThumbnailView(face: face)
          if let label = face.label {
            Text(label)
              .font(.caption)
          } else {
            Text("Unlabeled")
              .italic()
              .foregroundColor(.secondary)
              .font(.caption)
          }
          Spacer()
        }
      }
    }.padding(.horizontal)
  }
}

struct FaceGrid_Previews: PreviewProvider {
  
  static let sampleFaces: [MyFacesThumbnailsQuery.Data.MyFaceGroup] = [
    .init(id: "123", label: "Sample Person", imageFaceCount: 102, imageFaces: [.init(id: "1", rectangle: .init(minX: 0, maxX: 100, minY: 0, maxY: 100), media: .init(id: "4"))]),
    .init(id: "234", label: "John Doe", imageFaceCount: 102, imageFaces: [.init(id: "2", rectangle: .init(minX: 0, maxX: 100, minY: 0, maxY: 100), media: .init(id: "5"))]),
    .init(id: "345", label: nil, imageFaceCount: 102, imageFaces: [.init(id: "3", rectangle: .init(minX: 0, maxX: 100, minY: 0, maxY: 100), media: .init(id: "6"))]),
  ]
  
  static var previews: some View {
    FaceGrid(faceGroups: sampleFaces)
  }
}
