//
//  AnimationTests.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 5/7/2022.
//

import XCTest
@testable import Beam_Light

class AnimationTests: XCTestCase {

	func test_can_init_instance() {
		let sut = Animation(duration: 0.2, closure: { _ in })
		
		XCTAssertNotNil(sut)
	}
	
	func test_animation_fadeIn() {
		let sut = Animation.fadeIn(duration: 0.0)
		
		let view = UIView()
		view.alpha = 0.0
		
		sut.closure(view)
		
		XCTAssertEqual(view.alpha, 1.0)
	}
	
	func test_animation_fadeOut() {
		let sut = Animation.fadeOut(duration: 0.0)
		
		let view = UIView()
		view.alpha = 1.0
		
		sut.closure(view)
		
		XCTAssertEqual(view.alpha, 0.0)
	}
	
	func test_animation_transformIdentity() {
		let sut = Animation.transformIdentity(duration: 0.0)
		
		let view = UIView()
		view.alpha = 1.0
		
		sut.closure(view)
		
		XCTAssertTrue(view.transform.isIdentity)
	}

}
