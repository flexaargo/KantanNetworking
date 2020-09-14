//
//  RemoteImageService.swift
//  KantanNetworking
//
//  Created by Alex Fargo on 9/9/20.
//

import Foundation
import SwiftUI
import Combine

public enum RemoteImageState {
  case error(_ error: Error)
  case image(_ image: UIImage)
  case loading
}

final public class RemoteImageService: ObservableObject {
  private let cache = NSCache<NSURL, UIImage>()
  private let apiClient = APIClient()
  
  public init() { }
  
  /// Creates a publisher that will fetch an image from a given `url`. If an image is found, it will be stored
  /// in a cache.
  /// - Parameter url: The `URL` to fetch the image from.
  /// - Returns: A publisher with types `<RemoteImageState, Never>`
  public func imagePublisher(forURL url: URL) -> AnyPublisher<RemoteImageState, Never> {
    if let image = cache.object(forKey: url as NSURL) {
      return Just(.image(image)).eraseToAnyPublisher()
    }
    
    let publisher = apiClient.requestInternal(withURL: url)
      .handleEvents(receiveOutput: { [weak self] (image: UIImage) in self?.cache.setObject(image, forKey: url as NSURL) })
      .map { image in RemoteImageState.image(image) }
      .replaceError(with: .error(KantanError.unknown()))
      .receive(on: DispatchQueue.main)
    
    return publisher.eraseToAnyPublisher()
  }
}
