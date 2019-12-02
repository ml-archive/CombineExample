//: [Previous](@previous)

import Combine
import Foundation
import UIKit

/// If you have an API that is using completion closures you can wrap it to return a publisher e.g. `URLSession`It can be done using a Combine publisher type called a `Future`which will complete once in the future and yield a value or an error. it can be done like this

func urlSessionPublisher(with request: URLRequest) -> AnyPublisher<(Data?, URLResponse?, Error?), Never> {
    Future { callback in
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            callback(.success((data, response, error)))
        }.resume()
    }

    .eraseToAnyPublisher()
}

// At the end we call `eraseToAnyPublisher()` in order for publisher types to match up as working with Publishers will return long embedded generic types.
// Luckily Combine comes with a built in dataTaskPublisher and also a publisher for decoding Data

/// Thus we can make an api-call like so:

// Our data lives here
let url = URL(string: "https://api.chucknorris.io/jokes/random")!

// The return type from the API
struct Response: Decodable {
    let icon_url: URL
    let value: String
}

let cancellable = URLSession.shared.dataTaskPublisher(for: url)
    .map { data, _ in data }
    .decode(type: Response.self, decoder: JSONDecoder())
    .sink(receiveCompletion: {_ in }, receiveValue: {
        print($0.value)
    })

/// We can wrap that in a function. Since we are mostly interested in the joke here, we'll map the result to use the `\Response.value` KeyPath and again eraseToAnyPublisher

func getJoke() -> AnyPublisher<String, Error> {
    URLSession.shared.dataTaskPublisher(for: url)
        .map { data, _ in data }
        .decode(type: Response.self, decoder: JSONDecoder())
        .map(\.value)
        .eraseToAnyPublisher()
    
}

/// And now we can subscribe and get a joke

let cancellable2 =
    getJoke()
.sink(receiveCompletion: { completion in
    if case .failure(let error) = completion {
        print(error)
    }
}, receiveValue: { joke in
    print("Published joke: \(joke)")
})


//: [Next](@next)
