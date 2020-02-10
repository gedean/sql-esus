/*
CORRIGE ERRO AO UNIFICAR CADASTRO - NullPointerException
AUTOR: BRIDGE
1 - Rodar o script pelo pgadmin;
2 - Após, isso, se lotar como administrador da instalação e realizar o envio manual de fichas ao Centralizador Nacional 
(PEC > Administração > Transmissão de dados > Controle de envio 
de fichas);
3 - Após a transmissão das fichas, se lotar como coordenador da unidade e realizar a unificação de cadastros (PEC > Gestão de cadastros > Unificação de cadastros de cidadão).
--------------------------------------------------------------*/
update tb_cds_cad_individual
set st_envio = 0
where not exists (select * from tb_dado_transp dt where dt.co_unico_dado_serializado = tb_cds_cad_individual.co_unico_ficha );

update tb_cds_cad_domiciliar
set st_envio = 0
where not exists (select * from tb_dado_transp dt where dt.co_unico_dado_serializado = tb_cds_cad_domiciliar.co_unico_ficha );

update tb_cds_ficha_atend_individual
set st_envio = 0
where not exists (select * from tb_dado_transp dt where dt.co_unico_dado_serializado = tb_cds_ficha_atend_individual.co_unico_ficha );

update tb_cds_ficha_atend_odonto
set st_envio = 0
where not exists (select * from tb_dado_transp dt where dt.co_unico_dado_serializado = tb_cds_ficha_atend_odonto.co_unico_ficha );

update tb_cds_ficha_ativ_col
set st_envio = 0
where not exists (select * from tb_dado_transp dt where dt.co_unico_dado_serializado = tb_cds_ficha_ativ_col.co_unico_ficha );

update tb_cds_ficha_proced
set st_envio = 0
where not exists (select * from tb_dado_transp dt where dt.co_unico_dado_serializado = tb_cds_ficha_proced.co_unico_ficha );

update tb_cds_ficha_visita_domiciliar
set st_envio = 0
where not exists (select * from tb_dado_transp dt where dt.co_unico_dado_serializado = tb_cds_ficha_visita_domiciliar.co_unico_ficha );

update tb_cds_ficha_consumo_alimentar
set st_envio = 0
where not exists (select * from tb_dado_transp dt where dt.co_unico_dado_serializado = tb_cds_ficha_consumo_alimentar.co_unico_ficha );

update tb_cds_aval_elegibilidade
set st_envio = 0
where not exists (select * from tb_dado_transp dt where dt.co_unico_dado_serializado = tb_cds_aval_elegibilidade.co_unico_ficha );

update tb_cds_ficha_atend_domiciliar
set st_envio = 0
where not exists (select * from tb_dado_transp dt where dt.co_unico_dado_serializado = tb_cds_ficha_atend_domiciliar.co_unico_ficha );

update tb_cds_ficha_zika_microcefalia
set st_envio = 0
where not exists (select * from tb_dado_transp dt where dt.co_unico_dado_serializado = tb_cds_ficha_zika_microcefalia.co_unico_ficha );

update tb_cds_ficha_vacinacao
set st_envio = 0
where not exists (select * from tb_dado_transp dt where dt.co_unico_dado_serializado = tb_cds_ficha_vacinacao.co_unico_ficha )