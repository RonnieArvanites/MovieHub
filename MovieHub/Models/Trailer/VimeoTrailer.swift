//
//  VimeoTrailer.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/10/20.
//

import Foundation
import SwiftUI

// Vimeo trailer JSON response model
struct VimeoTrailer: Decodable, Hashable {
    
    let id: Int
    let title: String
    let shareUrl: String
    let contentUrl: ContentUrl?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case shareUrl = "share_url"
        case contentUrl
        case video
        case request
        case files
        case progressive
    }
    
    static func == (lhs: VimeoTrailer, rhs: VimeoTrailer) -> Bool {
        return lhs.id == rhs.id
    }
    
    // ContentUrl JSON response model
    struct ContentUrl: Decodable, Hashable {
        let url: String
        let quality: String
        
        enum CodingKeys: String, CodingKey {
            case url
            case quality
        }
    }
    
    // Manually decodes JSON
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let video = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .video)
        // Decodes id
        id = try video.decode(Int.self, forKey: .id)
        // Decodes title
        title = try video.decode(String.self, forKey: .title)
        // Decodes shareUrl
        shareUrl = try video.decode(String.self, forKey: .shareUrl)
        let request = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .request)
        let files = try request.nestedContainer(keyedBy: CodingKeys.self, forKey: .files)
        var progressive = try files.nestedUnkeyedContainer(forKey: .progressive)
        // Creates an empty list
        var contentUrls = [ContentUrl]()
        while !progressive.isAtEnd {
            // Decodes contentUrl
            let contentUrl = try progressive.decode(ContentUrl.self)
            // Adds contentUrl to contentUrls list
            contentUrls.append(contentUrl)
        }
        // Filters bestQualityUrl for 1080p quality
        if let bestQualityUrl = contentUrls.filter({ $0.quality == "1080p"}).first{
            // Sets contentUrl to bestQualityUrl
            contentUrl = bestQualityUrl
        }
        // Filters bestQualityUrl for 720p quality
        else if let bestQualityUrl = contentUrls.filter({ $0.quality == "720p"}).first{
            // Sets contentUrl to bestQualityUrl
            contentUrl = bestQualityUrl
        }
        // Filters bestQualityUrl for 540p quality
        else if let bestQualityUrl = contentUrls.filter({ $0.quality == "540p"}).first{
            // Sets contentUrl to bestQualityUrl
            contentUrl = bestQualityUrl
        } else {
            // Sets contentUrl to nil
            contentUrl = nil
        }
      }
}
