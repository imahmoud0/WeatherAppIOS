//
//  componentTests.swift
//  componentTests
//
//  Created by Mahmoud Ibrahmi on 18/08/2020.
//  Copyright © 2020 brahmi. All rights reserved.
//

import XCTest
@testable import component

class ComponentTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCheckWeatherAPI() {
        let longitude = 2.35
        let latitude  = 48.86
        let baseUrl = "http://api.openweathermap.org/data/2.5/onecall?"
        let apiKey = "&appid=67518cb5c876f706e3c1640cb3e38628"
        let unitsLang  = "&units=metric&lang=en"
        
        let expectation = XCTestExpectation.init(description: "call api")
        let url = "\(baseUrl)lat=\(latitude)&lon=\(longitude)\(apiKey)\(unitsLang)"
        guard let requestURL = URL(string: url) else { return }
        Service.shared.getData(requestURL, callback: { weather, err in
            guard err == nil else {
                XCTFail("Fail")
                return
            }
            XCTAssertNil(err, "Error should be nil")
            XCTAssertEqual(weather.lon, longitude)
            XCTAssertEqual(weather.lat, latitude)
            
            // The request is finished, so our expectation
            expectation.fulfill()
        })
        
         // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
         wait(for: [expectation], timeout: 10.0)
    }

}
