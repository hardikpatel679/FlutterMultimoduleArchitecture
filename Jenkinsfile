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
        
        // Use the explicit $class syntax to resolve the SecureGroovyScript type error
        activeChoice(
            name: 'FLAVOR',
            choiceType: 'PT_SINGLE_SELECT',
            description: 'Select the flavor to build (dynamically fetched from code).',
            script: [
                $class: 'GroovyScript',
                script: [
                    $class: 'SecureGroovyScript',
                    script: '''
                        import jenkins.model.Jenkins
                        def foundFlavors = []
                        try {
                            def jobName = null
                            def vars = binding.variables
                            if (vars.containsKey('JOB_NAME')) {
                                jobName = vars.get('JOB_NAME')
                            } else if (vars.containsKey('jenkinsProject')) {
                                jobName = vars.get('jenkinsProject').fullName
                            } else if (vars.containsKey('project')) {
                                jobName = vars.get('project').fullName
                            }
                            
                            if (jobName == null) return ["Error: Job name not found"]
                            
                            def job = Jenkins.get().getItemByFullName(jobName)
                            if (job == null) return ["Error: Job not found: " + jobName]
                            
                            def workspace = null
                            def build = job.getLastBuild()
                            
                            // Iterate back through builds to find one with a valid workspace directory that still exists
                            while (build != null && workspace == null) {
                                def tempWs = null
                                for (action in build.getActions()) {
                                    if (action.getClass().getName().contains("WorkspaceAction")) {
                                        tempWs = action.getWorkspace()
                                        break
                                    }
                                }
                                if (tempWs != null && tempWs.exists()) {
                                    workspace = tempWs
                                } else {
                                    build = build.getPreviousBuild()
                                }
                            }

                            if (workspace == null) return ["Error: No workspace found. Run build once."]
                            
                            def gradleFile = workspace.child("android/app/build.gradle.kts")
                            if (!gradleFile.exists()) return ["Error: android/app/build.gradle.kts not found in " + workspace.getRemote()]
                            
                            def text = gradleFile.readToString()
                            // Correct regex for Groovy triple-single-quoted strings
                            // We use character classes for parens to avoid escaping issues
                            def matcher = text =~ /create[ \t]*[(][ \t]*["'](.+?)["'][ \t]*[)]/
                            while (matcher.find()) {
                                def f = matcher.group(1)
                                if (!["release", "debug", "config", "implementation", "test", "android"].contains(f)) {
                                    foundFlavors.add(f)
                                }
                            }
                        } catch (Exception e) {
                            return ["Error: " + e.getMessage()]
                        }
                        return foundFlavors.unique().sort() ?: ["Error: No flavors detected in file"]
                    ''',
                    sandbox: true
                ],
                fallbackScript: [
                    $class: 'SecureGroovyScript',
                    script: 'return ["Error: Script failed"]',
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
        FLUTTER_HOME = "${HOME}/flutter"
        PATH = "${env.FLUTTER_HOME}/bin:${env.PATH}"
        REPO_URL = 'https://github.com/hardikpatel679/FlutterMultimoduleArchitecture.git'
    }

    stages {
        stage('Initialize') {
            steps {
                script {
                    try {
                        def rawBranch = params.BRANCH_TO_BUILD ?: env.BRANCH_NAME ?: "master"
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
                        
                        // Use a more CPS-friendly way to parse the file
                        def lcovContent = readFile('coverage/lcov.info')
                        if (!lcovContent) {
                            error("coverage/lcov.info is empty or not found")
                        }

                        def linesFound = 0
                        def linesHit = 0
                        
                        // Split by newline and iterate
                        def lines = lcovContent.split('\n')
                        for (int i = 0; i < lines.length; i++) {
                            def line = lines[i].trim()
                            if (line.startsWith('LF:')) {
                                linesFound += (line.split(':')[1] as Integer)
                            } else if (line.startsWith('LH:')) {
                                linesHit += (line.split(':')[1] as Integer)
                            }
                        }
                        
                        if (linesFound == 0) {
                            error("No coverage data found in coverage/lcov.info (LF count is 0)")
                        }
                        
                        float coverage = (linesHit / linesFound) * 100
                        echo "Current Coverage: ${String.format('%.2f', coverage)}% (${linesHit}/${linesFound} lines)"
                        
                        if (coverage < 90.0) {
                            error("Code coverage ${String.format('%.2f', coverage)}% is below the required 90% threshold.")
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
