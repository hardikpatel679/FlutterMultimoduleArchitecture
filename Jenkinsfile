pipeline {
    agent any

    environment {
        // Change this path to match the folder right before /bin/flutter from Step 1
        FLUTTER_HOME = "/Users/hardikp/developer/flutter" 
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
                echo 'Fetching dependencies...'
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
