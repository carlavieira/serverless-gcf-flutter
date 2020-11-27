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

Para a utilização do sistema localmente, será necessário a configuração de um ambiente capaz de executar uma aplicação flutter. Para isso, recomendamos que siga as orientações em https://flutter.dev/docs/get-started/install para cada sistema operacional.

Tendo o ambiente configurado, será necessário a utilização de um dispositivo ou emulador.

Para executar a aplicação, é possível realizar o comando:

```shell
flutter run
```

Após rodar a aplicação, você pode alterar a sua localização. Quando a sua localização se aproximar de uma das unidades da PUC Minas, você receberá um aviso de boas-vindas.

## Código

### Arquivo main.dart

* classe *MyApp* : Classe da aplicação que extende a classe [StatelessWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html) e, ao ser executada pelo método *runApp()* no *main()*, irá inicializar um [MaterialApp](https://api.flutter.dev/flutter/material/MaterialApp-class.html) com título *"FIND ME at PUC Minas"* e com home *MapPage()*, classe que será definida no arquivo *map.page.dart* .

### Arquivo map.page.dart

* classe *MapPage* : Classe da página do mapa, que extende a classe [StatelessWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html) e instancia um estado da página.

* classe *_MapPageState* : Classe de estado da página do mapa, que extende [State\<MapPage\>](https://api.flutter.dev/flutter/widgets/State-class.html) e, tem os seguintes atributos e métodos: 

#### Atributos _MapPageState

| Nome do Atributo  | Tipo                | Funcionalidade                           |
|-------------------|---------------------|------------------------------------------|
| mapController     | [GoogleMapController](https://pub.dev/documentation/google_maps_flutter/latest/google_maps_flutter/GoogleMapController-class.html) | Controler da instância do Google Maps|
| markers           | [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html)\<[Marker](https://pub.dev/documentation/flutter_map/latest/flutter_map.plugin_api/Marker-class.html)\> | Guarda a lista de Marker no qual representam as unidades da PUC      |
| databaseReference | [Firestore](https://firebase.flutter.dev/docs/firestore/usage/)    | Referência um local específico no bando de dados, no caso, será utilizado pra ler dados no Firebase |
| _position         | Position            | Posição utiliando do geolocator |
| myLatitude        | double              | Salvar a latitude do usuário no momento  |
| myLongitude       | double              | Salvar a longiture do usuário no momento |
| _positionStream   | [StreamSubscription](https://api.dart.dev/stable/2.10.4/dart-async/StreamSubscription-class.html)\<Position\>  |                             Stream de posições, que escuta mudanças na posição, onde é possível executar métodos a cada mudança |
| showAlert         | bool                | Definir se deve ou não mostrar o alerta |

#### Métodos _MapPageState

| Nome do Método  | Entrada                         | Retorno       | Funcionalidade                                                                                                                                                                       |
|-----------------|---------------------------------|---------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| initState       | -                               | -              | Inicializar o estado com as latitudes e longitudes iniciais do usuário                                                                                                               |
| _checkItsClose  | response                        | -              | Alterar o atributo booleano *showAlert* para true caso a resposta da chamada seja que os pontos estão próximos.                                                                      |
| getData         | lat1, lng1                      | -              | Para um determinado ponto, utiliza da função *fetchNearestPUC* para a restosta se o ponto está próximo de uma das unidades em *puc-units* e então utiliza da função *_checkItsClose* |
| fetchNearestPUC | latUnit, lngUnit, pucname       | response.body | Para uma determinada unidade da PUC, utiliza da função no cloud fuctions saber se um ponto está próximo ou não daquela PUC.                                                          |
| _alert          | pucName                         | AlertDialog   | Mostra uma janela dando as boas-vindas a PUC da unidade com o nome dado em *pucName*                                                                                                 |
| _onMapCreated   | GoogleMapController  controller | -              | Prepara o mapa e adiciona os Makers das unidades da PUC a lista *markers*.                                                                                                           |
| build           | BuildContext  context           | Scaffold      |                                                                                                                                                                                      |
