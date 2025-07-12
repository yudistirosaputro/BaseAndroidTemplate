package com.blank.basetemplate.ui

import kotlinx.serialization.Serializable

sealed class MainNavigation {
    @Serializable
    object SplashNavigation : MainNavigation()

    @Serializable
    object HomeNavigation : MainNavigation()
}
