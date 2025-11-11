@echo off
echo ========================================
echo Socket Test Runner
echo ========================================
echo.

:menu
echo Select test option:
echo 1. Run all socket tests
echo 2. Run SocketService tests only
echo 3. Run SocketManager tests only
echo 4. Run SocketChecker tests only
echo 5. Run Integration tests only
echo 6. Run Stream tests only
echo 7. Run all tests with verbose output
echo 8. Run all project tests
echo 9. Exit
echo.

set /p choice="Enter your choice (1-9): "

if "%choice%"=="1" (
    echo.
    echo Running all socket tests...
    flutter test test/socket_test.dart
    goto end
)

if "%choice%"=="2" (
    echo.
    echo Running SocketService tests...
    flutter test test/socket_test.dart --name "SocketService Tests"
    goto end
)

if "%choice%"=="3" (
    echo.
    echo Running SocketManager tests...
    flutter test test/socket_test.dart --name "SocketManager Tests"
    goto end
)

if "%choice%"=="4" (
    echo.
    echo Running SocketChecker tests...
    flutter test test/socket_test.dart --name "SocketChecker Tests"
    goto end
)

if "%choice%"=="5" (
    echo.
    echo Running Integration tests...
    flutter test test/socket_test.dart --name "Socket Integration Tests"
    goto end
)

if "%choice%"=="6" (
    echo.
    echo Running Stream tests...
    flutter test test/socket_test.dart --name "Socket Stream Tests"
    goto end
)

if "%choice%"=="7" (
    echo.
    echo Running all socket tests with verbose output...
    flutter test test/socket_test.dart --verbose
    goto end
)

if "%choice%"=="8" (
    echo.
    echo Running all project tests...
    flutter test
    goto end
)

if "%choice%"=="9" (
    echo.
    echo Exiting...
    exit /b
)

echo Invalid choice. Please try again.
echo.
goto menu

:end
echo.
echo ========================================
echo Test execution completed!
echo ========================================
pause
