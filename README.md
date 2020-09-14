# KantanNetworking

This is a simple networking layer for your next iOS project.

## Motivation

Whenever I start a new side project, I always find myself making the same, boiler plate code for my networking layer. While I could use a popular and well established networking library, I usually want something a little more simple and something I can easily tailor to my projects if needed. So, I figured I may as well make a small library and better yet, allow the community to use and iterate on it with me. My goal is to make this a robust while keeping it as expandable and simple as possible.

## Usage

This library really revolves around the idea of a `Routable` which should be used to define a collection of endpoint information for an API.

The protocol looks like this:

```swift
public protocol Routable {
  var baseUrl: String { get }
  var method: HTTPMethod { get }
  var path: String { get }
  var parameters: HTTPParameters { get }
  var body: HTTPBody? { get }
  var headers: HTTPHeaders? { get }
  var contentType: HTTPContentType { get }
}
```

I typically use an enum and implement `Routable` on the enum as seen here:

```swift
enum APIRoutable: Routable {
  case allPosts
  case createPost(title: String, content: String)
  // ...
}
```

Each of the endpoint information variables can then be computed variables with a `switch` that builds the content depending on the enum and the enums associated values.

Once you have your routable, a request can simply be made using `APIClient`

```swift
class APIService {
  let client = APIClient()
  // ...
  func getAllPosts(completion: @escaping ((Response?) -> Void)) {
    client.request(for: APIRoutable.allPosts) { (result: Result<Response, Error>) in
      switch result:
      case .failure(let error):
        print(error)
        completion(nil)
      case .success(let response):
        completion(response)
    }
  }
  // ...
}
```

It's quite easy to send a request to your API using `APIClient` and `Routables`. This is a Combine first library though, so there are also methods for creating publishers for the requests. This allows you to easily mutate the downstream result of a request publisher.

```swift
class APIService {
  // ...
  func createPost(title: String, content: String) -> AnyPublisher<Bool, Never> {
    client.requestPublisher(for: APIRoutable.createPost(title: title, content: content))
      .map { (response: PostResponse) in
        return response.success
      }
      .replaceError(with: false)
      .eraseToAnyPublisher()
  }
  // ...
}
```

### Advanced Usage

If you are the type of person that would like a little more control over how your networking layer works, you can use the protocol `RemoteClient`. `APIClient` conforms to this protocol and it only defines a few methods for sending requests with `Routable`. Another reason I made this a protocol was so that instead of making `APIClient` the type of your client, you can make it `RemoteClient` and easily override it in tests. This allows you to easily setup a class for sending mocked responses back to your `APIService`

```swift
class APIService {
  private let client: RemoteClient

  init(client: RemoteClient) {
    self.client = client
  }
}

// In your app
service = APIService(client: APIClient())

// In your tests
service = APIService(client: TestableClient())

class TestableClient: RemoteClient {
  // ...
}
```

## Contribute

Since I'm still figuring out how I want this library to work, the changes will be very volatile, but I expect it to get stable very quickly as I work on it more. I appreciate any suggested changes and encourage you to contribute.

## License

KantanNetworking is licensed under MIT. See LICENSE (c) [Alex Fargo](https://www.github.com/flexaargo) [(x)](https://twitter.com/flexaargo)
