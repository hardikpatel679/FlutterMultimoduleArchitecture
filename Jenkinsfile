pipeline {
    agent any

    // =========================================================================
    // 1. BUILD PARAMETERS
    // These define the options shown in the Jenkins "Build with Parameters" screen.
    // =========================================================================
    parameters {
        choice(
            name: 'PLATFORM',
            choices: ['Android', 'Both', 'iOS'],
            description: 'Select the target platform(s) for the build.'
        )
        
        // Dynamic Flavor Selection using Active Choices Plugin
        // Scans the Android build script to populate a dropdown with project flavors.
        activeChoice(
            name: 'FLAVOR',
            choiceType: 'PT_SINGLE_SELECT',
            description: 'Select the project flavor (e.g., dev, prod, mock).',
            script: [
                $class: 'GroovyScript',
                script: [
                    $class: 'SecureGroovyScript',
                    script: '''
                        def flavors = []
                        try {
                            // Automatically detects the workspace path or uses a local fallback
                            def workspace = System.getenv("WORKSPACE") ?: "."
                            def gradleFile = new File(workspace, "android/app/build.gradle.kts")
                            
                            if (gradleFile.exists()) {
                                // Scans for the pattern create("flavorName") in the Kotlin DSL
                                def matcher = gradleFile.text =~ /create\\s*\\(\\s*["']([^"']+)["']\\s*\\)/
                                while (matcher.find()) {
                                    def f = matcher.group(1)
                                    // Exclude standard build configuration names
                                    if (!["release", "debug", "config", "implementation", "test"].contains(f)) {
                                        flavors.add(f)
                                    }
                                }
                            }
                        } catch (Exception e) { /* Fallback handled below */ }
                        
                        return flavors.unique().sort() ?: ["dev", "prod", "mock"]
                    ''',
                    sandbox: true
                ],
                fallbackScript: [
                    $class: 'SecureGroovyScript',
                    script: 'return ["dev", "prod", "mock"]',
                    sandbox: true
                ]
            ]
        )
        
        choice(
            name: 'VARIANT', 
            choices: ['Release', 'Debug'],
            description: 'Select the build variant (Release for store, Debug for testing).'
        )
        
        gitParameter(
            name: 'BRANCH_TO_BUILD', 
            type: 'PT_BRANCH', 
            defaultValue: 'master', 
            description: 'Select the Git branch to build.',
            sortMode: 'ASCENDING_SMART',
            selectedValue: 'NONE'
        )

        text(
            name: 'RELEASE_NOTES', 
            defaultValue: 'General performance improvements and bug fixes.', 
            description: 'Notes to be included with the build metadata.'
        )
    }

    // =========================================================================
    // 2. CONFIGURABLE ENVIRONMENT VARIABLES
    // Update these variables to match your server environment and repository.
    // =========================================================================
    environment {
        // Path to the Flutter SDK on the Jenkins agent
        FLUTTER_HOME = "${HOME}/flutter"
        
        // Construct System PATH (Includes Homebrew for CocoaPods and Flutter binaries)
        PATH = "/opt/homebrew/bin:/usr/local/bin:${env.FLUTTER_HOME}/bin:${env.PATH}"
        
        // Your project's Git Repository URL
        REPO_URL = 'https://github.com/hardikpatel679/FlutterMultimoduleArchitecture.git'
        
        // The minimum code coverage percentage required to pass the build
        MIN_COVERAGE_THRESHOLD = "90.0"
    }

    stages {
        stage('Initialize') {
            steps {
                script {
                    try {
                        def targetBranch = params.BRANCH_TO_BUILD ?: "master"
                        echo "--- Preparing Build for Branch: ${targetBranch} ---"

                        checkout([$class: 'GitSCM', 
                            branches: [[name: "${targetBranch}"]], 
                            userRemoteConfigs: [[url: "${env.REPO_URL}"]]
                        ])

                        // Set global build variables from parameters
                        env.SELECTED_FLAVOR = params.FLAVOR ?: 'dev'
                        env.SELECTED_VARIANT = params.VARIANT?.toLowerCase() ?: 'release'
                        
                        echo "Configuration: Flavor=${env.SELECTED_FLAVOR}, Variant=${env.SELECTED_VARIANT}"
                    } catch (Exception e) {
                        currentBuild.description = "Initialization Error: ${e.message}"
                        error("Pipeline stopped during initialization.")
                    }
                }
            }
        }

        stage('Clean and Fetch') {
            steps {
                echo "--- Cleaning Build Cache and Fetching Dependencies ---"
                sh 'flutter clean'
                sh 'flutter doctor'
                sh 'flutter pub get'
            }
        }

        stage('Multi-Module Testing & Coverage') {
            steps {
                script {
                    try {
                        echo "--- Analyzing Multi-Module Coverage (Threshold: ${env.MIN_COVERAGE_THRESHOLD}%) ---"
                        
                        // CONFIGURATION: Add paths to all modules that require testing
                        def modules = ['.', 'packages/core', 'packages/domain', 'packages/network', 'packages/features/login_module']
                        def totalLinesFound = 0
                        def totalLinesHit = 0

                        for (module in modules) {
                            if (fileExists("${module}/pubspec.yaml")) {
                                echo "Processing module: ${module}"
                                dir(module) {
                                    sh 'flutter pub get'
                                    if (fileExists('test')) {
                                        sh 'flutter test --coverage'
                                        
                                        if (fileExists('coverage/lcov.info')) {
                                            def lines = readFile('coverage/lcov.info').split('\n')
                                            for (int i = 0; i < lines.length; i++) {
                                                def line = lines[i].trim()
                                                if (line.startsWith('LF:')) totalLinesFound += (line.split(':')[1] as Integer)
                                                else if (line.startsWith('LH:')) totalLinesHit += (line.split(':')[1] as Integer)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        if (totalLinesFound == 0) error("Coverage verification failed: No data found.")
                        
                        float coveragePercent = (totalLinesHit / totalLinesFound) * 100
                        echo "Total Project Coverage: ${String.format('%.2f', coveragePercent)}%"
                        
                        if (coveragePercent < env.MIN_COVERAGE_THRESHOLD.toFloat()) {
                            error("Coverage below threshold! Target: ${env.MIN_COVERAGE_THRESHOLD}%, Actual: ${String.format('%.2f', coveragePercent)}%")
                        }
                    } catch (Exception e) {
                        currentBuild.description = "Test/Coverage Failure: ${e.message}"
                        error("Build aborted due to test or coverage failure.")
                    }
                }
            }
        }

        stage('Functional Verification (FVT)') {
            steps {
                script {
                    try {
                        echo "--- Running Integration Tests for ${env.SELECTED_FLAVOR} ---"
                        sh "flutter test integration_test --flavor ${env.SELECTED_FLAVOR}"
                    } catch (Exception e) {
                        currentBuild.description = "FVT Failure"
                        error("UI Integration tests failed.")
                    }
                }
            }
        }

        stage('Build Android') {
            when { expression { params.PLATFORM == 'Android' || params.PLATFORM == 'Both' } }
            steps {
                script {
                    try {
                        echo "--- Compiling Android APK ---"
                        sh "flutter build apk --flavor ${env.SELECTED_FLAVOR} --${env.SELECTED_VARIANT}"
                    } catch (Exception e) {
                        error("Android Build failed: ${e.message}")
                    }
                }
            }
            post {
                success {
                    // Archives only the APK matching the current configuration
                    archiveArtifacts artifacts: "build/app/outputs/flutter-apk/app-${env.SELECTED_FLAVOR}-${env.SELECTED_VARIANT}.apk", fingerprint: true
                }
            }
        }

        stage('Build iOS') {
            when { expression { params.PLATFORM == 'iOS' || params.PLATFORM == 'Both' } }
            steps {
                script {
                    try {
                        echo "--- Compiling iOS App Bundle ---"
                        sh "flutter build ios --flavor ${env.SELECTED_FLAVOR} --${env.SELECTED_VARIANT} --no-codesign"
                        
                        // Packaging for artifact download
                        sh "cd build/ios/iphoneos && zip -r ../../../Runner-iOS-${env.SELECTED_FLAVOR}.zip Runner.app"
                    } catch (Exception e) {
                        error("iOS Build failed: ${e.message}")
                    }
                }
            }
            post {
                success {
                    // Archive ONLY the zip file matching the currently selected flavor
                    archiveArtifacts artifacts: "Runner-iOS-${env.SELECTED_FLAVOR}.zip", fingerprint: true
                }
            }
        }
    }

    post {
        success {
            script {
                // Clean up other flavors' artifacts to keep the workspace tidy for the NEXT run
                // iOS ZIPs
                sh "find . -name 'Runner-iOS-*.zip' ! -name 'Runner-iOS-${env.SELECTED_FLAVOR}.zip' -delete || true"
                
                // Android APKs (only keeping the one matching current selection)
                def currentApkName = "app-${env.SELECTED_FLAVOR}-${env.SELECTED_VARIANT}.apk"
                sh "find build/app/outputs/flutter-apk -name 'app-*.apk' ! -name '${currentApkName}' -delete || true"
            }
        }
        always {
            echo "--- Pipeline finished. Summary for ${env.SELECTED_FLAVOR}-${env.SELECTED_VARIANT} ---"
            echo "Release Notes: ${params.RELEASE_NOTES}"
        }
    }
}
