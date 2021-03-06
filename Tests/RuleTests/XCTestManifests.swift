/*
   Copyright 2016 Ryuichi Laboratories and the Yanagiba project contributors

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

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
  return [
    testCase(NoForceCastRuleTests.allTests),
    testCase(NoForcedTryRuleTests.allTests),
    testCase(CyclomaticComplexityRuleTests.allTests),
    testCase(NPathComplexityRuleTests.allTests),
    testCase(NCSSRuleTests.allTests),
    testCase(NestedCodeBlockDepthRuleTests.allTests),
    testCase(RemoveGetForReadOnlyComputedPropertyRuleTests.allTests),
    testCase(RedundantInitializationToNilRuleTests.allTests),
    testCase(RedundantIfStatementRuleTests.allTests),
    testCase(RedundantConditionalOperatorRuleTests.allTests),
    testCase(ConstantIfStatementConditionRuleTests.allTests),
    testCase(ConstantGuardStatementConditionRuleTests.allTests),
    testCase(ConstantConditionalOperatorConditionRuleTests.allTests),
    testCase(InvertedLogicRuleTests.allTests),
    testCase(DoubleNegativeRuleTests.allTests),
    testCase(CollapsibleIfStatementsRuleTests.allTests),
    testCase(RedundantVariableDeclarationKeywordRuleTests.allTests),
    testCase(RedundantEnumCaseStringValueRuleTests.allTests),
    testCase(TooManyParametersRuleTests.allTests),
    testCase(LongLineRuleTests.allTests),
    testCase(RedundantBreakInSwitchCaseRuleTests.allTests),
    testCase(RedundantReturnVoidTypeRuleTests.allTests),
    testCase(DeadCodeRuleTests.allTests),
    testCase(MustCallSuperRuleTests.allTests),
  ]
}
#endif
