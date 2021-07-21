// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class InitialSetupQueryQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query initialSetupQuery {
      siteInfo {
        __typename
        initialSetup
      }
    }
    """

  public let operationName: String = "initialSetupQuery"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("siteInfo", type: .nonNull(.object(SiteInfo.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(siteInfo: SiteInfo) {
      self.init(unsafeResultMap: ["__typename": "Query", "siteInfo": siteInfo.resultMap])
    }

    public var siteInfo: SiteInfo {
      get {
        return SiteInfo(unsafeResultMap: resultMap["siteInfo"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "siteInfo")
      }
    }

    public struct SiteInfo: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["SiteInfo"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("initialSetup", type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(initialSetup: Bool) {
        self.init(unsafeResultMap: ["__typename": "SiteInfo", "initialSetup": initialSetup])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var initialSetup: Bool {
        get {
          return resultMap["initialSetup"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "initialSetup")
        }
      }
    }
  }
}
