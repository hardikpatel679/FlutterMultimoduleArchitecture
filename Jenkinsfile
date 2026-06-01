pipeline {
    agent any

    // =========================================================================
    // BUILD PARAMETERS
    // =========================================================================
    parameters {
        choice(
            name: 'PLATFORM',
            choices: ['Android', 'iOS', 'Both'],
            description: 'Select the platform(s) to build.'
        )
        
        // FLAVOR selection is now dynamic and occurs in the 'Initialize' stage 
        // after the code is checked out, ensuring it matches your project's flavors.
        
        choice(
            name: 'VARIANT', 
            choices: ['Release', 'Debug'],
            description: 'Select the Build Type (Variant).'
        )
        
        // Requires Git Parameter Plugin
        gitParameter(
            name: 'BRANCH_TO_BUILD', 
            type: 'PT_BRANCH', 
            defaultValue: 'main', 
            description: 'Select the branch to build',
            sortMode: 'ASCENDING_SMART',
            selectedValue: 'NONE'
        )

        text(
            name: 'RELEASE_NOTES', 
            defaultValue: 'New features and bug fixes.', 
            description: 'Enter the release notes for this build.'
        )
    }

    environment {
        // Path to Flutter SDK on the Jenkins agent
        FLUTTER_HOME = "${HOME}/flutter"
        PATH = "${env.FLUTTER_HOME}/bin:${env.PATH}"
        
        // Project Specifics
        REPO_URL = 'https://github.com/hardikpatel679/AndroidMultimoduleDemo.git'
    }

    stages {
        stage('Initialize') {
            steps {
                script {
                    try {
                        // Resolve branch info
                        def rawBranch = params.BRANCH_TO_BUILD ?: env.BRANCH_NAME ?: "master"
                        env.CURRENT_BRANCH = rawBranch
                        
                        echo "Building Branch: ${env.CURRENT_BRANCH}"

                        // Checkout code
                        checkout([$class: 'GitSCM', 
                            branches: [[name: "${rawBranch}"]], 
                            userRemoteConfigs: [[url: "${env.REPO_URL}"]]
                        ])

                        // Extract flavors dynamically from android/app/build.gradle.kts
                        if (fileExists('android/app/build.gradle.kts')) {
                            env.PROJECT_FLAVORS = sh(script: "grep -o 'create(\"[^\"]*\")' android/app/build.gradle.kts | cut -d'\"' -f2 | grep -vE 'release|debug|config' | sort -u | tr '\\n' ',' | sed 's/,\$//'", returnStdout: true).trim()
                            echo "Detected Project Flavors: ${env.PROJECT_FLAVORS}"
                        }
                        
                        // Dynamically populate flavor selection from detected flavors
                        if (env.PROJECT_FLAVORS) {
                            def flavorList = env.PROJECT_FLAVORS.split(',')
                            env.SELECTED_FLAVOR = input(
                                message: 'Select flavor to build',
                                parameters: [
                                    choice(name: 'FLAVOR', choices: flavorList, description: 'Choose a flavor from the project code')
                                ]
                            )
                        } else {
                            env.SELECTED_FLAVOR = 'dev'
                        }

                        env.SELECTED_VARIANT = params.VARIANT?.toLowerCase() ?: 'release'
                        env.BUILD_ALL = 'false'
                    } catch (Exception e) {
                        currentBuild.description = "Failed at Initialize: ${e.message}"
                        error("Initialization failed: ${e.message}")
                    }
                }
            }
        }

        stage('Prepare') {
            steps {
                sh 'flutter doctor'
                sh 'flutter pub get'
                // If using Melos for multi-module:
                // sh 'dart pub global activate melos'
                // sh 'melos bootstrap'
            }
        }

        stage('Unit Test and Code Coverage') {
            steps {
                script {
                    try {
                        echo "--- Running Unit Tests and Checking Coverage ---"
                        // Run tests with coverage
                        sh 'flutter test --coverage'
                        
                        // Check coverage threshold (requires lcov/genhtml on the agent)
                        // This script extracts the total line coverage percentage
                        def coverageOutput = sh(script: "lcov --summary coverage/lcov.info | grep lines | cut -d ' ' -f 4 | cut -d '%' -f 1", returnStdout: true).trim()
                        float coverage = coverageOutput.toFloat()
                        
                        echo "Current Coverage: ${coverage}%"
                        
                        if (coverage < 90.0) {
                            error("Code coverage ${coverage}% is below the required 90% threshold.")
                        }
                    } catch (Exception e) {
                        currentBuild.description = "Failed at Unit Tests/Coverage: ${e.message}"
                        error("Unit Test or Coverage verification failed.")
                    }
                }
            }
        }

        stage('FVT (Functional Verification Tests)') {
            steps {
                script {
                    try {
                        echo "--- Running Functional Verification Tests ---"
                        // For Flutter, this usually means Integration Tests
                        // You need a running emulator/device or a service like Firebase Test Lab
                        sh 'flutter test integration_test'
                    } catch (Exception _) {
                        currentBuild.description = "Failed at FVT: UI/Integration Tests failed."
                        error("Integration Testing (FVT) failed.")
                    }
                }
            }
        }

        stage('Gate') {
            steps {
                script {
                    echo "--- Quality Gate Passed ---"
                    // You can add manual approval here if needed
                    // input message: 'Approve build for deployment?', ok: 'Deploy'
                }
            }
        }

        stage('Build Android') {
            when {
                expression { params.PLATFORM == 'Android' || params.PLATFORM == 'Both' }
            }
            steps {
                script {
                    try {
                        echo "Building Android APK for flavor: ${env.SELECTED_FLAVOR}"
                        sh "flutter build apk --flavor ${env.SELECTED_FLAVOR} --${env.SELECTED_VARIANT}"
                    } catch (Exception e) {
                        currentBuild.description = "Failed at Build Android: ${e.message}"
                        error("Android Build failed.")
                    }
                }
            }
            post {
                success {
                    archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/*.apk', fingerprint: true
                }
            }
        }

        stage('Build iOS') {
            when {
                expression { params.PLATFORM == 'iOS' || params.PLATFORM == 'Both' }
            }
            steps {
                script {
                    try {
                        // Note: iOS builds require a Mac agent with proper certs
                        echo "Building iOS IPA for flavor: ${env.SELECTED_FLAVOR}"
                        sh "flutter build ipa --flavor ${env.SELECTED_FLAVOR} --${env.SELECTED_VARIANT} --no-codesign"
                    } catch (Exception e) {
                        currentBuild.description = "Failed at Build iOS: ${e.message}"
                        error("iOS Build failed.")
                    }
                }
            }
            post {
                success {
                    archiveArtifacts artifacts: 'build/ios/ipa/*.ipa', fingerprint: true
                }
            }
        }

        stage('Post-Build') {
            steps {
                script {
                    echo "Build Summary:"
                    echo "Platform: ${params.PLATFORM}"
                    echo "Flavor: ${env.SELECTED_FLAVOR}"
                    echo "Variant: ${env.SELECTED_VARIANT}"
                    echo "Release Notes: ${params.RELEASE_NOTES}"
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
