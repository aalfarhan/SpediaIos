//
//  ServiceManager.swift
//
//  Created by Viraj Sharma on 01/01/2020.
//  Copyright © 2020 Rahul-101. All rights reserved.
//



import UIKit

import Alamofire
import SVProgressHUD
import SwiftyJSON


//1
class Connectivity {
   class var isConnectedToInternet:Bool {
    return NetworkReachabilityManager()!.isReachable
    }
}


//2
class ServiceManager: NSObject {
    
    let win:UIWindow = ((UIApplication.shared.delegate?.window)!)!
    
    //1 Post Request
    func postRequest(_ url : String, loader: Bool,parameters: [String: Any], responseBlock:@escaping (_ status :Bool,  _ jsonResponse:Any?) -> Void ) {
         
            //0
            if !Connectivity.isConnectedToInternet {
                showNetworkError()
                SVProgressHUD.dismiss()
                self.win.isUserInteractionEnabled = true
                responseBlock(false,nil)
                
            } else {
            
            //1
            if loader { SVProgressHUD.show() }
            self.win.isUserInteractionEnabled = false
            
            //2
            AF.request(url, method: .post, parameters:parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                
                if loader { SVProgressHUD.dismiss() }
                self.win.isUserInteractionEnabled = true
                               
                    
                let reponseJson = JSON.init(response.value ?? "NO DATA")
                let statusLocal = reponseJson["Status"].boolValue
                let errorMsg = L102Language.isCurrentLanguageArabic() ? reponseJson["MessageAr"].stringValue : reponseJson["MessageEn"].stringValue
                
                
                print("\n\n\nPOST API URL---->", url)
                
                print("\nPOST Params---->", parameters)
                    
                print("\nPOST DATA---->", reponseJson)
                
                switch response.result {
                
                case .success:
                    
                    if errorMsg == "authorization failed" {
                        
                        logoutNow()
                        responseBlock(false, nil)
                    
                    } else if !statusLocal {
                        SVProgressHUD.showError(withStatus: errorMsg)
                        responseBlock(false, nil)
                        
                    } else {
                       responseBlock(true, response.value)
                    }
                case .failure:
                    
                    if !Connectivity.isConnectedToInternet {
                        
                        //let msg =  L102Language.isCurrentLanguageArabic() ? "لم يتم العثور على شبكة ، تحقق من الإتصال بالانترنت" : " Network Error!\nPlease check your connection! "
                        
                        showNetworkError()
                        
                    } else {
                        
                       let msg =  L102Language.isCurrentLanguageArabic() ? "حدث خطأ ما ، برجاء إعادة المحاولة لاحقا" : " Something Went Wrong!\nPlease try later! "
                       
                       SVProgressHUD.showInfo(withStatus: msg)
                       
                    }
                
                    responseBlock(false, nil)
                }
           }
        }
    }
    
    
  
    
    
    
    //2 GET Request
    func getRequest(_ url : String, loader: Bool,parameters: [String: String], responseBlock:@escaping (_ status :Bool,  _ jsonResponse:Any?) -> Void ) {
        
            //0
            if !Connectivity.isConnectedToInternet {
                showNetworkError()
                SVProgressHUD.dismiss()
                self.win.isUserInteractionEnabled = true
                responseBlock(false,nil)
            } else {
                 
                
            //1
            if loader { SVProgressHUD.show() }
            self.win.isUserInteractionEnabled = false
             
            //2
            AF.request(url).responseJSON { response in
            //AF.request(url, method: .get, parameters:parameters, encoding: .default)
                //.responseJSON { response in
                
                if loader { SVProgressHUD.dismiss() }
                self.win.isUserInteractionEnabled = true
                               
                let reponseJson = JSON.init(response.value ?? "NO DATA")
                let statusLocal = reponseJson["Status"].boolValue
                let errorMsg = L102Language.isCurrentLanguageArabic() ? reponseJson["MessageAr"].stringValue : reponseJson["MessageEn"].stringValue
                
                print("\n\n GET API URL---->", url)
                
                print("\n\n\n GET Params---->", parameters, "\n")
                    
                print("\n\n\n GET DATA---->", reponseJson, "\n")
                
                switch response.result {
                
                case .success:
                    
                    if !statusLocal {
                        SVProgressHUD.showError(withStatus: errorMsg)
                        responseBlock(false, nil)
                        
                    }
                    responseBlock(true, response.value)
                    
                case .failure:
                    
                    if !Connectivity.isConnectedToInternet {
                        
                        //let msg =  L102Language.isCurrentLanguageArabic() ? "لم يتم العثور على شبكة ، تحقق من الإتصال بالانترنت" : " Network Error!\nPlease check your connection! "
                        
                        showNetworkError()
                        
                    } else {
                        
                       let msg =  L102Language.isCurrentLanguageArabic() ? "حدث خطأ ما ، برجاء إعادة المحاولة لاحقا" : " Something Went Wrong!\nPlease try later! "
                       
                       SVProgressHUD.showInfo(withStatus: msg)
                       
                    }
                
                    responseBlock(false, nil)
                }
            }
        }
    }

    
    //3 CANCEL request
    func cancelPreviousSearchRequest() {
        let sessionManager = AF //SessionManager.default
        sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach {
            if($0.originalRequest?.url?.absoluteString.contains("searchcontent"))! {
                    $0.cancel()
                    
            }
            if($0.originalRequest?.url?.absoluteString.contains("update"))! {
                    $0.cancel()
            }
            }
            //uploadTasks.forEach { $0.cancel() }
            //downloadTasks.forEach { $0.cancel() }
        }
    }
    
    
    
    func uploadPhoto(_ url: String, imageExtension: String, imageData : Data, params: [String : Data], header: [String:String], responseBlock:@escaping (_ status :Bool,  _ jsonResponse:Any?) -> Void) {
        
        
        SVProgressHUD.showProgress(Float(0), status: "uploading".localized()+"\n...")
        self.win.isUserInteractionEnabled = false
        
        
        //let httpHeaders: HTTPHeaders = ["Content-Type": "application/json; charset=utf-8"]
       
        
        AF.upload(multipartFormData: { (multipartFormData) in
                    for (key, value) in params {
                        
                        print("Upload Params KEY AND VALUE---->", key, value )
                        
                        //multipartFormData.append("\(value)".data(using: .utf8)!, withName: key as String)
                        
                        //multipartFormData.append(imageData, withName: key as String, fileName: "image.\(imageExtension)", mimeType: "image/\(imageExtension)")
                        
                        multipartFormData.append(imageData, withName: "stream", fileName: "imagefile.png", mimeType: "image/png")
                        
                        
                    }
            
                    //multipartFormData.append(imageData, withName: "strem", fileName: "file.\(imageExtension)", mimeType: "image\(imageExtension)")
          }
          , to: url, method: .post).uploadProgress(queue: .main, closure: { progress in
            
            let str = String(format: "uploading".localized()+"\n%.0f%%", progress.fractionCompleted*100)
            progress.cancel()
            SVProgressHUD.showProgress(Float(progress.fractionCompleted), status: str)
            
        }).responseJSON(completionHandler: { data in
            print("upload finished: \(String(describing: data.value))")
            
        }).response { (response) in
            switch response.result {
            case .success(let resut):
                
                let reponseJson = JSON.init((response.value ?? "NO DATA") ?? "NO DATA")
                let statusLocal = reponseJson["Status"].boolValue
                let errorMsg = L102Language.isCurrentLanguageArabic() ? reponseJson["MessageAr"].stringValue : reponseJson["MessageEn"].stringValue
                
                print("\n\n\n Upload Params---->", url, "\n")
                                   
                print("\n\n\n Uplaod DATA---->", params, "\n")
                
                print("\n\n\n Upload success result: \(String(describing: resut))")
                
                self.win.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
                
                
                if !statusLocal {
                    SVProgressHUD.showError(withStatus: errorMsg)
                    responseBlock(false, nil)
                    
                }
                
                responseBlock(true, response.value ?? nil)
                
            case .failure(let err):
                
                self.win.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
                print("upload err: \(err)")
                
                responseBlock(false, nil)
                
            }
        
            
        }
    }
    
    
    //MARK: Upload File or PDF....
    func uploadFileOrPdf(_ url: String, fileExtension: String, fileData : Data, params: [String : Data], header: [String:String], responseBlock:@escaping (_ status :Bool,  _ jsonResponse:Any?) -> Void) {
        
        
        SVProgressHUD.showProgress(Float(0), status: "uploading".localized()+"\n...")
        self.win.isUserInteractionEnabled = false
        
        AF.upload(multipartFormData: { (multipartFormData) in
                    for (key, value) in params {
                        
                        print("Upload Params KEY AND VALUE---->", key, value, fileExtension, fileData )
                        
                        multipartFormData.append(fileData, withName: "stream", fileName: "file.\(fileExtension)", mimeType: "application/\(fileExtension)")
                        
                    }
            
          }
          , to: url, method: .post).uploadProgress(queue: .main, closure: { progress in
            
            let str = String(format: "uploading".localized()+"\n%.0f%%", progress.fractionCompleted*100)
            progress.cancel()
            SVProgressHUD.showProgress(Float(progress.fractionCompleted), status: str)
            
        }).responseJSON(completionHandler: { data in
            print("upload finished: \(String(describing: data.value))")
            
        }).response { (response) in
            switch response.result {
            case .success(let resut):
                
                
                let reponseJson = JSON.init((response.value ?? "NO DATA") ?? "NO DATA")
                let statusLocal = reponseJson["Status"].boolValue
                let errorMsg = L102Language.isCurrentLanguageArabic() ? reponseJson["MessageAr"].stringValue : reponseJson["MessageEn"].stringValue
                
                print("\n\n\n Upload Params---->", url, "\n")
                                   
                print("\n\n\n Uplaod DATA---->", params, "\n")
                
                print("\n\n\n Upload success result: \(String(describing: resut))")
                
                self.win.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
                
                if !statusLocal {
                    SVProgressHUD.showError(withStatus: errorMsg)
                    responseBlock(false, nil)
                }
                
                responseBlock(true, response.value ?? nil)
                
            case .failure(let err):
                
                self.win.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
                print("upload err: \(err)")
                
                responseBlock(false, nil)
                
            }
        }
    }

    
    //MARK: 4 Download file with return string file path (Save File Cache)
    func downloadFile(_ url: String, responseBlock:@escaping (_ status :Bool,  _ saveFilePath:URL?) -> Void) {
        
        SVProgressHUD.showProgress(Float(0), status: "please_wait_loading".localized()+"\n...")
        self.win.isUserInteractionEnabled = false
        
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("file.pdf")

            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        AF.download(url, to: destination).downloadProgress { progress in
            //progress closure
            let str = String(format: "please_wait_loading".localized()+"\n%.0f%%", progress.fractionCompleted*100)
            progress.cancel()
            SVProgressHUD.showProgress(Float(progress.fractionCompleted), status: str)
        }
        
        .response { response in
            
            if response.error == nil, let pdfFilePath = response.fileURL?.absoluteURL {
                
                self.win.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
                
                responseBlock(true, pdfFilePath)
                
            } else {
                self.win.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
                debugPrint(response.error ?? "")
                responseBlock(false, nil)
            }
        }
        
        
        
        /*
        SVProgressHUD.showProgress(Float(0), status: "uploading".localized()+"\n...")
        self.win.isUserInteractionEnabled = false
        
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        
        AF.download(url, method: .get, encoding: JSONEncoding.default, to: destination).downloadProgress(closure: { (progress) in
            
            //progress closure
            let str = String(format: "uploading".localized()+"\n%.0f%%", progress.fractionCompleted*100)
            progress.cancel()
            SVProgressHUD.showProgress(Float(progress.fractionCompleted), status: str)
            
        }).response(completionHandler: { (DefaultDownloadResponse) in
            //result closure
            
        
        }).response { (response) in
            switch response.result {
            case .success(let resut):
                
                //print("\n\n\n Download File Path---->", response.fileURL ?? "")
                                   
                print("\n Download Success Result: \(String(describing: resut))")
                
                self.win.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
                
                responseBlock(true, response.fileURL?.absoluteURL)
                
            case .failure(let err):
                
                self.win.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
                print("upload err: \(err)")
                
                responseBlock(false, nil)
                
            }
        }
        */
    }
    

    //MARK: 5 Download file with return string file path (Save File Cache)
    func downloadImage(_ url: String, responseBlock:@escaping (_ status :Bool,  _ image:UIImage?) -> Void) {
        
        SVProgressHUD.showProgress(Float(0), status: "please_wait_loading".localized()+"\n...")
        self.win.isUserInteractionEnabled = false

        AF.request(url, method: .get).downloadProgress(closure: { progress in
            //progress closure
            let str = String(format: "please_wait_loading".localized()+"\n%.0f%%", progress.fractionCompleted*100)
            progress.cancel()
            SVProgressHUD.showProgress(Float(progress.fractionCompleted), status: str)
        }).response{ response in
            self.win.isUserInteractionEnabled = true
            SVProgressHUD.dismiss()
           switch response.result {
            case .success(let responseData):
                let image = UIImage(data: responseData!, scale:1)
               responseBlock(true, image)
            case .failure(let error):
               responseBlock(false, nil)
                print("error--->",error)
            }
        }
        
        /*
        SVProgressHUD.showProgress(Float(0), status: "uploading".localized()+"\n...")
        self.win.isUserInteractionEnabled = false
        
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        
        AF.download(url, method: .get, encoding: JSONEncoding.default, to: destination).downloadProgress(closure: { (progress) in
            
            //progress closure
            let str = String(format: "uploading".localized()+"\n%.0f%%", progress.fractionCompleted*100)
            progress.cancel()
            SVProgressHUD.showProgress(Float(progress.fractionCompleted), status: str)
            
        }).response(completionHandler: { (DefaultDownloadResponse) in
            //result closure
            
        
        }).response { (response) in
            switch response.result {
            case .success(let resut):
                
                //print("\n\n\n Download File Path---->", response.fileURL ?? "")
                                   
                print("\n Download Success Result: \(String(describing: resut))")
                
                self.win.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
                
                responseBlock(true, response.fileURL?.absoluteURL)
                
            case .failure(let err):
                
                self.win.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
                print("upload err: \(err)")
                
                responseBlock(false, nil)
                
            }
        }
        */
    }
    
    
} //END....











//Don't Delete Now....

/*
 
 //Convert JSON Formate....
 func getJSONStringFromDictionary(_ dic: Dictionary<String, Any>) -> String {
 do {
 let jsonData = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted)
 let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)!
 return jsonString as String
 } catch let error as NSError {
 print(error.localizedDescription)
 return ""
 }
 
 }

 
 
 //1 POST Request....
 func postRequestOld(_ url : String, parameters : [String: String],headers: [String: String], loader: Bool, responseBlock:@escaping (_ status :Bool,  _ jsonResponse:AnyObject?, _ error:NSError?) -> Void ) {
 
 Alamofire.request(url, method: .post, parameters:parameters, encoding: URLEncoding.default, headers:nil).responseJSON
 { (response) in
 
 switch response.result {
 
 case .success:
 responseBlock(true, response.result.value as AnyObject?, nil)
 
 case .failure:
 
 //if !Connectivity.isConnectedToInternet {
 //   showAlertViewWith(title: networkErrorTitle, msg: networkErrorMsg)
 //}
 responseBlock(false, nil, response.result.error as NSError?)
 }
 }
 
 }
 */

