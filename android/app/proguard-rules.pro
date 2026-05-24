# ML Kit — preserve classes used via reflection
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_pose.** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_pose_common.** { *; }

# TensorFlow Lite (bundled inside ML Kit accurate model)
-keep class org.tensorflow.** { *; }
-keep class org.tensorflow.lite.** { *; }

# Keep native method bindings
-keepclassmembers class * {
    native <methods>;
}
