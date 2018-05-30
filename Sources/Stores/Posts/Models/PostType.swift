//
//  PostType.swift
//  SwiftPress
//
//  Created by Basem Emara on 2018-05-26.
//

public protocol PostType: Identifiable, Dateable {
    var slug: String { get }
    var type: String { get }
    var title: String { get }
    var content: String { get }
    var excerpt: String { get }
    var link: String { get }
    var commentCount: Int { get }
    var authorID: Int { get }
    var mediaID: Int? { get }
    var categories: [Int] { get }
    var tags: [Int] { get }
}
