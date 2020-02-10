/*--------------------------------------------------------------
MULTIPLAS OCORRENCIAS DE CADASTROS (COM DOCUMENTOS) - 03/02/2020
AUTOR: DIEGO RODRIGUES RIBEIRO
ADAPTAÇÃO: GEDEAN DIAS (gedean.dias@akapu.com.br)
--------------------------------------------------------------
ESTE SCRIPT GERA UM ARQUIVO 'CSV' (QUE PODE SER VISUALIZADO NO EXCEL)
CONTENDO INFORMAÇÕES DE PESSOAS (NOME, NOME MAE, DATA NASCIMENTO, CPF, CNS)
COM MAIS DE UMA OCORRENCIA DOS CAMPOS NOME, NOME MAE E DATA DE NASCIMENTO
INDICANDO POSSÍVEL DUPLICIDADE DE REGIRSTROS NA BASE DE DADOS DO E-SUS

** WHERE ST_UNIFICADO = 0 --> NÃO MOSTRA OS QUE JÁ FORAM UNIFICADOS
** NAO GERA TABELA TEMPORARIA NO BD, POSSIBILITANDO EXECUCOES CONSECUTIVAS 
DO SCRIPT SEM A OCORRENCIA DE ERROS POR TABELA JA EXISTENTE
--------------------------------------------------------------*/

WITH
    pessoas_duplicadas AS (
     SELECT
         tb_cidadao.no_cidadao,
         tb_cidadao.no_mae,
         tb_cidadao.dt_nascimento
     FROM
         tb_cidadao
     WHERE st_unificado = 0
     GROUP BY
         tb_cidadao.no_cidadao,
         tb_cidadao.no_mae,
         tb_cidadao.dt_nascimento
     HAVING
         Count(tb_cidadao.no_cidadao) > 1
    ),
    docs_pessoas_duplicadas AS (
     SELECT
         tb_cidadao.no_cidadao,
         tb_cidadao.no_mae,
         tb_cidadao.dt_nascimento,
         tb_cidadao.nu_cpf,
         tb_cidadao.nu_cns
     FROM
         tb_cidadao
    )
SELECT
    pessoas_duplicadas.no_cidadao AS nome,
    pessoas_duplicadas.no_mae AS nome_mae,
    pessoas_duplicadas.dt_nascimento AS data_nascimento,
    docs_pessoas_duplicadas.nu_cpf as cpf,
    docs_pessoas_duplicadas.nu_cns as cartao_sus
FROM
    pessoas_duplicadas LEFT JOIN
    docs_pessoas_duplicadas ON docs_pessoas_duplicadas.no_cidadao = pessoas_duplicadas.no_cidadao AND
            docs_pessoas_duplicadas.no_mae = pessoas_duplicadas.no_mae AND
            docs_pessoas_duplicadas.dt_nascimento = pessoas_duplicadas.dt_nascimento
ORDER BY pessoas_duplicadas.no_cidadao;
