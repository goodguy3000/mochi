//
//  Client.swift
//  
//
//  Created ErrorErrorError on 4/10/23.
//  Copyright © 2023. All rights reserved.
//

import Dependencies
import Foundation
import SharedModels
import WasmInterpreter
import XCTestDynamicOverlay

public struct ModuleClient: Sendable {
    public let searchFilters: @Sendable (Module) async throws -> [SearchFilter]
    public let search: @Sendable (Module, SearchQuery) async throws -> Paging<Media>
    public let getDiscoverListings: @Sendable (Module) async throws -> [DiscoverListing]
}

extension ModuleClient {
    public enum Error: Swift.Error, Equatable, Sendable {
        case wasm3(WasmInstance.Error)
        case nullPtr(for: String = #function)
        case castError(for: String = #function)
        case indexOutOfBounds
        case unknown
    }
}

extension ModuleClient: TestDependencyKey {
    public static let testValue = Self(
        searchFilters: unimplemented(),
        search: unimplemented(),
        getDiscoverListings: unimplemented()
    )
}

extension DependencyValues {
    public var moduleClient: ModuleClient {
        get { self[ModuleClient.self] }
        set { self[ModuleClient.self] = newValue }
    }
}