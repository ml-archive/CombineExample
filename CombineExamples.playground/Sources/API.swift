import Foundation
import Combine

extension String: Error {}

public enum Credentials {
    public static let validUsername = "validUsername"
    public static let validPassword = "validPassword"
}

public struct API {
    
    public enum Error: Swift.Error, LocalizedError {
        case invalidCredentials
        
        public var errorDescription: String? {
             "\(self)"
        }
    }
    
    public var fetchUser = fetchUserImpl(token:)
    public var login = loginImpl(username: password: )
}

private func fetchUserImpl(token: String) -> AnyPublisher<User, Error> {
    
    Just<User>.init(User(id: "ABCD1234", name: "Hoppekat", email: "test@test.dk", isVerified: false))
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
}

private func loginImpl(username: String, password: String) -> AnyPublisher<String, Error> {
    
    guard username == Credentials.validUsername, password == Credentials.validPassword else {
        return Fail(error: API.Error.invalidCredentials)
            .eraseToAnyPublisher()
    }
    
    return Just("TheToken")
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
}

