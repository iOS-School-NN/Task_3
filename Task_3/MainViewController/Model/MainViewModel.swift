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
    private var additionalPagesArray = [Result]()
    
    let queueForLoadAdditionalPages = DispatchQueue(
        label: "com.task_3.queueForLoadAdditionalPages",
        attributes: [.concurrent, .initiallyInactive]
    )
    
    init() {
        self.baseURL = NetworkConstants.urlForLoadingListOfCharacters
    }
    
    func loadInformation() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.loadInformationByPage(urlString: NetworkConstants.urlForLoadingListOfCharacters, id: self.pageId)
        }
    }
    
    func loadInformationByPage(urlString: String, id: Int) {
        NetworkService.performGetRequestForLoadingPages(url: urlString, pageId: id, onComplete: { [weak self] (data, id) in
                print("HELLO", id)
                self?.delegate?.updateTableViewBy(item: data.results)
                self?.asyncDownloadCharactersInfoByPage(count: data.info.pages, with: 3)
                
        }) { (error, id) in
                NSLog(error.localizedDescription)
                print("HELLO", id)
           }
    }
    
    func asyncDownloadCharactersInfoByPage(count: Int, with pageSize: Int) {
        let queue = DispatchQueue(label: "com.task_3.semaphore", attributes: .concurrent)
        //queue.

        let semaphore = DispatchSemaphore(value: pageSize)
    
        for i in 2...count {
            queue.async {
                semaphore.wait()
                NetworkService.performGetRequestForLoadingPages(url: NetworkConstants.urlForLoadingListOfCharacters + "?page=" + String(i), pageId: i, onComplete: { [weak self] (data, id) in
                        print("HELLO", id)
                        self?.additionalPagesArray = self!.additionalPagesArray + data.results
                        semaphore.signal()
                        if (i == count) {
                            print("All")
                            self?.delegate?.updateDataBy(item: (self!.additionalPagesArray.sorted { $0.id < $1.id }))
                        }
                        if (self?.additionalPagesArray.count == 3 * 20) {
                            self!.delegate?.updateDataBy(item: (self!.additionalPagesArray.sorted { $0.id < $1.id }))
                            self?.additionalPagesArray.removeAll()
                            print("three")
                        }
                        
                }) { (error, id) in
                        NSLog(error.localizedDescription)
                        print("HELLO", id)
                        semaphore.signal()
                   }
            }
        }
        }
    }




