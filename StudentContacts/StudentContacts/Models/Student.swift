import UIKit
import CoreData

enum CoreDataError: Error {
  case duplicateError(String)
  case fetchError(String)
}

class Student: NSManagedObject {
  
  public static func createStudent(studentInfo: StudentInfo,
                                   context:NSManagedObjectContext) throws -> Student {
    let student = Student()
    do {
      if try !userExists(studentInfo: studentInfo, context: context) {
        student.firstName = studentInfo.firstName
        student.lastName = studentInfo.lastName
        student.emergencyContact = studentInfo.emergencyContact
        student.phoneNumber = studentInfo.phoneNumber
      } else {
        throw CoreDataError.duplicateError("duplicate Error")
      }
    } catch {
      throw error
    }
    return student
  }
  
  private static func userExists(studentInfo:StudentInfo,
                                 context:NSManagedObjectContext) throws -> Bool {
    let request: NSFetchRequest<Student> = Student.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: "lastName", ascending: true), NSSortDescriptor(key: "firstName", ascending: true)]
    request.predicate = NSPredicate(format: "firstName = %@ and lastName = %@", studentInfo.firstName, studentInfo.lastName)
    var students = [Student]()
    do {
      students = try context.fetch(request)
    } catch {
      throw CoreDataError.fetchError(error.localizedDescription)
    }
    return students.count == 0
  }
}

