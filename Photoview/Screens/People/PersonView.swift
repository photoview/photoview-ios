//
//  PersonView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 29/07/2021.
//

import SwiftUI

struct PersonView: View {
    
    let faceGroup: MyFacesThumbnailsQuery.Data.MyFaceGroup
    
    @EnvironmentObject var showWelcome: ShowWelcomeScreen
    @State var mediaEnv: MediaEnvironment = MediaEnvironment()
    
    func fetchMedia() {
        Network.shared.apollo?.fetch(query: SinglePersonQuery(faceGroupID: faceGroup.id)) { result in
            switch result {
            case let .success(data):
                DispatchQueue.main.async {
                    let media = data.data?.faceGroup.imageFaces.map { $0.media.fragments.mediaItem }
                    mediaEnv.media = media
                }
            case let .failure(error):
                Network.shared.handleGraphqlError(error: NetworkError(message: "Failed to fetch single person", error: error), showWelcomeScreen: showWelcome)
            }
        }
    }
    
    var body: some View {
        ScrollView {
            MediaGrid()
                .environmentObject(mediaEnv)
        }
        .navigationTitle(faceGroup.label ?? "Unlabeled")
        .onAppear {
            fetchMedia()
        }
    }
}

struct PersonView_Previews: PreviewProvider {
    static var previews: some View {
        PersonView(faceGroup: FaceGrid_Previews.sampleFaces.first!)
    }
}
