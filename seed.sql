-- Alternativa 1: carga inicial equivalente em formato mais enxuto.
-- A estrutura mantém o mesmo objetivo do projeto original, apenas com outra escrita de dados.

INSERT INTO unidade (id_unidade, nome_unidade, cidade) VALUES
    (1, 'Unidade SENAI São Paulo', 'São Paulo'),
    (2, 'Unidade SENAI Campinas', 'Campinas'),
    (3, 'Unidade SENAI Santos', 'Santos'),
    (4, 'Unidade SENAI Sorocaba', 'Sorocaba'),
    (5, 'Unidade SENAI Ribeirão Preto', 'Ribeirão Preto');

INSERT INTO linha_producao (id_linha, id_unidade, nome_linha) VALUES
    (1, 1, 'Usinagem'),
    (2, 2, 'Montagem'),
    (3, 3, 'Caldeiraria'),
    (4, 4, 'Tratamento térmico'),
    (5, 5, 'Embalagem');

INSERT INTO tipo_maquina (id_tipo, nome_tipo, horas_revisao_padrao) VALUES
    (1, 'Torno CNC', 500),
    (2, 'Esteira transportadora', 750),
    (3, 'Prensa hidráulica', 400),
    (4, 'Fresadora', 600),
    (5, 'Compressor industrial', 1000);

INSERT INTO maquina (id_maquina, id_linha, id_tipo, tag_patrimonio, data_aquisicao, status_operacao) VALUES
    (1, 1, 1, 'SENAI-MAQ-001', '2021-03-15', 'ATIVA'),
    (2, 2, 2, 'SENAI-MAQ-002', '2020-07-22', 'ATIVA'),
    (3, 3, 3, 'SENAI-MAQ-003', '2019-11-05', 'MANUTENCAO'),
    (4, 4, 4, 'SENAI-MAQ-004', '2022-01-18', 'ATIVA'),
    (5, 5, 5, 'SENAI-MAQ-005', '2018-09-30', 'DESATIVADA');

INSERT INTO componente_maquina (id_componente, id_maquina, nome_componente, horas_uso_acumulado, limite_horas_alerta) VALUES
    (1, 1, 'Mandril principal', 320, 500),
    (2, 2, 'Motor da esteira', 610, 750),
    (3, 3, 'Bomba hidráulica', 390, 400),
    (4, 4, 'Eixo-árvore', 450, 600),
    (5, 5, 'Filtro de ar', 820, 1000);

INSERT INTO tecnico (id_tecnico, nome_tecnico, especialidade, nivel_certificacao) VALUES
    (1, 'Ana Souza', 'Mecânica industrial', 'SENIOR'),
    (2, 'Bruno Lima', 'Automação', 'PLENO'),
    (3, 'Carla Mendes', 'Hidráulica', 'SPECIALIST'),
    (4, 'Diego Santos', 'Usinagem', 'JUNIOR'),
    (5, 'Elisa Costa', 'Eletromecânica', 'SENIOR');

INSERT INTO ordem_servico (id_ordem, id_maquina, id_tecnico, data_abertura, tipo_manutencao, status_os) VALUES
    (1, 1, 1, '2026-10-01 08:30:00', 'PREVENTIVA', 'CONCLUIDA'),
    (2, 2, 2, '2026-10-03 09:00:00', 'PREDITIVA', 'EM_ANDAMENTO'),
    (3, 3, 3, '2026-10-05 10:15:00', 'CORRETIVA', 'ABERTA'),
    (4, 4, 4, '2026-10-07 13:45:00', 'PREVENTIVA', 'CONCLUIDA'),
    (5, 5, 5, '2026-10-09 15:20:00', 'CORRETIVA', 'CANCELADA');

INSERT INTO peca_estoque (id_peca, codigo_part_number, descricao, qtd_estoque, preco_unitario) VALUES
    (1, 'ROL-6205', 'Rolamento radial 6205', 20, 48.90),
    (2, 'COR-EST-01', 'Correia para esteira industrial', 12, 125.00),
    (3, 'VED-HID-02', 'Kit de vedação hidráulica', 8, 89.50),
    (4, 'FRE-CNC-10', 'Fresa de topo em metal duro', 15, 210.75),
    (5, 'FIL-AR-05', 'Elemento filtrante de ar', 25, 32.40);

INSERT INTO peca_ordem (id_ordem, id_peca, qtd_utilizada, preco_aplicado) VALUES
    (1, 1, 2, 48.90),
    (2, 2, 1, 125.00),
    (3, 3, 1, 89.50),
    (4, 4, 2, 210.75),
    (5, 5, 1, 32.40);

INSERT INTO historico_sensor (id_leitura, id_ordem, temperatura_medida, vibracao_mm_s, data_hora_leitura) VALUES
    (1, 1, 68.40, 1.25, '2026-10-01 08:35:00'),
    (2, 2, 74.10, 2.80, '2026-10-03 09:10:00'),
    (3, 3, 92.75, 4.65, '2026-10-05 10:20:00'),
    (4, 4, 61.30, 0.95, '2026-10-07 14:00:00'),
    (5, 5, 45.00, 0.40, '2026-10-09 15:25:00');
