-- =====================================================
-- SISTEMA DE GESTÃO DE BIBLIOTECA
-- Banco de Dados Completo
-- =====================================================


CREATE DATABASE IF NOT EXISTS biblioteca;
USE biblioteca;


CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);


CREATE TABLE autores (
    id_autor INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    nacionalidade VARCHAR(50),
    data_nascimento DATE
);


CREATE TABLE livros (
    id_livro INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(200) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    ano_publicacao INT,
    quantidade_total INT NOT NULL DEFAULT 1,
    quantidade_disponivel INT NOT NULL DEFAULT 1,
    id_categoria INT,
    status ENUM('Ativo', 'Inativo') DEFAULT 'Ativo',
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);


CREATE TABLE livros_autores (
    id_livro INT,
    id_autor INT,
    PRIMARY KEY (id_livro, id_autor),
    FOREIGN KEY (id_livro) REFERENCES livros(id_livro),
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor)
);


CREATE TABLE usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    cpf VARCHAR(14) UNIQUE NOT NULL,
    data_cadastro DATE NOT NULL,
    status ENUM('Ativo', 'Inativo', 'Suspenso') DEFAULT 'Ativo'
);


CREATE TABLE emprestimos (
    id_emprestimo INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    id_livro INT NOT NULL,
    data_emprestimo DATE NOT NULL,
    data_devolucao_prevista DATE NOT NULL,
    data_devolucao_real DATE,
    status ENUM('Ativo', 'Devolvido', 'Atrasado') DEFAULT 'Ativo',
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_livro) REFERENCES livros(id_livro)
);


CREATE TABLE multas (
    id_multa INT PRIMARY KEY AUTO_INCREMENT,
    id_emprestimo INT NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    dias_atraso INT NOT NULL,
    status ENUM('Pendente', 'Paga') DEFAULT 'Pendente',
    data_pagamento DATE,
    FOREIGN KEY (id_emprestimo) REFERENCES emprestimos(id_emprestimo)
);



INSERT INTO categorias (nome, descricao) VALUES
('Ficção', 'Livros de ficção e literatura'),
('Tecnologia', 'Livros sobre programação e tecnologia'),
('História', 'Livros históricos e biografias'),
('Ciência', 'Livros científicos e acadêmicos'),
('Romance', 'Literatura romântica');


INSERT INTO autores (nome, nacionalidade, data_nascimento) VALUES
('Machado de Assis', 'Brasileiro', '1839-06-21'),
('J.K. Rowling', 'Britânica', '1965-07-31'),
('George Orwell', 'Britânico', '1903-06-25'),
('Robert C. Martin', 'Americano', '1952-12-05'),
('Yuval Noah Harari', 'Israelense', '1976-02-24'),
('Stephen King', 'Americano', '1947-09-21'),
('Gabriel García Márquez', 'Colombiano', '1927-03-06');


INSERT INTO livros (titulo, isbn, ano_publicacao, quantidade_total, quantidade_disponivel, id_categoria) VALUES
('Dom Casmurro', '978-8535911663', 1899, 3, 3, 1),
('Harry Potter e a Pedra Filosofal', '978-8532530787', 1997, 5, 4, 1),
('1984', '978-8535914849', 1949, 4, 3, 1),
('Código Limpo', '978-8576082675', 2008, 3, 2, 2),
('Sapiens', '978-8525432629', 2011, 4, 4, 3),
('O Iluminado', '978-8581050157', 1977, 2, 1, 1),
('Cem Anos de Solidão', '978-8501012449', 1967, 3, 3, 1);


INSERT INTO livros_autores (id_livro, id_autor) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7);


INSERT INTO usuarios (nome, email, telefone, cpf, data_cadastro, status) VALUES
('João Silva', 'joao.silva@email.com', '(41) 98765-4321', '123.456.789-00', '2024-01-15', 'Ativo'),
('Maria Santos', 'maria.santos@email.com', '(41) 98765-4322', '123.456.789-01', '2024-02-20', 'Ativo'),
('Pedro Oliveira', 'pedro.oliveira@email.com', '(41) 98765-4323', '123.456.789-02', '2024-03-10', 'Ativo'),
('Ana Costa', 'ana.costa@email.com', '(41) 98765-4324', '123.456.789-03', '2024-04-05', 'Ativo'),
('Carlos Souza', 'carlos.souza@email.com', '(41) 98765-4325', '123.456.789-04', '2024-05-12', 'Suspenso');


INSERT INTO emprestimos (id_usuario, id_livro, data_emprestimo, data_devolucao_prevista, data_devolucao_real, status) VALUES
(1, 2, '2024-10-01', '2024-10-15', '2024-10-14', 'Devolvido'),
(2, 4, '2024-10-05', '2024-10-19', NULL, 'Ativo'),
(3, 3, '2024-09-20', '2024-10-04', NULL, 'Atrasado'),
(1, 6, '2024-10-10', '2024-10-24', NULL, 'Ativo'),
(4, 4, '2024-09-15', '2024-09-29', '2024-10-05', 'Devolvido');


INSERT INTO multas (id_emprestimo, valor, dias_atraso, status, data_pagamento) VALUES
(3, 15.00, 15, 'Pendente', NULL),
(5, 6.00, 6, 'Paga', '2024-10-06');


CREATE VIEW vw_livros_disponiveis AS
SELECT 
    l.id_livro,
    l.titulo,
    l.isbn,
    l.ano_publicacao,
    l.quantidade_disponivel,
    c.nome AS categoria,
    GROUP_CONCAT(a.nome SEPARATOR ', ') AS autores
FROM livros l
INNER JOIN categorias c ON l.id_categoria = c.id_categoria
LEFT JOIN livros_autores la ON l.id_livro = la.id_livro
LEFT JOIN autores a ON la.id_autor = a.id_autor
WHERE l.quantidade_disponivel > 0 AND l.status = 'Ativo'
GROUP BY l.id_livro, l.titulo, l.isbn, l.ano_publicacao, l.quantidade_disponivel, c.nome;

-- View 2: Empréstimos atrasados com informações do usuário e multa
CREATE VIEW vw_emprestimos_atrasados AS
SELECT 
    e.id_emprestimo,
    u.nome AS usuario,
    u.email,
    u.telefone,
    l.titulo AS livro,
    e.data_emprestimo,
    e.data_devolucao_prevista,
    DATEDIFF(CURDATE(), e.data_devolucao_prevista) AS dias_atraso,
    COALESCE(m.valor, 0) AS valor_multa,
    COALESCE(m.status, 'Sem Multa') AS status_multa
FROM emprestimos e
INNER JOIN usuarios u ON e.id_usuario = u.id_usuario
INNER JOIN livros l ON e.id_livro = l.id_livro
LEFT JOIN multas m ON e.id_emprestimo = m.id_emprestimo
WHERE e.status = 'Atrasado' OR (e.status = 'Ativo' AND e.data_devolucao_prevista < CURDATE());


SELECT 
    l.titulo,
    c.nome AS categoria,
    COUNT(e.id_emprestimo) AS total_emprestimos,
    GROUP_CONCAT(DISTINCT a.nome SEPARATOR ', ') AS autores
FROM livros l
INNER JOIN categorias c ON l.id_categoria = c.id_categoria
INNER JOIN emprestimos e ON l.id_livro = e.id_livro
LEFT JOIN livros_autores la ON l.id_livro = la.id_livro
LEFT JOIN autores a ON la.id_autor = a.id_autor
GROUP BY l.id_livro, l.titulo, c.nome
ORDER BY total_emprestimos DESC;


SELECT 
    u.nome,
    u.email,
    u.status,
    (SELECT COUNT(*) 
     FROM emprestimos e 
     WHERE e.id_usuario = u.id_usuario) AS total_emprestimos,
    (SELECT SUM(m.valor) 
     FROM multas m 
     INNER JOIN emprestimos e ON m.id_emprestimo = e.id_emprestimo 
     WHERE e.id_usuario = u.id_usuario AND m.status = 'Pendente') AS total_multas_pendentes
FROM usuarios u
WHERE u.id_usuario IN (
    SELECT DISTINCT e.id_usuario
    FROM emprestimos e
    INNER JOIN multas m ON e.id_emprestimo = m.id_emprestimo
    WHERE m.status = 'Pendente'
)
ORDER BY total_multas_pendentes DESC;


DELIMITER //

CREATE PROCEDURE sp_registrar_devolucao(
    IN p_id_emprestimo INT
)
BEGIN
    DECLARE v_data_prevista DATE;
    DECLARE v_dias_atraso INT;
    DECLARE v_valor_multa DECIMAL(10,2);
    DECLARE v_id_livro INT;
        
    SELECT data_devolucao_prevista, id_livro
    INTO v_data_prevista, v_id_livro
    FROM emprestimos
    WHERE id_emprestimo = p_id_emprestimo;
    
    
    UPDATE emprestimos
    SET data_devolucao_real = CURDATE(),
        status = 'Devolvido'
    WHERE id_emprestimo = p_id_emprestimo;
        
    UPDATE livros
    SET quantidade_disponivel = quantidade_disponivel + 1
    WHERE id_livro = v_id_livro;
        
    SET v_dias_atraso = DATEDIFF(CURDATE(), v_data_prevista);
        
    IF v_dias_atraso > 0 THEN
        SET v_valor_multa = v_dias_atraso * 1.00; -- R$ 1,00 por dia
        
        INSERT INTO multas (id_emprestimo, valor, dias_atraso, status)
        VALUES (p_id_emprestimo, v_valor_multa, v_dias_atraso, 'Pendente');
        
        SELECT CONCAT('Devolução registrada com multa de R$ ', v_valor_multa) AS mensagem;
    ELSE
        SELECT 'Devolução registrada sem multa' AS mensagem;
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_atualizar_estoque_emprestimo
AFTER INSERT ON emprestimos
FOR EACH ROW
BEGIN
    
    UPDATE livros
    SET quantidade_disponivel = quantidade_disponivel - 1
    WHERE id_livro = NEW.id_livro;
    
    
    UPDATE livros
    SET status = 'Inativo'
    WHERE id_livro = NEW.id_livro 
    AND quantidade_disponivel = 0;
END //

DELIMITER ;

SELECT * FROM vw_livros_disponiveis;

SELECT * FROM vw_emprestimos_atrasados;

CALL sp_registrar_devolucao(3);

INSERT INTO emprestimos (id_usuario, id_livro, data_emprestimo, data_devolucao_prevista, status)
VALUES (2, 1, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY), 'Ativo');

SELECT titulo, quantidade_disponivel FROM livros WHERE id_livro = 1;