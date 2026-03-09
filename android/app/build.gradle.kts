plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter Gradle Plugin Android va Kotlin dan keyin bo'lishi shart
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.rdr"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.rdr"
        
        // Kamera va ML Kit uchun minSdk kamida 21 bo'lishi shart
        // Agar iloji bo'lsa 24 qiling, lekin 21 ko'p qurilmalarga mos keladi
        minSdk = flutter.minSdkVersion 
        
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Debug key bilan release qilish faqat vaqtinchalik test uchun
            signingConfig = signingConfigs.getByName("debug")
            
            // Kodni optimallashtirish (ixtiyoriy)
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Agar qo'shimcha native kutubxonalar kerak bo'lsa shu yerga yoziladi
}
