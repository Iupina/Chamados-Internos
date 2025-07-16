*---------------------------------------------------------------------*
* Programa    : ZJC_CONSULTAR                                         *
* Título      : Consulta de Chamados                                  *
* Autor       : Jaqueline Cristine Rosa                               *
* Data        : 15.07.2025                                            *                                               *
* Descrição   : Exibe os chamados cadastrados em ALV ordenado por     *
*               data e hora de criação                                *
*---------------------------------------------------------------------*
* Observações:                                                        *
* - Utiliza função REUSE_ALV_GRID_DISPLAY (ALV clássico)              *
* - Ordena resultados por data/hora DESCENDENTE                       *
*---------------------------------------------------------------------*
REPORT zjc_consultar.

DATA: it_alv     TYPE TABLE OF zjcrist_chamados,
      s_fieldcat TYPE slis_fieldcat_alv,
      t_fieldcat TYPE slis_t_fieldcat_alv.

*----------------------------------------------------------------------*
* Início da execução
*----------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM f_consulta.        "Busca dados
  PERFORM f_monta_saida.     "Monta campos do ALV

  "Exibição do ALV
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      it_fieldcat   = t_fieldcat
    TABLES
      t_outtab      = it_alv
    EXCEPTIONS
      program_error = 1
      OTHERS        = 2.

  IF sy-subrc <> 0.
    MESSAGE 'Erro ao exibir o ALV.' TYPE 'E'.
  ENDIF.

*---------------------------------------------------------------------*
* Form f_consulta - Busca os dados ordenados
*---------------------------------------------------------------------*
FORM f_consulta.
  SELECT * FROM zjcrist_chamados
    INTO TABLE @it_alv
    ORDER BY data_criacao DESCENDING, hora_criacao DESCENDING.

  IF sy-subrc <> 0.
    MESSAGE 'Nenhum dado encontrado.' TYPE 'I'.
  ENDIF.
ENDFORM.

*---------------------------------------------------------------------*
* Form f_monta_saida - Define colunas do ALV
*---------------------------------------------------------------------*
FORM f_monta_saida.
  PERFORM f_monta_fieldcat USING 'NUMERO_DO_CHAMADO'  'ID do Chamado'       0.
  PERFORM f_monta_fieldcat USING 'SOLICITANTE'        'Solicitante'         1.
  PERFORM f_monta_fieldcat USING 'DESCRICAO'          'Descrição'           2.
  PERFORM f_monta_fieldcat USING 'STATUS'             'Status do Chamado'   3.
  PERFORM f_monta_fieldcat USING 'DATA_CRIACAO'       'Data de Criação'     4.
  PERFORM f_monta_fieldcat USING 'HORA_CRIACAO'       'Hora de Criação'     5.
ENDFORM.

*---------------------------------------------------------------------*
* Form f_monta_fieldcat - Preenche cada coluna do ALV
*---------------------------------------------------------------------*
FORM f_monta_fieldcat USING i_fname TYPE slis_fieldname
                             i_ftext TYPE string
                             i_fpos  TYPE i.

  CLEAR s_fieldcat.
  s_fieldcat-fieldname = i_fname.
  s_fieldcat-seltext_m = i_ftext.
  s_fieldcat-col_pos   = i_fpos.

  APPEND s_fieldcat TO t_fieldcat.
ENDFORM.
