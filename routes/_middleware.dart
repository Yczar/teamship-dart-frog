import 'package:dart_frog/dart_frog.dart';
import 'package:team_ship_dart_frog/middlewares/bearer_auth_middleware.dart';
import 'package:team_ship_dart_frog/middlewares/db_middleware.dart';

Handler middleware(Handler handler) =>
    handler.use(requestLogger()).use(dbMiddleware).use(bearerAuthMiddleware);
