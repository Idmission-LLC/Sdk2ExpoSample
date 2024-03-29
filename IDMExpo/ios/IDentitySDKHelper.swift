//
//  IDentitySDKHelper.swift
//  IDMTest
//
//  Created by Pranjal Lamba on 29/11/21.
//

import Foundation
import IDentitySDK_Swift
import IDCapture_Swift
import SelfieCapture_Swift

class IDentitySDKHelper : NSObject{
  
  @IBAction func initializeSDK(data: NSDictionary, instances: UIViewController) {
    
    let initialize_url:String = data["initialize_url"] as! String
    let url:String = data["url"] as! String
    let loginId:String = data["loginId"] as! String
    let password:String = data["password"] as! String
    let merchantId:String = data["merchantId"] as! String
    
    if initialize_url.isEmpty {
      IDentitySDK.templateModelBaseURL = UserDefaults.templateModelBaseURL
    }else{
      IDentitySDK.templateModelBaseURL = initialize_url + "IDS/service/"
    }
    
    if url.isEmpty {
      IDentitySDK.apiBaseURL = UserDefaults.apiBaseURL
    }else{
      IDentitySDK.apiBaseURL = url + "v2/"
    }

    var LoginId:String
    if loginId.isEmpty {
      LoginId = UserDefaults.loginId
    }else{
      LoginId = loginId
    }
    
    var Password:String
    if password.isEmpty {
      Password = UserDefaults.password
    }else{
      Password = password
    }
    
    var MerchantId:String
    if merchantId.isEmpty {
      MerchantId = UserDefaults.merchantId
    }else{
      MerchantId = merchantId
    }
    
    IDentitySDK.pluginName = "Expo_Wrapper"
    
    IDentitySDK.initializeSDK(loginId: LoginId, password: Password, merchantId: MerchantId) { error in
        if let error = error {
          print(error.localizedDescription)
          self.sendData(text: error.localizedDescription)
        } else {
          print("Success")
          self.sendData(text: "Success")
        }
    }
  }
  
  // 20 - ID Validation
  @IBAction func startIDValidations(instances: UIViewController) {
    ViewController().startIDValidation(instance: instances);
  }
 
  // 10 - ID Validation and Match Face
  @IBAction func startIDValidationAndMatchFaces(instances: UIViewController) {
    ViewController().startIDValidationAndMatchFace(instance: instances);
  }
  
  // 50 - ID Validation And Customer Enroll
  @IBAction func startIDValidationAndCustomerEnrolls(uniqueNumbers: String, instances: UIViewController) {
    ViewController().startIDValidationAndCustomerEnroll(uniqueNumber: uniqueNumbers, instance: instances);
  }
  
  // 175 - Customer Enroll Biometrics
  @IBAction func startCustomerEnrollBiometricss(uniqueNumbers: String, instances: UIViewController) {
    ViewController().startCustomerEnrollBiometrics(uniqueNumber: uniqueNumbers, instance: instances);
  }
  
  // 105 - Customer Verification
  @IBAction func startCustomerVerifications(uniqueNumbers: String, instances: UIViewController) {
    ViewController().startCustomerVerification(uniqueNumber: uniqueNumbers, instance: instances);
  }
  
  // 185 - Identify Customer
  @IBAction func startIdentifyCustomers(instances: UIViewController) {
    ViewController().startIdentifyCustomer(instance: instances);
  }
  
  // 660 - Live Face Check
  @IBAction func startLiveFaceChecks(instances: UIViewController) {
    ViewController().startLiveFaceCheck(instance: instances);
  }
  
  // Submit Result
  @IBAction func submitResult(instances: UIViewController) {
    ViewController().submitResult(instance: instances);
  }
  
  private func sendData(text: String) {
    let dict2:NSMutableDictionary? = ["data" : text ]
    let iDMissionSDK = IDMissionSDK()
    iDMissionSDK.getEvent2("DataCallback", dict: dict2 ?? ["data" : "error"])
  }
}
