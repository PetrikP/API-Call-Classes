import Foundation
import UIKit

class CallApiP : NSObject
{
    
    let SERVER_ADDRESS = "http://www/yourdomain.com"
    var responseData : NSData! = nil
    var delegate : AnyObject?
    var callBackSelector : String!
    
    func MakeRequestAPI_POST(parameters:String,callBack:String,apiDelegate:AnyObject,method:String)
    {
        
        self.callBackSelector = callBack
        self.delegate = apiDelegate
        
        let RequestBody = parameters
        let url: NSURL = NSURL(string: SERVER_ADDRESS + method)!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = RequestBody.dataUsingEncoding(NSASCIIStringEncoding)
        request.timeoutInterval = 30
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(data,response,error) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                if error == nil
                {
                    if self.delegate != nil
                    {
                        do{
                            let jsonResult =  try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                            
                            self.delegate?.performSelector(Selector(self.callBackSelector), withObject: jsonResult, withObject: "200")
                            
                        }catch{
                            
                            //Error in response
                            self.delegate?.performSelector(Selector(self.callBackSelector), withObject: nil, withObject: "500")
                        }
                    }
                    
                    
                }else
                {
                    //Error in api call
                    self.delegate?.performSelector(Selector(self.callBackSelector), withObject: nil, withObject: "600")
                    
                    
                    
                }
                
            })//End Dispatch
            
        })// End CompletionHandler
        
        
        task.resume()
        
        
        
    }
    
    
    func MakeRequestAPI_GET(parameters:String,callBack:String,apiDelegate:AnyObject,method:String)
    {
        
        self.callBackSelector = callBack
        self.delegate = apiDelegate
        
        let RequestBody = parameters
        let url: NSURL = NSURL(string: "" + method + "?" + parameters)!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.HTTPBody = RequestBody.dataUsingEncoding(NSASCIIStringEncoding)
        request.timeoutInterval = 30
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(data,response,error) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                if error == nil
                {
                    if self.delegate != nil
                    {
                        do{
                            let jsonResult =  try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                            
                            self.delegate?.performSelector(Selector(self.callBackSelector), withObject: jsonResult, withObject: "200")
                            
                        }catch{
                            
                            //Error in response
                            self.delegate?.performSelector(Selector(self.callBackSelector), withObject: nil, withObject: "500")
                        }
                    }
                    
                    
                }else
                {
                    //Error in api call
                    self.delegate?.performSelector(Selector(self.callBackSelector), withObject: nil, withObject: "600")
                    
                    
                    
                }
                
            })//End Dispatch
            
        })// End CompletionHandler
        
        
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





