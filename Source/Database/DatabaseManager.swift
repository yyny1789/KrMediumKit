//
//  DatabaseManager.swift
//  Client
//
//  Created by aidenluo on 7/26/16.
//  Copyright © 2016 36Kr. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseManager {
    
    class var manager: DatabaseManager {
        
        struct SingletonWrapper {
            static let singleton = DatabaseManager()
        }
        
        return SingletonWrapper.singleton
    }
    
    let databasePath = DatabaseManagerSettings.databasePath ??
        NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] + "/defaultData.realm"
    
    let writeOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "com.36kr.realm.write"
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .background
        return queue
    }()
    
    init() {
        let config = Realm.Configuration(
            fileURL: URL(fileURLWithPath: databasePath),
            // 设置新的架构版本。这个版本号必须高于之前所用的版本号（如果您之前从未设置过架构版本，那么这个版本号设置为 0）
            schemaVersion: 1,
            
            // 设置闭包，这个闭包将会在打开低于上面所设置版本号的 Realm 数据库的时候被自动调用
            migrationBlock: { migration, oldSchemaVersion in
                // 目前我们还未进行数据迁移，因此 oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // 什么都不要做！Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构
                }
        })
        Realm.Configuration.defaultConfiguration = config
    }
    
    func saveObjects<T: Object>(_ objects: @escaping () -> [T], completion: (() -> Void)? = nil) {
        writeOperationQueue.addOperation {
            autoreleasepool {
                do {
                    let realm = try Realm()
                    try realm.write {
                        for object in objects() {
                            realm.add(object, update: true)
                        }
                    }
                } catch {
                    
                }
            }
            OperationQueue.main.addOperation({
                completion?()
            })
        }
    }
    
    //注意，要从Realm中删除的Object必须是从Realm中读出来的,并且在同一线程读出并删除，如果是内存中New的，删除会抛异常
    func deleteObjects<T : Object>(_ retrieveObjects: @escaping () -> Results<T>, completion: (() -> Void)? = nil) {
        writeOperationQueue.addOperation {
            autoreleasepool {
                do {
                    let realm = try Realm()
                    let objects = retrieveObjects()
                    try realm.write {
                        for object in objects {
                            realm.delete(object)
                        }
                    }
                } catch {
                    
                }
                OperationQueue.main.addOperation({
                    completion?()
                })
            }
        }
    }
    
    func retrieveObjects<T : Object>(_ objectType: T.Type, filter: NSPredicate? = nil) -> Results<T> {
        let realm = try! Realm()
        if let filter = filter {
            return realm.objects(objectType).filter(filter)
        } else {
            return realm.objects(objectType)
        }
    }
    
    func objectWithPrimaryKey<T: Object>(_ type: T.Type, primaryKey: AnyObject) -> T? {
        do {
            let realm = try Realm()
            return realm.object(ofType: type, forPrimaryKey: primaryKey)
        } catch {
            return nil
        }
    }
    
}
