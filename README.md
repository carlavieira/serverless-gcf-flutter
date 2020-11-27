# Trabalho - Serverless com GCF e Flutter

Este trabalho teve como objetivo desenvolver uma pequena aplicação usando Serverless com o Google Cloud Functions - GCF, na qual exibe um mapa da localização atual do telefone, rastreia a localização do usuário e, a cada localização, confere se está a menos de 100 metros de alguma unidade da PUC Minas.

## Alunos integrantes da equipe

* Carla d'Abreu Martins Vieira
* Otávio Vinícius Guimarães Silveira Rocha

## Professores responsáveis

* Hugo Bastos de Paula

## Especificação

Durante as aulas de laboratório foram apresentadas formas de se acessar o GCF e o Firebase. Neste trabalho iremos implementar uma aplicação que ilustre uma situação de sistema ciente de contexto (context-aware system). O sistema deve funcionar da seguinte forma:

* A aplicação móvel deve exibir o mapa da localização atual do telefone.
* A aplicação móvel deve rastrear a localização do usuário.
* A cada atualização de localização, a aplicação móvel deve invocar a função lambda do GCF.
* A função lambda deve verificar se o aparelho se encontra a menos de 100 metros de alguma unidade da PUC Minas e retornar para o celular a mensagem "Bem vindo à PUC Minas unidade " + <nome da unidade mais próxima>.


## Instruções de utilização

Assim que a primeira versão do sistema estiver disponível, deverá complementar com as instruções de utilização. Descreva como instalar eventuais dependências e como executar a aplicação.
