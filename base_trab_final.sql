-- Tabelas

CREATE TABLE IF NOT EXISTS Unidade (
	nome varchar(100),
	cep char(9),

	primary key(nome, cep)
);

CREATE TYPE sexo_enum AS ENUM ('M', 'F', 'Outro');
CREATE TYPE tipo_enum AS ENUM ('Aluno', 'Professor', 'Funcionario');

CREATE TABLE IF NOT EXISTS Usuario (
    nome VARCHAR(100) NOT NULL,
    sobrenome VARCHAR(100) NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    dataNasc DATE,
    cep CHAR(9),
    numero INTEGER,
    sexo sexo_enum,
    email VARCHAR(150) UNIQUE,
    senha VARCHAR(255)NOT NULL,
    tipo tipo_enum,
    areaEspecializacao VARCHAR(100),
    titulacao VARCHAR(100),
    nomeUnidade VARCHAR(100),
    cepUnidade CHAR(9),

    PRIMARY KEY (nome, sobrenome, telefone),

    FOREIGN KEY (nomeUnidade, cepUnidade)
    REFERENCES unidade (nome, cep)
    ON UPDATE CASCADE 
    ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS Departamento(
	CodDepartamento int, 
	nome varchar(100),
	chefeNome varchar(100),
	chefeSobrenome varchar(100),
	chefeTelefone varchar(15),

	primary key(codDepartamento),
	foreign key (chefeNome, chefeSobrenome, chefeTelefone) references Usuario(nome, sobrenome, telefone)
	on update cascade on delete cascade
	
);

CREATE TABLE IF NOT EXISTS Curso(
	codCurso int,
	nome varchar(100) NOT NULL,
	nivelEnsino varchar(100) NOT NULL,
	cargaHoraria int,
	numVagas int, 
	ementa varchar(100),
	codDepartamento int, 
	nomeUnidade varchar(100),
	cepUnidade char(9),

	primary key (codCurso),
	foreign key (codDepartamento) references Departamento(codDepartamento) 
	on update cascade on delete cascade,
	foreign key (nomeUnidade, cepUnidade) references Unidade(nome, cep)
	on update cascade on delete cascade
);

CREATE TABLE IF NOT EXISTS PreRequisitos (
	codCurso int, 
	nome varchar(100),

	primary key(codCurso, nome),
	foreign key (codCurso) references Curso(codCurso) 
	on update cascade on delete cascade
);

CREATE TABLE IF NOT EXISTS Disciplina (
	codDisciplina int, 
	nome varchar(100),
	qtdAulasSemanais int, 
	nomeUnidade varchar(100),
	cepUnidade char(9),

	primary key(codDisciplina),
	foreign key (nomeUnidade, cepUnidade) references Unidade(nome, cep)
	on update cascade on delete cascade
);

CREATE TABLE IF NOT EXISTS MaterialDidatico(
	codDisciplina int, 
	descricao varchar(100),

	primary key(codDisciplina, descricao),
	foreign key (codDisciplina) references Disciplina (codDisciplina)
	on update cascade on delete cascade
);

CREATE TABLE IF NOT EXISTS Regra(
	idRegra int,
	descricao varchar(100),

	primary key (idRegra)
);

CREATE TABLE IF NOT EXISTS Infraestrutura(
	idInfraestrutura int, 
	tipo varchar(100),

	primary key(idInfraestrutura)
);

CREATE TABLE IF NOT EXISTS Compor(
	codCurso int, 
	codDisciplina int,

	primary key(codCurso, codDisciplina),
	foreign key (codCurso) references Curso(codCurso) 
	on update cascade on delete cascade,
	foreign key (codDisciplina) references Disciplina (codDisciplina)
	on update cascade on delete cascade
);

CREATE TABLE IF NOT EXISTS Possuir(
	codCurso int,
	idRegra int,

	primary key(codCurso, idRegra),

	foreign key (codCurso) references Curso(codCurso) 
	on update cascade on delete cascade,
	foreign key(idRegra) references Regra(idRegra)
	on update cascade on delete cascade
);

CREATE TABLE IF NOT EXISTS AvaliarDisciplina(
	codDisciplina int, 
	nomeUsuario varchar(100),
	sobrenomeUsuario varchar(100),
	telefoneUsuario varchar(15),
	comentario text,
	classificacaoMaterial int check(classificacaoMaterial between 0 and 5),
	classificacaoRelevancia int check (classificacaoRelevancia between 0 and 5),
	classificacaoInfraestrutura int check(classificacaoInfraestrutura between 0 and 5),

	primary key(codDisciplina, nomeUsuario, sobrenomeUsuario, telefoneUsuario),

	foreign key(codDisciplina) references Disciplina(codDisciplina)
	on update cascade on delete cascade,
	foreign key(nomeUsuario, sobrenomeUsuario, telefoneUsuario) references Usuario(nome, sobrenome, telefone)
	on update cascade on delete cascade
);

CREATE TABLE IF NOT EXISTS OfertaDisciplina (
    idOferta INTEGER NOT NULL,
    codDisciplina INTEGER NOT NULL,
    periodoLetivo VARCHAR(7) NOT NULL,
    capacidadeTurma INTEGER,
    salaDeAula VARCHAR(10),

    PRIMARY KEY (idOferta, codDisciplina),

    FOREIGN KEY (codDisciplina)
    REFERENCES Disciplina(codDisciplina)
    ON UPDATE CASCADE 
    ON DELETE SET NULL
);


CREATE TABLE IF NOT EXISTS Mensagem (
    idMensagem INTEGER NOT NULL,
    nomeRemetente VARCHAR(100) NOT NULL,
    sobrenomeRemetente VARCHAR(100) NOT NULL,
    telefoneRemetente VARCHAR(15) NOT NULL,
    nomeDestinatario VARCHAR(100) NOT NULL,
    sobrenomeDestinatario VARCHAR(100) NOT NULL,
    telefoneDestinatario VARCHAR(15) NOT NULL,
    timestamp TIME,
    texto VARCHAR(100),

    PRIMARY KEY (idMensagem, nomeRemetente, sobrenomeRemetente, telefoneRemetente, nomeDestinatario, sobrenomeDestinatario, telefoneDestinatario),
        
    FOREIGN KEY (nomeRemetente, sobrenomeRemetente, telefoneRemetente)
	REFERENCES Usuario (nome, sobrenome, telefone)
    ON UPDATE CASCADE 
    ON DELETE CASCADE,
	
	FOREIGN KEY(nomeDestinatario, sobrenomeDestinatario, telefoneDestinatario)
    REFERENCES Usuario (nome, sobrenome, telefone)
    ON UPDATE CASCADE 
    ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS AvaliarProfessor (
    nomeP VARCHAR(100),
    sobrenomeP VARCHAR(100),
    telefoneP VARCHAR(15),
    nomeA VARCHAR(100),
    sobrenomeA VARCHAR(100),
    telefoneA VARCHAR(15),
    classificacaoDidatica INT check (ClassificacaoDidatica between 0 and 5),
    comentario VARCHAR(100),

    PRIMARY KEY(nomeP, sobrenomeP, telefoneP, nomeA, sobrenomeA, telefoneA),
    FOREIGN KEY (nomeP, sobrenomeP, telefoneP)
	REFERENCES Usuario (nome, sobrenome, telefone)
    ON UPDATE CASCADE 
    ON DELETE CASCADE,
	
	FOREIGN KEY(nomeA, sobrenomeA, telefoneA)
    REFERENCES Usuario (nome, sobrenome, telefone)
    ON UPDATE CASCADE 
    ON DELETE CASCADE
);

CREATE TYPE status_enum AS ENUM ('Ativa', 'Trancada', 'Concluída', 'Reprovada');

CREATE TABLE IF NOT EXISTS Matricular(
	nomeA varchar(100),
	sobrenomeA varchar(100),
	telefoneA varchar(15),
	idOferta int,
	codDisciplina int, 
	dataMatricula date,
	status status_enum, 
	desconto decimal(5,2),
	dataConfirmacao date,
	confirmacao boolean,
	pagamentoTaxas boolean,

	PRIMARY KEY(nomeA, sobrenomeA, telefoneA, idOferta, codDisciplina),
	
	FOREIGN KEY(nomeA, sobrenomeA, telefoneA)
    REFERENCES Usuario (nome, sobrenome, telefone)
    ON UPDATE CASCADE 
    ON DELETE CASCADE,

	FOREIGN KEY(idOferta, codDisciplina)
	REFERENCES OfertaDisciplina(idOferta, codDisciplina)
	ON UPDATE CASCADE 
    ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Notas(
	nomeA varchar(100),
	sobrenomeA varchar(100),
	telefoneA varchar(15),
	idOferta int, 
	codDisciplina int, 
	nota decimal(5,2),

	PRIMARY KEY(nomeA, sobrenomeA, telefoneA, idOferta, codDisciplina, nota),
	
	FOREIGN KEY(nomeA, sobrenomeA, telefoneA, idOferta, codDisciplina)
    REFERENCES Matricular (nomeA, sobrenomeA, telefoneA, idOferta, codDisciplina)
    ON UPDATE CASCADE 
    ON DELETE CASCADE
);


--Consultas SQL

--Média das notas dos alunos
select N.nomeA, N.sobrenomeA, N.telefoneA, avg(N.nota) as media_notas
from notas N
group by (N.nomeA, N.sobrenomeA, N.telefoneA);

--Listar todos os alunos matriculados em uma disciplina em um período letivo específico
select M.nomeA, M.sobrenomeA, M.telefoneA
from Matricular M, Disciplina D, OfertaDisciplina O
where (M.codDisciplina = D.codDisciplina) and (O.codDisciplina=D.codDisciplina) and (D.codDisciplina=20) and (periodoLetivo='2025-1');

--Listar os professores avaliados com notas menores que 3
select nomeP, sobrenomeP, telefoneP
from AvaliarProfessor
where classificacaoDidatica<3;

--Liste todos os cursos que possuem mais de 2 pré-requesitos
select C.nome, count(P.nome) as "Quantidade de Pré-Requisitos"
from Curso C 
join PreRequisitos P on (C.codCurso=P.codCurso)
group by C.nome, C.codCurso
having count(P.nome)>2;

--Liste todas as disciplinas que possuem matrículas não ativas
select distinct D.nome
from Disciplina D, matricular M
where (D.codDisciplina=M.codDisciplina) and (M.status <> 'Ativa');

--Liste as unidades que possuem mais de 20 alunos
select U.nome, U.cep, count(*) as "Quantidade de alunos"
from Unidade U
join Usuario A on (A.nomeUnidade, A.cepUnidade)=(U.nome, U.cep)
where A.tipo='Aluno'
group by U.nome, U.cep
having count(*)>20;

-- Liste as disciplinas que compõem o curso com codCurso 19
select D.nome
from Curso C, Compor CO, Disciplina D
where (CO.codCurso=C.codCurso) and (D.codDisciplina=CO.codDisciplina) and (C.codCurso=19);

CREATE INDEX IdxCursoUnidade on Curso(nomeUnidade);
-- DROP INDEX IdxCursoUnidade;

explain analyse SELECT nome, cargaHoraria, nomeUnidade
FROM Curso
where nomeUnidade='Campus 8';

CREATE INDEX IdxMatricularStatus on Matricular(status);
CREATE INDEX IdxOfertaPeriodo on OfertaDisciplina(periodoLetivo); 
-- DROP INDEX IdxMatricularStatusPeriodo;
-- DROP INDEX IdxOfertaPeriodo;

explain analyse SELECT *
FROM Matricular M
JOIN OfertaDisciplina O ON M.idOferta = O.idOferta AND M.codDisciplina = O.codDisciplina
WHERE M.status = 'Ativa' AND O.periodoLetivo = '2025-2';

-- Visões 
CREATE VIEW vw_AlunosPorUnidade AS
SELECT U.nome AS nomeUnidade, U.cep AS cepUnidade, COUNT(*) AS qtdAlunos
FROM Unidade U
JOIN Usuario A ON (A.nomeUnidade = U.nome AND A.cepUnidade = U.cep)
WHERE A.tipo = 'Aluno'
GROUP BY U.nome, U.cep;

CREATE VIEW vw_CursosESeusDepartamentos AS
SELECT C.codCurso, C.nome AS nomeCurso, D.nome AS nomeDepartamento,
   	D.chefeNome, D.chefeSobrenome, D.chefeTelefone
FROM Curso C
JOIN Departamento D ON C.codDepartamento = D.codDepartamento;

CREATE VIEW vw_MateriaisDidaticosPorDisciplina AS
SELECT M.codDisciplina, D.nome AS nomeDisciplina, M.descricao
FROM MaterialDidatico M
JOIN Disciplina D ON M.codDisciplina = D.codDisciplina;
