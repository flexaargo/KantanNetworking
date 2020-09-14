//
//  RemoteImage.swift
//  KantanNetworking
//
//  Created by Alex Fargo on 9/9/20.
//

import SwiftUI
import Combine

/// An image view that will fetch and display an image for a given URL or routable.
/// Requires a `RemoteImageService` environment object.
public struct RemoteImage: View {
  public typealias ErrorBuilder = (Error) -> AnyView
  public typealias ImageBuilder = (Image) -> AnyView
  public typealias LoadingBuilder = () -> AnyView
  
  @EnvironmentObject private var service: RemoteImageService
  
  private let url: URL?
  private var errorView: ErrorBuilder?
  private var imageView: ImageBuilder?
  private var loadingView: LoadingBuilder?
  @State private var imageState: RemoteImageState = .loading
  @State private var subscription: AnyCancellable?
  
  // MARK: - URL init
  public init(url: URL?,
              errorView: ErrorBuilder? = nil,
              loadingView: LoadingBuilder? = nil,
              imageView: ImageBuilder? = nil) {
    self.url = url
    self.errorView = errorView
    self.loadingView = loadingView
    self.imageView = imageView
  }
  
  // MARK: - Routable init
  public init(routable: Routable,
              errorView: ErrorBuilder? = nil,
              loadingView: LoadingBuilder? = nil,
              imageView: ImageBuilder? = nil) {
    self.init(url: routable.makeUrl(),
              errorView: errorView,
              loadingView: loadingView,
              imageView: imageView)
  }
  
  public var body: some View {
    switch imageState {
    case .loading:
      return makeLoadingView()
        .onAppear {
          // Already began fetching image
          guard subscription == nil else { return }
          // Verify url is valid
          guard let url = url else {
            self.imageState = .error(KantanError.unknown())
            return
          }
          // Fetch image
          subscription = self.service.imagePublisher(forURL: url)
            .sink(receiveCompletion: { completion in
              if case let .failure(error) = completion {
                self.imageState = .error(error)
              }
            }, receiveValue: { (imageState) in
              self.imageState = imageState
            })
        }
        .eraseToAnyView()
    case .error(let error):
      return makeErrorView(forError: error)
    case .image(let image):
      return makeImageView(forImage: Image(uiImage: image))
    }
  }
  
  private func makeErrorView(forError error: Error) -> AnyView {
    if let errorView = errorView {
      return errorView(error).eraseToAnyView()
    }
    return ZStack {
      Rectangle()
        .foregroundColor(Color(UIColor.lightGray))
      Image(systemName: "xmark.octagon.fill")
        .imageScale(.large)
        .font(.headline)
    }
    .foregroundColor(.white)
    .eraseToAnyView()
  }
  
  private func makeLoadingView() -> AnyView {
    if let loadingView = loadingView {
      return loadingView().eraseToAnyView()
    }
    return ZStack {
      Rectangle()
        .foregroundColor(Color(UIColor.lightGray))
      if #available(iOS 14.0, *) {
        ProgressView()
      }
    }
    .eraseToAnyView()
  }
  
  private func makeImageView(forImage image: Image) -> AnyView {
    if let imageView = imageView {
      return imageView(image).eraseToAnyView()
    }
    return image
      .resizable()
      .aspectRatio(contentMode: .fit)
      .eraseToAnyView()
  }
}

extension View {
  func eraseToAnyView() -> AnyView {
    AnyView(self)
  }
}
