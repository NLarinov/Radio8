//
//  EfirM.swift
//  Radio8
//  Created by brfsu on 24.04.2024.
//
import SwiftUI

struct EfirM: Codable, Identifiable, Equatable {
    let id = UUID()
    let name: String
    let imageUrl: URL
    let streamUrl: String
    
    enum CodingKeys: String, CodingKey {
        case name, streamUrl = "url", imageUrl = "favicon"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.streamUrl = try container.decode(String.self, forKey: .streamUrl)
        
        let imageUrlString = try container.decode(String.self, forKey: .imageUrl)
        imageUrl = URL(string: imageUrlString) ?? URL(string: "https://i.postimg.cc/dVhrFLff/temp-Image-Ox-S6ie.avif")!
    }
}
