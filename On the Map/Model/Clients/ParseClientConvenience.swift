//
//  ParseClientConvenience.swift
//  On the Map
//
//  Created by Bruno Barbosa on 23/02/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import Foundation

extension ParseClient {
    
    // MARK: (GET) StudentLocation
    
    func getStudentLocation(completion: @escaping (_ success: [StudentInformation]?, _ error: NSError?) -> Void) {
        let studentURL = baseURL(method: Methods.StudentLocation, parameters: nil)
        
        var request = URLRequest(url: studentURL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completion(nil, NSError(domain: "getStudentLocation", code: 1, userInfo: userInfo))
            }
            
            guard error == nil else {
                let errorMessage = NSLocalizedString("Request failed with error", comment: "")
                sendError(errorMessage)
                return
            }
            
            guard let data = data else {
                let errorMessage = NSLocalizedString("Request failed without response data", comment: "")
                sendError(errorMessage)
                return
            }
            
            let unexpectedErrorMessage = NSLocalizedString("Request failed with an unexpected error", comment: "")
            guard let response = response as? HTTPURLResponse, 200 ... 299 ~= response.statusCode else {
                sendError(unexpectedErrorMessage)
                return
            }
            
            let decoder = JSONDecoder()
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            
            decoder.dateDecodingStrategy = .formatted(formatter)
            
            struct StudentInformationResults: Codable {
                
                var results: [StudentInformation]?
            }
            
            do {
                let studentInformationResults = try decoder.decode(StudentInformationResults.self, from: data)
                completion(studentInformationResults.results, nil)
                
            } catch {
                sendError(unexpectedErrorMessage)
            }
        }
        
        task.resume()
    }
    
    // MARK: (POST) StudentLocation
    
    func postStudentLocation(studentLocation: StudentInformation, completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        let studentURL = baseURL(method: Methods.StudentLocation, parameters: nil)
        
        var request = URLRequest(url: studentURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let encoder = JSONEncoder()
        request.httpBody = try! encoder.encode(studentLocation)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(false, NSError(domain: "postStudentLocation", code: 1, userInfo: userInfo))
            }
            
            guard error == nil else {
                let errorMessage = NSLocalizedString("Request failed with error", comment: "")
                sendError(errorMessage)
                return
            }
            
            guard data != nil else {
                let errorMessage = NSLocalizedString("Request failed without response data", comment: "")
                sendError(errorMessage)
                return
            }
            
            let errorMessage = NSLocalizedString("Request failed with an unexpected error", comment: "")
            guard let response = response as? HTTPURLResponse, 200 ... 299 ~= response.statusCode else {
                sendError(errorMessage)
                return
            }
            
            if response.statusCode == 201 {
                completionHandler(true, nil)
            
            } else {
                sendError(errorMessage)
            }
        }
        
        task.resume()
    }
}
