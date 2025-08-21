plugins {
    alias(libs.plugins.android.library)
    alias(libs.plugins.kotlin.android)
}

android {
    namespace = "com.blank.domain"
    compileSdk = 36

    defaultConfig {
        minSdk = 24
    }
}

dependencies {
    implementation(libs.androidx.core.ktx)
}
