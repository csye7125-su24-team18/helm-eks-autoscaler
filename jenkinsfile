pipeline {
    agent any
    environment {
        GITHUB_PAT = credentials('github_pat')
        DOCKER_CREDS = credentials('dockerhub-credentials')
        DOCKER_REGISTRY = 'hsa404/assignments'
        GIT_LOCAL_BRANCH = 'main'
    }

    stages {

        stage('Check Commit Message') {
            when {
                not {
                    branch 'main'
                }
            }
            steps {
                script {
                    String commitMessage = sh(script: 'git log -1 --pretty=%B', returnStdout: true).trim()
                    def conventionalCommitRegex = /^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|\w+)(\(.+\))?: .{1,}$/

                    if (!commitMessage.matches(conventionalCommitRegex)) {
                        error "Commit message '${commitMessage}' does not follow the conventional commit format"
                    }
                }
            }
        }

        stage('Check Linting') {
            steps {
                script {
                    def lintResult = sh(script: 'helm lint .', returnStatus: true)
                    if (lintResult != 0) {
                        error 'Helm lint failed'
                    }

                    // Run helm template
                    def templateResult = sh(script: 'helm template .', returnStatus: true)
                    if (templateResult != 0) {
                        error 'Helm template failed'
                    }
                }
            }
        }

        stage('Release') {
            when {
                branch 'main'
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'github_pat', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GH_TOKEN')]) {
                    script {
                        try {
                        

                            sh """
                                npm install --save-dev semantic-release
                                npm install @semantic-release/changelog @semantic-release/git semantic-release-helm @semantic-release/exec
                                npx semantic-release
                            """
                        } catch (Exception e) {
                            echo "Semantic release failed: ${e.getMessage()}"
                            currentBuild.result = 'FAILURE'
                            error("Failed to create a release")
                        }
                    }
                }
            }
        }

        stage('Cleanup') {
            steps {
                echo "Cleaning up the code"
            }
        }
    }
}
