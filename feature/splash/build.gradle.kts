plugins {
    alias(libs.plugins.buildlogic.android.feature)
}

android {
    namespace = "com.blank.feature.splash"
}

dependencies {
    implementation(project(":core"))
}
