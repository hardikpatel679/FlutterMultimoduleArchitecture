pipeline {
    agent any
    stages {
        stage('Environment Check') {
            steps {
                sh 'flutter --version'
            }
        }
        stage('Install Dependencies') {
            steps {
                // Run clean to avoid path caching issues
                sh 'flutter clean' 
                sh 'flutter pub get' 
            }
        }
        stage('Build APK') {
            steps {
                // CRITICAL: Point to your executable module if it's not at the root
                dir('name_of_your_main_app_module') {
                    sh 'flutter build apk --release'
                }
            }
        }
    }
}
