import Foundation
import UIKit


class CallApiP : NSObject
{
    
    var responseData : NSData! = nil
    var delegate : AnyObject?
    var callBackSelector : String!
    var InternetCheck : Reachability!

    
    
    
    func MakeRequestAPI(parameters:NSDictionary,callBack:String,apiDelegate:AnyObject,method:String)
    {
       /* do{
            InternetCheck = try Reachability.reachabilityForInternetConnection()
            
            */
            
            self.callBackSelector = callBack
            self.delegate = apiDelegate
            
            let RequestBody = GeneratePerameters(parameters)
            let url: NSURL = NSURL(string: AppConfig.SERVER_ADDRESS + method)!
            let session = NSURLSession.sharedSession()
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = RequestBody.dataUsingEncoding(NSASCIIStringEncoding)
            request.timeoutInterval = 30
            //print(RequestBody,url)
            let task = session.dataTaskWithRequest(request, completionHandler: {(data,response,error) in
                
                if error == nil
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                        do{
                            let xmlParse = try AEXMLDocument(xmlData: data!)
                            if self.delegate != nil
                            {
                                //self.delegate?.performSelector(Selector(self.callBackSelector), withObject: xmlParse)
                                self.delegate?.performSelector(Selector(self.callBackSelector), withObject: xmlParse, withObject: "200")
                            }
                        }catch
                        {
                          //  print(error)
                            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                            self.delegate?.performSelector(Selector(self.callBackSelector), withObject: nil, withObject: "500")
                            //Processcall.hideLoadingWithView()
                        }
                        
                    })
                    
                }else
                {
                    print("Error:",error?.description)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                            Processcall.hideLoadingWithView()
                        self.delegate?.performSelector(Selector(self.callBackSelector), withObject: nil, withObject: "600")
                    })
                        
                        
                }
            })
            
            task.resume()
            
       /* }catch
        {
            
            UIAlertView.init(title: "DoctorStay", message: "No Internet Connection!", delegate: nil, cancelButtonTitle: "Cancel").show()
        }*/
        
    }
    
    
    //MARK:- API CALL WITH TEST SERVER ADDRESS
    func TEST_MakeRequestAPI(parameters:NSDictionary,callBack:String,apiDelegate:AnyObject,method:String)
    {
        /* do{
        InternetCheck = try Reachability.reachabilityForInternetConnection()
        
        */
        
        self.callBackSelector = callBack
        self.delegate = apiDelegate
        
        let RequestBody = GeneratePerameters(parameters)
        let url: NSURL = NSURL(string: AppConfig.TEST_SERVER_ADDRESS + method)!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = RequestBody.dataUsingEncoding(NSASCIIStringEncoding)
        request.timeoutInterval = 30
//                    print(RequestBody)
//        print(url)
        let task = session.dataTaskWithRequest(request, completionHandler: {(data,response,error) in
            
            if error == nil
            {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    do{
                        let xmlParse = try AEXMLDocument(xmlData: data!)
                        if self.delegate != nil
                        {
                            self.delegate?.performSelector(Selector(self.callBackSelector), withObject: xmlParse)
                        }
                    }catch
                    {
                      //  print(error)
                        Processcall.hideLoadingWithView()
                    }
                    
                })
                
            }else
            {
              //  print(error?.description)
            }
        })
        
        task.resume()
        
        /* }catch
        {
        
        UIAlertView.init(title: "DoctorStay", message: "No Internet Connection!", delegate: nil, cancelButtonTitle: "Cancel").show()
        }*/
        
    }
    
    
    func MakeRequestAPI_JsonResponse(parameters:String,callBack:String,apiDelegate:AnyObject,method:String)
    {
        
        self.callBackSelector = callBack
        self.delegate = apiDelegate
        
        
        let RequestBody = parameters
        let url: NSURL = NSURL(string: "http://yourdomain" + method)!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = RequestBody.dataUsingEncoding(NSASCIIStringEncoding)
        request.timeoutInterval = 30

        let task = session.dataTaskWithRequest(request, completionHandler: {(data,response,error) in
            
            if error == nil
            {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    
                        if self.delegate != nil
                        {
                            let outputString : NSString = NSString(data:data!, encoding:NSUTF8StringEncoding)!
                            self.delegate?.performSelector(Selector(self.callBackSelector), withObject: outputString, withObject: "200")
                        }
                })
                
            }else
            {
              //  print("Error:",error?.description)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    //                            Processcall.hideLoadingWithView()
                    self.delegate?.performSelector(Selector(self.callBackSelector), withObject: nil, withObject: "600")
                })
                
                
            }
        })
        
        task.resume()
        
        
        
    }
    
    func MakeRequestAPI_JsonResponse_com(parameters:String,callBack:String,apiDelegate:AnyObject,method:String)
    {
        
        self.callBackSelector = callBack
        self.delegate = apiDelegate
        
        
        let RequestBody = parameters
        let url: NSURL = NSURL(string: "http://yourdomain" + method)!
     //   print(url)
      //  print(RequestBody)
        
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = RequestBody.dataUsingEncoding(NSASCIIStringEncoding)
        request.timeoutInterval = 30
        
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(data,response,error) in
            
            if error == nil
            {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    
                    if self.delegate != nil
                    {
                        let outputString : NSString = NSString(data:data!, encoding:NSUTF8StringEncoding)!
                        self.delegate?.performSelector(Selector(self.callBackSelector), withObject: outputString, withObject: "200")
                    }
                })
                
            }else
            {
              //  print("Error:",error?.description)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    //                            Processcall.hideLoadingWithView()
                    self.delegate?.performSelector(Selector(self.callBackSelector), withObject: nil, withObject: "600")
                })
                
                
            }
        })
        
        task.resume()
        
        
        
    }
    


    
    
    
    
    
    
    private func GeneratePerameters(m_paramMap:NSDictionary)->String
    {
        let param: NSMutableString = NSMutableString()
        let fields: [AnyObject] = m_paramMap.allKeys
        if fields.count == 0 {
            return param as String
        }
        for field in fields
        {
            let value : String = m_paramMap.objectForKey(field) as! String
            param.appendFormat((field as! String)+"="+value + "&")
        }
        return param.substringToIndex(param.length-1)
    }
    
    
    
    
    deinit {
       // print("deiniting")
    }
    
    
    
    
    func UploadFile(imageData : NSData,aDelegate:AnyObject,callBack:String,imgName:String)
    {
        let mainURL = AppConfig.IMAGE_UPLOAD_ADDRESS        
        let url = NSURL(string: mainURL)
        let request = NSMutableURLRequest(URL: url!)
        let boundary = "78876565564454554547676"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        request.HTTPMethod = "POST" // POST OR PUT What you want
        let session = NSURLSession(configuration:NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: nil)
        
        let imageData = imageData//UIImageJPEGRepresentation(UIImage(named: "Test.jpeg")!, 1)
    
        
        let body = NSMutableData()
        
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        // Append your parameters
        
        body.appendData("Content-Disposition: form-data; name=\"name\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("PREMKUMAR\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        body.appendData("Content-Disposition: form-data; name=\"description\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("IOS_DEVELOPER\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        
        // Append your Image/File Data
        
        let dtfrmt = NSDateFormatter()
        dtfrmt.dateFormat = "ddMMyyyy"
        
        let imageNameval = imgName
        
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition: form-data; name=\"uploaded_file\"; filename=\"\(imageNameval)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Type: image/jpeg\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(imageData)
        body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        request.HTTPBody = body
        
        print(imageNameval)
        
        
        let dataTask = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if error != nil {
                //handle error
                
                aDelegate.performSelector(Selector(callBack), withObject: nil, withObject: "500")
            }
            else {
                let outputString : NSString = NSString(data:data!, encoding:NSUTF8StringEncoding)!
                print(outputString)
                if outputString.lowercaseString == "success"
                {
                    print("Response:\(outputString)")
                    aDelegate.performSelector(Selector(callBack), withObject: outputString, withObject: "200")
                }else
                {
                    aDelegate.performSelector(Selector(callBack), withObject: outputString, withObject: "500")
                }
                
            }
            })
        }
        dataTask.resume()
        
    }
    
    
    
    
    
    
    
    
    
}





