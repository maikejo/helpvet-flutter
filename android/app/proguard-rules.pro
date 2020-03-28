#Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

## don't waring Flutter
-dontwarn io.flutter.app.**
-dontwarn io.flutter.plugin.**
-dontwarn io.flutter.util.**
-dontwarn io.flutter.view.**
-dontwarn io.flutter.**
-dontwarn io.flutter.plugins.**
-dontwarn io.flutter.embedding.**

-dontwarn com.google.firebase.**
-keep class com.google.firebase.** { *; }
-keep interface com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**