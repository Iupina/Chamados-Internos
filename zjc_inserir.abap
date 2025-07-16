**---------------------------------------------------------------------*
** Programa    : ZJC_INSERIR                                           *
** Título      : Cadastro de Chamados                                  *
** Autor       : Jaqueline Cristine Rosa                     *
** Data        : 15.07.2025                                            *                                                *
** Descrição   : Permite inserir chamados na tabela ZJCRIST_CHAMADOS   *
**---------------------------------------------------------------------*
** Observações:                                                        *
** - Evita duplicidade de ID                                           *
** - Valida campos obrigatórios                                        *
** - Grava data/hora do sistema no registro                            *
**---------------------------------------------------------------------*
REPORT zjc_inserir.

DATA: it_chamados TYPE TABLE OF zjcrist_chamados.

*----------------------------------------------------------------------*
* Tela de entrada
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_id     TYPE zjcrist_chamados-numero_do_chamado,
              p_solic  TYPE zjcrist_chamados-solicitante,
              p_desc   TYPE zjcrist_chamados-descricao,
              p_status TYPE zjcrist_chamados-status.

  SELECTION-SCREEN SKIP 1.

  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN POSITION 25.
    SELECTION-SCREEN PUSHBUTTON (30) gv_bot1 USER-COMMAND gravar.
    SELECTION-SCREEN PUSHBUTTON (30) gv_bot2 USER-COMMAND voltar.
  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b2.

*----------------------------------------------------------------------*
INITIALIZATION.
  gv_bot1 = 'Gravar Chamado'.
  gv_bot2 = 'Voltar para o menu'.

*----------------------------------------------------------------------*
AT SELECTION-SCREEN.
  IF sy-ucomm = 'GRAVAR'.
    PERFORM f_inserir.
  ELSEIF sy-ucomm = 'VOLTAR'.
    SUBMIT zjcrist_chamados VIA SELECTION-SCREEN AND RETURN.
  ENDIF.

*----------------------------------------------------------------------*
* FORM f_inserir - Insere novo chamado após validações
*----------------------------------------------------------------------*
FORM f_inserir.

  IF p_desc IS INITIAL OR p_solic IS INITIAL OR p_status IS INITIAL.
    MESSAGE 'Preencha todos os campos obrigatórios.' TYPE 'E'.
    RETURN.
  ENDIF.

  SELECT SINGLE * FROM zjcrist_chamados
    INTO @DATA(ls_chamado)
    WHERE numero_do_chamado = @p_id.

  IF sy-subrc = 0.
    MESSAGE 'Já existe um chamado com esse ID.' TYPE 'E'.
    RETURN.
  ENDIF.

  APPEND INITIAL LINE TO it_chamados ASSIGNING FIELD-SYMBOL(<fs_chamado>).
  <fs_chamado>-numero_do_chamado = p_id.
  <fs_chamado>-solicitante       = p_solic.
  <fs_chamado>-descricao         = p_desc.
  <fs_chamado>-status            = p_status.
  <fs_chamado>-data_criacao      = sy-datum.
  <fs_chamado>-hora_criacao      = sy-uzeit.

  INSERT zjcrist_chamados FROM TABLE it_chamados.
  COMMIT WORK.

  IF sy-subrc = 0.
    MESSAGE 'Chamado inserido com sucesso.' TYPE 'S'.
  ELSE.
    MESSAGE 'Erro ao inserir o chamado.' TYPE 'E'.
  ENDIF.

ENDFORM.
