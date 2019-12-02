//: [Previous](@previous)

import Combine

/// In order to pass data between publishers we use the flatMap operator. You can think of it as taking the output of one publisher and using it as input to another to create a chain-like dataflow
/// E.g. take a publisher that publishes Integers

let intPublisher: PassthroughSubject<Int, Never> = .init()

// This function creates a publisher that squres values. It uses a Combine Publisher called `Just`, which is used for turning a simple value into a Publisher

func squarePublisher<Input: Numeric>(_ value: Input) -> AnyPublisher<Input, Never> {
    Just(value*value).eraseToAnyPublisher()
}

func addOnePublisher<Input: Numeric>(_ value: Input) -> AnyPublisher<Input, Never> {
    Just(value+1).eraseToAnyPublisher()
}


intPublisher
    .flatMap { squarePublisher($0) }
    .flatMap { addOnePublisher($0) }
    .flatMap(addOnePublisher) // You can go point-free also
    .sink { double in
        print("output is: \(double)")
}

intPublisher.send(2)



//: [Next](@next)
