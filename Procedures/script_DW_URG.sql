use dw_urg;

DELIMITER //
 
CREATE PROCEDURE `PREENCHE_DIM_CAUSA`()
BEGIN
	-- Variáves
	DECLARE v_finished INTEGER DEFAULT 0;
	DECLARE v_des_causa TEXT;
 
	-- Cursor
	DECLARE cursor_causa CURSOR FOR 
	SELECT DISTINCT des_causa FROM bd_urg.urg_inform_geral
	ORDER BY des_causa ASC;
 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;
 
	OPEN cursor_causa;
 
	get_causa: LOOP
 
	FETCH cursor_causa INTO v_des_causa;
 
	IF v_finished = 1 THEN 
		LEAVE get_causa;
	END IF;
 
	-- Preenche a tabela DIM_CAUSA
    INSERT INTO DIM_CAUSA(descricao_cau) VALUES (v_des_causa);
    COMMIT;
 
	END LOOP get_causa;
 
	CLOSE cursor_causa;
 
END //
 
DELIMITER ;

DELIMITER //
 
CREATE PROCEDURE `PREENCHE_DIM_DATA`()
BEGIN

	-- Variáveis
	DECLARE v_finished INTEGER DEFAULT 0;
    DECLARE v_desDatas TEXT;
        
	-- Cursor
	DECLARE cursor_data CURSOR FOR SELECT DATE_FORMAT(DATAHORA_ADM, '%Y-%m-%d') FROM bd_urg.urg_inform_geral
	UNION SELECT DATE_FORMAT(DATAHORA_ALTA, '%Y-%m-%d') FROM bd_urg.urg_inform_geral
	UNION SELECT DTA_NASCIMENTO FROM bd_urg.urg_inform_geral;
		
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;
 
	OPEN cursor_data;
 
	get_data: LOOP
 
	FETCH cursor_data INTO v_desDatas;
 
	IF v_finished = 1 THEN 
		LEAVE get_data;
	END IF;
 
	-- Preencher a tabela DIM_DATA
	INSERT INTO DIM_DATA(data) VALUES (v_desDatas);
	COMMIT;
 
	END LOOP get_data;
 
	CLOSE cursor_data;
 
END //
 
DELIMITER ; 


DELIMITER //
 
CREATE PROCEDURE `PREENCHE_DIM_ESPECIALIDADE`()
BEGIN
		
        -- Variáveis
		DECLARE v_finished INTEGER DEFAULT 0;
        DECLARE v_especialidade TEXT;
        
        -- Cursor 
        DECLARE cursor_especialidade CURSOR FOR 
		SELECT DISTINCT alta_des_especialidade FROM bd_urg.urg_inform_geral
		ORDER BY alta_des_especialidade ASC;
 
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;
 
		OPEN cursor_especialidade;
 
		get_especialidade: LOOP
 
		FETCH cursor_especialidade INTO v_especialidade;
 
		IF v_finished = 1 THEN 
		LEAVE get_especialidade;
		END IF;
 
		-- Preencher a tabela DIM_Especialidade
		INSERT INTO DIM_ESPECIALIDADE(descricao_esp) VALUES (v_especialidade);
		COMMIT;
 
		END LOOP get_especialidade;
 
		CLOSE cursor_especialidade;
        
 
END //
 
DELIMITER ;

DELIMITER //
 
CREATE PROCEDURE `PREENCHE_DIM_GENERO`()
BEGIN
	
    -- Variáveis
	DECLARE v_finished INTEGER DEFAULT 0;
	DECLARE v_genero TEXT;
 
	-- Cursor 
	DECLARE cursor_genero CURSOR FOR 
	SELECT DISTINCT sexo FROM bd_urg.urg_inform_geral
	ORDER BY sexo ASC;
 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;
 
	OPEN cursor_genero;
 
	get_genero: LOOP
 
	FETCH cursor_genero INTO v_genero;
 
	IF v_finished = 1 THEN 
		LEAVE get_genero;
	END IF;
 
	-- Preencher a tabela DIM_GENERO
    INSERT INTO DIM_GENERO(descricao_gen) VALUES (v_genero);
    COMMIT;
 
	END LOOP get_genero;
 
	CLOSE cursor_genero;

 
END //
 
DELIMITER ;

DELIMITER //
 
CREATE PROCEDURE `PREENCHE_DIM_LOCAL`()
BEGIN
	
    -- Variáveis
	DECLARE v_finished INTEGER DEFAULT 0;
	DECLARE v_des_local TEXT;
 
	-- Cursor 
	DECLARE cursor_local CURSOR FOR 
	SELECT DISTINCT des_local FROM bd_urg.urg_inform_geral
	ORDER BY des_local ASC;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;
 
	OPEN cursor_local;
 
	get_local: LOOP
 
	FETCH cursor_local INTO v_des_local;
 
	IF v_finished = 1 THEN 
		LEAVE get_local;
	END IF;
 
	-- Preencher a tabela DIM_Local
    INSERT INTO DIM_LOCAL(descricao_loc) VALUES (v_des_local);
    COMMIT;
 
	END LOOP get_local;
 
	CLOSE cursor_local;
 
END //
 
DELIMITER ;

DELIMITER //
 
CREATE PROCEDURE `PREENCHE_DIM_PROVENIENCIA`()
BEGIN
	
    -- Variáveis
	DECLARE v_finished INTEGER DEFAULT 0;
    DECLARE v_des_proveniencia TEXT;
        
    -- Cursor
	DECLARE cursor_proveniencia CURSOR FOR 
	SELECT DISTINCT des_proveniencia FROM bd_urg.urg_inform_geral
	ORDER BY des_proveniencia ASC;
 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;
 
	OPEN cursor_proveniencia;

	get_proveniencia: LOOP
 
	FETCH cursor_proveniencia INTO v_des_proveniencia;

	IF v_finished = 1 THEN 
	LEAVE get_proveniencia;
	END IF;
 
	-- Preencher a tabela DIM_PROVENIENCIA
	INSERT INTO DIM_PROVENIENCIA(descricao_prov) VALUES (v_des_proveniencia);
	COMMIT;
 
	END LOOP get_proveniencia;
 
	CLOSE cursor_proveniencia;
 
END //
 
DELIMITER ;


 DELIMITER //
 
CREATE PROCEDURE `PREENCHE_FACTS_URG`()
BEGIN
	
    /*---------- Variáveis ----------*/
    
	DECLARE v_finished INTEGER DEFAULT 0;
	DECLARE v_idUrgencia INT(11);
    DECLARE v_tempo_adm_alta INT(11);
	DECLARE v_idade_paciente INT(11);
    DECLARE v_cod_local INT(11);
    DECLARE v_cod_proveniencia INT(11);
    DECLARE v_cod_data_adm INT(11);
	DECLARE v_cod_data_alta INT(11);
	DECLARE v_cod_data_nascimento INT(11);
    DECLARE v_cod_especialidade INT(11);
	DECLARE v_cod_causa INT(11);
    DECLARE v_cod_genero INT(11);
    
	/*-- Variáveis para os cursores --*/
	
	-- GENERO
    DECLARE v_finished_genero INTEGER DEFAULT 0;
    DECLARE cod_genero1 INT(11);
    DECLARE genero1 TEXT;
    DECLARE genero2 VARCHAR(250);
    
    -- LOCAL
    DECLARE v_finished_local INTEGER DEFAULT 0;
    DECLARE cod_local1 INT(11);
    DECLARE local1 TEXT;
    DECLARE local2 VARCHAR(250);
    
    -- PROVENIENCIA
    DECLARE v_finished_proveniencia INTEGER DEFAULT 0;
    DECLARE cod_proveniencia1 INT(11);
    DECLARE proveniencia1 TEXT;
    DECLARE proveniencia2 VARCHAR(250);
    
    -- DATA
    DECLARE v_finished_data INTEGER DEFAULT 0;
	-- DATA_ADM
    DECLARE cod_data_adm1 INT(11);
    DECLARE data_adm1 TEXT;
    DECLARE data_adm2 VARCHAR(250);
	-- DATA_ALTA
    DECLARE cod_data_alta1 INT(11);
    DECLARE data_alta1 TEXT;
    DECLARE data_alta2 VARCHAR(250);
    -- DATA_NASCIMENTO
    DECLARE cod_data_nascimento1 INT(11);
    DECLARE data_nascimento1 TEXT;
    DECLARE data_nascimento2 VARCHAR(250);
    
    -- ESPECIALIDADE
    DECLARE v_finished_especialidade INTEGER DEFAULT 0;
    DECLARE cod_especialidade1 INT(11);
    DECLARE especialidade1 TEXT;
    DECLARE especialidade2 VARCHAR(250);
    
    -- CAUSA
    DECLARE v_finished_causa INTEGER DEFAULT 0;
    DECLARE cod_causa1 INT(11);
    DECLARE causa1 TEXT;
    DECLARE causa2 VARCHAR(250);
    
    
    /*-- Declaração dos cursores --*/
    
	-- URGENCIA
    DECLARE cursor_idUrgencia CURSOR FOR 
    SELECT DISTINCT URG_EPISODIO, 
    TIMESTAMPDIFF(MINUTE,DATAHORA_ADM,DATAHORA_ALTA),
    TIMESTAMPDIFF(YEAR,DTA_NASCIMENTO,DATAHORA_ADM)
	FROM bd_urg.urg_inform_geral
	ORDER BY URG_EPISODIO ASC;
	
    -- GENERO 
	DECLARE cursor_genero CURSOR FOR 
	SELECT DISTINCT id_genero
    FROM DIM_GENERO
	ORDER BY id_genero ASC;
	
    -- LOCAL
	DECLARE cursor_local CURSOR FOR 
	SELECT DISTINCT id_local
    FROM DIM_LOCAL
	ORDER BY id_local ASC;
    
    -- PROVENIENCIA
	DECLARE cursor_proveniencia CURSOR FOR 
	SELECT DISTINCT id_proveniencia
    FROM DIM_PROVENIENCIA
	ORDER BY id_proveniencia ASC;
    
    -- DATA
	DECLARE cursor_data CURSOR FOR 
	SELECT DISTINCT id_data
    FROM DIM_DATA
	ORDER BY id_data ASC;
    
    -- ESPECIALIDADE
	DECLARE cursor_especialidade CURSOR FOR 
	SELECT DISTINCT id_especialidade
    FROM DIM_ESPECIALIDADE
	ORDER BY id_especialidade ASC;
    
    -- CAUSA
	DECLARE cursor_causa CURSOR FOR 
	SELECT DISTINCT id_causa
    FROM DIM_CAUSA
	ORDER BY id_causa ASC;
    
 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;
 
	OPEN cursor_idUrgencia;
 
	get_idUrgencia: LOOP
 
	SET v_finished = 0;
    
	FETCH cursor_idUrgencia INTO v_idUrgencia, v_tempo_adm_alta, v_idade_paciente;
 
	IF v_finished = 1 THEN 
		LEAVE get_idUrgencia;
	END IF;
    
    /*-- Preenchimento das Tabelas --*/
    
    -- GENERO 
    SELECT SEXO INTO genero1 FROM bd_urg.urg_inform_geral WHERE URG_EPISODIO=v_idUrgencia;
    SET v_finished_genero = 0;
    OPEN cursor_genero;
	get_genero: LOOP
	FETCH cursor_genero INTO cod_genero1;
	IF v_finished_genero = 1 THEN 
		LEAVE get_genero;
	END IF; 
	-- Atribuição de v_cod_genero
    SELECT descricao_gen INTO genero2 FROM DIM_GENERO WHERE id_genero = cod_genero1;
    IF (genero1 LIKE genero2) THEN
		SET v_cod_genero = cod_genero1;
        SET v_finished_genero = 1;
	END IF; 
	END LOOP get_genero;
	CLOSE cursor_genero;
    
    -- LOCAL 
    SELECT DES_LOCAL INTO local1 FROM bd_urg.urg_inform_geral WHERE URG_EPISODIO=v_idUrgencia;
    SET v_finished_local = 0;
    OPEN cursor_local;
	get_local: LOOP
	FETCH cursor_local INTO cod_local1;
	IF v_finished_local = 1 THEN 
		LEAVE get_local;
	END IF; 
	--  Atribuição de v_cod_local
    SELECT descricao_loc INTO local2 
    FROM DIM_LOCAL 
    WHERE id_local = cod_local1;
    IF (local1 LIKE local2) THEN
		SET v_cod_local = cod_local1;
        SET v_finished_local = 1;
	END IF; 
	END LOOP get_local;
	CLOSE cursor_local;
    
	-- PROVENIENCIA 
    SELECT DES_PROVENIENCIA INTO proveniencia1 FROM bd_urg.urg_inform_geral WHERE URG_EPISODIO=v_idUrgencia;
    SET v_finished_proveniencia = 0;
    OPEN cursor_proveniencia;
	get_proveniencia: LOOP
	FETCH cursor_proveniencia INTO cod_proveniencia1;
	IF v_finished_proveniencia = 1 THEN 
		LEAVE get_proveniencia;
	END IF; 
	-- Atribuição de v_cod_proveniencia
    SELECT descricao_prov INTO proveniencia2 FROM DIM_PROVENIENCIA WHERE id_proveniencia = cod_proveniencia1;
    IF (proveniencia1 LIKE proveniencia2) THEN
		SET v_cod_proveniencia = cod_proveniencia1;
        SET v_finished_proveniencia = 1;
	END IF; 
	END LOOP get_proveniencia;
	CLOSE cursor_proveniencia;
    
    -- DATA_ADM
    SELECT DATE_FORMAT(DATAHORA_ADM, '%Y-%m-%d') INTO data_adm1 FROM bd_urg.urg_inform_geral WHERE URG_EPISODIO=v_idUrgencia;
    SET v_finished_data = 0;
    OPEN cursor_data;
	get_data: LOOP
	FETCH cursor_data INTO cod_data_adm1;
	IF v_finished_data = 1 THEN 
		LEAVE get_data;
	END IF; 
	-- Atribuição de v_cod_data_adm
    SELECT data INTO data_adm2 FROM DIM_DATA WHERE id_data= cod_data_adm1;
    IF (data_adm1 LIKE data_adm2) THEN
		SET v_cod_data_adm = cod_data_adm1;
        SET v_finished_data = 1;
	END IF; 
	END LOOP get_data;
	CLOSE cursor_data;
    
    -- DATA_ALTA
    SELECT DATE_FORMAT(DATAHORA_ALTA, '%Y-%m-%d') INTO data_alta1 FROM bd_urg.urg_inform_geral WHERE URG_EPISODIO=v_idUrgencia;
    SET v_finished_data = 0;
    OPEN cursor_data;
	get_data: LOOP
	FETCH cursor_data INTO cod_data_alta1;
	IF v_finished_data = 1 THEN 
		LEAVE get_data;
	END IF; 
	-- Atribuição de v_cod_data_alta
    SELECT data INTO data_alta2 FROM DIM_DATA WHERE id_data = cod_data_alta1;
    IF (data_alta1 LIKE data_alta2) THEN
		SET v_cod_data_alta = cod_data_alta1;
        SET v_finished_data = 1;
	END IF; 
	END LOOP get_data;
	CLOSE cursor_data;
    
    -- DATA_NASCIMENTO
    SELECT DTA_NASCIMENTO INTO data_nascimento1 FROM bd_urg.urg_inform_geral WHERE URG_EPISODIO=v_idUrgencia;
    SET v_finished_data = 0;
    OPEN cursor_data;
	get_data: LOOP
	FETCH cursor_data INTO cod_data_nascimento1;
	IF v_finished_data = 1 THEN 
		LEAVE get_data;
	END IF; 
	-- Atribuição de v_cod_data_nascimento
    SELECT data INTO data_nascimento2 FROM DIM_DATA WHERE id_data = cod_data_nascimento1;
    IF (data_nascimento1 LIKE data_nascimento2) THEN
		SET v_cod_data_nascimento = cod_data_nascimento1;
        SET v_finished_data = 1;
	END IF; 
	END LOOP get_data;
	CLOSE cursor_data;
    
    -- ESPECIALIDADE 
    SELECT ALTA_DES_ESPECIALIDADE INTO especialidade1 FROM bd_urg.urg_inform_geral WHERE URG_EPISODIO=v_idUrgencia;
    SET v_finished_especialidade = 0;
    OPEN cursor_especialidade;
	get_especialidade: LOOP
	FETCH cursor_especialidade INTO cod_especialidade1;
	IF v_finished_especialidade = 1 THEN 
		LEAVE get_especialidade;
	END IF; 
	-- Atribuição de v_cod_especialidade
    SELECT descricao_esp INTO especialidade2 FROM DIM_ESPECIALIDADE WHERE id_especialidade = cod_especialidade1;
    IF (especialidade1 LIKE especialidade2) THEN
		SET v_cod_especialidade = cod_especialidade1;
        SET v_finished_especialidade = 1;
	END IF; 
	END LOOP get_especialidade;
	CLOSE cursor_especialidade;
    
	-- CAUSA 
    SELECT DES_CAUSA INTO causa1 FROM bd_urg.urg_inform_geral WHERE URG_EPISODIO=v_idUrgencia;
    SET v_finished_causa = 0;
    OPEN cursor_causa;
	get_causa: LOOP
	FETCH cursor_causa INTO cod_causa1;
	IF v_finished_causa = 1 THEN 
		LEAVE get_causa;
	END IF; 
	-- Atribuição de v_cod_causa
    SELECT descricao_cau INTO causa2 FROM DIM_CAUSA WHERE id_causa = cod_causa1;
    IF (causa1 LIKE causa2) THEN
		SET v_cod_causa = cod_causa1;
        SET v_finished_causa = 1;
	END IF; 
	END LOOP get_causa;
	CLOSE cursor_causa;
    
    
	-- Preenche a tabela de factos FACTS_URG
    INSERT INTO FACTS_URG(idUrg, id_proveniencia, id_admissao, id_alta, 
    id_nascimento, id_especialidade, id_causa, id_genero, id_local, 
    tempo_adm_alta, idade_paciente) 
    VALUES (v_idUrgencia, v_cod_proveniencia, v_cod_data_adm, v_cod_data_alta, 
    v_cod_data_nascimento, v_cod_especialidade, v_cod_causa, v_cod_genero, 
    v_cod_local, v_tempo_adm_alta, v_idade_paciente);
    COMMIT;
    
	END LOOP get_idUrgencia;
 
	CLOSE cursor_idUrgencia;
 
END //
 
DELIMITER ;