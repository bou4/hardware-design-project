pipeline {
    agent any

    stages {
        stage('Environment') {
            steps {
                sh 'set_env.sh'
            }
        }
        stage('Build') {
            steps {
                sh 'vivado -mode batch -source build.tcl'
                archiveArtifacts artifacts: 'output/*'
            }
        }
    }
}

