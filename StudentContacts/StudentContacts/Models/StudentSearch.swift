import Foundation

struct StudentInfo: Codable {
  public let firstName: String
  public let lastName: String
  public let emergencyContact: String
  public let phoneNumber: String
  public let imageURL: URL
}
