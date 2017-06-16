/*
   Copyright 2015 Ryuichi Saito, LLC and the Yanagiba project contributors

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

class RuleBase {
  var astContext: ASTContext?
  var configurations: [String: Any]?
}

extension RuleBase {
  func getConfiguration<T>(for key: String, orDefault defaultValue: T) -> T {
    if let configurations = configurations,
      let customThreshold = configurations[key] as? T
    {
      return customThreshold
    }
    return defaultValue
  }
}

extension RuleBase {
  typealias CommentBasedConfiguration = [Int: [String?]]
  typealias CommentBasedSuppression = [Int: [String]]
  typealias CommentBasedRuleConfiguration = [Int: [String: String]]

  var commentBasedSuppressions: CommentBasedSuppression {
    return commentBasedConfigurations(forKey: "suppress")
      .map({ lineConfig -> (Int, [String]) in
        let line = lineConfig.0
        let configurations = lineConfig.1
        var suppressionConf: [String] = []
        for conf in configurations {
          guard let selectedSuppressions = conf else {
            return (line, [])
          }
          if selectedSuppressions.isEmpty {
            return (line, [])
          }

          let ruleIds = selectedSuppressions.components(separatedBy: ",")
          suppressionConf += ruleIds
        }

        return (line, suppressionConf)
      })
      .reduce([:]) { carryOver, e in
        var mutableDict = carryOver
        mutableDict[e.0] = e.1
        return mutableDict
      }
  }

  var commentBasedRuleConfigurations: CommentBasedRuleConfiguration {
    return commentBasedConfigurations(forKey: "rule_configure")
      .map({ lineConfig -> (Int, [String: String]) in
        let line = lineConfig.0
        let configurations = lineConfig.1
        var ruleConfig: [String: String] = [:]
        for conf in configurations {
          guard let ruleConf = conf else {
            continue
          }
          if ruleConf.isEmpty {
            continue
          }

          for e in ruleConf.components(separatedBy: ",") {
            let keyValuePair = e.components(separatedBy: "=")
            guard keyValuePair.count == 2 else {
              continue
            }
            ruleConfig[keyValuePair[0]] = keyValuePair[1]
          }
        }

        return (line, ruleConfig)
      })
      .reduce([:]) { carryOver, e in
        var mutableDict = carryOver
        mutableDict[e.0] = e.1
        return mutableDict
      }
  }

  private func commentBasedConfigurations(
    forKey key: String
  ) -> CommentBasedConfiguration {
    guard let astContext = astContext else {
      return [:]
    }
    return astContext.topLevelDeclaration.comments
      .map({ ($0.location.line, $0.content) })
      .filter({ $0.1.contains("swift-lint") && $0.1.contains(key) })
      .map({ lineContent -> (Int, [String?]) in
        let line = lineContent.0
        let configurations = lineContent.1.extractedConfigurations
          .filter({ $0.name == key })
          .map({ $0.args })
        return (line, configurations)
      })
      .reduce([:]) { carryOver, e in
        var mutableDict = carryOver
        mutableDict[e.0] = e.1
        return mutableDict
      }
  }
}

fileprivate extension String {
  var extractedConfigurations: [(name: String, args: String?)] { // swift-lint:rule_configure(NESTED_CODE_BLOCK_DEPTH=6)
    guard let swiftLintKeywordRange = range(of: "swift-lint") else {
      return []
    }

    let remainingString = String(self[swiftLintKeywordRange.upperBound...])
    var configurations: [(String, String?)] = []

    enum State {
      case head
      case keyword
      case argument
      case tail
    }

    var state = State.head
    var currentString = ""
    var currentKey = ""
    for c in remainingString {
      switch c {
      case ":":
        if state == .head ||
          (state == .tail &&
            (currentString == "" || currentString.hasSuffix("swift-lint")))
        {
          currentString = ""
          currentKey = ""
          state = .keyword
        } else if state == .keyword {
          configurations.append((currentString, nil))
          currentString = ""
          currentKey = ""
        } else {
          currentString += String(c)
        }
      case "(":
        if state == .keyword {
          currentKey = currentString
          currentString = ""
          state = .argument
        } else {
          currentString += String(c)
        }
      case ")":
        if state == .argument {
          configurations.append((currentKey, currentString))
          currentString = ""
          currentKey = ""
          state = .tail
        }
      default:
        if c != " " {
          currentString += String(c)
        }
      }
    }

    if state == .keyword && !currentString.isEmpty {
      configurations.append((currentString, nil))
    }

    return configurations
  }
}
