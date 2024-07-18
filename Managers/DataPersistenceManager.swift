//
//  DataPersistenceManager.swift
//  Netflix-Clone
//
//  Created by serhat on 13.07.2024.
//

import Foundation
import CoreData
import UIKit

class DataPersistenceManager {
    static  let shared = DataPersistenceManager()
    
    func downloadTitleWith(model: ResultMovie, completion: @escaping (Result<Void,Error>)->Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let context = appDelegate.persistentContainer.viewContext
        let item    = TitleItem(context: context)
        item.itemId = Int64(model.id!)
        item.mediaType = model.mediaType ?? ""
        item.originalLanguage = model.originalLanguage ?? ""
        item.originalName = model.originalName ?? ""
        item.originalTitle = model.originalTitle ?? ""
        item.overview = model.overview ?? ""
        item.popularity = model.popularity ?? 0.0
        item.posterPath = model.posterPath ?? ""
        item.releaseDate = model.releaseDate ?? ""
        item.title = model.title ?? ""
        item.voteAverage = model.voteAverage ?? 0.0
        item.voteCount = model.voteCount ?? 0.0
        
        
        do {
            try context.save()
            completion(.success(()))
        } catch{
            print(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
    
    func fetchTitleFromDatabase(completion: @escaping (Result<[TitleItem],Error>)->Void){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<TitleItem>
        request = TitleItem.fetchRequest()
        do {
            let titles = try context.fetch(request)
            completion(.success(titles))
        } catch{
            completion(.failure(error))
        }
    }
    
    func deleteTitleWith(model: TitleItem, completion: @escaping (Result<Void,Error>)->Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do{
            try context.save()
            completion(.success(()))
        } catch{
            completion(.failure(error))
        }
        
    }
}
