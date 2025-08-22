package com.blank.navigation

import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.blank.navigation.MainNavigation.SplashNavigation
import com.blank.navigation.MainNavigation.HomeNavigation
import com.blank.feature.home.HomeScreen
import com.blank.feature.splash.SplashScreen

@Composable
fun MainNavGraph(
    modifier: Modifier = Modifier,
    navController: NavHostController = rememberNavController(),
    startDestination: MainNavigation = SplashNavigation,
    ) {

    NavHost(
        navController = navController,
        startDestination = startDestination,
        modifier = modifier
    ) {
        composable<SplashNavigation> {
            SplashScreen(modifier) {
                navController.navigate(HomeNavigation)
            }
        }
        composable<HomeNavigation> {
            HomeScreen()
        }

    }
}
