//
//  ViewController.swift
//  IDentitySample
//
//  Created by Stefan Kaczmarek on 8/29/21.
//

import UIKit
import IDentitySDK_Swift
import IDCapture_Swift
import SelfieCapture_Swift
import SwiftyJSON

extension AdditionalCustomerWFlagCommonData {
    init(serviceOptions options: ServiceOptions) {
        let manualReviewRequired: AdditionalCustomerWFlagCommonData.ManualReviewRequired
        switch options.manualReviewRequired {
        case .yes: manualReviewRequired = .yes
        case .no: manualReviewRequired = .no
        case .forced: manualReviewRequired = .forced
        }

        self = AdditionalCustomerWFlagCommonData(manualReviewRequired: manualReviewRequired,
                                                 bypassAgeValidation: options.bypassAgeValidation ? .yes : .no,
                                                 deDuplicationRequired: options.deDuplicationRequired ? .yes : .no,
                                                 bypassNameMatching: options.bypassNameMatching ? .yes : .no,
                                                 postDataAPIRequired: options.postDataAPIRequired ? .yes : .no,
                                                 sendInputImagesInPost: options.sendInputImagesInPost ? .yes : .no,
                                                 sendProcessedImagesInPost: options.sendProcessedImagesInPost ? .yes : .no,
                                                 needImmediateResponse: options.needImmediateResponse ? .yes : .no,
                                                 deduplicationSynchronous: options.deduplicationSynchronous ? .yes : .no,
                                                 verifyDataWithHost: options.verifyDataWithHost ? .yes : .no,
                                                 idBackImageRequired: options.idBackImageRequired ? .yes : .no,
                                                 stripSpecialCharacters: options.stripSpecialCharacters ? .yes : .no)
    }
}

extension AdditionalCustomerEnrollBiometricRequestData {
    init(serviceOptions options: ServiceOptions) {
        self = AdditionalCustomerEnrollBiometricRequestData(needImmediateResponse: options.needImmediateResponse ? .yes : .no,
                                                            deDuplicationRequired: options.deDuplicationRequired ? .yes : .no)
    }
}

extension JSON {
    mutating func merge(other: JSON) {
        if self.type == other.type {
            switch self.type {
                case .dictionary:
                    for (key, _) in other {
                        self[key].merge(other: other[key])
                    }
                case .array:
                    self = JSON(self.arrayValue + other.arrayValue)
                default:
                    self = other
            }
        } else {
            self = other
        }
    }

    func merged(other: JSON) -> JSON {
        var merged = self
        merged.merge(other: other)
        return merged
    }
}

var validateIdResult2: ValidateIdResult?                             // 20
var validateIdMatchFaceResult2: ValidateIdMatchFaceResult?           // 10
var customerEnrollResult2: CustomerEnrollResult?                     // 50
var customerEnrollBiometricsResult2: CustomerEnrollBiometricsResult? // 175
var customerVerificationResult2: CustomerVerificationResult?         // 105
var customerIdentifyResult2: CustomerIdentifyResult?                 // 185
var liveFaceCheckResult2: LiveFaceCheckResult?                       // 660

class ViewController: UIViewController {
    var texts: String!
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - IBAction Methods

    // 20 - ID Validation
    func startIDValidation(instance: UIViewController) {
        // start ID capture, presenting it from this view controller
      let options = AdditionalCustomerWFlagCommonData(serviceOptions: UserDefaults.serviceOptions)
      IDentitySDK.idValidation(from: instance, options: options) { result in
          switch result {
          case .success(let validateIdResult):
            self.emptyResults()
            validateIdResult2 = validateIdResult
            let successViewController = SuccessViewController()
            successViewController.validateIdResult = validateIdResult
            successViewController.frontDetectedData = validateIdResult.front
            successViewController.backDetectedData = validateIdResult.back
            let navigationController = UINavigationController(rootViewController: successViewController)
            instance.present(navigationController, animated: true)
          case .failure(let error):
            print(error.localizedDescription)
            self.sendData(text: error.localizedDescription)
          }
      }
    }
  
    // 10 - ID Validation and Match Face
    func startIDValidationAndMatchFace(instance: UIViewController) {
        let options = AdditionalCustomerWFlagCommonData(serviceOptions: UserDefaults.serviceOptions)
        IDentitySDK.idValidationAndMatchFace(from: instance, options: options) { result in
            switch result {
            case .success(let validateIdMatchFaceResult):
              self.emptyResults()
              validateIdMatchFaceResult2=validateIdMatchFaceResult
              let successViewController = SuccessViewController()
              successViewController.validateIdMatchFaceResult = validateIdMatchFaceResult
              successViewController.frontDetectedData = validateIdMatchFaceResult.front
              successViewController.backDetectedData = validateIdMatchFaceResult.back
              let navigationController = UINavigationController(rootViewController: successViewController)
              instance.present(navigationController, animated: true)
            case .failure(let error):
              print(error.localizedDescription)
              self.sendData(text: error.localizedDescription)
            }
        }
    }

    // 50 - ID Validation And Customer Enroll
      func startIDValidationAndCustomerEnroll(uniqueNumber: String, instance: UIViewController) {
          let personalData = PersonalCustomerCommonRequestData(uniqueNumber: uniqueNumber)
          let options = AdditionalCustomerWFlagCommonData(serviceOptions: UserDefaults.serviceOptions)
          IDentitySDK.idValidationAndCustomerEnroll(from: instance, personalData: personalData, options: options) { result in
              switch result {
              case .success(let customerEnrollResult):
                self.emptyResults()
                customerEnrollResult2=customerEnrollResult
                let successViewController = SuccessViewController()
                // set the customer's unique number
                successViewController.customerEnrollResult = customerEnrollResult
                successViewController.frontDetectedData = customerEnrollResult.front
                successViewController.backDetectedData = customerEnrollResult.back
                let navigationController = UINavigationController(rootViewController: successViewController)
                instance.present(navigationController, animated: true, completion: nil)
              case .failure(let error):
                  print(error.localizedDescription)
                  self.sendData(text: error.localizedDescription)
              }
          }
      }
  
    // 175 - Customer Enroll Biometrics
    func startCustomerEnrollBiometrics(uniqueNumber: String, instance: UIViewController) {
        let personalData = PersonalCustomerCommonRequestData(uniqueNumber: uniqueNumber)
        let options = AdditionalCustomerEnrollBiometricRequestData(serviceOptions: UserDefaults.serviceOptions)
        IDentitySDK.customerEnrollBiometrics(from: instance, personalData: personalData, options: options) { result in
            switch result {
            case .success(let customerEnrollBiometricsResult):
                self.emptyResults()
                customerEnrollBiometricsResult2=customerEnrollBiometricsResult
                // pass the API request to the success view controller
                let successViewController = SuccessViewController()
                successViewController.customerEnrollBiometricsResult = customerEnrollBiometricsResult
                let navigationController = UINavigationController(rootViewController: successViewController)
                instance.present(navigationController, animated: true, completion: nil)
            case .failure(let error):
                print(error.localizedDescription)
                self.sendData(text: error.localizedDescription)
            }
        }
    }

    // 105 - Customer Verification
    func startCustomerVerification(uniqueNumber: String, instance: UIViewController) {
        let personalData = PersonalCustomerVerifyData(uniqueNumber: uniqueNumber)
        IDentitySDK.customerVerification(from: instance, personalData: personalData) { result in
            switch result {
            case .success(let customerVerificationResult):
                self.emptyResults()
                customerVerificationResult2=customerVerificationResult
                // pass the API request to the success view controller
                let successViewController = SuccessViewController()
                successViewController.customerVerificationResult = customerVerificationResult
                let navigationController = UINavigationController(rootViewController: successViewController)
                instance.present(navigationController, animated: true, completion: nil)
            case .failure(let error):
                print(error.localizedDescription)
                self.sendData(text: error.localizedDescription)
            }
        }
    }

    // 185 - Identify Customer
    func startIdentifyCustomer(instance: UIViewController) {
        IDentitySDK.identifyCustomer(from: instance) { result in
            switch result {
            case .success(let customerIdentifyResult):
                    self.emptyResults()
                    customerIdentifyResult2=customerIdentifyResult
                    // pass the API request to the success view controller
                    let successViewController = SuccessViewController()
                    successViewController.customerIdentifyResult = customerIdentifyResult
                    let navigationController = UINavigationController(rootViewController: successViewController)
                    instance.present(navigationController, animated: true, completion: nil)
            case .failure(let error):
                print(error.localizedDescription)
                self.sendData(text: error.localizedDescription)
            }
        }
    }

    // 660 - Live Face Check
    func startLiveFaceCheck(instance: UIViewController) {
        // start selfie capture, presenting it from this view controller
        IDentitySDK.liveFaceCheck(from: instance) { result in
            switch result {
            case .success(let liveFaceCheckResult):
                    self.emptyResults()
                    liveFaceCheckResult2=liveFaceCheckResult
                    // pass the API request to the success view controller
                    let successViewController = SuccessViewController()
                    successViewController.liveFaceCheckResult = liveFaceCheckResult
                    let navigationController = UINavigationController(rootViewController: successViewController)
                    instance.present(navigationController, animated: true, completion: nil)
            case .failure(let error):
                print(error.localizedDescription)
                self.sendData(text: error.localizedDescription)
            }
        }
    }

    func submitResult(instance: UIViewController) {
      submit()
    }

    @objc func submit() {
        if let validateIdResult = validateIdResult2 {
            validateIdResult.submit { result, hostData in
                self.navigationItem.leftBarButtonItem = nil
                validateIdResult2 = nil
                switch result {
                case .success(let response):
                   var hostDataString = ""
                   var hostDataJson: JSON = [] 
                    if let hostData = hostData,
                       let data = try? JSONSerialization.data(withJSONObject: hostData, options: [.prettyPrinted]),
                       let json = String(data: data, encoding: .utf8) {
                        hostDataJson = JSON(hostData)   
                        hostDataString = json
                    }

                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted
                    if let data = try? encoder.encode(response), let json = String(data: data, encoding: .utf8) {
                      let responseJson = JSON(data)  
                      if((hostDataString) != ""){
                        self.texts = responseJson.merged(other: hostDataJson).rawString()
                      }else{
                        self.texts = responseJson.rawString()
                      }
                    }
                    self.sendData()
                case .failure(let error):
                    self.texts = error.localizedDescription
                    self.sendData()
                }
            }
        } else if let validateIdMatchFaceResult = validateIdMatchFaceResult2 {
            validateIdMatchFaceResult.submit { result, hostData in
                self.navigationItem.leftBarButtonItem = nil
                validateIdMatchFaceResult2 = nil
                switch result {
                case .success(let response):
                    var hostDataString = ""
                    var hostDataJson: JSON = [] 
                    if let hostData = hostData,
                       let data = try? JSONSerialization.data(withJSONObject: hostData, options: [.prettyPrinted]),
                       let json = String(data: data, encoding: .utf8) {
                        hostDataJson = JSON(hostData)   
                        hostDataString = json
                    }

                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted
                    if let data = try? encoder.encode(response), let json = String(data: data, encoding: .utf8) {
                      let responseJson = JSON(data)  
                      if((hostDataString) != ""){
                        self.texts = responseJson.merged(other: hostDataJson).rawString()
                      }else{
                        self.texts = responseJson.rawString()
                      }
                    }
                    self.sendData()
                case .failure(let error):
                    self.texts = error.localizedDescription
                    self.sendData()
                }
            }
        } else if let customerEnrollResult = customerEnrollResult2 {
            customerEnrollResult.submit { result, hostData in
                self.navigationItem.leftBarButtonItem = nil
                customerEnrollResult2 = nil
                switch result {
                case .success(let response):
                    var hostDataString = ""
                    var hostDataJson: JSON = [] 
                    if let hostData = hostData,
                       let data = try? JSONSerialization.data(withJSONObject: hostData, options: [.prettyPrinted]),
                       let json = String(data: data, encoding: .utf8) {
                        hostDataJson = JSON(hostData)   
                        hostDataString = json
                    }

                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted
                    if let data = try? encoder.encode(response), let json = String(data: data, encoding: .utf8) {
                      let responseJson = JSON(data)  
                      if((hostDataString) != ""){
                        self.texts = responseJson.merged(other: hostDataJson).rawString()
                      }else{
                        self.texts = responseJson.rawString()
                      }
                    }
                    self.sendData()
                case .failure(let error):
                    self.texts = error.localizedDescription
                    self.sendData()
                }
            }
        } else if let customerEnrollBiometricsResult = customerEnrollBiometricsResult2 {
            customerEnrollBiometricsResult.submit { result in
                self.navigationItem.leftBarButtonItem = nil
                customerEnrollBiometricsResult2 = nil
                switch result {
                case .success(let response):
                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted
                    if let data = try? encoder.encode(response), let json = String(data: data, encoding: .utf8) {
                        self.texts = json
                    }
                    self.sendData()
                case .failure(let error):
                    self.texts = error.localizedDescription
                    self.sendData()
                }
            }
        } else if let customerVerificationResult = customerVerificationResult2 {
            customerVerificationResult.submit { result in
                self.navigationItem.leftBarButtonItem = nil
                customerVerificationResult2 = nil
                switch result {
                case .success(var response):
                    // stub out the base64 image text for logging
                    response.responseCustomerVerifyData?.extractedPersonalData?.enrolledFaceImage = "..."

                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted
                    if let data = try? encoder.encode(response), let json = String(data: data, encoding: .utf8) {
                        self.texts = json
                    }
                    self.sendData()
                case .failure(let error):
                    self.texts = error.localizedDescription
                    self.sendData()
                }
            }
        } else if let customerIdentifyResult = customerIdentifyResult2 {
            customerIdentifyResult.submit { result in
                self.navigationItem.leftBarButtonItem = nil
                customerIdentifyResult2 = nil
                switch result {
                case .success(var response):
                    // stub out the base64 image text for logging
                    response.responseCustomerData?.extractedPersonalData?.enrolledFaceImage = "..."

                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted
                    if let data = try? encoder.encode(response), let json = String(data: data, encoding: .utf8) {
                        self.texts = json
                    }
                    self.sendData()
                case .failure(let error):
                    self.texts = error.localizedDescription
                    self.sendData()
                }
            }
        } else if let liveFaceCheckResult = liveFaceCheckResult2 {
            liveFaceCheckResult.submit { result in
                self.navigationItem.leftBarButtonItem = nil
                liveFaceCheckResult2 = nil
                switch result {
                case .success(let response):
                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted
                    if let data = try? encoder.encode(response), let json = String(data: data, encoding: .utf8) {
                        self.texts = json
                    }
                    self.sendData()
                case .failure(let error):
                    self.texts = error.localizedDescription
                    self.sendData()
                }
            }
        }
    }
  
    private func sendData() {
      let dict2:NSMutableDictionary? = ["data" : self.texts ?? ["data" : "error"]]
      let iDMissionSDK = IDMissionSDK()
      iDMissionSDK.getEvent2("DataCallback", dict: dict2 ?? ["data" : "error"])
    }
  
    private func sendData(text: String) {
      let dict2:NSMutableDictionary? = ["data" : text ]
      let iDMissionSDK = IDMissionSDK()
      iDMissionSDK.getEvent2("DataCallback", dict: dict2 ?? ["data" : "error"])
    }
  
    func emptyResults(){
      validateIdResult2 = nil
      validateIdMatchFaceResult2 = nil
      customerEnrollResult2 = nil
      customerEnrollBiometricsResult2 = nil
      customerVerificationResult2 = nil
      customerIdentifyResult2 = nil
      liveFaceCheckResult2 = nil
    }
}
