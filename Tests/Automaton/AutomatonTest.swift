//
//  AutomatonTest.swift
//  UnitTest
//
//  Created by mzp on 2017/09/19.
//  Copyright © 2017 mzp. All rights reserved.
//

import XCTest

open class AutomatonTest: XCTestCase {
    // swiftlint:disable:next implicitly_unwrapped_optional
    private var automaton: EmojiAutomaton!

    override open func setUp() {
        super.setUp()
        self.automaton = EmojiAutomaton()
    }

    open func testTransition() {
        XCTAssertEqual(automaton.state.value, .normal)

        _ = automaton.handle(.enter)
        XCTAssertEqual(automaton.state.value, .normal)

        _ = automaton.handle(.input(text: "a"))
        XCTAssertEqual(automaton.state.value, .composing)

        _ = automaton.handle(.input(text: "b"))
        XCTAssertEqual(automaton.state.value, .composing)

        _ = automaton.handle(.enter)
        XCTAssertEqual(automaton.state.value, .normal)
    }

    open func testComposing() {
        var text: String = ""
        automaton.text.observeValues { text.append($0) }

        _ = automaton.handle(.input(text: "a"))
        XCTAssertEqual(automaton.markedText.value, "a")

        _ = automaton.handle(.input(text: "b"))
        XCTAssertEqual(automaton.markedText.value, "ab")

       _ = automaton.handle(.backspace)
        XCTAssertEqual(automaton.markedText.value, "a")

        _ = automaton.handle(.enter)
        XCTAssertEqual(automaton.markedText.value, "")
        XCTAssertEqual(text, "a")
    }

    open func testBackspaceReturnNormal() {
        _ = automaton.handle(.input(text: "a"))
        _ = automaton.handle(.input(text: "a"))
        _ = automaton.handle(.backspace)
        XCTAssertEqual(automaton.state.value, .composing)
        _ = automaton.handle(.backspace)
        XCTAssertEqual(automaton.state.value, .normal)
    }

    open func testHandled() {
        XCTAssertTrue(automaton.handle(.input(text: "a")))
        XCTAssertTrue(automaton.handle(.input(text: "a")))
        XCTAssertTrue(automaton.handle(.enter))
        XCTAssertFalse(automaton.handle(.enter))
    }
}
