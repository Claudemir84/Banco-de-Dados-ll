# 📚 Sistema de Gestão de Biblioteca

![MySQL](https://img.shields.io/badge/MySQL-8.0+-4479A1?style=flat&logo=mysql&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green)
![Status](https://img.shields.io/badge/status-Concluído-success)

Sistema completo para gerenciamento de bibliotecas, desenvolvido como projeto acadêmico para a disciplina de Banco de Dados II.

## 📋 Sobre o Projeto

O Sistema de Gestão de Biblioteca é uma solução robusta e automatizada para controle de acervos, usuários, empréstimos e multas. Desenvolvido utilizando MySQL, o sistema implementa conceitos avançados de banco de dados incluindo views, stored procedures, triggers e consultas complexas.

### ✨ Funcionalidades Principais

- **Gestão de Acervo**: Cadastro completo de livros, autores e categorias
- **Controle de Usuários**: Gerenciamento de usuários com diferentes status
- **Empréstimos Automatizados**: Sistema inteligente de controle de empréstimos e devoluções
- **Cálculo de Multas**: Cálculo automático de multas por atraso (R$ 1,00/dia)
- **Controle de Estoque**: Atualização automática de disponibilidade de livros
- **Relatórios Gerenciais**: Views otimizadas para consultas rápidas

## 🗂️ Estrutura do Banco de Dados

### Entidades Principais

```
📊 CATEGORIAS
├── Classificação dos livros

📖 LIVROS
├── Acervo da biblioteca
└── Relacionamento N:M com Autores

✍️ AUTORES
├── Informações dos autores

👤 USUARIOS
├── Cadastro de usuários
└── Status: Ativo, Inativo, Suspenso

🔄 EMPRESTIMOS
├── Controle de transações
├── Status: Ativo, Devolvido, Atrasado
└── Gera MULTAS quando em atraso

💰 MULTAS
└── Penalidades por atraso
```

## 🚀 Recursos Implementados

### Views (Visões)

1. **vw_livros_disponiveis**
   - Lista livros disponíveis para empréstimo
   - Inclui informações de categoria e autores
   - Otimizada para consultas rápidas

2. **vw_emprestimos_atrasados**
   - Relatório de empréstimos vencidos
   - Cálculo automático de dias de atraso
   - Informações de multas associadas

### Stored Procedure

**sp_registrar_devolucao**
- Automatiza o processo completo de devolução
- Atualiza estoque automaticamente
- Calcula e registra multas se houver atraso
- Garante consistência em múltiplas tabelas

```sql
CALL sp_registrar_devolucao(id_emprestimo);
```

### Trigger

**trg_atualizar_estoque_emprestimo**
- Execução automática após inserção de empréstimo
- Reduz quantidade disponível do livro
- Atualiza status do livro quando estoque zerado
- Garante integridade do estoque

## 💻 Tecnologias Utilizadas

- **MySQL 8.0+**: Sistema de gerenciamento de banco de dados
- **SQL**: Linguagem de consulta estruturada
- **Stored Procedures**: Automação de processos
- **Triggers**: Manutenção de integridade
- **Views**: Otimização de consultas

## 📊 Modelagem

O projeto inclui:
- **Modelo Conceitual (MER)**: Diagrama Entidade-Relacionamento
- **Modelo Lógico (DER)**: Diagrama com implementação de chaves
- **Dicionário de Dados**: Documentação completa de todas as tabelas

## 🔧 Instalação

### Pré-requisitos

- MySQL Server 8.0 ou superior
- Cliente MySQL (MySQL Workbench, phpMyAdmin, ou similar)

### Passos de Instalação

1. Clone o repositório
```bash
git clone https://github.com/Claudemir84/Banco-de-Dados-ll.git
cd sistema-gestao-biblioteca
```

2. Execute o script de criação do banco de dados
```sql
source schema.sql
```

3. Popule o banco com dados de teste
```sql
source dados_teste.sql
```

## 📖 Exemplos de Uso

### Consultar livros disponíveis
```sql
SELECT * FROM vw_livros_disponiveis;
```

### Verificar empréstimos atrasados
```sql
SELECT * FROM vw_emprestimos_atrasados;
```

### Registrar devolução de livro
```sql
CALL sp_registrar_devolucao(3);
```

### Livros mais emprestados
```sql
SELECT 
    l.titulo,
    c.nome AS categoria,
    COUNT(e.id_emprestimo) AS total_emprestimos
FROM livros l
INNER JOIN categorias c ON l.id_categoria = c.id_categoria
INNER JOIN emprestimos e ON l.id_livro = e.id_livro
GROUP BY l.id_livro
ORDER BY total_emprestimos DESC;
```

## 🎯 Regras de Negócio

- **Prazo de Empréstimo**: 7 dias (padrão)
- **Multa por Atraso**: R$ 1,00 por dia
- **Status de Usuário**: 
  - Ativo: pode realizar empréstimos
  - Suspenso: bloqueado para novos empréstimos
  - Inativo: cadastro desativado
- **Controle de Estoque**: Atualização automática via trigger
- **Livros Inativos**: Automaticamente desativados quando estoque zerado

## 🔒 Segurança e Integridade

- ✅ Chaves primárias em todas as tabelas
- ✅ Chaves estrangeiras garantindo integridade referencial
- ✅ Constraints (NOT NULL, UNIQUE, ENUM)
- ✅ Validações automáticas via triggers
- ✅ Transações consistentes via stored procedures

## 📈 Melhorias Futuras

- [ ] Sistema de reservas de livros
- [ ] Renovação automática de empréstimos
- [ ] Notificações por e-mail
- [ ] Relatórios estatísticos avançados
- [ ] API REST para integração
- [ ] Dashboard administrativo
- [ ] Sistema de recomendações
- [ ] Implementação de backup automático

## 📚 Documentação

A documentação técnica completa está disponível no arquivo `DOCUMENTACAO_TECNICA.pdf`, incluindo:
- Modelagem conceitual e lógica
- Dicionário de dados detalhado
- Diagramas ER
- Casos de teste
- Exemplos de uso

## 👨‍💻 Autor

**Claudemir Dias de Oliveira**

Desenvolvido como projeto acadêmico para o curso de graduação em Banco de Dados II na Faculdade Senac Maringá.

- 📧 Email: [seu-email@exemplo.com]
- 💼 LinkedIn: [seu-linkedin]
- 🌐 GitHub: [@seu-usuario]

## 👩‍🏫 Orientação

**Professora**: Joszislaine Costa  
**Instituição**: Faculdade Senac Maringá  
**Curso**: Banco de Dados II  
**Período**: 2025

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 🙏 Agradecimentos

- Faculdade Senac Maringá
- Professora Joszislaine Costa
- Colegas de turma que contribuíram com feedbacks
- Comunidade MySQL

---

⭐ Se este projeto foi útil para você, considere dar uma estrela!

**Data de Desenvolvimento**: Outubro/2025  
**Versão**: 1.0
