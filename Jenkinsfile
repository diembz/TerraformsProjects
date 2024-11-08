pipeline {
    agent any
    environment {
        TF_VAR_REGION = 'us-east-1' // Ajusta la región o cualquier otra variable de entorno necesaria
    }
    stages {
        stage('Terraform Init') {
            steps {
                script {
                    // Inicializa Terraform y descarga los proveedores necesarios
                    sh 'terraform init'
                }
            }
        }
        stage('Terraform Validate') {
            steps {
                script {
                    // Valida el código de Terraform para asegurarse de que la sintaxis es correcta
                    sh 'terraform validate'
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                script {
                    // Ejecuta terraform plan usando el archivo caso_4.tfvars para definir los valores de las variables
                    sh 'terraform plan -var-file="caso_4.tfvars" -out=tfplan'
                }
            }
        }
        stage('Approval') {
            steps {
                script {
                    // Pausa el pipeline para una aprobación manual antes de aplicar los cambios
                    input message: "¿Quieres aplicar estos cambios?", ok: "Aprobar"
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                script {
                    // Aplica el plan de Terraform usando el archivo tfplan generado anteriormente
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }
}
