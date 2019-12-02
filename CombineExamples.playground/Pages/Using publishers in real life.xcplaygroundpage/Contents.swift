import Combine
//: [Previous](@previous)

/// Now let's emulate having tapped a loginbutton that triggers a loginflow with username and password.
/// We'll use the username and password to try and login to a server and get a token.
/// So the steps are
/// 1. Create a publisher with appropriate types
/// 2. flatMap on the publisher to get the data out of it and use it as input to a loginpublisher
/// 3. Subscribe to the login publisher using sink and print the result

let credentialsObserver1: PassthroughSubject<(username: String, password: String), Error> = .init()

let cancellable1 = credentialsObserver1
    .flatMap { credentials in Current.api.login(credentials.username, credentials.password) }
    .sink(receiveCompletion: { completion in
        if case .failure(let error) = completion {
            print(error.localizedDescription)
        }
    }, receiveValue: { token in
        let token = "Received token: \(token)"
        print(token)
    })

credentialsObserver1.send((Credentials.validUsername, Credentials.validPassword))

/// Let's use the token to fetch a user from the api. Since text input doesn't fail in this example, the Error type can be Never

let credentialsObserver2: PassthroughSubject<(username: String, password: String), Never> = .init()

/// Never is an enum with no cases. It is used here to show that the publisher will never return an error

let cancellable = credentialsObserver2
    .setFailureType(to: Error.self) // For the error types to match up we need to force the Error type to Error.self
    .flatMap { credentials in Current.api.login(credentials.username, credentials.password) }
    .flatMap { token in Current.api.fetchUser(token) }
    .sink(receiveCompletion: { completion in
        if case .failure(let error) = completion {
            print(error.localizedDescription)
        }
    }, receiveValue: { user in
        print("Received user: \(user)")
    })

credentialsObserver2.send((Credentials.validUsername, Credentials.validPassword))
    
// It seems like logging in and fetching the user is something we might usually do together. Let's bundle them up in a function.

func loginAndFetchUser(username: String, password: String) -> AnyPublisher<User, Error> {
    
    Current.api.login(username, password)
        .flatMap { token in Current.api.fetchUser(token) }
        .eraseToAnyPublisher()
}

/// We can then flatmap the function since it returns a Publisher
let credentialsObserver3: PassthroughSubject<(username: String, password: String), Never> = .init()

let sub = credentialsObserver3
    .setFailureType(to: Error.self)
    .flatMap(loginAndFetchUser(username: password: )) // <- Here
    .sink(receiveCompletion: { completion in
        if case .failure(let error) = completion {
            print(error.localizedDescription)
        }
    }, receiveValue: { user in
        print("Received user: \(user)")
    })

/// If any of the publisher in the chain fail, any subsequent links in the chain are skipped and control goes directly to the failure completion

credentialsObserver3.send((Credentials.validUsername, "invalid"))


//: [Next](@next)
