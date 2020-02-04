/*--------------------------------------------------------------*
CADASTRO DE HIPERTENSOS, GESTANTES - 30/01/2020
AUTOR: AURELIO CHAVES
ADAPTAÇÃO: SÉRGIO ROSA SCHÜTZ
REVISÃO: SÉRGIO SCHÜTZ
*--------------------------------------------------------------*
esta consulta retorna a lista de pessoas com hipertensao, gestantes, diabeticos e situcao de rua
*--------------------------------------------------------------*/

SELECT distinct tb_cidadao.nu_cns ,
tb_cidadao.no_cidadao,
tb_fat_cad_individual.dt_nascimento,
tb_fat_cad_individual.co_dim_sexo,
tb_fat_cad_individual.co_dim_unidade_saude,
tb_fat_cad_individual.co_dim_profissional,
tb_fat_cad_individual.nu_micro_area,
tb_fat_cad_individual.st_gestante,
tb_fat_cad_individual.st_hipertensao_arterial,
tb_fat_cad_individual.st_diabete,
tb_fat_cad_individual.st_hanseniase,
tb_fat_cad_individual.st_tuberculose,
tb_fat_cad_individual.st_acamado,
tb_fat_cad_individual.st_domiciliado,
tb_fat_cad_individual.co_dim_tipo_condicao_peso,
tb_fat_cad_individual.st_fumante,
tb_fat_cad_individual.st_alcool,
tb_fat_cad_individual.co_dim_tipo_saida_cadastro

FROM
public.tb_fat_cad_individual,
public.tb_cidadao

where
tb_cidadao.nu_cns  = tb_fat_cad_individual.nu_cns;
