

import Foundation

extension Court: Equatable {
    static func ==(lhs: Court, rhs: Court) -> Bool {
        return lhs.id == rhs.id
    }
}
    
struct Court: Codable {
    let id: Int
    let parent_id: Int?
    let name: String
    let address: String
    let prev_address: String
    let category: String
    let polygons: String
  //  let polygons: [[[Double]]]?
    let jurisdiction_address: String
    let latitude: Double?
    let longitude: Double?
    let code: String
  //  let website: String
    let court_id: String?
    let number: String?
    let taxOfficeEntity: TaxOfficeEntity?
}



struct TaxOfficeEntity: Codable {
    let id: Int
    let code: String
    let payment_receiver: String 
    let kpp: String
    let inn: String
    let bank: String
}


