pipeline {
  agent any
    
    
  stages {
        
    stage('Cloning Git') {
      steps {
        git 'https://github.com/pontsho/goitseone-node-frontend'
      }
    }
        
    stage('Install dependencies') {
      steps {
        sh 'npm install'
      }
    }
    
    stage('Start server') {
      steps {
        sh 'npm start'
      }
    }
     
    stage('Test') {
      steps {
         sh 'npm test'
      }
    }      
  }
}
