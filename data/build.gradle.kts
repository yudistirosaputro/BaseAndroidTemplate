plugins {
    alias(libs.plugins.buildlogic.android.library)
}

android {
    namespace = "com.blank.data"
}

dependencies {
    implementation(libs.androidx.core.ktx)
}
