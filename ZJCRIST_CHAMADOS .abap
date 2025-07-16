*---------------------------------------------------------------------*
* Programa    : ZJCRIST_CHAMADOS                                      *
* Título      : Menu Principal - Sistema de Chamados                  *
* Autor       : Jaqueline Cristine Rosa                               *
* Data        : 14.07.2025                                            *                                                *
* Descrição   : Menu com botões para navegação entre os programas     *
*               de cadastro e consulta de chamados                    *
*---------------------------------------------------------------------*
* Observações :                                                       *
* - Usa SUBMIT para chamar os programas: ZJC_INSERIR e ZJC_CONSULTAR  *
*---------------------------------------------------------------------*
REPORT zjcrist_chamados.

TABLES sscrfields. " Necessário para capturar eventos de botão (USER-COMMAND)

"---------------------------------------------------------------
" Tela de Seleção - Menu com Botões
"---------------------------------------------------------------
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001. " Bloco principal da tela
  SELECTION-SCREEN SKIP 1.

  " Botão 1 - Inserir chamado
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN: POSITION 10, PUSHBUTTON (66) but01 USER-COMMAND but01.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN SKIP 1.

  " Botão 2 - Consultar chamados
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN: POSITION 10, PUSHBUTTON (66) but02 USER-COMMAND but02.
  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b1.

"---------------------------------------------------------------
" INITIALIZATION - Configura o texto dos botões antes da tela aparecer
"---------------------------------------------------------------
INITIALIZATION.
  PERFORM f_definir_botoes.

  "---------------------------------------------------------------
  " AT SELECTION-SCREEN - Trata eventos dos botões
  "---------------------------------------------------------------
AT SELECTION-SCREEN.
  PERFORM f_executar_acao.

  "---------------------------------------------------------------
  " FORM f_definir_botoes - Define o texto exibido nos botões
  "---------------------------------------------------------------
FORM f_definir_botoes.
  but01 = 'Inserir novos chamados'.
  but02 = 'Consultar chamados existentes'.
ENDFORM.

"---------------------------------------------------------------
" FORM f_executar_acao - Executa o programa chamado via SUBMIT
"---------------------------------------------------------------
FORM f_executar_acao.

  CASE sscrfields-ucomm.
    WHEN 'BUT01'.
      " Executa programa de inserção
      SUBMIT zjc_inserir VIA SELECTION-SCREEN AND RETURN.

    WHEN 'BUT02'.
      " Executa programa de consulta
      SUBMIT zjc_consultar VIA SELECTION-SCREEN AND RETURN.
  ENDCASE.
ENDFORM.
