import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage extends CognitoStorage {
  SharedPreferences _prefs;
  Storage(this._prefs);

  @override
  Future getItem(String key) async {
    String item;
    try {
      item = json.decode((_prefs.getString(key)).toString());
    } catch (e) {
      return null;
    }
    return item;
  }

  @override
  Future setItem(String key, value) async {
    _prefs.setString(key, json.encode(value));
    return getItem(key);
  }

  @override
  Future removeItem(String key) async {
    final item = getItem(key);
    if (item != null) {
      _prefs.remove(key);
      return item;
    }
    return null;
  }

  @override
  Future<void> clear() async {
    _prefs.clear();
  }
}

class User {
  late String email;
  // String name;
  late String password;
  bool confirmed = false;
  bool hasAccess = false;
  User();
  // User({this.email, this.name});

  /// Decode user from Cognito User Attributes
  factory User.fromUserAttributes(List<CognitoUserAttribute>? attributes) {
    final user = User();
    attributes?.forEach((attribute) {
      if (attribute.getName() == 'email') {
        user.email = attribute.getValue()!;
      }
    });
    return user;
  }
}

class UserService {
  CognitoUserPool _userPool;
  late CognitoUser _cognitoUser;
  late CognitoUserSession _session;
  UserService(this._userPool);
  late CognitoCredentials credentials;

  /// Initiate user session from local storage if present
  Future<bool> init() async {
    final prefs = await SharedPreferences.getInstance();
    final storage = Storage(prefs);
    _userPool.storage = storage;

    try{
      _cognitoUser = (await _userPool.getCurrentUser())!;
    }
    catch(e){
      return false;
    }
    _session = (await _cognitoUser.getSession())!;
    return _session.isValid();
  }

  /// Get existing user from session with his/her attributes
  Future<User?> getCurrentUser() async {
    if (_cognitoUser == null || _session == null) {
      return null;
    }
    if (!_session.isValid()) {
      return null;
    }
    final attributes = await _cognitoUser.getUserAttributes();
    if (attributes == null) {
      return null;
    }
    final user = new User.fromUserAttributes(attributes);
    user.hasAccess = true;
    return user;
  }

  // /// Retrieve user credentials -- for use with other AWS services
  // Future<CognitoCredentials?> getCredentials() async {
  //   if (_cognitoUser == null || _session == null) {
  //     return null;
  //   }
  //   credentials = new CognitoCredentials(_identityPoolId, _userPool);
  //   await credentials.getAwsCredentials(_session.getIdToken().getJwtToken());
  //   return credentials;
  // }

  /// Login user
  Future<User?> login(String email, String password) async {
    debugPrint('Authenticating User...');
    final prefs = await SharedPreferences.getInstance();
    final storage = Storage(prefs);
    _userPool.storage = storage;
    _cognitoUser =
    new CognitoUser(email, _userPool, storage: _userPool.storage);

    final authDetails = new AuthenticationDetails(
      username: email,
      password: password,
    );

    bool isConfirmed;
    bool hasAccess;
    try {
      _session = (await _cognitoUser.authenticateUser(authDetails))!;
      isConfirmed = true;
      debugPrint('Login Success...');

    } on CognitoClientException catch (e) {
      if (e.code == 'UserNotConfirmedException') {
        isConfirmed = false;
      } else {
        final attributes = null;
        final user = new User.fromUserAttributes(attributes);
        user.confirmed = true;
        user.hasAccess = false;
        return user;
      }
    }


    hasAccess = true;
    try{
      if (!_session.isValid()) {
         return null;
      }
    }
    catch (e) {
      hasAccess = false;
      final attributes = null;
      final user = new User.fromUserAttributes(attributes);
      user.confirmed = isConfirmed;
      user.hasAccess = hasAccess;

      return user;
    }


    final attributes = await _cognitoUser.getUserAttributes();
    final user = new User.fromUserAttributes(attributes!);
    user.confirmed = isConfirmed;
    user.hasAccess = hasAccess;

    return user;
  }

  /// Confirm user's account with confirmation code sent to email
  Future<bool> confirmAccount(String email, String confirmationCode) async {
    _cognitoUser =
    new CognitoUser(email, _userPool, storage: _userPool.storage);

    return await _cognitoUser.confirmRegistration(confirmationCode);
  }

  /// Resend confirmation code to user's email
  Future<void> resendConfirmationCode(String email) async {
    _cognitoUser =
    new CognitoUser(email, _userPool, storage: _userPool.storage);
    await _cognitoUser.resendConfirmationCode();
  }

  /// Check if user's current session is valid
  Future<bool> checkAuthenticated() async {
    if (_cognitoUser == null || _session == null) {
      return false;
    }
    return _session.isValid();
  }

  /// Sign up new user
  Future<User> signUp(String email, String password) async {
    CognitoUserPoolData data;
    // final userAttributes = [
    //   new AttributeArg(name: 'custom:university', value: uni),
    // ];
    data =
    await _userPool.signUp(email, password);

    final user = User();
    // user.email = email;
    // user.name = name;
    user.confirmed = data.userConfirmed!;

    return user;
  }

  Future<void> signOut() async {
    // if (credentials != null) {
    //   await credentials.resetAwsCredentials();
    // }
    if (_cognitoUser != null) {
      return _cognitoUser.signOut();
    }
  }
}