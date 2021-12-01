pipeline {
  agent any

  stages {
      stage('Build Artifact') {
            steps {
              sh "mvn clean package -DskipTests=true"
              archive 'target/*.jar'
            }
        }
      stage('Unit Test') {
            steps {
              sh "mvn test"
            }
            post {
              always {
                junit 'target/surefire-reports/*.xml'
                jacoco execPattern: 'target/jacoco.exec'
              }
            }
        }
      stage('Mutation Tests - PIT') {
      steps {
        sh "mvn org.pitest:pitest-maven:mutationCoverage"
      }
      post {
        always {
          pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
        }
      }
    }
      stage('SAST Scan') {
      
      steps {
        withSonarQubeEnv('SonarQube')
       {
          sh "mvn clean verify sonar:sonar -Dsonar.projectKey=numeric-app -Dsonar.host.url=http://3.109.169.209:9000 -Dsonar.login=678db3f346dafa7bd7c4feee2b40e7d08c8e00ca"
        }
        timeout(time: '2, unit: 'MINUTES') {
          script {
            withForQualityGate abortPipeline: true
          }
      }     
      }
      

      stage('Docker Build and Push') {
      steps {
        
        withDockerRegistry([credentialsId: "docker-hub", url: ""]) {
          sh 'printenv'
          sh 'docker build -t prateekjain/numeric-app:""$GIT_COMMIT"" .'
          sh 'docker push prateekjain/numeric-app:""$GIT_COMMIT""'
        }
      }     
    }
     stage('Kubernetes Deployment - DEV') {
      steps {
        withKubeConfig([credentialsId: 'kube-config']) {
          sh "sed -i 's#replace#prateekjain/numeric-app:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
          sh "kubectl apply -f k8s_deployment_service.yaml"
        }
      }
     }
  }
}