//
//  ProtectedImageView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 24/07/2021.
//

import SwiftUI
import KeychainSwift

/// Shows a media thumbnail, used in grids where a lot of media is shown at once
struct ProtectedImageView: View {
    
    let url: String?
    let blurhash: String?
    let imageView: (_ image: UIImage) -> AnyView
    
    @Binding var isLoading: Bool
    
    init(url: String?, isLoading: Binding<Bool>?, blurhash: String? = nil, imageView: @escaping (_ image: UIImage) -> AnyView) {
        self.url = url
        self.blurhash = blurhash
        self.imageView = imageView
        if isLoading?.wrappedValue != nil {
            self._isLoading = isLoading!
        }
        else {
            self._isLoading = .constant(false)
        }
    }
    
    init(url: String?) {
        self.init(url: url, isLoading: nil) { img in
            AnyView(Image(uiImage: img))
        }
    }
    
    @State var image: UIImage? = nil
    @State var task: URLSessionTask? = nil
    @State var canceled: Bool = false
    @State var imageLoaded: Bool = false
    
    @State var numOfRequests: Int = 0
        
    var presentImage: UIImage? {
        if self.image != nil {
            return self.image
        }

        if let blurhash = self.blurhash {
            return UIImage(blurHash: blurhash, size: CGSize(width: 4, height: 3))
        }
        
        return nil
    }
    
    func fetchImage(url: String) {
        numOfRequests += 1
        self.task = ProtectedImageCache.shared.fetch(url: url) { image in
            numOfRequests -= 1
            self.image = image
        }
    }
    
    var body: some View {
        Group {
            if let image = self.presentImage {
                imageView(image)
            } else {
                Rectangle()
                    .fill(Color("PlaceholderBackground"))
            }
        }
        .onChange(of: url) { newURL in
            if let newURL = newURL {
                self.fetchImage(url: newURL)
            } else {
                self.image = nil
            }
        }
        .onChange(of: numOfRequests) { num in
            isLoading = num > 0
        }
        .onAppear {
            if image == nil, let url = url {
                canceled = false
                self.fetchImage(url: url)
            }
        }
        .onDisappear {
            canceled = true
            numOfRequests = 0
            self.task?.cancel()
        }
    }
}

struct ProtectedImageView_Previews: PreviewProvider {
    static var previews: some View {
        ProtectedImageView(url: nil)
            .frame(width: 100, height: 100)
            .previewLayout(.sizeThatFits)
    }
}
