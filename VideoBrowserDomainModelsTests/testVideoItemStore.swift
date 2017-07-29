//
//  testVideoItemStore.swift
//  VideoBrowserDomainModels
//
//  Created by James Honeyball on 29/07/2017.
//  Copyright © 2017 James Honeyball. All rights reserved.
//

import XCTest
@testable import VideoBrowserDomainModels
@testable import VideoBrowserDataSources

class testVideoItemStore: XCTestCase {

    

    
        var sutImageURLFromInt22: ImageURLDetails!
        var sutImageURLFromInt23: ImageURLDetails!
        var sutImageURLFromInt24: ImageURLDetails!
        var sutImageURLFromInt30: ImageURLDetails!
        var sutImageURLFromInt39: ImageURLDetails!
        
        var sutImageURLFromInts22and23: [ImageURLDetails]!
        var sutImageURLFromInts22and23and24: [ImageURLDetails]!
        var sutImageURLFromInts22and30and39: [ImageURLDetails]!
        
        var sutVideoDataItemWithURLsFromInts22n23: VideoDataItem!
        var sutVideoDataItemWithURLsFromInts22n23n24: VideoDataItem!
        var sutVideoDataItemWithURLsFromInts22n30n39: VideoDataItem!
        
        override func setUp() {
            super.setUp()
            
            sutImageURLFromInt22 = ImageURLDetails(url: "1st image url with res of 22", resolution: URLImageResolution(22))
            sutImageURLFromInt23 = ImageURLDetails(url: "2nd image url with res of 23", resolution: URLImageResolution(23))
            sutImageURLFromInt24 = ImageURLDetails(url: "3rd image url with res of 24", resolution: URLImageResolution(24))
            sutImageURLFromInt30 = ImageURLDetails(url: "3rd image url with res of 24", resolution: URLImageResolution(30))
            sutImageURLFromInt39 = ImageURLDetails(url: "3rd image url with res of 24", resolution: URLImageResolution(39))
            
            
            sutImageURLFromInts22and23 = [sutImageURLFromInt22, sutImageURLFromInt23]
            sutImageURLFromInts22and23and24 = [sutImageURLFromInt22, sutImageURLFromInt23, sutImageURLFromInt24]
            sutImageURLFromInts22and30and39 = [sutImageURLFromInt22, sutImageURLFromInt30, sutImageURLFromInt39]
            
            sutVideoDataItemWithURLsFromInts22n23 = VideoDataItemStruct(title: "The title",
                                                                        synopsis: "The synopsis",
                                                                        broadcastChannel: "The broadcast channel",
                                                                        imageURLs: sutImageURLFromInts22and23)
            sutVideoDataItemWithURLsFromInts22n23n24 = VideoDataItemStruct(title: "The next title",
                                                                           synopsis: "The next synopsis",
                                                                           broadcastChannel: "The next broadcast channel",
                                                                           imageURLs: sutImageURLFromInts22and23and24)
            sutVideoDataItemWithURLsFromInts22n30n39 = VideoDataItemStruct(title: "The other title",
                                                                           synopsis: "The other synopsis",
                                                                           broadcastChannel: "The other broadcast channel",
                                                                           imageURLs: sutImageURLFromInts22and30and39)
            
            
            
        }
        
        override func tearDown() {
            // Put teardown code here. This method is called after the invocation of each test method in the class.
            super.tearDown()
        }
        
        func test_getImageURL_withImages22n23_getLowerValue() {
            XCTAssertEqual(22, getBestImageURL(sutImageURLFromInts22and23, for: URLImageResolution(0)).resolution.pixels)
            XCTAssertEqual(22, getBestImageURL(sutImageURLFromInts22and23, for: URLImageResolution(21)).resolution.pixels)
            XCTAssertEqual(22, getBestImageURL(sutImageURLFromInts22and23, for: URLImageResolution(22)).resolution.pixels)
            }
        
        func test_getImageURL_withImages22n23_getHigherValue() {
            XCTAssertEqual(23, getBestImageURL(sutImageURLFromInts22and23, for: URLImageResolution(23)).resolution.pixels)
            XCTAssertEqual(23, getBestImageURL(sutImageURLFromInts22and23, for: URLImageResolution(24)).resolution.pixels)
            XCTAssertEqual(23, getBestImageURL(sutImageURLFromInts22and23, for: URLImageResolution(Int.max)).resolution.pixels)
        }
        
        func test_getImageURL_withImages22n23n24_getLowerValue() {
            XCTAssertEqual(22, getBestImageURL(sutImageURLFromInts22and23and24, for: URLImageResolution(0)).resolution.pixels)
            XCTAssertEqual(22, getBestImageURL(sutImageURLFromInts22and23and24, for: URLImageResolution(21)).resolution.pixels)
            XCTAssertEqual(22, getBestImageURL(sutImageURLFromInts22and23and24, for: URLImageResolution(22)).resolution.pixels)
        }
        
        func test_getImageURL_withImages22n23n24_getMiddleValue() {
            XCTAssertEqual(23, getBestImageURL(sutImageURLFromInts22and23and24, for: URLImageResolution(23)).resolution.pixels)
        }
        
        func test_getImageURL_withImages22n23n24_getHigherValue() {
            XCTAssertEqual(24, getBestImageURL(sutImageURLFromInts22and23and24, for: URLImageResolution(24)).resolution.pixels)
            XCTAssertEqual(24, getBestImageURL(sutImageURLFromInts22and23and24, for: URLImageResolution(25)).resolution.pixels)
            XCTAssertEqual(24, getBestImageURL(sutImageURLFromInts22and23and24, for: URLImageResolution(Int.max)).resolution.pixels)
        }
        
        func test_getImageURL_withImages22n30n39_dontResLessThanRequested() {
            XCTAssertEqual(22, getBestImageURL(sutImageURLFromInts22and30and39, for: URLImageResolution(0)).resolution.pixels)
            XCTAssertEqual(22, getBestImageURL(sutImageURLFromInts22and30and39, for: URLImageResolution(22)).resolution.pixels)
            XCTAssertEqual(30, getBestImageURL(sutImageURLFromInts22and30and39, for: URLImageResolution(23)).resolution.pixels)
            XCTAssertEqual(30, getBestImageURL(sutImageURLFromInts22and30and39, for: URLImageResolution(29)).resolution.pixels)
            XCTAssertEqual(30, getBestImageURL(sutImageURLFromInts22and30and39, for: URLImageResolution(30)).resolution.pixels)
            XCTAssertEqual(39, getBestImageURL(sutImageURLFromInts22and30and39, for: URLImageResolution(31)).resolution.pixels)
            XCTAssertEqual(39, getBestImageURL(sutImageURLFromInts22and30and39, for: URLImageResolution(38)).resolution.pixels)
            XCTAssertEqual(39, getBestImageURL(sutImageURLFromInts22and30and39, for: URLImageResolution(39)).resolution.pixels)
            XCTAssertEqual(39, getBestImageURL(sutImageURLFromInts22and30and39, for: URLImageResolution(40)).resolution.pixels)
            XCTAssertEqual(39, getBestImageURL(sutImageURLFromInts22and30and39, for: URLImageResolution(999999)).resolution.pixels)
        }
}
