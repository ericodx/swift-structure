import Testing

@testable import SwiftStructure

@Suite("Annotation Detection Tests")
struct AnnotationDetectionTests {

    // MARK: - Property Annotations

    @Test("Detects annotated property")
    func detectsAnnotatedProperty() {
        let members = discoverMembers(in: "@State var name: String")

        #expect(members.count == 1)
        #expect(members[0].isAnnotated == true)
    }

    @Test("Detects non-annotated property")
    func detectsNonAnnotatedProperty() {
        let members = discoverMembers(in: "var name: String")

        #expect(members.count == 1)
        #expect(members[0].isAnnotated == false)
    }

    @Test("Detects multiple annotations")
    func detectsMultipleAnnotations() {
        let members = discoverMembers(in: "@State @Observable var name: String")

        #expect(members.count == 1)
        #expect(members[0].isAnnotated == true)
    }

    @Test("Detects common SwiftUI annotations")
    func detectsSwiftUIAnnotations() {
        let sources = [
            "@State var state: Int",
            "@Binding var binding: String",
            "@Published var published: Bool",
            "@ObservedObject var observed: Object",
            "@EnvironmentObject var environment: Object",
            "@Environment(\\.key) var env: Value",
        ]

        for source in sources {
            let members = discoverMembers(in: source)
            #expect(members.count == 1)
            #expect(members[0].isAnnotated == true)
        }
    }

    // MARK: - Method Annotations

    @Test("Detects annotated method")
    func detectsAnnotatedMethod() {
        let members = discoverMembers(in: "@MainActor func doSomething() {}")

        #expect(members.count == 1)
        #expect(members[0].isAnnotated == true)
    }

    @Test("Detects non-annotated method")
    func detectsNonAnnotatedMethod() {
        let members = discoverMembers(in: "func doSomething() {}")

        #expect(members.count == 1)
        #expect(members[0].isAnnotated == false)
    }

    @Test("Detects discardableResult annotation")
    func detectsDiscardableResult() {
        let members = discoverMembers(in: "@discardableResult func compute() -> Int { 0 }")

        #expect(members.count == 1)
        #expect(members[0].isAnnotated == true)
    }

    // MARK: - Combined Visibility and Annotation

    @Test("Detects both visibility and annotation")
    func detectsBothVisibilityAndAnnotation() {
        let members = discoverMembers(in: "@State private var state: Int")

        #expect(members.count == 1)
        #expect(members[0].visibility == .private)
        #expect(members[0].isAnnotated == true)
    }

    @Test("Detects public annotated property")
    func detectsPublicAnnotatedProperty() {
        let members = discoverMembers(in: "@Published public var value: String")

        #expect(members.count == 1)
        #expect(members[0].visibility == .public)
        #expect(members[0].isAnnotated == true)
    }

    // MARK: - Initializer Annotations

    @Test("Detects annotated initializer")
    func detectsAnnotatedInitializer() {
        let members = discoverMembers(in: "@MainActor init() {}")

        #expect(members.count == 1)
        #expect(members[0].isAnnotated == true)
    }

    // MARK: - Mixed Members

    @Test("Correctly identifies annotations across mixed members")
    func identifiesAnnotationsAcrossMixedMembers() {
        let source = """
            @State var annotatedProp: String
            var normalProp: Int
            @MainActor func annotatedMethod() {}
            func normalMethod() {}
            """
        let members = discoverMembers(in: source)

        #expect(members.count == 4)
        #expect(members[0].isAnnotated == true)
        #expect(members[1].isAnnotated == false)
        #expect(members[2].isAnnotated == true)
        #expect(members[3].isAnnotated == false)
    }
}
