import Testing

@testable import SwiftStructure

@Suite("Visibility Detection Tests")
struct VisibilityDetectionTests {

    // MARK: - Property Visibility

    @Test("Detects public property")
    func detectsPublicProperty() {
        let members = discoverMembers(in: "public var name: String")

        #expect(members.count == 1)
        #expect(members[0].visibility == .public)
    }

    @Test("Detects private property")
    func detectsPrivateProperty() {
        let members = discoverMembers(in: "private var name: String")

        #expect(members.count == 1)
        #expect(members[0].visibility == .private)
    }

    @Test("Detects internal property")
    func detectsInternalProperty() {
        let members = discoverMembers(in: "internal var name: String")

        #expect(members.count == 1)
        #expect(members[0].visibility == .internal)
    }

    @Test("Detects fileprivate property")
    func detectsFileprivateProperty() {
        let members = discoverMembers(in: "fileprivate var name: String")

        #expect(members.count == 1)
        #expect(members[0].visibility == .fileprivate)
    }

    @Test("Detects open property")
    func detectsOpenProperty() {
        let members = discoverMembers(in: "open var name: String")

        #expect(members.count == 1)
        #expect(members[0].visibility == .open)
    }

    @Test("Defaults to internal when no visibility specified")
    func defaultsToInternal() {
        let members = discoverMembers(in: "var name: String")

        #expect(members.count == 1)
        #expect(members[0].visibility == .internal)
    }

    // MARK: - Method Visibility

    @Test("Detects public method")
    func detectsPublicMethod() {
        let members = discoverMembers(in: "public func doSomething() {}")

        #expect(members.count == 1)
        #expect(members[0].visibility == .public)
    }

    @Test("Detects private method")
    func detectsPrivateMethod() {
        let members = discoverMembers(in: "private func doSomething() {}")

        #expect(members.count == 1)
        #expect(members[0].visibility == .private)
    }

    @Test("Detects internal method")
    func detectsInternalMethod() {
        let members = discoverMembers(in: "internal func doSomething() {}")

        #expect(members.count == 1)
        #expect(members[0].visibility == .internal)
    }

    @Test("Method defaults to internal")
    func methodDefaultsToInternal() {
        let members = discoverMembers(in: "func doSomething() {}")

        #expect(members.count == 1)
        #expect(members[0].visibility == .internal)
    }

    // MARK: - Initializer Visibility

    @Test("Detects public initializer")
    func detectsPublicInitializer() {
        let members = discoverMembers(in: "public init() {}")

        #expect(members.count == 1)
        #expect(members[0].visibility == .public)
    }

    @Test("Detects private initializer")
    func detectsPrivateInitializer() {
        let members = discoverMembers(in: "private init() {}")

        #expect(members.count == 1)
        #expect(members[0].visibility == .private)
    }

    @Test("Initializer defaults to internal")
    func initializerDefaultsToInternal() {
        let members = discoverMembers(in: "init() {}")

        #expect(members.count == 1)
        #expect(members[0].visibility == .internal)
    }

    // MARK: - Static Method Visibility

    @Test("Detects public static method")
    func detectsPublicStaticMethod() {
        let members = discoverMembers(in: "public static func create() {}")

        #expect(members.count == 1)
        #expect(members[0].kind == .typeMethod)
        #expect(members[0].visibility == .public)
    }

    @Test("Detects private static method")
    func detectsPrivateStaticMethod() {
        let members = discoverMembers(in: "private static func helper() {}")

        #expect(members.count == 1)
        #expect(members[0].kind == .typeMethod)
        #expect(members[0].visibility == .private)
    }

    // MARK: - Static Property Visibility

    @Test("Detects public static property")
    func detectsPublicStaticProperty() {
        let members = discoverMembers(in: "public static var shared: Self")

        #expect(members.count == 1)
        #expect(members[0].kind == .typeProperty)
        #expect(members[0].visibility == .public)
    }

    @Test("Detects private static property")
    func detectsPrivateStaticProperty() {
        let members = discoverMembers(in: "private static var instance: Self")

        #expect(members.count == 1)
        #expect(members[0].kind == .typeProperty)
        #expect(members[0].visibility == .private)
    }

    // MARK: - Multiple Members

    @Test("Detects visibility for multiple members")
    func detectsVisibilityForMultipleMembers() {
        let source = """
            public var publicProp: String
            private var privateProp: Int
            internal func internalMethod() {}
            """
        let members = discoverMembers(in: source)

        #expect(members.count == 3)
        #expect(members[0].visibility == .public)
        #expect(members[1].visibility == .private)
        #expect(members[2].visibility == .internal)
    }
}
