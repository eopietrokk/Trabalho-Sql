-- Alternativa 1: versão compacta, nomes mais enxutos e organização por blocos.
-- Objetivo: manter o mesmo domínio da manutenção industrial, mas com uma escrita diferente.

CREATE TABLE IF NOT EXISTS unidade (
    id_unidade INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome_unidade VARCHAR(120) NOT NULL,
    cidade VARCHAR(80) NOT NULL,
    PRIMARY KEY (id_unidade),
    UNIQUE KEY uq_unidade_nome (nome_unidade, cidade)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS linha_producao (
    id_linha INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_unidade INT UNSIGNED NOT NULL,
    nome_linha VARCHAR(120) NOT NULL,
    PRIMARY KEY (id_linha),
    UNIQUE KEY uq_linha_unidade_nome (id_unidade, nome_linha),
    KEY idx_linha_unidade (id_unidade),
    CONSTRAINT fk_linha_unidade FOREIGN KEY (id_unidade)
        REFERENCES unidade(id_unidade)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS tipo_maquina (
    id_tipo INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome_tipo VARCHAR(60) NOT NULL,
    horas_revisao_padrao INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_tipo),
    UNIQUE KEY uq_tipo_maquina_nome (nome_tipo),
    CONSTRAINT chk_horas_revisao CHECK (horas_revisao_padrao > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS maquina (
    id_maquina INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_linha INT UNSIGNED NOT NULL,
    id_tipo INT UNSIGNED NOT NULL,
    tag_patrimonio VARCHAR(30) NOT NULL,
    data_aquisicao DATE NOT NULL,
    status_operacao ENUM('ATIVA', 'MANUTENCAO', 'DESATIVADA') NOT NULL,
    PRIMARY KEY (id_maquina),
    UNIQUE KEY uq_maquina_tag (tag_patrimonio),
    KEY idx_maquina_linha (id_linha),
    KEY idx_maquina_tipo (id_tipo),
    CONSTRAINT fk_maquina_linha FOREIGN KEY (id_linha)
        REFERENCES linha_producao(id_linha)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_maquina_tipo FOREIGN KEY (id_tipo)
        REFERENCES tipo_maquina(id_tipo)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS componente_maquina (
    id_componente INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_maquina INT UNSIGNED NOT NULL,
    nome_componente VARCHAR(100) NOT NULL,
    horas_uso_acumulado INT UNSIGNED NOT NULL DEFAULT 0,
    limite_horas_alerta INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_componente),
    UNIQUE KEY uq_componente_maquina_nome (id_maquina, nome_componente),
    KEY idx_componente_maquina (id_maquina),
    CONSTRAINT fk_componente_maquina FOREIGN KEY (id_maquina)
        REFERENCES maquina(id_maquina)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_horas_uso CHECK (horas_uso_acumulado >= 0),
    CONSTRAINT chk_limite_alerta CHECK (limite_horas_alerta > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS tecnico (
    id_tecnico INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome_tecnico VARCHAR(120) NOT NULL,
    especialidade VARCHAR(80) NOT NULL,
    nivel_certificacao ENUM('JUNIOR', 'PLENO', 'SENIOR', 'SPECIALIST') NOT NULL,
    PRIMARY KEY (id_tecnico)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS ordem_servico (
    id_ordem INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_maquina INT UNSIGNED NOT NULL,
    id_tecnico INT UNSIGNED NOT NULL,
    data_abertura DATETIME NOT NULL,
    tipo_manutencao ENUM('PREVENTIVA', 'CORRETIVA', 'PREDITIVA') NOT NULL,
    status_os ENUM('ABERTA', 'EM_ANDAMENTO', 'CONCLUIDA', 'CANCELADA') NOT NULL,
    PRIMARY KEY (id_ordem),
    KEY idx_ordem_maquina (id_maquina),
    KEY idx_ordem_tecnico (id_tecnico),
    KEY idx_ordem_status_data (status_os, data_abertura),
    CONSTRAINT fk_ordem_maquina FOREIGN KEY (id_maquina)
        REFERENCES maquina(id_maquina)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_ordem_tecnico FOREIGN KEY (id_tecnico)
        REFERENCES tecnico(id_tecnico)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS peca_estoque (
    id_peca INT UNSIGNED NOT NULL AUTO_INCREMENT,
    codigo_part_number VARCHAR(50) NOT NULL,
    descricao VARCHAR(150) NOT NULL,
    qtd_estoque INT NOT NULL DEFAULT 0,
    preco_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_peca),
    UNIQUE KEY uq_peca_codigo (codigo_part_number),
    CONSTRAINT chk_qtd_estoque CHECK (qtd_estoque >= 0),
    CONSTRAINT chk_preco_peca CHECK (preco_unitario > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS peca_ordem (
    id_ordem INT UNSIGNED NOT NULL,
    id_peca INT UNSIGNED NOT NULL,
    qtd_utilizada INT UNSIGNED NOT NULL,
    preco_aplicado DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_ordem, id_peca),
    KEY idx_peca_ordem_peca (id_peca),
    CONSTRAINT fk_peca_ordem_ordem FOREIGN KEY (id_ordem)
        REFERENCES ordem_servico(id_ordem)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_peca_ordem_peca FOREIGN KEY (id_peca)
        REFERENCES peca_estoque(id_peca)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_qtd_utilizada CHECK (qtd_utilizada > 0),
    CONSTRAINT chk_preco_aplicado CHECK (preco_aplicado >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS historico_sensor (
    id_leitura INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_ordem INT UNSIGNED NOT NULL,
    temperatura_medida DECIMAL(5,2) NOT NULL,
    vibracao_mm_s DECIMAL(5,2) NOT NULL,
    data_hora_leitura DATETIME NOT NULL,
    PRIMARY KEY (id_leitura),
    KEY idx_sensor_ordem (id_ordem),
    CONSTRAINT fk_sensor_ordem FOREIGN KEY (id_ordem)
        REFERENCES ordem_servico(id_ordem)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_temp_sensor CHECK (temperatura_medida BETWEEN -50.00 AND 300.00),
    CONSTRAINT chk_vib_sensor CHECK (vibracao_mm_s >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
