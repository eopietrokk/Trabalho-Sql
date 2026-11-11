-- Esquema do sistema de manutenção industrial SENAI.
-- Compatível com MySQL 8.0.16+ (para aplicação das constraints CHECK).
-- Execute este arquivo antes de seed.sql.

CREATE TABLE unidades_senai (
    id_unidade INT NOT NULL AUTO_INCREMENT,
    nome_unidade VARCHAR(100) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_unidade)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE linhas_producao (
    id_linha INT NOT NULL AUTO_INCREMENT,
    id_unidade INT NOT NULL,
    nome_linha VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_linha),
    CONSTRAINT fk_linhas_unidade
        FOREIGN KEY (id_unidade) REFERENCES unidades_senai (id_unidade)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tipos_maquina (
    id_tipo INT NOT NULL AUTO_INCREMENT,
    nome_tipo VARCHAR(50) NOT NULL,
    horas_revisao_padrao INT NOT NULL,
    PRIMARY KEY (id_tipo),
    CONSTRAINT chk_tipo_horas_revisao CHECK (horas_revisao_padrao > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE maquinas_senai (
    id_maquina INT NOT NULL AUTO_INCREMENT,
    id_linha INT NOT NULL,
    id_tipo INT NOT NULL,
    tag_patrimonio VARCHAR(30) NOT NULL,
    data_aquisicao DATE NOT NULL,
    status_operacao VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_maquina),
    CONSTRAINT uq_maquina_tag UNIQUE (tag_patrimonio),
    CONSTRAINT fk_maquinas_linha
        FOREIGN KEY (id_linha) REFERENCES linhas_producao (id_linha),
    CONSTRAINT fk_maquinas_tipo
        FOREIGN KEY (id_tipo) REFERENCES tipos_maquina (id_tipo),
    CONSTRAINT chk_maquina_status
        CHECK (status_operacao IN ('ATIVA', 'MANUTENCAO', 'DESATIVADA'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE componentes_maq (
    id_componente INT NOT NULL AUTO_INCREMENT,
    id_maquina INT NOT NULL,
    nome_componente VARCHAR(100) NOT NULL,
    horas_uso_acumulado INT NOT NULL DEFAULT 0,
    limite_horas_alerta INT NOT NULL,
    PRIMARY KEY (id_componente),
    CONSTRAINT fk_componentes_maquina
        FOREIGN KEY (id_maquina) REFERENCES maquinas_senai (id_maquina),
    CONSTRAINT chk_componente_horas_uso CHECK (horas_uso_acumulado >= 0),
    CONSTRAINT chk_componente_limite CHECK (limite_horas_alerta > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tecnicos (
    id_tecnico INT NOT NULL AUTO_INCREMENT,
    nome_tecnico VARCHAR(100) NOT NULL,
    especialidade VARCHAR(50) NOT NULL,
    nivel_certificacao VARCHAR(30) NOT NULL,
    PRIMARY KEY (id_tecnico),
    CONSTRAINT chk_tecnico_certificacao
        CHECK (nivel_certificacao IN ('JUNIOR', 'PLENO', 'SENIOR', 'SPECIALIST'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE ordens_servico (
    id_ordem INT NOT NULL AUTO_INCREMENT,
    id_maquina INT NOT NULL,
    id_tecnico INT NOT NULL,
    data_abertura DATETIME NOT NULL,
    tipo_manutencao VARCHAR(20) NOT NULL,
    status_os VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_ordem),
    CONSTRAINT fk_ordens_maquina
        FOREIGN KEY (id_maquina) REFERENCES maquinas_senai (id_maquina),
    CONSTRAINT fk_ordens_tecnico
        FOREIGN KEY (id_tecnico) REFERENCES tecnicos (id_tecnico),
    CONSTRAINT chk_ordem_tipo
        CHECK (tipo_manutencao IN ('PREVENTIVA', 'CORRETIVA', 'PREDITIVA')),
    CONSTRAINT chk_ordem_status
        CHECK (status_os IN ('ABERTA', 'EM_ANDAMENTO', 'CONCLUIDA', 'CANCELADA'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE estoque_pecas (
    id_peca INT NOT NULL AUTO_INCREMENT,
    codigo_part_number VARCHAR(50) NOT NULL,
    descricao VARCHAR(150) NOT NULL,
    qtd_estoque INT NOT NULL DEFAULT 0,
    preco_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_peca),
    CONSTRAINT uq_peca_part_number UNIQUE (codigo_part_number),
    CONSTRAINT chk_peca_quantidade CHECK (qtd_estoque >= 0),
    CONSTRAINT chk_peca_preco CHECK (preco_unitario > 0.00)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE pecas_os (
    id_ordem INT NOT NULL,
    id_peca INT NOT NULL,
    qtd_utilizada INT NOT NULL,
    preco_aplicado DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_ordem, id_peca),
    CONSTRAINT fk_pecas_os_ordem
        FOREIGN KEY (id_ordem) REFERENCES ordens_servico (id_ordem),
    CONSTRAINT fk_pecas_os_peca
        FOREIGN KEY (id_peca) REFERENCES estoque_pecas (id_peca),
    CONSTRAINT chk_pecas_os_quantidade CHECK (qtd_utilizada > 0),
    CONSTRAINT chk_pecas_os_preco CHECK (preco_aplicado >= 0.00)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE historico_sensores (
    id_leitura INT NOT NULL AUTO_INCREMENT,
    id_ordem INT NOT NULL,
    temperatura_medida DECIMAL(5,2) NOT NULL,
    vibracao_mm_s DECIMAL(5,2) NOT NULL,
    data_hora_leitura DATETIME NOT NULL,
    PRIMARY KEY (id_leitura),
    CONSTRAINT fk_historico_ordem
        FOREIGN KEY (id_ordem) REFERENCES ordens_servico (id_ordem),
    CONSTRAINT chk_sensor_temperatura
        CHECK (temperatura_medida BETWEEN -50.00 AND 300.00),
    CONSTRAINT chk_sensor_vibracao CHECK (vibracao_mm_s >= 0.00)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
