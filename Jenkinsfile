pipeline {
    agent any

    parameters {
        choice(
            name: 'PLATFORM',
            choices: ['Android', 'iOS', 'Both'],
            description: 'Select the platform(s) to build.'
        )
        
        // Active Choice Parameter for Dynamic Flavor Selection
        activeChoice(
            name: 'FLAVOR',
            choiceType: 'PT_SINGLE_SELECT',
            description: 'Select the flavor to build.',
            script: [
                $class: 'GroovyScript',
                script: [
                    $class: 'SecureGroovyScript',
                    script: '''
                        def flavors = []
                        try {
                            // Professional path detection: Priority Workspace -> Hardcoded Fallback
                            def path = System.getenv("WORKSPACE") ?: "/Users/hardikp/.jenkins/workspace/FlutterMultimoduleArchitecture"
                            def gradleFile = new File(path, "android/app/build.gradle.kts")
                            
                            if (gradleFile.exists()) {
                                // Optimized regex to capture flavor names from Kotlin DSL
                                def matcher = gradleFile.text =~ /create\\s*\\(\\s*["']([^"']+)["']\\s*\\)/
                                while (matcher.find()) {
                                    def f = matcher.group(1)
                                    // Filter out non-flavor Gradle configurations
                                    if (!["release", "debug", "config", "implementation", "test"].contains(f)) {
                                        flavors.add(f)
                                    }
                                }
                            }
                        } catch (Exception e) { /* Fallback to defaults on any error */ }
                        
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
            description: 'Select the Build Type (Variant).'
        )
        
        gitParameter(
            name: 'BRANCH_TO_BUILD', 
            type: 'PT_BRANCH', 
            defaultValue: 'master', 
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
        FLUTTER_HOME = "${HOME}/flutter"
        // Ensure Homebrew and standard binary paths are included for CocoaPods
        PATH = "/opt/homebrew/bin:/usr/local/bin:${env.FLUTTER_HOME}/bin:${env.PATH}"
        REPO_URL = 'https://github.com/hardikpatel679/FlutterMultimoduleArchitecture.git'
    }

    stages {
        stage('Initialize') {
            steps {
                script {
                    try {
                        def rawBranch = params.BRANCH_TO_BUILD ?: "master"
                        env.CURRENT_BRANCH = rawBranch
                        echo "Building Branch: ${env.CURRENT_BRANCH}"

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
                sh 'flutter clean' // Clean old build artifacts to ensure fresh archives
                sh 'flutter doctor'
                sh 'pod --version'
                sh 'flutter pub get'
            }
        }

        stage('Unit Test and Code Coverage') {
            steps {
                script {
                    try {
                        echo "--- Running Multi-Module Unit Tests and Checking Coverage ---"
                        
                        def modules = ['.', 'packages/core', 'packages/domain', 'packages/network', 'packages/features/login_module']
                        def totalLinesFound = 0
                        def totalLinesHit = 0

                        for (module in modules) {
                            if (fileExists("${module}/pubspec.yaml")) {
                                echo "Testing module: ${module}"
                                dir(module) {
                                    sh 'flutter pub get'
                                    // Only run coverage if there is a test directory
                                    if (fileExists('test')) {
                                        sh 'flutter test --coverage'
                                        
                                        if (fileExists('coverage/lcov.info')) {
                                            def lcovContent = readFile('coverage/lcov.info')
                                            def lines = lcovContent.split('\n')
                                            for (int i = 0; i < lines.length; i++) {
                                                def line = lines[i].trim()
                                                if (line.startsWith('LF:')) {
                                                    totalLinesFound += (line.split(':')[1] as Integer)
                                                } else if (line.startsWith('LH:')) {
                                                    totalLinesHit += (line.split(':')[1] as Integer)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        if (totalLinesFound == 0) {
                            error("No coverage data found in any module.")
                        }
                        
                        float coverage = (totalLinesHit / totalLinesFound) * 100
                        echo "Aggregated Project Coverage: ${String.format('%.2f', coverage)}% (${totalLinesHit}/${totalLinesFound} lines)"
                        
                        // Per-module breakdown for debugging
                        echo "--- Coverage Breakdown ---"
                        for (module in modules) {
                            def lcovPath = "${module}/coverage/lcov.info"
                            if (fileExists(lcovPath)) {
                                def content = readFile(lcovPath)
                                def mFound = 0
                                def mHit = 0
                                def mLines = content.split('\n')
                                for (int j = 0; j < mLines.length; j++) {
                                    def l = mLines[j].trim()
                                    if (l.startsWith('LF:')) {
                                        mFound += (l.split(':')[1] as Integer)
                                    } else if (l.startsWith('LH:')) {
                                        mHit += (l.split(':')[1] as Integer)
                                    }
                                }
                                if (mFound > 0) {
                                    def mPerc = (mHit / mFound) * 100
                                    echo "${module}: ${String.format('%.2f', mPerc)}% (${mHit}/${mFound})"
                                }
                            }
                        }

                        if (coverage < 90.0) {
                            error("Total project coverage ${String.format('%.2f', coverage)}% is below the required 90% threshold.")
                        }
                    } catch (Exception e) {
                        currentBuild.description = "Failed at Unit Tests/Coverage: ${e.message}"
                        error("Unit Test or Coverage verification failed: ${e.message}")
                    }
                }
            }
        }

        stage('FVT (Functional Verification Tests)') {
            steps {
                script {
                    try {
                        echo "--- Running Functional Verification Tests for flavor: ${env.SELECTED_FLAVOR} ---"
                        // Specify flavor to avoid building extra APKs for all flavors
                        sh "flutter test integration_test --flavor ${env.SELECTED_FLAVOR}"
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
                    // Archive all APKs found in the build directory
                    archiveArtifacts artifacts: '**/build/**/outputs/flutter-apk/*.apk', fingerprint: true
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
                        echo "Building iOS for flavor: ${env.SELECTED_FLAVOR}"
                        // Build the iOS app bundle
                        sh "flutter build ios --flavor ${env.SELECTED_FLAVOR} --${env.SELECTED_VARIANT} --no-codesign"
                        
                        // Package the .app into a ZIP so you have a downloadable build artifact
                        sh "cd build/ios/iphoneos && zip -r ../../../Runner-iOS-${env.SELECTED_FLAVOR}.zip Runner.app"
                    } catch (Exception e) {
                        currentBuild.description = "Failed at Build iOS: ${e.message}"
                        error("iOS Build failed.")
                    }
                }
            }
            post {
                success {
                    // Archive the ZIP and the xcarchive
                    archiveArtifacts artifacts: '*.zip', fingerprint: true
                    archiveArtifacts artifacts: 'build/ios/archive/*.xcarchive/**', allowEmptyArchive: true, fingerprint: true
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
            echo "Pipeline finished. Current coverage files preserved."
            // cleanWs() // Keep workspace to allow parameter scripts to read it
        }
    }
}
