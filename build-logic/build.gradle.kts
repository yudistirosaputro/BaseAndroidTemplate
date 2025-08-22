plugins {
    `kotlin-dsl`
}

group = "buildlogic"

repositories {
    google()
    mavenCentral()
}

gradlePlugin {
    plugins {
        register("androidApplication") {
            id = "buildlogic.android.application"
            implementationClass = "AndroidApplicationConventionPlugin"
        }
        register("androidLibrary") {
            id = "buildlogic.android.library"
            implementationClass = "AndroidLibraryConventionPlugin"
        }
        register("androidFeature") {
            id = "buildlogic.android.feature"
            implementationClass = "AndroidFeatureConventionPlugin"
        }
    }
}
