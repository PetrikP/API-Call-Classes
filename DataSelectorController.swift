import UIKit
import AddressBook


struct DataSelect {
    static var lbl_name  = ""
    static var lbl_number = ""
}

class DataSelectorController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contact"
        tbl_contact.tableFooterView = UIView()
        
        let authorizationStatus = ABAddressBookGetAuthorizationStatus()
        switch authorizationStatus
        {
        case .Denied, .Restricted:
            //1
            print("Denied")
        case .Authorized:
            //2
            print("Authorized")
            getContactNames()
        case .NotDetermined:
            //3
            AskForContact()
            print("Not Determined")
        }
        
        //Navigation Back Button
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.NavigationBackButton(_:)))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func NavigationBackButton(sender:AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func AskForContact()
    {
        
        ABAddressBookRequestAccessWithCompletion(addressBookRef) {
            (granted: Bool, error: CFError!) in
            dispatch_async(dispatch_get_main_queue()) {
                if !granted {
                    print("Just denied")
                } else {
                    print("Just authorized")
                    self.getContactNames()
                }
            }
        }
    }
    
    func getContactNames()
    {
        
        let people = ABAddressBookCopyArrayOfAllPeople(addressBookRef).takeRetainedValue() as NSArray as [ABRecord]
        
        for person in people
        {
            
            
            let dict = NSMutableDictionary()
            let fullname = "\(ABRecordCopyCompositeName(person).takeRetainedValue())"
            dict["full_name"] = fullname
            
            if readPhoneForPerson(person) != ""
            {
                dict["mobile"] = readPhoneForPerson(person)
            }
            
            
            let emails: ABMultiValueRef = ABRecordCopyValue(person, kABPersonEmailProperty).takeRetainedValue() as ABMultiValueRef
            if ABMultiValueGetCount(emails) > 0 {
                let email = ABMultiValueCopyValueAtIndex(emails, 0).takeRetainedValue() as! String
                dict["email"] = email
            }
            
            if (ABPersonHasImageData(person)) {
                let imgData = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatOriginalSize).takeRetainedValue()
                let image = UIImage(data: imgData)
                dict["profile"] = image
            }
            arr_contact.addObject(dict)
        }
        
        tbl_contact.reloadData()
        
    }
    
    
    func readPhoneForPerson(person: ABRecordRef) -> String
    {
        
        var string_email = ""
        
        let emails: ABMultiValueRef = ABRecordCopyValue(person,
                                                        kABPersonPhoneProperty).takeRetainedValue()
        
        for counter in 0..<ABMultiValueGetCount(emails){
            
            let email = ABMultiValueCopyValueAtIndex(emails,
                                                     counter).takeRetainedValue() as! String
            string_email = email
        }
        
        
        return string_email
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearchActive
        {
            return arr_contact_filter.count
        }else{
            return arr_contact.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : DataCell = tableView.dequeueReusableCellWithIdentifier("DataCell") as! DataCell
        
        var dict = NSMutableDictionary()
        
        if isSearchActive
        {
            dict = arr_contact_filter[indexPath.row] as! NSMutableDictionary
        }else
        {
            dict = arr_contact[indexPath.row] as! NSMutableDictionary
        }
        
        cell.lbl_name.text = dict["full_name"] as? String
        cell.lbl_number.text = dict["mobile"] as? String
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var dict = NSMutableDictionary()
        
        if isSearchActive
        {
            dict = arr_contact_filter[indexPath.row] as! NSMutableDictionary
        }else
        {
            dict = arr_contact[indexPath.row] as! NSMutableDictionary
        }
        
        
        if let value = dict["full_name"] as? String
        {
            DataSelect.lbl_name = value
        }else
        {
            DataSelect.lbl_name = ""
        }
        
        if let value = dict["mobile"] as? String
        {
            DataSelect.lbl_number = value
        }else
        {
            DataSelect.lbl_number = ""
        }
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        isSearchActive = false
        searchBar.resignFirstResponder()
        tbl_contact.reloadData()
    }
    
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        isSearchActive = true
        return true
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        isSearchActive = true
        searchBar.resignFirstResponder()
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        isSearchActive = true
        
        arr_contact_filter.removeAllObjects()
        
        
        for i in arr_contact
        {
            
            var flag = false
            if let value = i["full_name"] as? String
            {
                if value.lowercaseString.containsString(searchText.lowercaseString)
                {
                    flag = true
                }
            }
            
            if let value = i["mobile"] as? String
            {
                if value.lowercaseString.containsString(searchText.lowercaseString)
                {
                    flag = true
                }
            }
            
            
            if flag
            {
                arr_contact_filter.addObject(i)
            }
        }
        
        
        tbl_contact.reloadData()
    }
    
    
    
    
    
    
    
    
    @IBOutlet var tbl_contact : UITableView!
    var arr_contact = NSMutableArray()
    var arr_contact_filter = NSMutableArray()
    var isSearchActive = false
    let addressBookRef: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
}




class DataCell : UITableViewCell
{
    @IBOutlet var lbl_name : UILabel!
    @IBOutlet var lbl_number : UILabel!
}