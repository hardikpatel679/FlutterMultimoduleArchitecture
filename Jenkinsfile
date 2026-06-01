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
        
        // This will be populated dynamically in some Jenkins setups, 
        // but here we define the standard ones as defaults.
        choice(
            name: 'FLAVOR', 
            choices: ['dev', 'prod', 'mock', 'all'],
            description: 'Select the flavor to build.'
        )
        
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
                        def rawBranch = params.BRANCH_TO_BUILD ?: env.BRANCH_NAME ?: "main"
                        env.CURRENT_BRANCH = rawBranch
                        
                        echo "Building Branch: ${env.CURRENT_BRANCH}"

                        // Checkout code
                        checkout([$class: 'GitSCM', 
                            branches: [[name: "${rawBranch}"]], 
                            userRemoteConfigs: [[url: "${env.REPO_URL}"]]
                        ])

                        // Extract flavors dynamically from android/app/build.gradle.kts if available
                        // This mimics your provided logic but targets the Flutter Android path
                        if (fileExists('android/app/build.gradle.kts')) {
                            env.PROJECT_FLAVORS = sh(script: "grep -o 'create(\"[^\"]*\")' android/app/build.gradle.kts | cut -d'\"' -f2 | grep -vE 'release|debug|config' | sort -u | tr '\\n' ',' | sed 's/,\$//'", returnStdout: true).trim()
                            echo "Detected Project Flavors: ${env.PROJECT_FLAVORS}"
                        }
                        
                        env.SELECTED_FLAVOR = params.FLAVOR ?: 'dev'
                        env.SELECTED_VARIANT = params.VARIANT?.toLowerCase() ?: 'release'
                        env.BUILD_ALL = (env.SELECTED_FLAVOR == 'all').toString()
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
                        if (env.BUILD_ALL == 'true') {
                            def flavors = env.PROJECT_FLAVORS.split(',')
                            for (flavor in flavors) {
                                echo "Building Android APK for flavor: ${flavor}"
                                sh "flutter build apk --flavor ${flavor} --${env.SELECTED_VARIANT}"
                            }
                        } else {
                            echo "Building Android APK for flavor: ${env.SELECTED_FLAVOR}"
                            sh "flutter build apk --flavor ${env.SELECTED_FLAVOR} --${env.SELECTED_VARIANT}"
                        }
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
                        if (env.BUILD_ALL == 'true') {
                            def flavors = env.PROJECT_FLAVORS.split(',')
                            for (flavor in flavors) {
                                echo "Building iOS IPA for flavor: ${flavor}"
                                sh "flutter build ipa --flavor ${flavor} --${env.SELECTED_VARIANT} --no-codesign"
                            }
                        } else {
                            echo "Building iOS IPA for flavor: ${env.SELECTED_FLAVOR}"
                            sh "flutter build ipa --flavor ${env.SELECTED_FLAVOR} --${env.SELECTED_VARIANT} --no-codesign"
                        }
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
