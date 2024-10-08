import 'dart:html' as html;

final _localStorage = html.window.localStorage;

Future<bool> hasAccessToken(String persistSessionKey) async =>
    _localStorage.containsKey(persistSessionKey);

Future<String?> accessToken(String persistSessionKey) async =>
    _localStorage[persistSessionKey];

Future<void> removePersistedSession(String persistSessionKey) async =>
    _localStorage.remove(persistSessionKey);

Future<void> persistSession(
        String persistSessionKey, String persistSessionString) async =>
    _localStorage[persistSessionKey] = persistSessionString;
