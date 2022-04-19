pipeline {
    agent any
    tools {
        maven "maven"
    }
    
    stages {
        stage ('clean dir') {
            steps {
                sh "rm -rf /tmp/folder/* "
            }
        }
        stage ('Clone Geo Citizen project') {
            steps {             
                git branch: 'main', url: 'https://github.com/mentorchita/Geocit134.git'
            }
        }

        stage('fixing project') {
            steps {
                script {
                    sh '''#!/bin/bash
                    ### Starint ###
                    mail="your email"
                    mail_password="your_password"
                    
                    server_app="192.168.43.121"
                    server_db="192.168.43.61"
                    nexus_ip="129.151.202.208"
                    name_db="geocitizen"
                    
                    echo "Fix dependencies"
                    
                    
                    # Fix pom.xml for mvn install
                    
                    sed -i "s/>servlet-api/>javax.servlet-api/g" pom.xml
                    sed -i -E "s/(http:\\/\\/repo.spring)/https:\\/\\/repo.spring/g" pom.xml
                    sed -i -E "s/35.188.29.52/$nexus_ip/g" pom.xml
                    
                    # Fix application.properties for url and db ip
                    
                    sed -i -E "s/ss_demo_1/$name_db/g" src/main/resources/application.properties
                    sed -i "s/http:\\/\\/localhost/http:\\/\\/$server_app/g" src/main/resources/application.properties
                    sed -i -E "s/postgresql:\\/\\/localhost/postgresql:\\/\\/$server_db/g" src/main/resources/application.properties
                    sed -i "s/postgresql:\\/\\/35.204.28.238/postgresql:\\/\\/$server_db/g" src/main/resources/application.properties
                    sed -i "s/ssgeocitizen@gmail.com/$mail/g" src/main/resources/application.properties
                    sed -i "s/=softserve/=$mail_password/g" src/main/resources/application.properties
                    
                    # Fix front-end
                    
                    sed -i "s/\\/src\\/assets/\\.\\/static/g" src/main/webapp/index.html
                    
                    sed -i "s/localhost/$server_app/g" src/main/java/com/softserveinc/geocitizen/configuration/MongoConfig.java   
                    sed -i "s/localhost/$server_app/g" src/main/webapp/static/js/app.6313e3379203ca68a255.js
                    sed -i "s/localhost/$server_app/g" src/main/webapp/static/js/app.6313e3379203ca68a255.js.map
                    sed -i "s/localhost/$server_app/g" src/main/webapp/static/js/vendor.9ad8d2b4b9b02bdd427f.js
                    sed -i "s/localhost/$server_app/g" src/main/webapp/static/js/vendor.9ad8d2b4b9b02bdd427f.js.map
                    '''
                }
            }
        }

        stage('Build Geo Citizen with Maven') {
            steps {
                sh("mvn clean install")
            }
        }
                  
        stage('Uploading to Nexus') {
            steps {
                nexusArtifactUploader artifacts: [
                            [
                                artifactId: 'geo-citizen', 
                                classifier: '', 
                                file: "target/citizen.war", 
                                type: 'war'
                            ]
                        ], 
                        credentialsId: 'nexus', 
                        groupId: 'com.softserveinc', 
                        nexusUrl: "129.151.202.208:8081", 
                        nexusVersion: 'nexus3', 
                        protocol: 'http', 
                        repository: 'maven-snapshots', 
                        version: "1.0.5-SNAPSHOT"
            }
        }
    }
}