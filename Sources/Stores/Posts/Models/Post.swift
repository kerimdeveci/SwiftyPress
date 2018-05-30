//
//  Post.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-05-30.
//

public struct Post: PostType {
    public let id: Int
    public let slug: String
    public let type: String
    public let title: String
    public let content: String
    public let excerpt: String
    public let link: String
    public let commentCount: Int
    public let authorID: Int
    public let mediaID: Int?
    public let categories: [Int]
    public let tags: [Int]
    public let createdAt: Date
    public let modifiedAt: Date
}
