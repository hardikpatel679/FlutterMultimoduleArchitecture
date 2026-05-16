pipeline {
    agent any

    environment {
        // Ensuring a clean, predictable Flutter environment
        FLUTTER_HOME = "/Users/hardikp/flutter" // Update this path if different
        PATH         = "${env.FLUTTER_HOME}/bin:${env.PATH}"
    }

    stages {
        stage('Environment Setup') {
            steps {
                echo 'Checking Flutter installation...'
                sh 'flutter --version'
            }
        }

        stage('Install Dependencies') {
            steps {
                echo 'Cleaning and pulling fresh pub packages...'
                sh 'flutter clean'
                sh 'flutter pub get'
            }
        }

        stage('Code Analysis & Linting') {
            steps {
                echo 'Running static analysis...'
                // Fails the pipeline if there are unaddressed linter errors
                sh 'flutter analyze'
            }
        }

        stage('Run Unit & Widget Tests') {
            steps {
                echo 'Executing unit and widget test cases...'
                // Runs all files ending with _test.dart in the test/ directory
                sh 'flutter test --coverage'
            }
        }

        stage('Run Integration Tests') {
            steps {
                echo 'Executing integration/UI test cases...'
                /* * NOTE: Integration tests require a running emulator/simulator 
                 * or a physical device connected to your Jenkins Mac mini/host.
                 */
                // For standard Flutter integration tests:
                sh 'flutter test integration_test'
                
                // OR if you use Patrol for multi-module UI testing, uncomment below:
                // sh 'patrol test --target integration_test/app_test.dart'
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace active test caches...'
        }
        success {
            echo 'CI/CD Pipeline succeeded! All test cases passed flawlessly.'
        }
        failure {
            echo 'Pipeline failed. Please review the compilation errors or test failure logs above.'
        }
    }
}
