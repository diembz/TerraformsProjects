pipeline {
    agent any
    environment {
        TF_VAR_REGION = 'us-east-1' // Configura la región o cualquier variable que necesites para Terraform
    }
    stages {
        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }
        stage('Terraform Validate') {
            steps {
                script {
                    sh 'terraform validate'
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                script {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }
        stage('Approval') {
            steps {
                script {
                    input message: "¿Quieres aplicar estos cambios?", ok: "Aprobar"
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                script {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }
}
