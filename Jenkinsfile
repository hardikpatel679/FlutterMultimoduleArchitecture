pipeline {
    agent any

    environment {
        // Points Jenkins to the local Flutter installation path on the server
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

        stage('Install Dependencies') {
            steps {
                echo 'Fetching dependencies for all architecture modules...'
                // Script block allows native Groovy commands to update environment variables
                script {
                    sh 'dart pub global activate melos'
                    env.PATH = "${env.HOME}/.pub-cache/bin:${env.PATH}"
                }
                
                // If using Melos, uncomment the line below:
                // sh 'melos bootstrap'
                
                // Alternative: Native fallback to manually pull packages in your multi-module setup
                sh 'flutter pub get'
            }
        }

        stage('Code Analysis') {
            steps {
                echo 'Running lint and analysis...'
                sh 'flutter analyze'
            }
        }

        stage('Build APK') {
            steps {
                echo 'Building production release APK...'
                sh 'flutter build apk --release'
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
            archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/app-release.apk', allowEmptyArchive: true
        }
        failure {
            echo 'Pipeline failed. Check build logs for specific compilation errors.'
        }
    }
}
