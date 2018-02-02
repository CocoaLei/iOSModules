//
//  iOSModulesTests.m
//  iOSModulesTests
//
//  Created by 石城磊 on 21/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>

@interface iOSModulesTests : XCTestCase

@end

@implementation iOSModulesTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
