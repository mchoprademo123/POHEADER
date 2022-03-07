CLASS lhc_ZCE_PO_Header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.

    TYPES: BEGIN OF ty_header,
             po_number    TYPE c LENGTH 10,
             co_code      TYPE c LENGTH 4,
             doc_cat      TYPE c LENGTH 1,
             doc_type     TYPE c LENGTH 4,
             cntrl_ind    TYPE c LENGTH 1,
             delete_ind   TYPE c LENGTH 1,
             status       TYPE c LENGTH 1,
             created_on   TYPE c LENGTH 8,
             created_by   TYPE c LENGTH 12,
             item_intvl   TYPE n LENGTH 5,
             last_item    TYPE n LENGTH 5,
             vendor       TYPE c LENGTH 10,
             language     TYPE c LENGTH 1,
             pmnttrms     TYPE c LENGTH 4,
             dscnt1_to    TYPE p LENGTH 3 DECIMALS 0,
             dscnt2_to    TYPE p LENGTH 3 DECIMALS 0,
             dscnt3_to    TYPE p LENGTH 3 DECIMALS 0,
             cash_disc1   TYPE p LENGTH 5 DECIMALS 3,
             cash_disc2   TYPE p LENGTH 5 DECIMALS 3,
             purch_org    TYPE c LENGTH 4,
             pur_group    TYPE c LENGTH 3,
             currency     TYPE p LENGTH 5 DECIMALS 0,
             exch_rate    TYPE p LENGTH 9 DECIMALS 5,
             ex_rate_fx   TYPE c LENGTH 1,
             doc_date     TYPE c LENGTH 8,
             vper_start   TYPE c LENGTH 8,
             vper_end     TYPE c LENGTH 8,
             applic_by    TYPE c LENGTH 8,
             quot_dead    TYPE c LENGTH 8,
             bindg_per    TYPE c LENGTH 8,
             warranty     TYPE c LENGTH 8,
             bidinv_no    TYPE c LENGTH 10,
             quotation    TYPE c LENGTH 10,
             quot_date    TYPE c LENGTH 8,
             ref_1        TYPE c LENGTH 12,
             sales_pers   TYPE c LENGTH 30,
             telephone    TYPE c LENGTH 16,
             suppl_vend   TYPE c LENGTH 10,
             customer     TYPE c LENGTH 10,
             agreement    TYPE c LENGTH 10,
             rej_reason   TYPE c LENGTH 2,
             compl_dlv    TYPE c LENGTH 1,
             gr_message   TYPE c LENGTH 1,
             suppl_plnt   TYPE c LENGTH 4,
             rcvg_vend    TYPE c LENGTH 10,
             incoterms1   TYPE c LENGTH 3,
             incoterms2   TYPE c LENGTH 28,
             target_val   TYPE p LENGTH 12 DECIMALS 4,
             coll_no      TYPE c LENGTH 10,
             doc_cond     TYPE c LENGTH 10,
             procedure    TYPE c LENGTH 6,
             update_grp   TYPE c LENGTH 6,
             diff_inv     TYPE c LENGTH 10,
             export_no    TYPE c LENGTH 10,
             our_ref      TYPE c LENGTH 12,
             logsystem    TYPE c LENGTH 10,
             subitemint   TYPE n LENGTH 5,
             mast_cond    TYPE c LENGTH 1,
             rel_group    TYPE c LENGTH 2,
             rel_strat    TYPE c LENGTH 2,
             rel_ind      TYPE c LENGTH 1,
             rel_status   TYPE c LENGTH 8,
             subj_to_r    TYPE c LENGTH 1,
             taxr_cntry   TYPE c LENGTH 3,
             sched_ind    TYPE c LENGTH 1,
             vend_name    TYPE c LENGTH 35,
             currency_iso TYPE c LENGTH 3,
             exch_rate_cm TYPE p LENGTH 9 DECIMALS 5,
             hold         TYPE c LENGTH 1,
           END OF ty_header.

    TYPES: BEGIN OF ty_return,
             type       TYPE c LENGTH 1,
             code       TYPE c LENGTH 5,
             message    TYPE c LENGTH 220,
             log_no     TYPE c LENGTH 20,
             log_msg_no TYPE n LENGTH 6,
             message_v1 TYPE c LENGTH 50,
             message_v2 TYPE c LENGTH 50,
             message_v3 TYPE c LENGTH 50,
             message_v4 TYPE c LENGTH 50,
           END OF ty_return.

    TYPES: BEGIN OF ty_return1,
             type       TYPE c LENGTH 1,
             code       TYPE c LENGTH 5,
             message    TYPE c LENGTH 220,
             log_no     TYPE c LENGTH 20,
             log_msg_no TYPE n LENGTH 6,
             message_v1 TYPE c LENGTH 50,
             message_v2 TYPE c LENGTH 50,
             message_v3 TYPE c LENGTH 50,
             message_v4 TYPE c LENGTH 50,
             parameter  TYPE c LENGTH 32,
             row        TYPE int4,
             field      TYPE c LENGTH 30,
             system     TYPE c LENGTH 10,
           END OF ty_return1.

    TYPES: BEGIN OF ty_pohead,
             po_number TYPE c LENGTH 10,
             po_item   TYPE n LENGTH 5,
             text_id   TYPE c LENGTH 4,
             text_form TYPE c LENGTH 2,
             text_line TYPE c LENGTH 132,
           END OF ty_pohead.



    TYPES:
      tt_header  TYPE STANDARD TABLE OF ty_header,
      tt_return  TYPE STANDARD TABLE OF ty_return,
      tt_return1 TYPE STANDARD TABLE OF ty_return1,
      tt_pohead  TYPE STANDARD TABLE OF ty_pohead.

    DATA it_header TYPE tt_header.
    DATA wa_header TYPE ty_header.
    DATA it_return TYPE tt_return.
    DATA wa_return TYPE ty_return.
    DATA it_ret TYPE tt_return1.
    DATA wa_ret TYPE tt_return1.
    DATA it_pohead TYPE tt_pohead.
    DATA wa_pohead TYPE ty_pohead.
    DATA v_text TYPE string.


  PRIVATE SECTION.

    TYPES tt_text_failed    TYPE TABLE FOR FAILED   zce_po_header.
    TYPES tt_text_reported  TYPE TABLE FOR REPORTED zce_po_header.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ZCE_PO_Header RESULT result.


    METHODS read FOR READ
      IMPORTING keys FOR READ ZCE_PO_Header RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK ZCE_PO_Header.

    METHODS changeText FOR MODIFY
      IMPORTING keys FOR ACTION ZCE_PO_Header~changeText RESULT result.


    METHODS map_messages
      IMPORTING
        cid          TYPE string         OPTIONAL
        po_number    TYPE ty_header-po_number    OPTIONAL
        messages     TYPE tt_return1
      EXPORTING
        failed_added TYPE abap_bool
      CHANGING
        failed       TYPE tt_text_failed
        reported     TYPE tt_text_reported.

ENDCLASS.

CLASS lhc_ZCE_PO_Header IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.



  METHOD read.

*        result = VALUE #( FOR wa_header IN it_header ( PurchaseOrder = wa_header-po_number
*                                            Type    = wa_header-doc_type
*                                            Category = wa_header-doc_cat
*                                            CompanyCode = wa_header-co_code
*                                            text = ''
*                                          ) ).


  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.



  METHOD changeText.

    DATA lt_data TYPE STANDARD TABLE OF zce_po_header.
    DATA  pochangetext LIKE LINE OF result.
    DATA(lt_keys) = keys.

*    READ ENTITIES OF zce_po_header IN LOCAL MODE
*        ENTITY zce_po_header
*        FIELDS ( PurchaseOrder )
*        WITH CORRESPONDING #( keys )
*        RESULT DATA(lt_txt_head).

    TRY.
        DATA(lo_rfc_dest) = cl_rfc_destination_provider=>create_by_cloud_destination(
*                            i_name = |S41_RFCMC|
                            i_name = |S41_RFC_I554241|
                               ).

        DATA(lv_rfc_dest_name) = lo_rfc_dest->get_destination_name( ).



        LOOP AT lt_keys ASSIGNING FIELD-SYMBOL(<fs_keys>).
          CLEAR it_pohead.
          APPEND VALUE #( po_number = <fs_keys>-PurchaseOrder
                          po_item = 00000
                          text_id = 'F01'
                          text_line = <fs_keys>-%param-text
           ) TO it_pohead.
          CALL FUNCTION 'BAPI_PO_CHANGE' DESTINATION lv_rfc_dest_name
            EXPORTING
              purchaseorder = <fs_keys>-PurchaseOrder
            TABLES
              return        = it_ret
              potextheader  = it_pohead.

          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' DESTINATION lv_rfc_dest_name.


         map_messages(
                 EXPORTING
                   po_number        = <fs_keys>-PurchaseOrder
                   messages         = it_ret
                 IMPORTING
                   failed_added = DATA(failed_added)
                 CHANGING
                   failed           = failed-zce_po_header
                   reported         = reported-zce_po_header
               ).
          IF failed_added = abap_false.



          ENDIF.
        ENDLOOP.

      CATCH cx_rfc_dest_provider_error INTO DATA(lx_dest).
    ENDTRY.


  ENDMETHOD.


  METHOD map_messages.
    failed_added = abap_false.
    LOOP AT messages INTO DATA(message).
      IF message-type = 'E' OR message-type = 'A'.
        APPEND VALUE #( %cid        = cid
                        purchaseorder    = po_number
                        %fail-cause  = if_abap_behv=>cause-unspecific )
               TO failed.

      ENDIF.
      IF message-type = 'S' .
        IF sy-tabix = 1 .
          CONCATENATE po_number 'PO text updated successfully' INTO DATA(lv_text) SEPARATED BY space .
          APPEND VALUE #( %msg          = new_message_with_text(

                                           severity = if_abap_behv_message=>severity-success
                                           text =  lv_text
                                           )
                         %cid          = cid
                         purchaseorder      = po_number )

                TO reported.

        ENDIF.
        APPEND VALUE #( %msg          = new_message_with_text(

                                          severity = if_abap_behv_message=>severity-success
                                          text = message-message
                                          )
                        %cid          = cid
                        purchaseorder      = po_number )  TO reported..

      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZCE_PO_HEADER DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PUBLIC SECTION.


  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZCE_PO_HEADER IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.

  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
