
import Foundation
import UIKit

// This enum contains all the possible states a photo record can be in
enum PhotoRecordState {
  case new, downloaded, failed
}

class PendingOperations {
  lazy var downloadsInProgress: [IndexPath: Operation] = [:]
  lazy var downloadQueue: OperationQueue = {
    var queue = OperationQueue()
    queue.name = "Download queue"
    queue.maxConcurrentOperationCount = 1
    return queue
  }()
  
}

class ImageDownloader: Operation {
  //1
  let item: KeywordItem
  
  //2
  init(_ item: KeywordItem) {
    self.item = item
  }
  
  //3
  override func main() {
    //4
    if isCancelled {
      return
    }
    
    //5
    let url: URL = URL(string: item.keywordModel.icon)!
    
    guard let imageData = try? Data(contentsOf: url) else { return }
    
    //6
    if isCancelled {
      return
    }
    
    //7
    if !imageData.isEmpty {
      item.imageCached = UIImage(data:imageData)
      item.state = .downloaded
    } else {
      item.state = .failed
      item.imageCached = UIImage(named: "Failed")
    }
  }
}

