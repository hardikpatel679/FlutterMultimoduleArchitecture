pipeline {
    agent any

    environment {
        // Defines path to Flutter SDK if not globally set in your Jenkins agent path
        FLUTTER_HOME = "/opt/flutter" 
        PATH         = "${env.FLUTTER_HOME}/bin:${env.PATH}"
    }

    stages {
        stage('Environment Check') {
            steps {
                echo 'Checking Flutter and Dart installations...'
                sh 'flutter --version'
                sh 'dart --version'
            }
        }

        stage('Install Melos') {
            steps {
                echo 'Activating Melos for multi-module dependency tracking...'
                // Melos cleanly bootstraps and handles multiple local packages/modules
                sh 'dart pub global activate melos'
                // Ensure globally activated pub packages are in executable path
                env.PATH = "${env.HOME}/.pub-cache/bin:${env.PATH}"
            }
        }

        stage('Bootstrap Modules') {
            steps {
                echo 'Bootstrapping all Flutter sub-modules...'
                // Automatically runs 'flutter pub get' across all internal architecture modules
                sh 'melos bootstrap' 
            }
        }

        stage('Code Analysis & Linting') {
            steps {
                echo 'Running code analysis across the workspace...'
                sh 'melos run analyze'
            }
        }

        stage('Unit Testing') {
            steps {
                echo 'Running unit tests for all internal packages...'
                sh 'melos run test'
            }
        }

        stage('Build APK') {
            steps {
                echo 'Building the main application Android APK...'
                // Navigates to your primary runner module and executes production build
                // Adjust path "apps/main_app" if your runner application lives in a different directory
                dir('apps/main_app') {
                    sh 'flutter build apk --release'
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
            // Archives the compiled APK so you can download it directly from the Jenkins UI
            archiveArtifacts artifacts: 'apps/main_app/build/app/outputs/flutter-apk/app-release.apk', allowEmptyArchive: true
        }
        failure {
            echo 'Pipeline failed. Please review compilation logs.'
        }
    }
}
