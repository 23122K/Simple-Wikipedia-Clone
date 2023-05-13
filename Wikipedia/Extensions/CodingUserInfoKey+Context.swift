//
//  CodingUserInfoKey.swift
//  Wikipedia
//
//  Created by Patryk Maciąg on 12/05/2023.
//

/*
 When initializing a Swift Decodable object that needs access to a managed object context, it's not possible to pass the context directly as a parameter to the initializer. One workaround is to pass the context using the userInfo dictionary of the JSONDecoder instance.
 */
extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
