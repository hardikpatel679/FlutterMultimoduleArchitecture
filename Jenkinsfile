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
        
        // Requires "Active Choices Plugin"
        // This script runs on the Jenkins controller to find flavors in the workspace
        // NOTE: On the first run, this might be empty until code is checked out.
        // You may need to approve this script in Manage Jenkins > In-process Script Approval.
        // @NonCPS is required for some Jenkins versions.
        activeChoice(
            name: 'FLAVOR',
            choiceType: 'PT_SINGLE_SELECT',
            description: 'Select the flavor to build (dynamically fetched from code).',
            script: groovyScript(
                script: '''
                    def flavors = ["dev", "prod", "mock"]
                    try {
                        // JOB_NAME is available in Active Choices script context
                        def workspacePath = "/var/jenkins_home/workspace/${JOB_NAME}"
                        def gradleFile = new File(workspacePath, "android/app/build.gradle.kts")
                        
                        if (gradleFile.exists()) {
                            def text = gradleFile.text
                            def matcher = text =~ /create\\("([^"]+)"\\)/
                            def foundFlavors = []
                            while (matcher.find()) {
                                def f = matcher.group(1)
                                if (!["release", "debug", "config"].contains(f)) {
                                    foundFlavors << f
                                }
                            }
                            if (foundFlavors) {
                                flavors = foundFlavors
                            }
                        }
                    } catch (e) {
                        // Fallback
                    }
                    return flavors.unique().sort()
                ''',
                fallbackScript: 'return ["dev", "prod", "mock"]'
            )
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

                        env.SELECTED_FLAVOR = params.FLAVOR ?: 'dev'
                        env.SELECTED_VARIANT = params.VARIANT?.toLowerCase() ?: 'release'
                        
                        echo "Build Configuration: Flavor=${env.SELECTED_FLAVOR}, Variant=${env.SELECTED_VARIANT}"
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
            }
        }

        stage('Unit Test and Code Coverage') {
            steps {
                script {
                    try {
                        echo "--- Running Unit Tests and Checking Coverage ---"
                        sh 'flutter test --coverage'
                        
                        // Check coverage threshold (requires lcov on the agent)
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
