# Forum API - Observability Stack

Sistema de API de Forum com stack completa de observabilidade, demonstrando boas praticas de monitoramento, alertas e visualizacao de metricas em aplicacoes Spring Boot.

## Indice

- [Visao Geral](#visao-geral)
- [Arquitetura](#arquitetura)
- [Tecnologias](#tecnologias)
- [Pre-requisitos](#pre-requisitos)
- [Instalacao e Execucao](#instalacao-e-execucao)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [API Endpoints](#api-endpoints)
- [Observabilidade](#observabilidade)
- [Configuracao](#configuracao)
- [Testes](#testes)

---

## Visao Geral

Este projeto implementa uma API RESTful de forum com funcionalidades de:

- Gerenciamento de topicos (CRUD)
- Autenticacao JWT
- Cache distribuido com Redis
- Metricas customizadas com Micrometer
- Monitoramento com Prometheus e Grafana
- Alertas configurados com Alertmanager

### Principais Funcionalidades

| Funcionalidade | Descricao |
|----------------|-----------|
| Gestao de Topicos | Criar, listar, atualizar e remover topicos do forum |
| Autenticacao | Login com JWT Token |
| Cache | Cache distribuido para otimizacao de consultas |
| Metricas | Exposicao de metricas para monitoramento |
| Alertas | Notificacoes automaticas via Slack |

---

## Arquitetura

```
                                    [Grafana]
                                        |
                                   [Prometheus]
                                        |
[Client] --> [Nginx Proxy] --> [Spring Boot API] --> [PostgreSQL]
                                        |
                                     [Redis]
                                        |
                                 [Alertmanager] --> [Slack]
```

### Fluxo de Dados

1. Requisicoes chegam via Nginx (porta 80)
2. Nginx roteia para a aplicacao Spring Boot
3. Aplicacao consulta PostgreSQL e Redis
4. Metricas sao expostas via `/actuator/prometheus`
5. Prometheus coleta metricas a cada 15 segundos
6. Alertmanager avalia regras e dispara alertas
7. Grafana visualiza dashboards

### Redes Docker

| Rede | Proposito | Servicos |
|------|-----------|----------|
| `database` | Comunicacao com banco | PostgreSQL, App |
| `cache` | Comunicacao com cache | Redis, App |
| `api` | Comunicacao da API | App, Proxy, Prometheus |
| `monit` | Stack de monitoramento | Prometheus, Alertmanager, Grafana |
| `proxy` | Acesso externo | Nginx, Client |

---

## Tecnologias

### Backend

| Tecnologia | Versao | Proposito |
|------------|--------|-----------|
| Java | 8 | Linguagem principal |
| Spring Boot | 2.3.1 | Framework web |
| Spring Data JPA | - | Persistencia |
| Spring Security | - | Autenticacao/Autorizacao |
| Spring Cache | - | Abstracao de cache |
| Micrometer | - | Metricas |

### Infraestrutura

| Tecnologia | Versao | Proposito |
|------------|--------|-----------|
| PostgreSQL | 17-alpine | Banco de dados |
| Redis | latest | Cache distribuido |
| Nginx | latest | Proxy reverso |
| Docker | - | Containerizacao |
| Docker Compose | 3 | Orquestracao |

### Observabilidade

| Tecnologia | Proposito |
|------------|-----------|
| Prometheus | Coleta e armazenamento de metricas |
| Alertmanager | Gerenciamento de alertas |
| Grafana | Visualizacao e dashboards |
| Micrometer | Exportacao de metricas para Prometheus |

---

## Pre-requisitos

- Docker 20.10+
- Docker Compose 2.0+
- Git
- (Opcional) Java 8+ e Maven 3.6+ para desenvolvimento local

---

## Instalacao e Execucao

### Execucao com Docker Compose (Recomendado)

```bash
# Clonar repositorio
git clone <url-do-repositorio>
cd observabilidade

# Iniciar todos os servicos
docker-compose up -d

# Verificar status dos containers
docker-compose ps

# Visualizar logs
docker-compose logs -f app-forum-api
```

### Execucao Local (Desenvolvimento)

```bash
# Compilar projeto
mvn clean package -DskipTests

# Executar com perfil de desenvolvimento (H2)
mvn spring-boot:run

# Executar com perfil de producao
java -jar target/forum.jar --spring.profiles.active=prod
```

### URLs de Acesso

| Servico | URL | Credenciais |
|---------|-----|-------------|
| API | http://localhost | - |
| Swagger UI | http://localhost/swagger-ui.html | - |
| Prometheus | http://localhost:9090 | - |
| Grafana | http://localhost:3000 | admin/admin |
| Alertmanager | http://localhost:9093 | - |

---

## Estrutura do Projeto

```
observabilidade/
|
|-- src/                          # Codigo fonte da aplicacao
|   |-- main/
|   |   |-- java/br/com/alura/forum/
|   |   |   |-- config/           # Configuracoes (Security, Swagger)
|   |   |   |-- controller/       # Controllers REST
|   |   |   |   |-- dto/          # Data Transfer Objects
|   |   |   |   |-- form/         # Forms de entrada
|   |   |   |-- modelo/           # Entidades JPA
|   |   |   |-- repository/       # Repositorios Spring Data
|   |   |   |-- ForumApplication.java
|   |   |-- resources/
|   |       |-- application.properties
|   |       |-- application-prod.properties
|   |       |-- data.sql
|   |-- test/                     # Testes unitarios
|
|-- prometheus/                   # Configuracao Prometheus
|   |-- prometheus.yml            # Configuracao de scrape
|   |-- alert.rules               # Regras de alerta
|
|-- alertmanager/                 # Configuracao Alertmanager
|   |-- alertmanager.yml          # Rotas e receivers
|
|-- grafana/                      # Dados do Grafana
|   |-- grafana.db                # Banco SQLite
|   |-- plugins/                  # Plugins instalados
|
|-- nginx/                        # Configuracao Nginx
|   |-- nginx.conf                # Configuracao principal
|   |-- proxy.conf                # Configuracao de proxy
|
|-- postgres/                     # Scripts do banco
|   |-- database.sql              # Schema e dados iniciais
|
|-- client/                       # Cliente de teste
|   |-- client.sh                 # Script de carga
|   |-- Dockerfile
|
|-- docker-compose.yaml           # Orquestracao de containers
|-- pom.xml                       # Dependencias Maven
|-- README.md                     # Documentacao
```

---

## API Endpoints

### Autenticacao

| Metodo | Endpoint | Descricao | Autenticacao |
|--------|----------|-----------|--------------|
| POST | `/auth` | Gerar token JWT | Nao |

**Request Body:**
```json
{
  "email": "aluno@email.com",
  "senha": "123456"
}
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "tipo": "Bearer"
}
```

### Topicos

| Metodo | Endpoint | Descricao | Autenticacao |
|--------|----------|-----------|--------------|
| GET | `/topicos` | Listar topicos (paginado) | Nao |
| GET | `/topicos/{id}` | Obter detalhes do topico | Nao |
| POST | `/topicos` | Criar topico | Sim |
| PUT | `/topicos/{id}` | Atualizar topico | Sim |
| DELETE | `/topicos/{id}` | Remover topico | Sim |

### Health Check

| Metodo | Endpoint | Descricao |
|--------|----------|-----------|
| GET | `/actuator/health` | Status da aplicacao |
| GET | `/actuator/info` | Informacoes da aplicacao |
| GET | `/actuator/prometheus` | Metricas Prometheus |

---

## Observabilidade

### Metricas Coletadas

A aplicacao expoe metricas via Micrometer/Prometheus:

- **HTTP Requests**: Contagem e latencia por endpoint
- **JVM**: Memoria, GC, threads
- **Cache**: Hit/miss ratio do Redis
- **Database**: Pool de conexoes, queries

### Regras de Alerta

| Alerta | Condicao | Severidade |
|--------|----------|------------|
| SLO Breach | Latencia p90 >= 500ms por 1min | Critical |
| Error Rate | Taxa de erros 500 >= 1% por 1min | Critical |

### Dashboard Grafana

Dashboards pre-configurados para:

- Visao geral da aplicacao
- Metricas HTTP (latencia, throughput, erros)
- Metricas JVM
- Metricas de cache e banco

---

## Configuracao

### Variaveis de Ambiente

| Variavel | Descricao | Padrao |
|----------|-----------|--------|
| `SPRING_PROFILES_ACTIVE` | Perfil ativo | dev |
| `POSTGRES_DB` | Nome do banco | forum |
| `POSTGRES_USER` | Usuario do banco | forum |
| `POSTGRES_PASSWORD` | Senha do banco | - |

### Perfis de Aplicacao

| Perfil | Banco | Cache | Uso |
|--------|-------|-------|-----|
| `dev` | H2 (memoria) | Desabilitado | Desenvolvimento |
| `prod` | PostgreSQL | Redis | Producao |

---

## Testes

### Executar Testes

```bash
# Todos os testes
mvn test

# Teste especifico
mvn test -Dtest=CursoRepositoryTest
```

### Usuarios de Teste

| Email | Senha | Perfil |
|-------|-------|--------|
| aluno@email.com | 123456 | ALUNO |
| moderador@email.com | 123456 | MODERADOR |

---

## Comandos Uteis

```bash
# Reiniciar servico especifico
docker-compose restart app-forum-api

# Ver logs em tempo real
docker-compose logs -f prometheus-forum-api

# Parar todos os servicos
docker-compose down

# Remover volumes (CUIDADO: apaga dados)
docker-compose down -v

# Rebuild da aplicacao
docker-compose build --no-cache app-forum-api
```

---

## Contribuicao

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas alteracoes (`git commit -m 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

---

## Licenca

Este projeto esta sob a licenca MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.
