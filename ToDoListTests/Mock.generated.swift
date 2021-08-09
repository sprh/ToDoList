// Generated using Sourcery 1.0.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT



// Generated with SwiftyMocky 4.0.4

import SwiftyMocky
import XCTest
import Foundation
import Models
import SwiftyMocky
@testable import ToDoList


// MARK: - NetworkingService

open class NetworkingServiceMock: NetworkingService, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst

    private var queue = DispatchQueue(label: "com.swiftymocky.invocations", qos: .userInteractive)
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }





    open func getAll(completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        addInvocation(.m_getAll__completion_completion(Parameter<(Result<[ToDoItem], Error>) -> Void>.value(`completion`)))
		let perform = methodPerformValue(.m_getAll__completion_completion(Parameter<(Result<[ToDoItem], Error>) -> Void>.value(`completion`))) as? (@escaping (Result<[ToDoItem], Error>) -> Void) -> Void
		perform?(`completion`)
    }

    open func create(_ toDoItem: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        addInvocation(.m_create__toDoItemcompletion_completion(Parameter<ToDoItem>.value(`toDoItem`), Parameter<(Result<ToDoItem, Error>) -> Void>.value(`completion`)))
		let perform = methodPerformValue(.m_create__toDoItemcompletion_completion(Parameter<ToDoItem>.value(`toDoItem`), Parameter<(Result<ToDoItem, Error>) -> Void>.value(`completion`))) as? (ToDoItem, @escaping (Result<ToDoItem, Error>) -> Void) -> Void
		perform?(`toDoItem`, `completion`)
    }

    open func update(_ toDoItem: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        addInvocation(.m_update__toDoItemcompletion_completion(Parameter<ToDoItem>.value(`toDoItem`), Parameter<(Result<ToDoItem, Error>) -> Void>.value(`completion`)))
		let perform = methodPerformValue(.m_update__toDoItemcompletion_completion(Parameter<ToDoItem>.value(`toDoItem`), Parameter<(Result<ToDoItem, Error>) -> Void>.value(`completion`))) as? (ToDoItem, @escaping (Result<ToDoItem, Error>) -> Void) -> Void
		perform?(`toDoItem`, `completion`)
    }

    open func delete(_ id: String, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        addInvocation(.m_delete__idcompletion_completion(Parameter<String>.value(`id`), Parameter<(Result<ToDoItem, Error>) -> Void>.value(`completion`)))
		let perform = methodPerformValue(.m_delete__idcompletion_completion(Parameter<String>.value(`id`), Parameter<(Result<ToDoItem, Error>) -> Void>.value(`completion`))) as? (String, @escaping (Result<ToDoItem, Error>) -> Void) -> Void
		perform?(`id`, `completion`)
    }

    open func putAll(addOrUpdateItems: [ToDoItem], deleteIds: [String],
                completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        addInvocation(.m_putAll__addOrUpdateItems_addOrUpdateItemsdeleteIds_deleteIdscompletion_completion(Parameter<[ToDoItem]>.value(`addOrUpdateItems`), Parameter<[String]>.value(`deleteIds`), Parameter<(Result<[ToDoItem], Error>) -> Void>.value(`completion`)))
		let perform = methodPerformValue(.m_putAll__addOrUpdateItems_addOrUpdateItemsdeleteIds_deleteIdscompletion_completion(Parameter<[ToDoItem]>.value(`addOrUpdateItems`), Parameter<[String]>.value(`deleteIds`), Parameter<(Result<[ToDoItem], Error>) -> Void>.value(`completion`))) as? ([ToDoItem], [String], @escaping (Result<[ToDoItem], Error>) -> Void) -> Void
		perform?(`addOrUpdateItems`, `deleteIds`, `completion`)
    }


    fileprivate enum MethodType {
        case m_getAll__completion_completion(Parameter<(Result<[ToDoItem], Error>) -> Void>)
        case m_create__toDoItemcompletion_completion(Parameter<ToDoItem>, Parameter<(Result<ToDoItem, Error>) -> Void>)
        case m_update__toDoItemcompletion_completion(Parameter<ToDoItem>, Parameter<(Result<ToDoItem, Error>) -> Void>)
        case m_delete__idcompletion_completion(Parameter<String>, Parameter<(Result<ToDoItem, Error>) -> Void>)
        case m_putAll__addOrUpdateItems_addOrUpdateItemsdeleteIds_deleteIdscompletion_completion(Parameter<[ToDoItem]>, Parameter<[String]>, Parameter<(Result<[ToDoItem], Error>) -> Void>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_getAll__completion_completion(let lhsCompletion), .m_getAll__completion_completion(let rhsCompletion)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCompletion, rhs: rhsCompletion, with: matcher), lhsCompletion, rhsCompletion, "completion"))
				return Matcher.ComparisonResult(results)

            case (.m_create__toDoItemcompletion_completion(let lhsTodoitem, let lhsCompletion), .m_create__toDoItemcompletion_completion(let rhsTodoitem, let rhsCompletion)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTodoitem, rhs: rhsTodoitem, with: matcher), lhsTodoitem, rhsTodoitem, "_ toDoItem"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCompletion, rhs: rhsCompletion, with: matcher), lhsCompletion, rhsCompletion, "completion"))
				return Matcher.ComparisonResult(results)

            case (.m_update__toDoItemcompletion_completion(let lhsTodoitem, let lhsCompletion), .m_update__toDoItemcompletion_completion(let rhsTodoitem, let rhsCompletion)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTodoitem, rhs: rhsTodoitem, with: matcher), lhsTodoitem, rhsTodoitem, "_ toDoItem"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCompletion, rhs: rhsCompletion, with: matcher), lhsCompletion, rhsCompletion, "completion"))
				return Matcher.ComparisonResult(results)

            case (.m_delete__idcompletion_completion(let lhsId, let lhsCompletion), .m_delete__idcompletion_completion(let rhsId, let rhsCompletion)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsId, rhs: rhsId, with: matcher), lhsId, rhsId, "_ id"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCompletion, rhs: rhsCompletion, with: matcher), lhsCompletion, rhsCompletion, "completion"))
				return Matcher.ComparisonResult(results)

            case (.m_putAll__addOrUpdateItems_addOrUpdateItemsdeleteIds_deleteIdscompletion_completion(let lhsAddorupdateitems, let lhsDeleteids, let lhsCompletion), .m_putAll__addOrUpdateItems_addOrUpdateItemsdeleteIds_deleteIdscompletion_completion(let rhsAddorupdateitems, let rhsDeleteids, let rhsCompletion)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAddorupdateitems, rhs: rhsAddorupdateitems, with: matcher), lhsAddorupdateitems, rhsAddorupdateitems, "addOrUpdateItems"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsDeleteids, rhs: rhsDeleteids, with: matcher), lhsDeleteids, rhsDeleteids, "deleteIds"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCompletion, rhs: rhsCompletion, with: matcher), lhsCompletion, rhsCompletion, "completion"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_getAll__completion_completion(p0): return p0.intValue
            case let .m_create__toDoItemcompletion_completion(p0, p1): return p0.intValue + p1.intValue
            case let .m_update__toDoItemcompletion_completion(p0, p1): return p0.intValue + p1.intValue
            case let .m_delete__idcompletion_completion(p0, p1): return p0.intValue + p1.intValue
            case let .m_putAll__addOrUpdateItems_addOrUpdateItemsdeleteIds_deleteIdscompletion_completion(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_getAll__completion_completion: return ".getAll(completion:)"
            case .m_create__toDoItemcompletion_completion: return ".create(_:completion:)"
            case .m_update__toDoItemcompletion_completion: return ".update(_:completion:)"
            case .m_delete__idcompletion_completion: return ".delete(_:completion:)"
            case .m_putAll__addOrUpdateItems_addOrUpdateItemsdeleteIds_deleteIdscompletion_completion: return ".putAll(addOrUpdateItems:deleteIds:completion:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func getAll(completion: Parameter<(Result<[ToDoItem], Error>) -> Void>) -> Verify { return Verify(method: .m_getAll__completion_completion(`completion`))}
        public static func create(_ toDoItem: Parameter<ToDoItem>, completion: Parameter<(Result<ToDoItem, Error>) -> Void>) -> Verify { return Verify(method: .m_create__toDoItemcompletion_completion(`toDoItem`, `completion`))}
        public static func update(_ toDoItem: Parameter<ToDoItem>, completion: Parameter<(Result<ToDoItem, Error>) -> Void>) -> Verify { return Verify(method: .m_update__toDoItemcompletion_completion(`toDoItem`, `completion`))}
        public static func delete(_ id: Parameter<String>, completion: Parameter<(Result<ToDoItem, Error>) -> Void>) -> Verify { return Verify(method: .m_delete__idcompletion_completion(`id`, `completion`))}
        public static func putAll(addOrUpdateItems: Parameter<[ToDoItem]>, deleteIds: Parameter<[String]>, completion: Parameter<(Result<[ToDoItem], Error>) -> Void>) -> Verify { return Verify(method: .m_putAll__addOrUpdateItems_addOrUpdateItemsdeleteIds_deleteIdscompletion_completion(`addOrUpdateItems`, `deleteIds`, `completion`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func getAll(completion: Parameter<(Result<[ToDoItem], Error>) -> Void>, perform: @escaping (@escaping (Result<[ToDoItem], Error>) -> Void) -> Void) -> Perform {
            return Perform(method: .m_getAll__completion_completion(`completion`), performs: perform)
        }
        public static func create(_ toDoItem: Parameter<ToDoItem>, completion: Parameter<(Result<ToDoItem, Error>) -> Void>, perform: @escaping (ToDoItem, @escaping (Result<ToDoItem, Error>) -> Void) -> Void) -> Perform {
            return Perform(method: .m_create__toDoItemcompletion_completion(`toDoItem`, `completion`), performs: perform)
        }
        public static func update(_ toDoItem: Parameter<ToDoItem>, completion: Parameter<(Result<ToDoItem, Error>) -> Void>, perform: @escaping (ToDoItem, @escaping (Result<ToDoItem, Error>) -> Void) -> Void) -> Perform {
            return Perform(method: .m_update__toDoItemcompletion_completion(`toDoItem`, `completion`), performs: perform)
        }
        public static func delete(_ id: Parameter<String>, completion: Parameter<(Result<ToDoItem, Error>) -> Void>, perform: @escaping (String, @escaping (Result<ToDoItem, Error>) -> Void) -> Void) -> Perform {
            return Perform(method: .m_delete__idcompletion_completion(`id`, `completion`), performs: perform)
        }
        public static func putAll(addOrUpdateItems: Parameter<[ToDoItem]>, deleteIds: Parameter<[String]>, completion: Parameter<(Result<[ToDoItem], Error>) -> Void>, perform: @escaping ([ToDoItem], [String], @escaping (Result<[ToDoItem], Error>) -> Void) -> Void) -> Perform {
            return Perform(method: .m_putAll__addOrUpdateItems_addOrUpdateItemsdeleteIds_deleteIdscompletion_completion(`addOrUpdateItems`, `deleteIds`, `completion`), performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        self.queue.sync { invocations.append(call) }
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

