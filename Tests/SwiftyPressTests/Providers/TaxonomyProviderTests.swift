//
//  TaxonomyProviderTests.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-02.
//

#if !os(watchOS)
import XCTest
import SwiftyPress

final class TaxonomyProviderTests: BaseTestCase {
    private lazy var taxonomyProvider: TaxonomyProviderType = core.dependency()
}

extension TaxonomyProviderTests {
    
    func testFetch() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Terms fetch all promise")
        
        // When
        taxonomyProvider.fetch {
            // Handle double calls used for remote pulling
            guard $0.value?.isEmpty == false else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert(!$0.value!.isEmpty)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}

extension TaxonomyProviderTests {
    
    func testFetchByID() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Terms fetch by ID promise")
        let id = 55
        
        // When
        taxonomyProvider.fetch(id: id) {
            // Handle double calls used for remote pulling
            guard $0.value != nil else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert($0.value?.id == id)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchByIDs() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Terms fetch by IDs promise")
        let ids: Set = [4, 55, 64]
        
        // When
        taxonomyProvider.fetch(ids: ids) {
            // Handle double calls used for remote pulling
            guard $0.value?.isEmpty == false else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssertEqual($0.value?.map { $0.id }.sorted(), Array(ids).sorted())
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}

extension TaxonomyProviderTests {
    
    func testFetchBySlug() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Terms fetch by slug promise")
        let slug = "swift"
        
        // When
        taxonomyProvider.fetch(slug: slug) {
            // Handle double calls used for remote pulling
            guard $0.value != nil else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert($0.value?.slug == slug)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}

extension TaxonomyProviderTests {
    
    func testFetchByURL() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Terms fetch by url promise")
        let url = "https://example.com/category/protocol-oriented-programming"
        
        // When
        taxonomyProvider.fetch(url: url) {
            // Handle double calls used for remote pulling
            guard $0.value != nil else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert($0.value?.id == 62)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchByURL2() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Terms fetch by url 2 promise")
        let url = "https://example.com/category/ios/?abc=123#test"
        
        // When
        taxonomyProvider.fetch(url: url) {
            // Handle double calls used for remote pulling
            guard $0.value != nil else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert($0.value?.id == 53)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchByURL3() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Terms fetch by url 3 promise")
        let url = "/tag/protocol-oriented-PROgramming/?abc=123#test"
        
        // When
        taxonomyProvider.fetch(url: url) {
            // Handle double calls used for remote pulling
            guard $0.value != nil else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert($0.value?.id == 62)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchByURL4() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Terms fetch by url 4 promise")
        let url = "taG/deleGAtes"
        
        // When
        taxonomyProvider.fetch(url: url) {
            // Handle double calls used for remote pulling
            guard $0.value != nil else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert($0.value?.id == 74)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}

extension TaxonomyProviderTests {
    
    func testFetchByCategory() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Terms fetch by category promise")
        
        // When
        taxonomyProvider.fetch(by: .category) {
            // Handle double calls used for remote pulling
            guard $0.value?.isEmpty == false else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert($0.value!.allSatisfy { $0.taxonomy == .category })
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchByTag() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Terms fetch by tag promise")
        
        // When
        taxonomyProvider.fetch(by: .tag) {
            // Handle double calls used for remote pulling
            guard $0.value?.isEmpty == false else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert($0.value!.allSatisfy { $0.taxonomy == .tag })
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchByOther() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Terms fetch by other promise")
        
        // When
        taxonomyProvider.fetch(by: .other("series")) {
            // Handle double calls used for remote pulling
            guard $0.value?.isEmpty == false else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert($0.value!.allSatisfy { $0.taxonomy.rawValue == "series" })
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchByMultiple() {
        // Given
        var promise: XCTestExpectation? = expectation(description: "Terms fetch by multiple taxonomies promise")
        let taxonomies: [Taxonomy] = [.category, .tag]
        
        // When
        taxonomyProvider.fetch(by: taxonomies) {
            // Handle double calls used for remote pulling
            guard $0.value?.isEmpty == false else { return }
            defer { promise?.fulfill(); promise = nil }
            
            // Then
            XCTAssertNil($0.error, $0.error.debugDescription)
            XCTAssertNotNil($0.value, "response should not have been nil")
            XCTAssert($0.value!.allSatisfy { taxonomies.contains($0.taxonomy) })
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
#endif
