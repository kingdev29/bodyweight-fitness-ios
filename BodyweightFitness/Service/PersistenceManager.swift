import Foundation

public extension String {
    var NS: NSString { return (self as NSString) }
}

class UserDefaults {
    func showRestTimer() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey("showRestTimer")
    }
    
    func showRestTimerAfterWarmup() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey("showRestTimerAfterWarmup")
    }
    
    func showRestTimerAfterBodylineDrills() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey("showRestTimerAfterBodylineDrills")
    }
    
    func showRestTimerAfterFlexibilityExercises() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey("showRestTimerAfterFlexibilityExercises")
    }
}

class PersistenceManager {
    class func getWeightUnit() -> String {
        let fileManager = NSFileManager.defaultManager()
        let directoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = directoryPath[0]
        let dataFilePath = documentsDirectory.NS.stringByAppendingPathComponent("weightUnit.archive")
        
        if(fileManager.fileExistsAtPath(dataFilePath)) {
            if let weightUnit = NSKeyedUnarchiver.unarchiveObjectWithFile(dataFilePath) as? String {
                return weightUnit
            }
        }
        
        return "kg"
    }
    
    class func setWeightUnit(weightUnit: String) {
        let directoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = directoryPath[0]
        let dataFilePath = documentsDirectory.NS.stringByAppendingPathComponent("weightUnit.archive")
        
        NSKeyedArchiver.archiveRootObject(weightUnit, toFile: dataFilePath)
    }
    
    class func getRestTime() -> Int {
        let fileManager = NSFileManager.defaultManager()
        let directoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = directoryPath[0]
        let dataFilePath = documentsDirectory.NS.stringByAppendingPathComponent("restTime.archive")
        
        if(fileManager.fileExistsAtPath(dataFilePath)) {
            if let restTime = NSKeyedUnarchiver.unarchiveObjectWithFile(dataFilePath) as? Int {
                return restTime
            }
        }
        
        return 60
    }
    
    class func setRestTime(restTime: Int) {
        let directoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = directoryPath[0]
        let dataFilePath = documentsDirectory.NS.stringByAppendingPathComponent("restTime.archive")
        
        NSKeyedArchiver.archiveRootObject(restTime, toFile: dataFilePath)
    }
    
    class func getNumberOfReps(id: String) -> Int {
        let fileManager = NSFileManager.defaultManager()
        let directoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = directoryPath[0]
        let dataFilePath = documentsDirectory.NS.stringByAppendingPathComponent("reps.\(id).archive")
        
        if(fileManager.fileExistsAtPath(dataFilePath)) {
            if let seconds = NSKeyedUnarchiver.unarchiveObjectWithFile(dataFilePath) as? Int {
                return seconds
            }
        }
        
        return 5
    }
    
    class func storeNumberOfReps(id: String, numberOfReps: Int) {
        let directoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = directoryPath[0]
        let dataFilePath = documentsDirectory.NS.stringByAppendingPathComponent("reps.\(id).archive")
        
        NSKeyedArchiver.archiveRootObject(numberOfReps, toFile: dataFilePath)
    }
    
    class func getTimer(id: String) -> Int {
        let fileManager = NSFileManager.defaultManager()
        let directoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = directoryPath[0]
        let dataFilePath = documentsDirectory.NS.stringByAppendingPathComponent("timer.\(id).archive")
        
        if(fileManager.fileExistsAtPath(dataFilePath)) {
            if let seconds = NSKeyedUnarchiver.unarchiveObjectWithFile(dataFilePath) as? Int {
                return seconds
            }
        }
        
        return 60
    }
    
    class func storeTimer(id: String, seconds: Int) {
        let directoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = directoryPath[0] 
        let dataFilePath = documentsDirectory.NS.stringByAppendingPathComponent("timer.\(id).archive")
        
        NSKeyedArchiver.archiveRootObject(seconds, toFile: dataFilePath)
    }
    
    class func getRoutine(routineId: String) -> Routine {
        let fileManager = NSFileManager.defaultManager()
        let directoryPath = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory,
            .UserDomainMask,
            true)
        
        var fileName = ""
        var id = ""
        
        if (routineId == "routine0") {
            fileName = "bodyweight_fitness_recommended_routine"
            id = "routine"
        } else if (routineId == "d8a722a0-fae2-4e7e-a751-430348c659fe") {
            fileName = "starting_stretching_flexibility_routine"
            id = "d8a722a0-fae2-4e7e-a751-430348c659fe"
        } else {
            fileName = "molding_mobility_flexibility_routine"
            id = "e73593f4-ee17-4b9b-912a-87fa3625f63d"
        }
        
        let documentsDirectory = directoryPath[0]
        let dataFilePath = documentsDirectory.NS.stringByAppendingPathComponent(id + ".archive")
        
        if(fileManager.fileExistsAtPath(dataFilePath)) {
            if let currentExercises = NSKeyedUnarchiver.unarchiveObjectWithFile(dataFilePath) as? Dictionary<String, String> {
                return Routine(fileName: fileName, dictionary: currentExercises)
            }
        }
        
        return Routine(fileName: fileName)
    }
    
    class func storeRoutine(routine: Routine) {
        let directoryPath = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory,
            .UserDomainMask,
            true)
        
        var id = ""
        
        if (routine.routineId == "routine0") {
            id = "routine"
        } else {
            id = routine.routineId
        }
        
        let documentsDirectory = directoryPath[0]
        let dataFilePath = documentsDirectory.NS.stringByAppendingPathComponent(id + ".archive")
        
        var currentExercises = Dictionary<String, String>()
        for anySection in routine.sections {
            if let section = anySection as? Section {
                if(section.mode == SectionMode.Pick || section.mode == SectionMode.Levels) {
                    currentExercises[section.sectionId] = section.currentExercise?.exerciseId
                }
            }
        }
        
        NSKeyedArchiver.archiveRootObject(currentExercises, toFile: dataFilePath)
    }
}
