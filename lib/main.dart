import 'package:al_bayan_quran/firebase_options.dart';
import 'package:al_bayan_quran/screens/drawer/settings_with_appbar.dart';
import 'package:al_bayan_quran/screens/favorite_bookmark_notes/book_mark.dart';
import 'package:al_bayan_quran/screens/favorite_bookmark_notes/favorite.dart';
import 'package:al_bayan_quran/screens/favorite_bookmark_notes/notes_v.dart';
import 'package:al_bayan_quran/screens/home_mobile.dart';
import 'package:al_bayan_quran/screens/surah_view.dart/surah_with_translation.dart';
import 'package:al_bayan_quran/screens/unknown/unknown.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:url_strategy/url_strategy.dart';

import 'collect_info/collect_info_layout_responsive.dart';
import 'collect_info/init.dart';
import 'data/download/download.dart';
import 'theme/theme_controller.dart';
import 'package:appwrite/appwrite.dart';

Future<void> main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  Client client = Client();
  client
      .setEndpoint('https://cloud.appwrite.io/v1')
      .setProject('albayanquran')
      .setSelfSigned(status: true);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter("al_bayan_quran");
  await Hive.openBox("info");
  await Hive.openBox("data");
  await Hive.openBox("accountInfo");
  await Hive.openBox("notes");
  await Hive.openBox("quran");
  await Hive.openBox("translation");
  await Hive.openBox(quranScriptType);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Al-Quran',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark().copyWith(
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.grey.shade800),
      ),
      themeMode: ThemeMode.system,
      onInit: () async {
        final appTheme = Get.put(AppThemeData());
        appTheme.initTheme();
      },
      initialRoute: "/",
      routes: {
        "/": (p0) => const StartUpPage(),
      },
      onGenerateRoute: (route) {
        if (route.name == null) {
          return MaterialPageRoute(builder: (context) => const StartUpPage());
        }
        final box = Hive.box("info");
        final info = box.get("info", defaultValue: false);
        final dataBox = Hive.box("data");
        if (info == false) {
          return MaterialPageRoute(
            builder: (context) => const CollectInfoResponsive(pageNumber: 0),
          );
        }

        if (!(dataBox.get('quran_info', defaultValue: false) &&
            dataBox.get('quran', defaultValue: false) &&
            dataBox.get('translation', defaultValue: false) &&
            dataBox.get('tafseer', defaultValue: false))) {
          return MaterialPageRoute(
            builder: (context) => DownloadData(
              index: listOfHomePages.indexOf(route.name!.replaceAll("/", "")),
              nextRoute: route.name,
            ),
          );
        }

        if (route.name == "" || route.name == "/") {
          return MaterialPageRoute(
            builder: (context) => const SettingsWithAppbar(),
            settings: const RouteSettings(name: "/home"),
          );
        }

        if (route.name == "/home" ||
            route.name == "home" ||
            route.name!.contains("home")) {
          return MaterialPageRoute(
            builder: (context) => const HomeMobile(),
            settings: const RouteSettings(name: "/home"),
          );
        }

        if (route.name == "settings" || route.name == "/settings") {
          return MaterialPageRoute(
            builder: (context) => const SettingsWithAppbar(),
            settings: const RouteSettings(name: "/settings"),
          );
        }

        if (route.name == "notes" ||
            route.name == "note" ||
            route.name == "/notes") {
          return MaterialPageRoute(
            builder: (context) => const NotesView(),
            settings: const RouteSettings(name: "/notes"),
          );
        }
        if (route.name == "favorites" ||
            route.name == "favorite" ||
            route.name == "/favorite") {
          return MaterialPageRoute(
            builder: (context) => const Favorite(),
            settings: const RouteSettings(name: "/favorite"),
          );
        }
        if (route.name == "book-mark" || route.name == "/book-mark") {
          return MaterialPageRoute(
            builder: (context) => const BookMark(),
            settings: const RouteSettings(name: "/book-mark"),
          );
        }
        if (route.name!.contains("audio")) {
          if (route.name!.contains("?")) {
            try {
              int chapter = int.parse(route.name!.split("?")[1].split("=")[1]);
              return MaterialPageRoute(
                builder: (context) => HomeMobile(
                  playChapter: chapter,
                  bootomNavigationIndex: 1,
                ),
              );
              // ignore: empty_catches
            } catch (e) {}
          }
          return MaterialPageRoute(
            builder: (context) => const HomeMobile(
              bootomNavigationIndex: 1,
            ),
            settings: const RouteSettings(name: "/audio"),
          );
        }
        if (route.name == "profile" ||
            route.name == "profile" ||
            route.name == "/profile") {
          return MaterialPageRoute(
            builder: (context) => const HomeMobile(
              bootomNavigationIndex: 2,
            ),
            settings: const RouteSettings(name: "/profile"),
          );
        }
        if (route.name!.contains("surah")) {
          String path = route.name ?? "surah";
          if (path.contains("?")) {
            String args = path.split("?")[1];
            if (args.contains("=")) {
              if (args.contains("&")) {
                try {
                  int chapter = int.parse(args.split("&")[0].split("=")[1]);
                  int ayah = int.parse(args.split("&")[1].split("=")[1]);
                  if (chapter > 114) {
                    return MaterialPageRoute(
                      builder: (context) => const Unknown(),
                      settings: const RouteSettings(name: "/unknown"),
                    );
                  } else {
                    return MaterialPageRoute(
                      builder: (context) => SuraView(
                        surahNumber: chapter - 1,
                        surahName: "Chapter : $chapter",
                        scrollToAyah: ayah,
                      ),
                      settings: RouteSettings(
                          name: "/surah?chapter=$chapter&verse=$ayah"),
                    );
                  }
                } catch (e) {
                  return MaterialPageRoute(
                    builder: (context) => const Unknown(),
                    settings: const RouteSettings(name: "/unknown"),
                  );
                }
              } else {
                if (args.contains("=")) {
                  try {
                    int chapter = int.parse(args.split("=")[1]);
                    if (chapter > 114) {
                      return MaterialPageRoute(
                        builder: (context) => const Unknown(),
                        settings: const RouteSettings(name: "/unknown"),
                      );
                    } else {
                      return MaterialPageRoute(
                        builder: (context) => SuraView(
                          surahNumber: chapter - 1,
                          surahName: "Chapter : $chapter",
                        ),
                        settings:
                            RouteSettings(name: "/surah?chapter=$chapter"),
                      );
                    }
                  } catch (e) {
                    return MaterialPageRoute(
                      builder: (context) => const Unknown(),
                      settings: const RouteSettings(name: "/unknown"),
                    );
                  }
                }
              }
            } else {
              try {
                int chapter = int.parse(args);
                if (chapter > 114) {
                  return MaterialPageRoute(
                    builder: (context) => const Unknown(),
                    settings: const RouteSettings(name: "/unknown"),
                  );
                } else {
                  return MaterialPageRoute(
                    builder: (context) => SuraView(
                      surahNumber: chapter - 1,
                      surahName: "Chapter : $chapter",
                    ),
                    settings: RouteSettings(name: "/surah?chapter=$chapter"),
                  );
                }
              } catch (e) {
                return MaterialPageRoute(
                  builder: (context) => const Unknown(),
                  settings: const RouteSettings(name: "/unknown"),
                );
              }
            }
          } else if (path.contains("/")) {
            try {
              int chapter = int.parse(path.split('/')[2]);
              if (chapter > 114) {
                return MaterialPageRoute(
                  builder: (context) => const Unknown(),
                  settings: const RouteSettings(name: "/unknown"),
                );
              } else {
                return MaterialPageRoute(
                  builder: (context) => SuraView(
                    surahNumber: chapter - 1,
                    surahName: "Chapter : $chapter",
                  ),
                  settings: RouteSettings(name: "/surah?chapter=$chapter"),
                );
              }
            } catch (e) {
              return MaterialPageRoute(
                builder: (context) => const Unknown(),
                settings: const RouteSettings(name: "/unknown"),
              );
            }
          } else {
            return MaterialPageRoute(
              builder: (context) => const HomeMobile(
                bootomNavigationIndex: 0,
              ),
              settings: const RouteSettings(name: "/surah"),
            );
          }
        }
        return MaterialPageRoute(builder: (context) => const StartUpPage());
      },
    );
  }
}

List<String> listOfHomePages = ["home", "audio", "profile"];

class StartUpPage extends StatefulWidget {
  const StartUpPage({super.key});

  @override
  State<StartUpPage> createState() => _StartUpPageState();
}

class _StartUpPageState extends State<StartUpPage> {
  @override
  Widget build(BuildContext context) {
    return const InIt();
  }
}
