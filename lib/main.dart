import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_colors.dart';
import 'presentation/providers/movie_provider.dart';
import 'presentation/providers/search_provider.dart';
import 'presentation/providers/favorite_provider.dart';
import 'routes/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: MaterialApp.router(
        title: 'MyMovies',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: AppColors.kBackground,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.kPrimary,
            brightness: Brightness.dark,
            primary: AppColors.kPrimary,
            surface: AppColors.kSurface,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.kBackground,
            elevation: 0,
          ),
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
