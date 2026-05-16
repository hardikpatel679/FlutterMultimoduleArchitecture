pipeline {
    agent any

    stages {
        stage('Environment Check') {
            steps {
                echo 'Checking Flutter and Dart installations...'
                sh '#!/bin/bash -l\n flutter --version'
                sh '#!/bin/bash -l\n dart --version'
            }
        }

        stage('Install Dependencies') {
            steps {
                echo 'Fetching dependencies...'
                sh '#!/bin/bash -l\n flutter pub get'
            }
        }

        stage('Code Analysis') {
            steps {
                echo 'Running lint and analysis...'
                sh '#!/bin/bash -l\n flutter analyze || true'
            }
        }

        stage('Build APK') {
            steps {
                echo 'Building production release APK...'
                // Running from the root directory fixes Flutter\'s pathing mechanism
                sh '#!/bin/bash -l\n flutter build apk --release'
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
            // Automatically searches the actual Jenkins workspace for the compiled package
            archiveArtifacts artifacts: 'FlutterMultimoduleArchitecture/build/app/outputs/flutter-apk/app-release.apk', allowEmptyArchive: true
        }
        failure {
            echo 'Pipeline failed. Check build logs for specific compilation errors.'
        }
    }
}
