struct Category: Codable {
    let name: String
//    let sortOrder: SortOrder
    let sortOrder: Int
    let iconImage: String
    let subCategories: [SubCategory]
    
    private enum CodingKeys: String, CodingKey {
        case name
        case sortOrder
        case iconImage
        case subCategories = "subcategories"
    }
    
    init(from decoder: Decoder) {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        name = try! container.decode(String.self, forKey: .name)
        iconImage = try! container.decode(String.self, forKey: .iconImage)
        if let sortOrderString = try? container.decode(String.self, forKey: .sortOrder) {
            sortOrder = Int(sortOrderString)!
        } else {
            sortOrder = try! container.decode(Int.self, forKey: .sortOrder)
        }
       
        subCategories = try! container.decode([SubCategory].self, forKey: .subCategories)
    }
}

struct SubCategory: Codable {
    let id: Int
    let iconImage: String
    let sortOrder: Int
    let name: String
    let type: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case iconImage
        case sortOrder
        case name
        case type
    }
    
    init(from decoder: Decoder) {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        if let idString = try? container.decode(String.self, forKey: .id) {
            id = Int(idString)!
        } else {
            id = try! container.decode(Int.self, forKey: .id)
        }
        if let sortOrderString = try? container.decode(String.self, forKey: .sortOrder) {
            sortOrder = Int(sortOrderString)!
        } else {
            sortOrder = try! container.decode(Int.self, forKey: .sortOrder)
        }
        iconImage = try! container.decode(String.self, forKey: .iconImage)
        name = try! container.decode(String.self, forKey: .name)
        type = try! container.decode(String.self, forKey: .type)
    }
}

typealias Welcome = [String: Category]


struct CompareIDCategory {
    let id: String
    let myStruct: Category
}

