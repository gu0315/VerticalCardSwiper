//
//  Card.swift
//  CollectionViewLayout
//
//  Created by 顾钱想 on 2023/8/3.
//

import UIKit

// MARK: - MY
struct MY: Codable {
    let status: Int
    let desc: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let cards: [Card]
}

// MARK: - Card
struct Card: Codable {
    let tpl: Int
    let newFeature: NewFeature? //10
    let daily: Daily? //13
    let topic: CardTopic? // 7
    let hotEvents: HotEvents? // 12
    let activity: Activity? //11
    let recommendReason: String?
    
    var url: String {
        get {
            let defaultUrl = "https://cdn-mario-img.sns.sohu.com/public/img_card_tutorial_bg_v2.png"
            if (tpl == 10) {
                return newFeature?.bgURL ?? defaultUrl
            } else if (tpl == 13) {
                return daily?.bgURL ?? defaultUrl
            } else if (tpl == 7) {
                return topic?.cover ?? defaultUrl
            } else if (tpl == 12) {
                return defaultUrl
            } else if (tpl == 11) {
                return activity?.bgURL ?? defaultUrl
            } else {
                return defaultUrl
            }
        }
    }
}

// MARK: - Activity
struct Activity: Codable {
    let text: String
    let bgURL: String
    let jumpURL: String
    let imageTop, imageBottom: ImageBottomClass

    enum CodingKeys: String, CodingKey {
        case text
        case bgURL = "bgUrl"
        case jumpURL = "jumpUrl"
        case imageTop, imageBottom
    }
}

// MARK: - ImageBottomClass
struct ImageBottomClass: Codable {
    let url: String
    let width, height: Int
}

// MARK: - Daily
struct Daily: Codable {
    let id: String
    let date: Int
    let jumpURL: String
    let bgURL: String
    let overview: [String]

    enum CodingKeys: String, CodingKey {
        case id, date
        case jumpURL = "jumpUrl"
        case bgURL = "bgUrl"
        case overview
    }
}

// MARK: - HotEvents
struct HotEvents: Codable {
    let title: String
    let currentTime: Int
    let topics: [TopicElement]
}

// MARK: - TopicElement
struct TopicElement: Codable {
    let id, title: String
    let icon: String
    let kind: Int
    let recentFeeds: [PurpleRecentFeed]
}

// MARK: - PurpleRecentFeed
struct PurpleRecentFeed: Codable {
    let id, title, text: String
    let displayTime: Int
}

// MARK: - NewFeature
struct NewFeature: Codable {
    let version, text: String
    let bgURL: String
    let image: ImageBottomClass
    let jumpURL: String

    enum CodingKeys: String, CodingKey {
        case version, text
        case bgURL = "bgUrl"
        case image
        case jumpURL = "jumpUrl"
    }
}

// MARK: - CardTopic
struct CardTopic: Codable {
    let id, title: String
    let icon: String
    let kind: Int
    let cover: String
    let recentFeeds: [FluffyRecentFeed]?
    let description: String?
    let pv: Int?
}

// MARK: - FluffyRecentFeed
struct FluffyRecentFeed: Codable {
    let id, title, text: String
    let displayTime, type, contentType: Int
    let url: String
    let images: [ImageElement]
    let videos: [Video]
    let renderStyles: [Int]?
}

// MARK: - ImageElement
struct ImageElement: Codable {
    let width, height: Int
    let thumbnail: String
}

// MARK: - Video
struct Video: Codable {
    let width, height: Int
    let coverURL: String

    enum CodingKeys: String, CodingKey {
        case width, height
        case coverURL = "coverUrl"
    }
}
