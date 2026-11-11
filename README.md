# Trabalho-Sql

Projeto de banco de dados para controle de manutenção industrial em MySQL.

## Visão geral
Este repositório contém:
- `esquema.sql`: criação das tabelas do banco
- `seed.sql`: dados iniciais para testes

## Requisitos
- MySQL 8.0+ ou MariaDB 10.5+
- Cliente SQL (opcional, para importar os arquivos)

## Como rodar localmente

### Opção 1: usando Docker
Na raiz do projeto, execute:

```bash
docker compose up -d
```

Isso sobe um container MySQL na porta `3306` com o banco `trabalho_sql`.

Depois, importe os scripts:

```bash
mysql -h 127.0.0.1 -P 3306 -u root -p
```

Dentro do cliente MySQL:

```sql
CREATE DATABASE IF NOT EXISTS trabalho_sql;
USE trabalho_sql;
SOURCE /caminho/para/esquema.sql;
SOURCE /caminho/para/seed.sql;
```

Se preferir executar diretamente pelo terminal:

```bash
mysql -h 127.0.0.1 -P 3306 -u root -p trabalho_sql < esquema.sql
mysql -h 127.0.0.1 -P 3306 -u root -p trabalho_sql < seed.sql
```

### Opção 2: MySQL local
1. Crie um banco chamado `trabalho_sql`
2. Execute o conteúdo de `esquema.sql`
3. Execute o conteúdo de `seed.sql`

## Estrutura do banco
O modelo inclui:
- unidades e linhas de produção
- máquinas e tipos de máquina
- componentes das máquinas
- técnicos
- ordens de serviço
- peças em estoque
- histórico de sensores

## O que foi ajustado
- README com instruções de execução
- suporte explícito a MySQL/MariaDB
- arquivo `docker-compose.yml` para facilitar o setup do ambiente
- ajustes de integridade no esquema para evitar duplicidade de tipos de máquina e acelerar consultas usuais

## Observações
O projeto está em SQL puro; não há dependências de frontend, backend ou gerenciador de pacotes (npm, pip, Maven, etc.). A dependência real é o banco de dados.
