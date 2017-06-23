/*
   Copyright 2017 Ryuichi Saito, LLC and the Yanagiba project contributors

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

import XCTest

@testable import Lint

class RedundantIfStatementRuleTests : XCTestCase {
  func testNoElseBlock() {
    let issues = "if a == b { return true }"
      .inspect(withRule: RedundantIfStatementRule())
    XCTAssertTrue(issues.isEmpty)
  }

  func testPatternMatchings() {
    let issues = """
      if let a = b { return true } else { return false }
      if case .a = b { return false } else { return false }
      if var a = b { return 1 } else { return 1 }
      """
      .inspect(withRule: RedundantIfStatementRule())
    XCTAssertTrue(issues.isEmpty)
  }

  func testReturnTrueFalseRespectively() {
    let returns: [(String, String)] = [
      ("true", "false"),
      ("false", "true"),
    ]
    for (thenString, elseString) in returns {
      let issues = "if a == b { return \(thenString) } else { return \(elseString) }"
        .inspect(withRule: RedundantIfStatementRule())
      XCTAssertEqual(issues.count, 1)
      let issue = issues[0]
      XCTAssertEqual(issue.ruleIdentifier, "redundant_if_statement")
      XCTAssertEqual(issue.description, "if statement is redundant and can be simplified")
      XCTAssertEqual(issue.category, .badPractice)
      XCTAssertEqual(issue.severity, .minor)
      let range = issue.location
      XCTAssertEqual(range.start.path, "test/test")
      XCTAssertEqual(range.start.line, 1)
      XCTAssertEqual(range.start.column, 1)
      XCTAssertEqual(range.end.path, "test/test")
      XCTAssertEqual(range.end.line, 1)
      XCTAssertEqual(range.end.column, 48)
    }
  }

  func testReturnSameConstant() {
    let returns: [(String, String, Int)] = [
      ("true", "true", 47),
      ("false", "false", 49),
      ("1", "1", 41),
      ("1.23", "1.23", 47),
      ("\"foo\"", "\"foo\"", 49),
    ]
    for (thenString, elseString, endColumn) in returns {
      let issues = "if a == b { return \(thenString) } else { return \(elseString) }"
        .inspect(withRule: RedundantIfStatementRule())
      XCTAssertEqual(issues.count, 1)
      let issue = issues[0]
      XCTAssertEqual(issue.ruleIdentifier, "redundant_if_statement")
      XCTAssertEqual(issue.description, "if statement is redundant and can be removed")
      XCTAssertEqual(issue.category, .badPractice)
      XCTAssertEqual(issue.severity, .minor)
      let range = issue.location
      XCTAssertEqual(range.start.path, "test/test")
      XCTAssertEqual(range.start.line, 1)
      XCTAssertEqual(range.start.column, 1)
      XCTAssertEqual(range.end.path, "test/test")
      XCTAssertEqual(range.end.line, 1)
      XCTAssertEqual(range.end.column, endColumn)
    }
  }

  func testReturnSameVariable() {
    let issues = "if a == b { return foo } else { return foo }"
      .inspect(withRule: RedundantIfStatementRule())
    XCTAssertEqual(issues.count, 1)
    let issue = issues[0]
    XCTAssertEqual(issue.ruleIdentifier, "redundant_if_statement")
    XCTAssertEqual(issue.description, "if statement is redundant and can be removed")
    XCTAssertEqual(issue.category, .badPractice)
    XCTAssertEqual(issue.severity, .minor)
    let range = issue.location
    XCTAssertEqual(range.start.path, "test/test")
    XCTAssertEqual(range.start.line, 1)
    XCTAssertEqual(range.start.column, 1)
    XCTAssertEqual(range.end.path, "test/test")
    XCTAssertEqual(range.end.line, 1)
    XCTAssertEqual(range.end.column, 45)
  }

  func testExtraStatements() {
    let issues = """
      if a == b { a = 1; return false } else { return true }
      if a == b { return true } else { a = 1; return false }
      if a == b { a = 1; return true } else { return false }
      if a == b { return false } else { a = 1; return true }
      if a == b { a = 1; return true } else { return true }
      if a == b { return false } else { a = 1; return false }
      if a == b { a = 1; return 1 } else { return 1 }
      if a == b { return 1.23 } else { a = 1; return 1.23 }
      if a == b { a = 1; return "foo" } else { return "foo" }
      if a == b { return foo } else { a = 1; return foo }
      """.inspect(withRule: RedundantIfStatementRule())
    XCTAssertTrue(issues.isEmpty)
  }

  static var allTests = [
    ("testNoElseBlock", testNoElseBlock),
    ("testPatternMatchings", testPatternMatchings),
    ("testReturnTrueFalseRespectively", testReturnTrueFalseRespectively),
    ("testReturnSameConstant", testReturnSameConstant),
    ("testReturnSameVariable", testReturnSameVariable),
    ("testExtraStatements", testExtraStatements),
  ]
}