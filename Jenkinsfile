{\rtf1\ansi\ansicpg1252\cocoartf2869
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 pipeline \{\
    agent any \
\
    stages \{\
        stage('Checkout') \{\
            steps \{\
                echo 'Pulling the latest code from Git...'\
                checkout scm\
            \}\
        \}\
        stage('Build') \{\
            steps \{\
                echo 'Compiling project and creating build artifacts...'\
                // Mac shell command example:\
                // sh 'npm install' or sh './gradlew build'\
            \}\
        \}\
        stage('Test') \{\
            steps \{\
                echo 'Running automated test suites...'\
                // sh 'npm test' or sh './gradlew test'\
            \}\
        \}\
    \}\
    \
    post \{\
        success \{\
            echo 'Pipeline execution passed successfully!'\
        \}\
        failure \{\
            echo 'Pipeline failed. Check Jenkins console logs.'\
        \}\
    \}\
\}\
}