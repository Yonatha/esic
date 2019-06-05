# e-SIC

Sistema de solicitação e acompanhamento de informações do cidadão para atender a Lei de Acesso à Informação (Lei nº 12.527/2011).
http://www.acessoainformacao.gov.br/assuntos/conheca-seu-direito/a-lei-de-acesso-a-informacao


O sistema possui um módulo para usuários com perfil de Autoridade de Monitoramento da informação e um módulo para usuário com perfil Cidadão.


## Funcionalidades

* Solciitação de informações
* Acompanhamento/notificação por e-mail de tramite da solicitação por status Aberta, Respondida ou Cancelada pelo Cidadão
* Anexo de resposta a solicitação
* Cadastro de cidadão realizado com código de ativação
* Recuperação de senha


## Instalação

Execute a task abaixo:
```
rake esic:install
```

```
rails s
```

Acesse http://localhost:3000

Autoridade de monitoramento
```
login: yonathalmeida@gmail.com
senha: 123456
```

## Instalação usando docker

Com o docker e docker-compose devidamente instalado, execute:
```
docker-compose up -d -it
```

Execute:
```
docker-compose esic_app bundle exec rake esic:install
```

Acesse http://localhost:3000