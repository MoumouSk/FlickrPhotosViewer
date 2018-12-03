
	
import UIKit
import Alamofire

/* FORMAT URL WITH TERM , REQUEST API FOR PHOTOS, FILL THE RESULT ARRAY */

let apiKey = "63d81e65c3bea7d18298863241a2efbe"

class Flickr {
    
    // MARK: SEARCH TERM IN FLICKR - MAKE REQUEST AND PROCESS RESPONSE
    func searchFlickrForTerm(_ searchTerm: String, completion : @escaping (_ results: FlickrSearchResults?, _ error: Error?) -> Void) {
        
        // This block is assigning searchURL to the URL built by the flickrSearchURLForSearchTerm function.
        guard let searchURL = flickrSearchURLForSearchTerm(searchTerm) else {
            completion(nil, "URL failed to build" as? Error)
            return
        }
        
        // Making the request - Getting the response as JSON
        Alamofire.request(searchURL).validate(statusCode: 200..<299).responseJSON(completionHandler: { response in
            
            guard response.result.isSuccess else {
                completion(nil, String(describing: response.result.error) as? Error)
                return
            }
            
            // JSON into Dictionnary - Stat as a string - PhotoContainer getting the Photos array as dictionnary
            guard let json = response.result.value as? [String: AnyObject], let stat = json["stat"] as? String, let photoContainer = json["photos"] as? [String: AnyObject] else {
                completion(nil, "Coudln't build dictionnaries from JSON response" as? Error)
                return
            }
            
            // Photos received as Dictionnary from PhotoContainer
            guard let photosReceived = photoContainer["photo"] as? [[String: AnyObject]]  else {
                completion(nil, "Couldn't build photos dictionnary from photos container" as? Error)
                return
            }
            
            // Error handling from STAT
            switch (stat) {
            case "ok":
                print("Results processed OK")
            case "fail":
                if let message = json["message"] {
                    completion(nil,  message as? Error)
                }
                completion(nil, "Status : FAIL. No stat error message found." as? Error)
                return
            default:
                completion(nil, "Reponse status error" as? Error)
                return
            }
        
            // new array of FlickrPhoto
            var flickrPhotos = [FlickrPhoto]()
            
            // setting new FlickrPhoto attributes
            for photoObject in photosReceived {
                guard let photoID = photoObject["id"] as? String,
                    let farm = photoObject["farm"] as? Int ,
                    let server = photoObject["server"] as? String ,
                    let secret = photoObject["secret"] as? String else {
                        break
                }
                
                // Building it with attributes
                let flickrPhoto = FlickrPhoto(photoID: photoID, farm: farm, server: server, secret: secret)
                
                // Thumbnail - Actual image
                guard let url = flickrPhoto.flickrImageURL(),
                    let imageData = try? Data(contentsOf: url as URL) else {
                        break
                }
                // Append in array
                if let image = UIImage(data: imageData) {
                    flickrPhoto.thumbnail = image
                    flickrPhotos.append(flickrPhoto)
                }
            }
            completion(FlickrSearchResults(searchTerm: searchTerm, searchResults: flickrPhotos), nil)
        })
    }
    
    // MARK: FORMATTING CORRECT URL FOR THE SEARCH - WITH ENCODED TERM
    fileprivate func flickrSearchURLForSearchTerm(_ searchTerm: String) -> URL? {
        
        //Encoding the term to search
        guard let escapedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
            return nil
        }
        // Formating URL and adding API Key and encoded term
        let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&tags=\(escapedTerm)&per_page=21&format=json&nojsoncallback=1"
        
        //String to URL
        guard let url = URL(string:URLString) else {
            return nil
        }
        return url
    }
}
