// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class InitialSetupQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query InitialSetup {
      siteInfo {
        __typename
        initialSetup
      }
    }
    """

  public let operationName: String = "InitialSetup"

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

public final class AuthorizeUserMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation AuthorizeUser($username: String!, $password: String!) {
      authorizeUser(username: $username, password: $password) {
        __typename
        success
        status
        token
      }
    }
    """

  public let operationName: String = "AuthorizeUser"

  public var username: String
  public var password: String

  public init(username: String, password: String) {
    self.username = username
    self.password = password
  }

  public var variables: GraphQLMap? {
    return ["username": username, "password": password]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("authorizeUser", arguments: ["username": GraphQLVariable("username"), "password": GraphQLVariable("password")], type: .nonNull(.object(AuthorizeUser.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(authorizeUser: AuthorizeUser) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "authorizeUser": authorizeUser.resultMap])
    }

    public var authorizeUser: AuthorizeUser {
      get {
        return AuthorizeUser(unsafeResultMap: resultMap["authorizeUser"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "authorizeUser")
      }
    }

    public struct AuthorizeUser: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["AuthorizeResult"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("success", type: .nonNull(.scalar(Bool.self))),
          GraphQLField("status", type: .nonNull(.scalar(String.self))),
          GraphQLField("token", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(success: Bool, status: String, token: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "AuthorizeResult", "success": success, "status": status, "token": token])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var success: Bool {
        get {
          return resultMap["success"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "success")
        }
      }

      public var status: String {
        get {
          return resultMap["status"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "status")
        }
      }

      public var token: String? {
        get {
          return resultMap["token"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "token")
        }
      }
    }
  }
}
