import UIKit
import CoreData

class Teacher: NSManagedObject {
  
  public static func createTeacher(teacherInfo: TeacherInfo,
                                   context:NSManagedObjectContext) throws -> Teacher {
    let teacher = Teacher()
    do {
      if try !userExists(teacherInfo: teacherInfo, context: context) {
        teacher.firstName = teacherInfo.firstName
        teacher.lastName = teacherInfo.lastName
        teacher.phoneNumber = teacherInfo.phoneNumber
      } else {
        throw CoreDataError.duplicateError("duplicate Error")
      }
    } catch {
      throw error
    }
    return teacher
  }
  
  private static func userExists(teacherInfo:TeacherInfo,
                                 context:NSManagedObjectContext) throws -> Bool {
    let request: NSFetchRequest<Teacher> = Teacher.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: "lastName", ascending: true), NSSortDescriptor(key: "firstName", ascending: true)]
    request.predicate = NSPredicate(format: "firstName = %@ and lastName = %@", teacherInfo.firstName, teacherInfo.lastName)
    var teachers = [Teacher]()
    do {
      teachers = try context.fetch(request)
    } catch {
      throw CoreDataError.fetchError(error.localizedDescription)
    }
    return teachers.count == 0
  }
}


