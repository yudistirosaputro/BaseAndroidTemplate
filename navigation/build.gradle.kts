plugins {
    alias(libs.plugins.buildlogic.android.feature)
    alias(libs.plugins.kotlinSerialization)
}

android {
    namespace = "com.blank.navigation"
}

dependencies {
    implementation(libs.serialization.json)
}
