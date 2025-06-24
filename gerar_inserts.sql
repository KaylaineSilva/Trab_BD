INSERT INTO Unidade (nome, cep) VALUES
('Campus Central', '01000-000'),
('Campus Norte', '02000-000'),
('Campus Sul', '03000-000'),
('Campus Leste', '04000-000'),
('Campus Oeste', '05000-000'),
('Campus 6', '06000-000'),
('Campus 7', '07000-000'),
('Campus 8', '08000-000'),
('Campus 9', '09000-000'),
('Campus 10', '10000-000'),
('Campus 11', '11000-000'),
('Campus 12', '12000-000'),
('Campus 13', '13000-000'),
('Campus 14', '14000-000'),
('Campus 15', '15000-000'),
('Campus 16', '16000-000'),
('Campus 17', '17000-000'),
('Campus 18', '18000-000'),
('Campus 19', '19000-000'),
('Campus 20', '20000-000');


DO $$
DECLARE
    i INT;
    tipos tipo_enum[] := ARRAY['Aluno', 'Professor', 'Funcionario'];
    sexos sexo_enum[] := ARRAY['M', 'F', 'Outro'];
	posicao INT;
    campus_names TEXT[] := ARRAY[
        'Campus Central', 'Campus Norte', 'Campus Sul', 'Campus Leste', 'Campus Oeste',
        'Campus 6', 'Campus 7', 'Campus 8', 'Campus 9', 'Campus 10',
        'Campus 11', 'Campus 12', 'Campus 13', 'Campus 14', 'Campus 15',
        'Campus 16', 'Campus 17', 'Campus 18', 'Campus 19', 'Campus 20'
    ];
    campus_ceps CHAR(9)[] := ARRAY[
        '01000-000', '02000-000', '03000-000', '04000-000', '05000-000',
        '06000-000', '07000-000', '08000-000', '09000-000', '10000-000',
        '11000-000', '12000-000', '13000-000', '14000-000', '15000-000',
        '16000-000', '17000-000', '18000-000', '19000-000', '20000-000'
    ];
BEGIN
	
    FOR i IN 1..1000 LOOP
		posicao := (floor(random() * 20) + 1)::INT;
        INSERT INTO Usuario (nome, sobrenome, telefone, dataNasc, cep, numero, sexo, email, senha, tipo, areaEspecializacao, titulacao, nomeUnidade, cepUnidade)
        VALUES (
            'Nome' || i,
            'Sobrenome' || i,
            '900000000' || i::TEXT,
            CURRENT_DATE - (random()*365*30)::INT, -- data de nascimento aleatória nos últimos 30 anos
            '00000000',
            (random()*1000)::INT,
            sexos[(floor(random()*3)+1)::INT],
            'email' || i || '@example.com',
            'senha123',
            tipos[(floor(random()*3)+1)::INT],
            CASE WHEN random() < 0.5 THEN 'Engenharia' ELSE 'Ciência da Computação' END,
            CASE WHEN random() < 0.5 THEN 'Mestre' ELSE 'Doutor' END,
            campus_names[posicao],
            campus_ceps[posicao]
        );
    END LOOP;
END $$;

DO $$
DECLARE
    i INT;
    chefe RECORD;
BEGIN
    FOR i IN 1..1000 LOOP
        -- Seleciona aleatoriamente um professor existente
        SELECT nome, sobrenome, telefone
        INTO chefe
        FROM Usuario
        WHERE tipo = 'Professor'
        ORDER BY random()
        LIMIT 1;

        -- Insere o departamento com esse chefe
        INSERT INTO Departamento (CodDepartamento, nome, chefeNome, chefeSobrenome, chefeTelefone)
        VALUES (
            i,
            'Departamento ' || i,
            chefe.nome,
            chefe.sobrenome,
            chefe.telefone
        );
    END LOOP;
END $$;

DO $$
DECLARE
    i INT;
    unidade_idx INT;
BEGIN
    FOR i IN 1..1000 LOOP
        unidade_idx := (floor(random() * 20) + 1)::INT; -- Para escolher um campus entre os 20
        INSERT INTO Curso (codCurso, nome, nivelEnsino, cargaHoraria, numVagas, ementa, codDepartamento, nomeUnidade, cepUnidade)
        VALUES (
            i,
            'Curso ' || i,
            CASE WHEN random() < 0.5 THEN 'Graduação' ELSE 'Pós-graduação' END,
            (random() * 4000 + 1000)::INT,
            (random() * 100 + 20)::INT,
            'Ementa do curso ' || i,
            ((i - 1) % 1000) + 1, -- codDepartamento de 1 a 1000
            (SELECT nome FROM Unidade LIMIT 1 OFFSET (unidade_idx - 1)),
            (SELECT cep FROM Unidade LIMIT 1 OFFSET (unidade_idx - 1))
        );
    END LOOP;
END $$;

DO $$
DECLARE
    i INT;
    unidade_idx INT;
BEGIN
    FOR i IN 1..1000 LOOP
        unidade_idx := (floor(random() * 20) + 1)::INT;
        INSERT INTO Disciplina (codDisciplina, nome, qtdAulasSemanais, nomeUnidade, cepUnidade)
        VALUES (
            i,
            'Disciplina ' || i,
            (random() * 5 + 1)::INT,
            (SELECT nome FROM Unidade LIMIT 1 OFFSET (unidade_idx - 1)),
            (SELECT cep FROM Unidade LIMIT 1 OFFSET (unidade_idx - 1))
        );
    END LOOP;
END $$;

DO $$
DECLARE
    i INT;
BEGIN
    FOR i IN 1..1000 LOOP
        INSERT INTO Regra (idRegra, descricao)
        VALUES (
            i,
            'Regra ' || i
        );
    END LOOP;
END $$;

DO $$
DECLARE
    i INT;
BEGIN
    FOR i IN 1..1000 LOOP
        INSERT INTO Infraestrutura (idInfraestrutura, tipo)
        VALUES (
            i,
            CASE WHEN random() < 0.5 THEN 'Laboratório' ELSE 'Sala de Aula' END || ' ' || i
        );
    END LOOP;
END $$;

DO $$
DECLARE
    i INT;
    disciplina_id INT;
BEGIN
    FOR i IN 1..1000 LOOP
        disciplina_id := ((i - 1) % 1000) + 1; -- Fazendo os idDisciplina variar de 1 a 1000
        INSERT INTO OfertaDisciplina (idOferta, codDisciplina, periodoLetivo, capacidadeTurma, salaDeAula)
        VALUES (
            i,
            disciplina_id,
            CASE WHEN random() < 0.5 THEN '2025-1' ELSE '2025-2' END,
            (random() * 100 + 20)::INT,
            'Sala ' || i
        );
    END LOOP;
END $$;

DO $$
DECLARE
    i INT;
    curso_ids INT[];
    total INT;
    j INT;
BEGIN
    SELECT array_agg(codCurso) FROM Curso INTO curso_ids;
    total := array_length(curso_ids,1);

    FOR i IN 1..1000 LOOP
        -- Escolhe um curso para ser o principal
        IF total IS NULL THEN
            RAISE EXCEPTION 'Não há cursos cadastrados';
        END IF;
        j := (floor(random()*total)+1)::INT;

        -- Insere um pré-requisito qualquer (nome de outro curso)
        INSERT INTO PreRequisitos (codCurso, nome)
        VALUES (
            curso_ids[j],
            'Pré-requisito para curso ' || curso_ids[j] || ' número ' || i
        );
    END LOOP;
END $$;

DO $$
DECLARE
    i INT;
    j INT;
    disciplina_ids INT[];
    total INT;
BEGIN
    SELECT array_agg(codDisciplina) FROM Disciplina INTO disciplina_ids;
    total := array_length(disciplina_ids,1);

    FOR i IN 1..1000 LOOP
        j := (floor(random()*total)+1)::INT;

        INSERT INTO MaterialDidatico (codDisciplina, descricao)
        VALUES (
            disciplina_ids[j],
            'Material didático para disciplina ' || disciplina_ids[j] || ' número ' || i
        );
    END LOOP;
END $$;

DO $$
DECLARE
    i INT;
    curso_ids INT[];
    disciplina_ids INT[];
    total_curso INT;
    total_disc INT;
    c INT;
    d INT;
BEGIN
    SELECT array_agg(codCurso) FROM Curso INTO curso_ids;
    SELECT array_agg(codDisciplina) FROM Disciplina INTO disciplina_ids;
    total_curso := array_length(curso_ids,1);
    total_disc := array_length(disciplina_ids,1);

    FOR i IN 1..1000 LOOP
        c := (floor(random()*total_curso)+1)::INT;
        d := (floor(random()*total_disc)+1)::INT;

        BEGIN
            INSERT INTO Compor (codCurso, codDisciplina)
            VALUES (curso_ids[c], disciplina_ids[d]);
        EXCEPTION WHEN unique_violation THEN
            -- Já existe, ignora
            NULL;
        END;
    END LOOP;
END $$;

DO $$
DECLARE
    i INT;
    curso_ids INT[];
    regra_ids INT[];
    total_curso INT;
    total_regra INT;
    c INT;
    r INT;
BEGIN
    SELECT array_agg(codCurso) FROM Curso INTO curso_ids;
    SELECT array_agg(idRegra) FROM Regra INTO regra_ids;
    total_curso := array_length(curso_ids,1);
    total_regra := array_length(regra_ids,1);

    FOR i IN 1..1000 LOOP
        c := (floor(random()*total_curso)+1)::INT;
        r := (floor(random()*total_regra)+1)::INT;

        BEGIN
            INSERT INTO Possuir (codCurso, idRegra)
            VALUES (curso_ids[c], regra_ids[r]);
        EXCEPTION WHEN unique_violation THEN
            NULL;
        END;
    END LOOP;
END $$;

DO $$
DECLARE
    i INT;
    disciplina_ids INT[];
    total_disc INT;
    usuarios RECORD;
    class_mat INT;
    class_rel INT;
    class_infra INT;
BEGIN
    SELECT array_agg(codDisciplina) FROM Disciplina INTO disciplina_ids;
    total_disc := array_length(disciplina_ids,1);

    FOR i IN 1..1000 LOOP
        -- Selecionar tipo também!
        SELECT nome, sobrenome, telefone, tipo 
        FROM Usuario 
        ORDER BY random() 
        LIMIT 1 
        INTO usuarios;

        IF usuarios.tipo = 'Aluno' THEN
            class_mat := (floor(random()*6))::INT;
            class_rel := (floor(random()*6))::INT;
            class_infra := (floor(random()*6))::INT;

            INSERT INTO AvaliarDisciplina (
                codDisciplina, nomeUsuario, sobrenomeUsuario, telefoneUsuario, comentario,
                classificacaoMaterial, classificacaoRelevancia, classificacaoInfraestrutura
            )
            VALUES (
                disciplina_ids[(floor(random()*total_disc)+1)::INT],
                usuarios.nome,
                usuarios.sobrenome,
                usuarios.telefone,
                'Comentário da avaliação ' || i,
                class_mat,
                class_rel,
                class_infra
            );
        END IF;
    END LOOP;
END $$;

DO $$
DECLARE
    i INT;
    remetente RECORD;
    destinatario RECORD;
BEGIN
    FOR i IN 1..1000 LOOP
        SELECT nome, sobrenome, telefone FROM Usuario ORDER BY random() LIMIT 1 INTO remetente;
        SELECT nome, sobrenome, telefone FROM Usuario ORDER BY random() LIMIT 1 INTO destinatario;

        -- Evitar remetente = destinatario
        IF (remetente.nome = destinatario.nome AND remetente.sobrenome = destinatario.sobrenome AND remetente.telefone = destinatario.telefone) THEN
            CONTINUE;
        END IF;

        INSERT INTO Mensagem (
            idMensagem, nomeRemetente, sobrenomeRemetente, telefoneRemetente,
            nomeDestinatario, sobrenomeDestinatario, telefoneDestinatario,
            timestamp, texto
        )
        VALUES (
            i,
            remetente.nome,
            remetente.sobrenome,
            remetente.telefone,
            destinatario.nome,
            destinatario.sobrenome,
            destinatario.telefone,
            now()::time,
            'Mensagem teste ' || i
        );
    END LOOP;
END $$;

DO $$
DECLARE
    i INT := 0;
    professor RECORD;
    aluno RECORD;
    classif INT;
BEGIN
    WHILE i < 1000 LOOP
        SELECT nome, sobrenome, telefone FROM Usuario WHERE tipo='Professor' ORDER BY random() LIMIT 1 INTO professor;
        SELECT nome, sobrenome, telefone FROM Usuario WHERE tipo='Aluno' ORDER BY random() LIMIT 1 INTO aluno;

        classif := (floor(random()*6))::INT;

        -- Verifica se o par já existe
        IF NOT EXISTS (
            SELECT 1 FROM AvaliarProfessor
            WHERE nomeP = professor.nome
              AND sobrenomeP = professor.sobrenome
              AND telefoneP = professor.telefone
              AND nomeA = aluno.nome
              AND sobrenomeA = aluno.sobrenome
              AND telefoneA = aluno.telefone
        ) THEN
            INSERT INTO AvaliarProfessor (
                nomeP, sobrenomeP, telefoneP, nomeA, sobrenomeA, telefoneA, classificacaoDidatica, comentario
            )
            VALUES (
                professor.nome, professor.sobrenome, professor.telefone,
                aluno.nome, aluno.sobrenome, aluno.telefone,
                classif,
                'Comentário do professor ' || i+1
            );
            i := i + 1;
        END IF;
        -- Se já existir, vai tentar outro par (não incrementa i)
    END LOOP;
END $$;

DO $$
DECLARE
    i INT;
    aluno RECORD;
    oferta RECORD;
    status_arr status_enum[] := ARRAY['Ativa', 'Trancada', 'Concluída', 'Reprovada'];
    data_matricula DATE;
    data_confirm DATE;
    conf BOOLEAN;
    pag_taxas BOOLEAN;
    desc_val NUMERIC(5,2);
BEGIN
    FOR i IN 1..1000 LOOP
        -- Seleciona um aluno aleatório
        SELECT nome, sobrenome, telefone FROM Usuario WHERE tipo='Aluno' ORDER BY random() LIMIT 1 INTO aluno;
        -- Seleciona uma oferta aleatória
        SELECT idOferta, codDisciplina FROM OfertaDisciplina ORDER BY random() LIMIT 1 INTO oferta;

        -- Gera datas e status coerentes
        data_matricula := CURRENT_DATE - (floor(random() * 365 * 2))::INT; -- até 2 anos atrás
        conf := (random() < 0.7); -- 70% chance de confirmação
        pag_taxas := (random() < 0.8); -- 80% chance de pagamento de taxas
        desc_val := ROUND((random() * 30)::numeric, 2); -- desconto até 30% com 2 casas decimais
        data_confirm := CASE WHEN conf THEN data_matricula + (floor(random() * 30))::INT ELSE NULL END; -- confirmação até 30 dias depois
       
        INSERT INTO Matricular (
            nomeA, sobrenomeA, telefoneA, idOferta, codDisciplina, dataMatricula,
            status, desconto, dataConfirmacao, confirmacao, pagamentoTaxas
        )
        VALUES (
            aluno.nome,
            aluno.sobrenome,
            aluno.telefone,
            oferta.idOferta,
            oferta.codDisciplina,
            data_matricula,
            status_arr[(floor(random() * array_length(status_arr, 1)) + 1)],
            desc_val,
            data_confirm,
            conf,
            pag_taxas
        )
        ON CONFLICT DO NOTHING;  -- evita erro se duplicar matrícula
    END LOOP;
END $$;

DO $$
DECLARE
    i INT;
    matricula RECORD;
    nota_val NUMERIC(5,2);
BEGIN
    FOR i IN 1..1000 LOOP
        -- Seleciona uma matrícula aleatória
        SELECT nomeA, sobrenomeA, telefoneA, idOferta, codDisciplina
        FROM Matricular
        ORDER BY random()
        LIMIT 1
        INTO matricula;

        -- Gera nota aleatória entre 0 e 10 com 2 casas decimais
        nota_val := ROUND((random() * 10)::numeric, 2);

        -- Insere na tabela Notas
        INSERT INTO Notas (
            nomeA, sobrenomeA, telefoneA, idOferta, codDisciplina, nota
        )
        VALUES (
            matricula.nomeA,
            matricula.sobrenomeA,
            matricula.telefoneA,
            matricula.idOferta,
            matricula.codDisciplina,
            nota_val
        )
        ON CONFLICT DO NOTHING;  -- evita erro se tentar duplicar
    END LOOP;
END $$;
