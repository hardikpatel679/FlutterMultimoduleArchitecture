import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.hdapp.flutter_basics"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlin {
        compilerOptions {
            jvmTarget.set(JvmTarget.JVM_17)
        }
    }

    defaultConfig {
        applicationId = "com.hdapp.flutter_basics"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    flavorDimensions += "version"
    productFlavors {
        create("dev") {
            dimension = "version"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            isDefault = true
        }
        create("mock") {
            dimension = "version"
            applicationIdSuffix = ".mock"
            versionNameSuffix = "-mock"
        }
        create("prod") {
            dimension = "version"
        }
    }

    buildTypes {
        getByName("debug") {
            signingConfig = signingConfigs.getByName("debug")
        }
        getByName("release") {
            // Signing with debug keys so 'flutter run --release' works without a keystore
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

// Professional Workaround:
// When clicking the 'Play' button in Android Studio, it often triggers 'assembleDebug' 
// which doesn't specify a flavor. This block ensures that 'assembleDebug' always 
// results in a valid APK being found in the default Flutter path by fallbacking to 'dev'.
tasks.whenTaskAdded {
    if (name == "assembleDebug") {
        dependsOn("assembleDevDebug")
        finalizedBy("copyFlavoredApkToDefault")
    }
}

tasks.register<Copy>("copyFlavoredApkToDefault") {
    val buildDir = project.layout.buildDirectory.get().asFile
    from("$buildDir/outputs/apk/dev/debug/app-dev-debug.apk")
    into("$buildDir/outputs/flutter-apk/")
    rename { "app-debug.apk" }
    duplicatesStrategy = DuplicatesStrategy.INCLUDE
}

flutter {
    source = "../.."
    
    // Auto-select target based on flavor
    val taskNames = project.gradle.startParameter.taskNames
    when {
        taskNames.any { it.contains("mock", ignoreCase = true) } -> target = "lib/main_mock.dart"
        taskNames.any { it.contains("prod", ignoreCase = true) } -> target = "lib/main_prod.dart"
        else -> target = "lib/main.dart"
    }
}
