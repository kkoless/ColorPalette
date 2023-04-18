//
//  GoogleSearchResponse.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 10.04.2023.
//

import Foundation

struct GoogleSearchResponse: Codable {
    let items: [Result]?
    
    enum CodingKeys: String, CodingKey {
        case items = "items"
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self.items = try container.decodeIfPresent([Result].self, forKey: CodingKeys.items)
    }
}

extension GoogleSearchResponse {
    struct Result: Codable {
        let pagemap: PageMap?
        
        enum CodingKeys: String, CodingKey {
            case pagemap = "pagemap"
        }
        
        init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<Result.CodingKeys> = try decoder.container(keyedBy: Result.CodingKeys.self)
            self.pagemap = try container.decodeIfPresent(PageMap.self, forKey: Result.CodingKeys.pagemap)
        }
    }
    
    struct PageMap: Codable {
        let cseImage: [CSEImage]?
        
        enum CodingKeys: String, CodingKey {
            case cseImage = "cse_image"
        }
        
        init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<PageMap.CodingKeys> = try decoder.container(keyedBy: PageMap.CodingKeys.self)
            self.cseImage = try container.decodeIfPresent([CSEImage].self, forKey: PageMap.CodingKeys.cseImage)
        }
        
        struct CSEImage: Codable {
            let src: String?
            
            enum CodingKeys: String, CodingKey {
                case src = "src"
            }
            
            init(from decoder: Decoder) throws {
                let container: KeyedDecodingContainer<CSEImage.CodingKeys> = try decoder.container(keyedBy: CSEImage.CodingKeys.self)
                self.src = try container.decodeIfPresent(String.self, forKey: CSEImage.CodingKeys.src)
            }
        }
    }
}
