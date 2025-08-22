plugins {
    alias(libs.plugins.buildlogic.android.feature)
}

android {
    namespace = "com.blank.feature.home"
}

dependencies {
    implementation(project(":core"))
}
