part of '../api_client.export.dart';

enum TokenType { authToken, bearerToken }

class PublicApiOptions {
  Options get options => Options(
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
  );
}

class ProtectedApiOptions {
  ProtectedApiOptions({required this.cacheService, this.tokenType});

  final CacheService cacheService;
  final TokenType? tokenType;

  Future<Options> get options async {
    final bearerToken = await cacheService.bearerToken;
    // final authToken = await cacheService.authToken;
    // final residenceToken = await cacheService.residenceToken;

    log('Bearer Token: $bearerToken');

    return Options(
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (tokenType == TokenType.bearerToken)
          'Authorization': 'Bearer $bearerToken',
        // if (tokenType == TokenType.authToken) 'token': authToken,
        // if (tokenType == TokenType.stripe) 'Authorization': 'Bearer ${Env.stripeSecretKey}',
      },
    );
  }
}
