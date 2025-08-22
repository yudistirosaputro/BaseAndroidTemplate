package com.blank.navigation

import kotlinx.serialization.Serializable

sealed class MainNavigation {
    @Serializable
    object SplashNavigation : MainNavigation()

    @Serializable
    object HomeNavigation : MainNavigation()
}

