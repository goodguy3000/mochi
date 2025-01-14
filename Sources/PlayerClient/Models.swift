//
//  Models.swift
//
//
//  Created by ErrorErrorError on 5/26/23.
//
//

import Foundation

// MARK: - PlayerClient.Status

public extension PlayerClient {
    // TODO: Do more compositions for various types. eg. audio

    struct VideoCompositionItem {
        let link: URL
        let headers: [String: String]
        let subtitles: [Subtitle]
        let metadata: Metadata

        public init(
            link: URL,
            headers: [String: String] = [:],
            subtitles: [Subtitle] = [],
            metadata: Metadata
        ) {
            self.link = link
            self.headers = headers
            self.subtitles = subtitles
            self.metadata = metadata
        }

        public struct Subtitle {
            let name: String
            let `default`: Bool
            let autoselect: Bool
            let forced: Bool
            let link: URL

            public init(
                name: String,
                default: Bool,
                autoselect: Bool,
                forced: Bool = false,
                link: URL
            ) {
                self.name = name
                self.default = `default`
                self.autoselect = autoselect
                self.forced = forced
                self.link = link
            }
        }

        public struct Metadata {
            let title: String?
            let subtitle: String?
            let artworkImage: URL?
            let author: String?

            public init(
                title: String? = nil,
                subtitle: String? = nil,
                artworkImage: URL? = nil,
                author: String? = nil
            ) {
                self.title = title
                self.subtitle = subtitle
                self.artworkImage = artworkImage
                self.author = author
            }
        }
    }
}
