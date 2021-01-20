//
//  Copyright 2021 Readium Foundation. All rights reserved.
//  Use of this source code is governed by the BSD-style license
//  available in the top-level LICENSE file of the project.
//

import Foundation
import UIKit
import R2Shared
import R2Streamer

public class ReadiumWrapper: ReaderFormatModuleDelegate {
    
    var server: PublicationServer! = nil
    var navController: UINavigationController! = nil
    
    var darkMode: Bool! = nil
    
    private let streamer: Streamer = Streamer(
        contentProtections: []
    )
    
    public init(darkMode: Bool? = false) {
        guard let s = PublicationServer() else {
            print("Could not start publication server...")
            return
        }
        server = s
        self.darkMode = darkMode
    }
    
    public func open(at: String, sender: UIViewController) {
        if (server == nil) {
            print("Server is not running")
            return
        }
        
        let url = URL(fileURLWithPath: at)
        self.openPublication(at: url, allowUserInteraction: false, sender: sender)
            // Map on background because we will read the publication cover to create the
            // `Book`, which might take some CPU time.
            
            .map(on: .global(qos: .background)) { publication -> (Publication, Book) in
                let publication = publication
                let book = Book(publication: publication, url: url)
                return (publication, book)
            }
            .resolve { result in
                
                switch result {
                case .success((let publication, let book)):
                    self.showBook(publication: publication, book: book, sender: sender)
                    
                case .cancelled:
                    print("cancelled")
                    
                case .failure(let error):
                    print(error)
                }
                
            }
    }
    
    private func showBook(publication: Publication, book: Book, sender: UIViewController) {
        func present(_ viewController: UIViewController) {
            navController = UINavigationController(rootViewController: viewController)
            navController.modalPresentationStyle = .fullScreen
            viewController.hidesBottomBarWhenPushed = true
            sender.present(navController, animated: true, completion: nil)
        }
        
        preparePresentation(of: publication, book: book)
        
        do {
            let view = try self.makeReaderViewController(for: publication, book: book, resourcesServer: self.server)
            present(view)
        } catch {
            print("Show reader failed")
        }
    }
    
    
    private func openPublication(at url: URL, allowUserInteraction: Bool, sender: UIViewController?) -> Deferred<Publication, Error> {
        return deferred {
            self.streamer.open(asset: FileAsset(url: url), allowUserInteraction: allowUserInteraction, sender: sender, completion: $0)
        }
        .eraseToAnyError()
    }
    
    private func makeReaderViewController(for publication: Publication, book: Book, resourcesServer: ResourcesServer) throws -> ReadiumWrapperViewController {
        guard publication.metadata.identifier != nil else {
            throw ReaderError.epubNotValid
        }
        
        let epubViewController = ReadiumWrapperViewController(publication: publication, book: book, resourcesServer: resourcesServer)
        epubViewController.moduleDelegate = self
        epubViewController.darkMode = self.darkMode
        return epubViewController
    }
    
    private func preparePresentation(of publication: Publication, book: Book) {
        // If the book is a webpub, it means it is loaded remotely from a URL, and it doesn't need to be added to the publication server.
        guard publication.format != .webpub else {
            return
        }
        
        server.removeAll()
        do {
            try server.add(publication)
        } catch {
            print("Couldn't add book to server")
        }
    }
    
    private func setProperties(publication: Publication) {
//        publication.userProperties.
    }
    
    internal func presentOutline(of publication: Publication, delegate: OutlineTableViewControllerDelegate?, from viewController: UIViewController) {
        let outlineTableVC: OutlineTableViewController = make(publication: publication)
        outlineTableVC.delegate = delegate
        outlineTableVC.modalPresentationStyle = .overFullScreen
        viewController.present(UINavigationController(rootViewController: outlineTableVC), animated: true)
    }
    
    internal func presentDRM(for publication: Publication, from viewController: UIViewController) {
        // NOT NEEDED
    }
    
    internal func presentAlert(_ title: String, message: String, from viewController: UIViewController) {
        // NOT NEEDED
    }
    
    internal func presentError(_ error: Error?, from viewController: UIViewController) {
        // NOT NEEDED
    }
    
    func make(publication: Publication) -> OutlineTableViewController {
        let storyboard = UIStoryboard(name: "Outline", bundle: Bundle(for: ReadiumWrapper.self))
        let controller = storyboard.instantiateViewController(withIdentifier: "OutlineTableViewController") as! OutlineTableViewController
        controller.publication = publication
        return controller
    }
}

private extension Book {
    
    /// Creates a new `Book` from a Readium `Publication` and its URL.
    convenience init(publication: Publication, url: URL) {
        self.init(
            href: (url.isFileURL || url.scheme == nil) ? url.lastPathComponent : url.absoluteString,
            title: publication.metadata.title,
            author: publication.metadata.authors
                .map { $0.name }
                .joined(separator: ", "),
            identifier: publication.metadata.identifier ?? url.lastPathComponent,
            cover: publication.cover?.pngData()
        )
    }
    
}

private class ReadiumWrapperViewController: EPUBViewController {
    public var darkMode = false
    
    override func viewDidLoad() {
        super .viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.close(sender:)))
        
        if (darkMode) {
            userSettingNavigationController.appearanceDidChange(to: 2)
        } else {
            userSettingNavigationController.appearanceDidChange(to: 0)
        }
    }
    
    @objc func close(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

}
enum ReadiumWrapperError: Error {
    case serverError(String)
}
