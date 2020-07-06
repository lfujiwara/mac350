# Etapa 3 - MAC350

Grupo:

- Lucas Fujiwara, 10737049
- Cainã S.G., 10737115

## Organização

- Modelo conceitual/lógico: Usamos a etapa anterior como referência para o modelo conceitual, corrigimos de acordo com o feedback e unificamos as entidades usuário e paciente em uma entidade só chamada pessoa (`modelo_conceitual.(png|drawio)`). Para o modelo lógico, fizemos cards no estilo UML e depois geramos um diagrama com outra ferramenta que gera a partir do banco. (`modelo_logico_dbeaver.png`)
- Modelo físico: `database/schema.sql`, nos baseamos no modelo de referência disponibilizado, incluímos uma data de solicitação na relação realiza e uma tabela para guardar os logs/registros de uso de serviços.
- Consultas e rotinas de inserção: Estão inclusas em `procedures/`. Corrigimos os erros nas consultas e tornamos algumas rotinas mais práticas, por exemplo, para adicionar um usuário já com o tutor usando seu CPF, essa rotina também insere o tutelamento.
- Restore: Arquivo (`database/dump/restore.sql`) que possui o modelo físico junto com as queries/rotinas.
- Dump de dados: `database/dump/insert_users.sql`, apenas para inserção de fake data para testes, adicionamos mais dados, mas algumas relações precisa inserir manualmente para realizar testes (fizemos um backup do que inserimos manualmente) pela complexidade de gerar fake data em cima disso (múltiplas consultas e etc).
- Backup: `/backup.sql`, salvamos esse backup já com dados inseridos
- Interface:
  - CRUD: A interface do Django já faz isto, para tal, habilitamos nas configurações e alteramos a representação (método `__str__`).
  - Para visualizar as queries, utilizamos bootstrap junto com o template engine do django, basta ir em `localhost:8000`
- Configuração de conexão com o banco de dados (`web/examtracker/settings.py`)
  ![image-20200705233452706](md-assets\image-20200705233452706.png)
