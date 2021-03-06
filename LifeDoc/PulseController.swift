//
//  PulseContoller.swift
//  LifeDoc
//
//  Created by Andrew Cameron on 2016/12/12.
//  Copyright © 2016 MediSwitch. All rights reserved.
//

import UIKit
import Material
import Alamofire
import Toast_Swift

class PulseContoller: UIViewController, WWCalendarTimeSelectorProtocol  {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var sDate: ErrorTextField!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var sTime: ErrorTextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var hideButton: UIButton!
    @IBOutlet weak var pulse: ErrorTextField!
    @IBOutlet weak var sCalendar: UIButton!
    fileprivate var singleDate: Date = Date()
    fileprivate var multipleDates: [Date] = []
    var messageStr : String = String()
    var idPulse : String = String()
    var NewDate : Bool = Bool()
    var NewTime : Bool = Bool()
    var hideBool : Bool = Bool()
    var fields : Array<String> = Array()
    var add : Array<String> = Array()
    var hideImage : Bool = Bool()
    var deletedList : Array<String> = Array()
    var editDateTime = ""
    var editTime = ""
    var editDate = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PulseContoller.dismissKeyboard))
   
        view.addGestureRecognizer(tap)
        
        view.addSubview(scrollView)
        
        self.navItem.title = "Edit Pulse"
        idPulse = "0"
        
        
        NewDate = false
        NewTime = false
        hideBool = false
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "singleMeasurement") != nil){
            loadDataSingle()
            
            if (prefs.string(forKey: "isHiddenValue") != nil && prefs.string(forKey: "isHiddenValue") == "true"){
                
                hideImage = true
                
                
            }else{
                hideImage = false
                
            }
            
            if (prefs.string(forKey: "dateValue") != nil){
                
                editDateTime = prefs.string(forKey: "dateValue")!
                var myStringArr = editDateTime.components(separatedBy: " ")
                
                
                editDate = myStringArr [0]
                editTime = myStringArr [1]
                
                
            }
            
        }
        
        
        prepareCloseButton()
        prepareCalendarButton()
        prepareSaveButton()
        prepareHideButton()
        prepareDeleteButton()
        prepareTime()
        prepareDate()
        preparePulse()
        prepareDateView()
        prepareTimeView()
        
    }
    
    public func loadJSONSingle() -> JSON {
        let prefs = UserDefaults.standard
        
        if (prefs.string(forKey: "singleMeasurement") != nil){
            
            return JSON.parse(prefs.string(forKey: "singleMeasurement")!)
        }else{
            return nil
        }
        
    }
    
    
    func loadDataSingle(){
        
        let json = self.loadJSONSingle()
        
        
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "singleMeasurement") != nil){
            
            
            pulse.isEnabled = false
            
            
            for (_, object) in json {
                
                
                
                if (object["type"].stringValue == "Pulse rate resting") {
                    
                    let newString = object["value"].stringValue.replacingOccurrences(of: ".", with: ",")
                    pulse.text = newString
                    idPulse = object["id"].stringValue
                    pulse.isEnabled = true
                    deletedList.append(object["id"].stringValue)
                    
                }
                
                
                
                
            }
        }
        
        
    }
    
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize(width: 300, height: 600)
    }
    
    private func prepareCloseButton() {
        
        let leftNavItem = closeButton
        leftNavItem?.action = #selector(PulseContoller.buttonTapActionClose)
        
        
    }
    
    func showDatePicker() {
        
        NewDate = true
        NewTime = false
        showCal()
    }
    
    func showTimePicker() {
        
        NewTime = true
        NewDate = false
        showTime()
    }
    
    
    private func prepareDateView() {
        
        let tapDateView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CholesterolController.showDatePicker))
        dateView.addGestureRecognizer(tapDateView)
    }
    
    private func prepareTimeView() {
        
        let tapTimeView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CholesterolController.showTimePicker))
        timeView.addGestureRecognizer(tapTimeView)
    }
    
    
    private func prepareCalendarButton() {
        sCalendar.addTarget(self, action: #selector(buttonCalendarAction), for: .touchUpInside)
        
    }
    
    func buttonCalendarAction(sender: UIButton!) {
        print("Button tapped")
        NewDate = true
        NewTime = false
        showCal()
    }
    
    
    
    func buttonTapActionClose() {
        print("Button tapped")
        
        self.dismiss(animated: true, completion: nil)
        
        
        
        
    }
    
    
    private func prepareDate() {
        
        sDate.placeholder = "Date"
        sDate.resignFirstResponder()
        sDate.detailLabel.numberOfLines = 0
        sDate.delegate = self
        sDate.addTarget(self, action: #selector(myTargetFunctionDate), for: UIControlEvents.touchDown)
        let dateToday = Date()
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "singleMeasurement") != nil){
            sDate.text = editDate
        }else{
            sDate.text = dateToday.stringFromFormat("dd-MM-yyyy")
        }
        
        
        
    }
    
    private func prepareTime() {
        
        sTime.placeholder = "Time"
        
        sTime.detailLabel.numberOfLines = 0
        sTime.resignFirstResponder()
        
        sTime.delegate = self
        
        sTime.addTarget(self, action: #selector(myTargetFunction), for: UIControlEvents.touchDown)
        
        let dateToday = Date()
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "singleMeasurement") != nil){
            sTime.text = editTime
        }else{
            sTime.text = dateToday.stringFromFormat("HH:mm")
        }
        
        
        
        
        
    }
    
    func myTargetFunction(textField: UITextField) {
        NewTime = true
        showTime()
    }
    func myTargetFunctionDate(textField: UITextField) {
        NewDate = true
        showCal()
    }
    private func preparePulse() {
        
        pulse.placeholder = "Pulse rate resting (Beats/min)"
        pulse.detail = Constants.err_msg_Pulse
        pulse.isClearIconButtonEnabled = true
        
        pulse.detailLabel.numberOfLines = 0
        
        
        pulse.delegate = self
        
        pulse.addTarget(self,action: #selector(textFieldDidChangepulse),for: UIControlEvents.editingDidEnd)
        pulse.addTarget(self,action: #selector(textFieldDidChangepulseLength),for: UIControlEvents.editingChanged)
        
    }
    
    func textFieldDidChangepulse(textField: UITextField) {
        
        let Str: String = pulse.text!
        if(!Str.isEmpty){
            
            if(!validateValue(testStr: Str)){
                
                pulse.isErrorRevealed = true
                pulse.detail = Constants.err_msg_Pulse
            }else if(!validateValueDecimal(testStr: Str)){
                pulse.isErrorRevealed = true
                pulse.detail = Constants.err_msg_two_decimal
                
            }
            else{
                pulse.isErrorRevealed = false
                
            }
        }else{
            pulse.isErrorRevealed = false
            
        }
        
        
        
    }
    
    func textFieldDidChangepulseLength(textField: UITextField) {
        
        
        checkMaxLength(textField: pulse,maxLength: 6)
        
    }
    
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if (pulse.text!.characters.count > maxLength) {
            pulse.deleteBackward()
        }
    }
    
    
    
    
    
    
    
    private func prepareSaveButton() {
        
        let rightNavItem = saveButton
        rightNavItem?.action = #selector(HeightContoller.buttonTapAction)
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "singleMeasurement") != nil){
            rightNavItem?.title = "Apply"
        }
        
    }
    
    private func prepareHideButton() {
        
        hideButton.isHidden = false
        hideButton.addTarget(self, action: #selector(buttonHideAction), for: .touchUpInside)
        if(hideImage == false){
            let image = UIImage(named: "blue_unhide") as UIImage?
            hideButton.setBackgroundImage(image, for: .normal)
            hideBool = false
            
        }else if (hideImage == true){
            let image = UIImage(named: "blue_hide") as UIImage?
            hideButton.setBackgroundImage(image, for: .normal)
            hideBool = true
        }
        
        
    }
    
    
    
    func buttonHideAction(sender: UIButton!) {
        print("Button tapped")
        if(hideBool == false){
            let image = UIImage(named: "blue_hide") as UIImage?
            hideButton.setBackgroundImage(image, for: .normal)
            hideBool = true
            self.view.makeToast("Record has been hidden, please apply to save", duration: 3.0, position: .bottom)
            
        }else if (hideBool == true){
            let image = UIImage(named: "blue_unhide") as UIImage?
            hideButton.setBackgroundImage(image, for: .normal)
            hideBool = false
            self.view.makeToast("Record has been made visible, please apply to save", duration: 3.0, position: .bottom)
            
        }
    }
    
    
    func buttonDeleteAction(sender: UIButton!) {
        print("Button tapped")
        
        showAreYouSure()
        
    }
    
    func showAreYouSure() {
        let ac = UIAlertController(title: "Message", message: "Are you sure you wish to delete this information?", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default)
        { action -> Void in
            
            
        })
        ac.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default)
        { action -> Void in
            
            self.deleteRecord()
        })
        present(ac, animated: true)
    }
    
    
    
    
    private func prepareDeleteButton() {
        
        let prefs = UserDefaults.standard
        if (prefs.string(forKey: "singleMeasurement") != nil) {
            deleteButton.isHidden = false
        }else{
            deleteButton.isHidden = true
        }
        
        
        deleteButton.addTarget(self, action: #selector(buttonDeleteAction), for: .touchUpInside)
        
    }
    
    func buttonTapAction(sender: UIButton!) {
        print("Button tapped")
        
        
        let str1: String = pulse.text!
        
        let dateToday = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let dateNow = sDate.text
        let TimeNow = sTime.text
        
        let dateTime = dateNow! + " " + TimeNow! + ":00"
        let date = dateFormatter.date(from: dateTime)
        
        if (date! > dateToday) {
            print("future time")
            
            
            self.view.makeToast("You cannot select a future time, please select a current or past time.", duration: 3.0, position: .bottom)
            return
        }
        
        
        if(str1.isEmpty || !validateValue(testStr: str1)){
            pulse.isErrorRevealed = true
            pulse.detail = Constants.err_msg_Pulse
            self.pulse.becomeFirstResponder()
            return
        }
        
        if(!validateValueDecimal(testStr: str1)){
            pulse.isErrorRevealed = true
            pulse.detail = Constants.err_msg_two_decimal
            self.pulse.becomeFirstResponder()
            return
        }
        
        fields.append("Pulse rate resting-" + pulse.text! + "-" + idPulse);
        
        
        
        sendHealthAssessment()
    }
    
    func showDate() {
        let ac = UIAlertController(title: "Message", message: "Please select your date of birth.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
    
    
    func validateValue(testStr:String) -> Bool {
        
        
        if (testStr.isEmpty) {
            return false
        }
        if (!isValidRange(testStr: testStr)) {
            return false
        }
        return true
    }
    
    
    
    func validateValueDecimal(testStr:String) -> Bool {
        
        
        
        if (!isValidDecimal(testStr: testStr)) {
            return false
        }
        
        return true
    }
    
    
    
    
    func isValidRange(testStr:String) -> Bool {
        if (!isValidDecimal(testStr: testStr)) {
            return true
        }else{
            let formatter = NumberFormatter()
            let Svalue = formatter.number(from: (testStr as NSString) as String)
            let s:String = String(format:"%.2f", Svalue!.doubleValue)
            let myDouble = (s as NSString).doubleValue
            
            let valueNew = myDouble * 100
            
            
            if (valueNew  >= (10*100) && valueNew  <= (300*100)) {
                return true
            }
        }
        
        return false
    }
    
    
    
    
    func isValidDecimal(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let RegEx = "^[0-9]+(\\,[0-9]{1,2})?$"
        
        
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: testStr)
    }
    
    
    
    
    private func showCal() {
        
        singleDate = Date()
        
        let selector = UIStoryboard(name: "WWCalendarTimeSelector", bundle: nil).instantiateInitialViewController() as! WWCalendarTimeSelector
        selector.delegate = self
        selector.optionCurrentDate = singleDate
        selector.optionStyles.showDateMonth(true)
        selector.optionStyles.showMonth(false)
        selector.optionStyles.showYear(true)
        selector.optionStyles.showTime(false)
        selector.optionCalendarFontColorFutureDates = UIColor.lightGray
        
        
        
        
        /*
         Any other options are to be set before presenting selector!
         */
        present(selector, animated: true, completion: nil)
    }
    
    private func showTime() {
        
        singleDate = Date()
        
        let selector = UIStoryboard(name: "WWCalendarTimeSelector", bundle: nil).instantiateInitialViewController() as! WWCalendarTimeSelector
        selector.delegate = self
        selector.optionCurrentDate = singleDate
        selector.optionStyles.showDateMonth(false)
        selector.optionStyles.showMonth(false)
        selector.optionStyles.showYear(false)
        selector.optionStyles.showTime(true)
        
        
        
        
        /*
         Any other options are to be set before presenting selector!
         */
        present(selector, animated: true, completion: nil)
    }
    
    
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        print("Selected \n\(date)\n---")
        singleDate = date
        let dateToday = Date()
        
        if(NewDate == true){
            if date > dateToday {
                print("future date")
                
                self.view.makeToast("You cannot select a future date, please select a current or past date.", duration: 3.0, position: .bottom)
                
            }else{
                
                sDate.text = date.stringFromFormat("dd-MM-yyyy")
            }
        }
        if(NewTime == true){
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateNow = sDate.text
            
            let dateTime = dateFormatter.string(from: dateToday)
            
            if (date > dateToday && dateNow == dateTime) {
                print("future time")
                
                
                self.view.makeToast("You cannot select a future time, please select a current or past time.", duration: 3.0, position: .bottom)
                
            }else{
                
                sTime.text = date.stringFromFormat("HH:mm")
            }
            
        }
        
        NewDate = false
        NewTime = false
        
    }
    
    func showFutureDate() {
        let ac = UIAlertController(title: "Message", message: "You cannot select a future date, please select a current or past date.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    private func deleteRecord() {
        
        
        // get a reference to the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showActivityIndicator(uiView: self.view)
        
        deleteButton.isEnabled = false
        
        let urlString: String
        
        urlString = Constants.baseURL + "healthAssessments/remove"
        
        print(urlString)
        
        let prefs = UserDefaults.standard
        let loggedInUserDetailsId = prefs.integer(forKey: "loggedInUserDetailsId")
        let currentActiveUserDetailsId = prefs.integer(forKey: "currentActiveUserDetailsId")
        
        let authToken = prefs.string(forKey: "authToken")
        
        let parameters: Parameters = [
            "currentActiveUserDetailsId": currentActiveUserDetailsId,
            "loggedInUserDetailsId": loggedInUserDetailsId,
            "ids": deletedList
            
            
        ]
        
        print(parameters)
        
        let headers: HTTPHeaders = [
            "Authorization-Token": authToken!,
            "Accept": "application/json"
        ]
        
        
        //let sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
        //let delegate: Alamofire.SessionDelegate = sessionManager.delegate
        
        
        
        // Both calls are equivalent
        PulseContoller.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
            
            
            if let jsonResponse = response.result.value {
                //print("JSON: \(jsonResponse)")
                var json = JSON(jsonResponse)
                let status = json["status"]
                self.messageStr = json["message"].string!
                
                // let currentActiveuserDetailsId = json["currentActiveuserDetailsId"].string!
                
                
                if status == "SUCCESS"{
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    //appDelegate.hideActivityIndicator(uiView: self.view)
                    //self.showSuccess()
                    
                    appDelegate.gethealthAssessments()
                    //self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                    
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTable"), object: nil)
                    
                    let prefs = UserDefaults.standard
                    prefs.set(self.messageStr, forKey: "savedServerMessage")
                    
                    //Toast(text: self.messageStr, duration: Delay.long).show()
                    //self.dismiss(animated: true, completion: nil)
                    
                }else{
                    self.deleteButton.isEnabled = true
                    // get a reference to the app delegate
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.hideActivityIndicator(uiView: self.view)
                    self.showError()
                    
                }
                
            }
            if let error = response.result.error as? AFError{
                switch error {
                case .invalidURL(let url):
                    print("Invalid URL: \(url) - \(error.localizedDescription)")
                case .parameterEncodingFailed(let reason):
                    print("Parameter encoding failed: \(error.localizedDescription)")
                    print("Failure Reason: \(reason)")
                case .multipartEncodingFailed(let reason):
                    print("Multipart encoding failed: \(error.localizedDescription)")
                    print("Failure Reason: \(reason)")
                case .responseValidationFailed(let reason):
                    print("Response validation failed: \(error.localizedDescription)")
                    print("Failure Reason: \(reason)")
                    
                    switch reason {
                    case .dataFileNil, .dataFileReadFailed:
                        print("Downloaded file could not be read")
                    case .missingContentType(let acceptableContentTypes):
                        print("Content Type Missing: \(acceptableContentTypes)")
                    case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                        print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                    case .unacceptableStatusCode(let code):
                        print("Response status code was unacceptable: \(code)")
                    }
                case .responseSerializationFailed(let reason):
                    print("Response serialization failed: \(error.localizedDescription)")
                    print("Failure Reason: \(reason)")
                }
                
                print("Underlying error: \(error.underlyingError)")
            } else if let error = response.result.error as? URLError {
                print("URLError occurred: \(error)")
                self.deleteButton.isEnabled = true
                // get a reference to the app delegate
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.hideActivityIndicator(uiView: self.view)
                self.showNetworkError()
                
                
            } else {
                
                
                
            }
        }
        
        
    }
    
    private func sendHealthAssessment() {
        
        
        let strDate: String = sDate.text!
        let strTime: String = sTime.text!
        
        // get a reference to the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showActivityIndicator(uiView: self.view)
        
        saveButton.isEnabled = false
        
        
        let urlString: String
        
        urlString = Constants.baseURL + "healthAssessments"
        
        print(urlString)
        
        let dateAndTime = strDate + " " + strTime
        
        let prefs = UserDefaults.standard
        let loggedInUserDetailsId = prefs.integer(forKey: "loggedInUserDetailsId")
        let currentActiveUserDetailsId = prefs.integer(forKey: "currentActiveUserDetailsId")
        let authToken = prefs.string(forKey: "authToken")
        
        
        
        
        var savedFiles: [[String: AnyObject]] = []
        
        for i in 0 ..< fields.count  {
            
            var add : [String: String] = [:]
            
            let line = fields[i]
            let fullArr = line.components(separatedBy: "-")
            let name    = fullArr[0]
            let value = fullArr[1]
            let idd = fullArr[2]
            
            let formatter = NumberFormatter()
            let Svalue = formatter.number(from: value)
            
            
            let s:String = String(format:"%f", Svalue!.doubleValue)
            
            add["healthIndicatorElementName"] = name
            add["healthIndicatorValue"] = s
            add["UserResViewConditionId"] = idd
            
            
            savedFiles.append(add as [String : AnyObject])
            
            
        }
        
        
        let parameters: Parameters = [
            "records": savedFiles,
            "_hide": hideBool,
            "loggedInUserDetailsId": String(loggedInUserDetailsId),
            "currentActiveUserDetailsId": String(currentActiveUserDetailsId),
            "type": "Pulse",
            "dateAndTime": dateAndTime
        ]
        
        
        
        
        let headers: HTTPHeaders = [
            "Authorization-Token": authToken!,
            "Accept": "application/json",
            "Content-Type": "application/json"
            
        ]
        
        
        
        PulseContoller.Manager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            
            print(response)
            
            if let jsonResponse = response.result.value {
                //print("JSON: \(json)")
                var json = JSON(jsonResponse)
                let status = json["status"]
                self.messageStr = json["message"].string!
                
                
                if status == "SUCCESS"{
                    
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    //appDelegate.hideActivityIndicator(uiView: self.view)
                    //self.showSuccess()
                    
                    appDelegate.gethealthAssessments()
                    //self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                    
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTable"), object: nil)
                    
                    let prefs = UserDefaults.standard
                    prefs.set(self.messageStr, forKey: "savedServerMessage")
                    
                    //Toast(text: self.messageStr, duration: Delay.long).show()
                    //self.dismiss(animated: true, completion: nil)
                    
                    
                }else{
                    
                    self.saveButton.isEnabled = true
                    // get a reference to the app delegate
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.hideActivityIndicator(uiView: self.view)
                    self.showError()
                }
                
            }
            
            if let error = response.result.error  as? AFError {
                switch error {
                case .invalidURL(let url):
                    print("Invalid URL: \(url) - \(error.localizedDescription)")
                case .parameterEncodingFailed(let reason):
                    print("Parameter encoding failed: \(error.localizedDescription)")
                    print("Failure Reason: \(reason)")
                case .multipartEncodingFailed(let reason):
                    print("Multipart encoding failed: \(error.localizedDescription)")
                    print("Failure Reason: \(reason)")
                case .responseValidationFailed(let reason):
                    print("Response validation failed: \(error.localizedDescription)")
                    print("Failure Reason: \(reason)")
                    
                    switch reason {
                    case .dataFileNil, .dataFileReadFailed:
                        print("Downloaded file could not be read")
                    case .missingContentType(let acceptableContentTypes):
                        print("Content Type Missing: \(acceptableContentTypes)")
                    case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                        print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                    case .unacceptableStatusCode(let code):
                        print("Response status code was unacceptable: \(code)")
                    }
                case .responseSerializationFailed(let reason):
                    print("Response serialization failed: \(error.localizedDescription)")
                    print("Failure Reason: \(reason)")
                }
                
                print("Underlying error: \(error.underlyingError)")
            } else if let error = response.result.error  as? URLError {
                print("URLError occurred: \(error)")
                self.saveButton.isEnabled = true
                // get a reference to the app delegate
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.hideActivityIndicator(uiView: self.view)
                self.showNetworkError()
                
            } else {
                
                
                
                
            }
            
        }
        
        
    }
    
    
    
    private static var Manager: Alamofire.SessionManager = {
        
        // Create the server trust policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            Constants.appSSL: .disableEvaluation
        ]
        
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        
        return manager
    }()
    
    func showError() {
        let ac = UIAlertController(title: "Error", message: messageStr, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func showNetworkError() {
        let ac = UIAlertController(title: "Error", message:  "Your device is unable to connect,  Please check your device internet settings or contact 0800 695 433 (0800 My Life) for further assistance", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func showSuccess() {
        let ac = UIAlertController(title: "Success", message: messageStr, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        { action -> Void in
            self.dismissView()
        })
        present(ac, animated: true)
    }
    
    func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
}


extension PulseContoller: TextFieldDelegate {
    
    /// Executed when the 'return' key is pressed when using the emailField.
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //(textField as? ErrorTextField)?.isErrorRevealed = true
        view.endEditing(true)
        return true
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    public func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = false
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Create an `NSCharacterSet` set which includes everything *but* the digits
        
        if(sTime.isEditing){
            return false
        }else if(sDate.isEditing){
            return false
        }else{
            let inverseSet = NSCharacterSet(charactersIn:"0123456789,.").inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift
            
            return string == filtered
            
        }
        
        
    }
    
    public func textField(textField: UITextField, willClear text: String?) {
        print("will clear", text ?? "")
        
    }
    
    public func textField(textField: UITextField, didClear text: String?) {
        print("did clear", text ?? "")
        (textField as? ErrorTextField)?.isErrorRevealed = false
    }
    
    
}
