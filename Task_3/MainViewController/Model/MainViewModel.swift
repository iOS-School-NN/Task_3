//
//  MainViewModel.swift
//  Task_3
//
//  Created by KirRealDev on 16.07.2021.
//

import Foundation

protocol MainViewModelDelegate: AnyObject {
    func updateTableViewBy(item: [Result])
    func updateDataBy(item: [Result])
}

final class MainViewModel {
    weak var delegate: MainViewModelDelegate?
    private var baseURL: String = ""
    private var pageId: Int = 1
    //private var dataArray = [Result]()
    
    let queueForLoadAdditionalPages = DispatchQueue(
        label: "com.task_3.queueForLoadAdditionalPages",
        attributes: [.concurrent, .initiallyInactive]
    )
    
    init() {
        self.baseURL = NetworkConstants.urlForLoadingListOfCharacters
    }
    
    func loadStartInformation() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.loadInformationByPage(urlString: NetworkConstants.urlForLoadingListOfCharacters, id: self.pageId)
        }
    }
    
    func loadInformationByPage(urlString: String, id: Int) {
        NetworkService.performGetRequest(url: urlString, pageId: id, onComplete: { [weak self] (data, id) in
                print("HELLO", id)
                
                if (self?.pageId == 1) {
                    self?.delegate?.updateTableViewBy(item: data.results)
                    self?.asyncDownloadCharactersInfo(count: 10, with: 3)
                } else {
                    self?.delegate?.updateDataBy(item: data.results)
                }
                self?.pageId = (self?.pageId ?? 0) + 1
            
//                if (self?.currentPage == 1) {
//                    self?.characterInfo = self?.dictOfPages[self?.currentPage ?? 1]
//                    self?.mainTableView.reloadData()
//                    //self?.queueForLoadAdditionalPages.activate()
//                    self?.asyncDownloadCharactersInfo(count: 10, with: 3)
//                }
                
                
        }) { (error, id) in
                NSLog(error.localizedDescription)
                print("HELLO", id)
           }
    }
    
    func asyncDownloadCharactersInfo(count: Int, with pageSize: Int) {
        let queue = DispatchQueue(label: "com.task_3.semaphore", attributes: .concurrent)
        let semaphore = DispatchSemaphore(value: pageSize)
    
        for i in 2...count {
            queue.async {
                let itemNumber = i
                semaphore.wait()
                print("Загрузка началась \(itemNumber)")
                self.loadInformationByPage(urlString: "https://rickandmortyapi.com/api/character?page=" + String(i), id: i)
                print("Загрузка завершилась \(itemNumber)")
                  semaphore.signal()
            }
        }
    }

}


