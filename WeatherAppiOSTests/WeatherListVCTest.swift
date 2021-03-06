//
//  WeatherListVCTest.swift
//  WeatherAppiOSTests
//
//  Created by Mahmoud Ibrahmi on 15/08/2020.
//  Copyright © 2020 brahmi. All rights reserved.
//

import XCTest
@testable import WeatherApp
@testable import component

class WeatherListVCTest: XCTestCase {
    
    let manager = Manager()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDownWithError() throws {
        super.tearDown()
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
    
    func testCheckLocalDataBaseIsEmpty() {
        let cities = manager.getTown()
        XCTAssertTrue(cities.isEmpty)
    }
    
    func testCheckLocalDataBaseNotEmpty() {
        let cities = manager.getTown()
        XCTAssertFalse(cities.isEmpty)
    }
    
    func testClearDataBase() {
        manager.clearAllTown()
    }
    
    func testGetCityParis() {
        let townName  = "Paris"
        let longitude = 2.3510768
        let latitude  = 48.8567879
        let cities = manager.getTown()
        
        for city in cities {
            XCTAssertEqual(townName, city.name)
            XCTAssertEqual(longitude, city.longitude)
            XCTAssertEqual(latitude, city.latitude)
        }
    }
    
    
    func testCheckWeatherAPI() {
        let longitude = 2.3510768
        let latitude  = 48.8567879
        let expectation = XCTestExpectation.init(description: "call api")
        let url = "\(Config.baseUrl)lat=\(latitude)&lon=\(longitude)\(Config.apiKey)\(Config.units)\(Config.units)"
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
        
    }
    
}
