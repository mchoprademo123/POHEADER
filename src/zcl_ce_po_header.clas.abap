CLASS zcl_ce_po_header DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider.
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
    TYPES: BEGIN OF ty_pohead,
             po_number TYPE c LENGTH 10,
             po_item   TYPE n LENGTH 5,
             text_id   TYPE c LENGTH 4,
             text_form TYPE c LENGTH 2,
             text_line TYPE c LENGTH 132,
           END OF ty_pohead.

    TYPES:
      tt_header TYPE STANDARD TABLE OF ty_header,
      tt_return TYPE STANDARD TABLE OF ty_return,
      tt_pohead TYPE STANDARD TABLE OF ty_pohead.

    DATA it_header TYPE tt_header.
    DATA wa_header TYPE ty_header.
    DATA it_return TYPE tt_return.
    DATA wa_return TYPE ty_return.
    DATA it_pohead TYPE tt_pohead.
    DATA wa_pohead TYPE ty_pohead.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CE_PO_HEADER IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    DATA lt_result TYPE STANDARD TABLE OF zce_po_header.
    TRY.
        DATA(lo_rfc_dest) = cl_rfc_destination_provider=>create_by_cloud_destination(
*                                    i_name                  = 'S41_RFCMC' ).
                                    i_name                  = 'S41_RFC_I554241' ).

*          i_service_instance_name = |ZSAP_COM_0276_MC| ).

        DATA(lv_rfc_dest_name) = lo_rfc_dest->get_destination_name( ).


        IF io_request->is_data_requested( ).


          DATA(lv_skip) = io_request->get_paging( )->get_offset(  ).
          DATA(lv_top) = io_request->get_paging( )->get_page_size(  ).

          DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
          DATA(lt_fields)  = io_request->get_requested_elements( ).

*              IF lt_fields IS NOT INITIAL.
*              CONCATENATE LINES OF lt_fields INTO lv_select_string  SEPARATED BY ','.
*            ELSE.
*              "check coding. If no columns are specified via $select retrieve all columns from the model instead?
*              lv_select_string = '*'.
*            ENDIF.

          READ TABLE lt_filter_cond WITH KEY name = 'TYPE' INTO DATA(ls_po_type).
          IF sy-subrc EQ 0.
            LOOP AT ls_po_type-range INTO DATA(ls_sel_opt_potype).
              DATA(lv_potype) = ls_Sel_opt_potype-low.
            ENDLOOP.
          ENDIF.


          READ TABLE lt_filter_cond WITH KEY name = 'PURCHASEORDER' INTO DATA(ls_po).
          IF sy-subrc EQ 0.
            LOOP AT ls_po-range INTO DATA(ls_sel_opt_po).
              DATA(lv_po) = ls_Sel_opt_po-low.
            ENDLOOP.
          ENDIF.


          READ TABLE lt_filter_cond WITH KEY name = 'ORGANIZATION' INTO DATA(ls_org).
          IF sy-subrc EQ 0.
            LOOP AT ls_org-range INTO DATA(ls_sel_opt_org).
              DATA(lv_org) = ls_Sel_opt_org-low.
            ENDLOOP.
          ENDIF.

          READ TABLE lt_filter_cond WITH KEY name = 'PGROUP' INTO DATA(ls_grp).
          IF sy-subrc EQ 0.
            LOOP AT ls_grp-range INTO DATA(ls_sel_opt_grp).
              DATA(lv_grp) = ls_Sel_opt_grp-low.
            ENDLOOP.
          ENDIF.

    DATA lv_type TYPE c LENGTH 4.
    lv_type = lv_potype.

          CALL FUNCTION 'BAPI_PO_GETITEMS' DESTINATION lv_rfc_dest_name
            EXPORTING
*              purchaseorder          = lv_po
              doc_type               = lv_type
*              pur_group              = lv_grp
*              purch_org              = lv_org
              preq_name              = ' '
              with_po_headers        = 'X'
              deleted_items          = ' '
              items_open_for_receipt = ' '
              pur_mat                = ' '
              pur_mat_long           = ' '
            TABLES
              po_headers             = it_header
              return                 = it_return.



          IF io_request->is_total_numb_of_rec_requested( ).
          if lv_po is not INITIAL.
          DELETE it_header WHERE po_number <> lv_po.
          ENDIF.
           if lv_grp is not INITIAL.
          DELETE it_header WHERE pur_group <> lv_grp.
          ENDIF.
           if lv_org is not INITIAL.
          DELETE it_header WHERE purch_org <> lv_org.
          ENDIF.
            LOOP AT it_header ASSIGNING FIELD-SYMBOL(<fs_head>).
              CALL FUNCTION 'BAPI_PO_GETDETAIL1' DESTINATION lv_rfc_dest_name
                EXPORTING
                  purchaseorder = <fs_head>-po_number
                  header_text   = 'X'
                TABLES
                  potextheader  = it_pohead.

              TRY.

                  APPEND  VALUE #( PurchaseOrder = <fs_head>-po_number
                                   Type    = <fs_head>-doc_type
                                   organization = <fs_head>-purch_org
                                   pgroup  = <fs_head>-pur_group
                                   Category = <fs_head>-doc_cat

                                   CompanyCode = <fs_head>-co_code
                                   text   = it_pohead[ 1 ]-text_line ) TO lt_result.

                CATCH cx_sy_itab_line_not_found.

                  APPEND  VALUE #( PurchaseOrder = <fs_head>-po_number
                                  Type    = <fs_head>-doc_type
                                   organization = <fs_head>-purch_org
                                   pgroup  = <fs_head>-pur_group
                                  Category = <fs_head>-doc_cat
                                  CompanyCode = <fs_head>-co_code
                                   text   = '' ) TO lt_result.
              ENDTRY.
            ENDLOOP.

            io_response->set_total_number_of_records( lines( lt_result ) ).
            io_response->set_data( lt_result ).
          ENDIF.



        ENDIF.

      CATCH cx_rfc_dest_provider_error INTO DATA(lx_dest).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
