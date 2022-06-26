import 'package:firebase_service_learning/create_user_page.dart';
import 'package:firebase_service_learning/login_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';

// ルーティング設定用ファイル
// 名前付きルートはこうしてまとめておいても良い
final GoRouter router = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: '/', // ベース：認証状態を識別してホーム画面orログインへ遷移させる
      builder: (BuildContext context, GoRouterState state) =>
          const MyHomePage(),
    ),
    GoRoute(
      path: '/auth/login', // ログインページ
      builder: (BuildContext context, GoRouterState state) => const LoginPage(),
    ),
    GoRoute(
      path: '/auth/create', // 新規登録ページ
      builder: (BuildContext context, GoRouterState state) =>
          const CreateUserPage(),
    ),
    // Note: DetailページはMapデータを渡したかったのだが、再現しきれなかったので後日対応
    // GoRoute(
    //     path: '/chatList/detail',
    //     builder: (BuildContext context, GoRouterState state) {
    //       return ChatDetailPage(roomId: roomId, readUsers: readUsers);
    //     }),
  ],
  // ignore: avoid_redundant_argument_values
  initialLocation: '/',
);
