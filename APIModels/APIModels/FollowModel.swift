//
//  FollowModel.swift
//  APIModels
//
//  Created by Decagon on 10/11/2022.
//

import Foundation

public struct FollowDataModel: Codable {
    public let login: String?
    public let id: Int?
    public let nodeID: String?
    public let avatarURL: String?
    public let gravatarID: String?
    public let url, htmlURL, followersURL: String?
    public let followingURL, gistsURL, starredURL: String?
    public let subscriptionsURL, organizationsURL, reposURL: String?
    public let eventsURL: String?
    public let receivedEventsURL: String?
    public let type: TypeEnum?
    public let siteAdmin: Bool?

    public enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type
        case siteAdmin = "site_admin"
    }
}
