CLASS zcl_product_w_filter_km DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PRODUCT_W_FILTER_KM IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    "select options
    DATA lt_filter_ranges_productid TYPE RANGE OF zce_product_km-productid.
    DATA ls_filter_ranges_productid LIKE LINE OF lt_filter_ranges_productid.
    DATA lt_filter_ranges_supplier  TYPE RANGE OF zce_product_km-suppliername.
    DATA ls_filter_ranges_supplier  LIKE LINE OF lt_filter_ranges_supplier.
    DATA lt_filter_ranges_category  TYPE RANGE OF zce_product_km-category.
    DATA ls_filter_ranges_category  LIKE LINE OF lt_filter_ranges_category.
    DATA lv_select_string TYPE string.
    DATA lv_maxrows TYPE int4.

    DATA(lv_skip) = io_request->get_paging( )->get_offset(  ).
    DATA(lv_top) = io_request->get_paging( )->get_page_size(  ).


    DATA lt_product TYPE STANDARD TABLE OF zce_product_km.

    DATA(lv_abap_trial) = abap_false.

    IF lv_abap_trial = abap_false.

      TRY.
          DATA(lo_rfc_dest) = cl_rfc_destination_provider=>create_by_cloud_destination(
                                      i_name                  = 'S4H_RFCKM' ).

*          i_service_instance_name = |ZSAP_COM_0276_MC| ).

          DATA(lv_rfc_dest_name) = lo_rfc_dest->get_destination_name( ).


          IF io_request->is_data_requested( ).


            "get and add filter
            DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
            DATA(lt_fields)  = io_request->get_requested_elements( ).

            IF lt_fields IS NOT INITIAL.
              CONCATENATE LINES OF lt_fields INTO lv_select_string  SEPARATED BY ','.
            ELSE.
              "check coding. If no columns are specified via $select retrieve all columns from the model instead?
              lv_select_string = '*'.
            ENDIF.

            READ TABLE lt_filter_cond WITH KEY name = 'PRODUCTID' INTO DATA(ls_productid_cond).
            IF sy-subrc EQ 0.
              LOOP AT ls_productid_cond-range INTO DATA(ls_sel_opt_productid).
                MOVE-CORRESPONDING ls_sel_opt_productid TO ls_filter_ranges_productid.
                INSERT ls_filter_ranges_productid INTO TABLE lt_filter_ranges_productid.
              ENDLOOP.
            ENDIF.

            READ TABLE  lt_filter_cond WITH  KEY name = 'SUPPLIERNAME' INTO DATA(ls_suppliername_cond).
            IF sy-subrc EQ 0.
              LOOP AT ls_suppliername_cond-range INTO DATA(ls_sel_opt_suppliername).
                MOVE-CORRESPONDING ls_sel_opt_suppliername TO ls_filter_ranges_supplier.
                INSERT ls_filter_ranges_supplier INTO TABLE lt_filter_ranges_supplier.
              ENDLOOP.
            ENDIF.

            "-get filter for CATEGORY
            READ TABLE  lt_filter_cond WITH  KEY name = 'CATEGORY' INTO DATA(ls_category_cond).
            IF sy-subrc EQ 0.
              LOOP AT ls_category_cond-range INTO DATA(ls_sel_opt_category).
                MOVE-CORRESPONDING ls_sel_opt_category TO ls_filter_ranges_category.
                INSERT ls_filter_ranges_category INTO TABLE lt_filter_ranges_category.
              ENDLOOP.
            ENDIF.



            lv_maxrows = lv_skip + lv_top.

            CALL FUNCTION 'BAPI_EPM_PRODUCT_GET_LIST'
              DESTINATION lv_rfc_dest_name
              EXPORTING
                max_rows              = lv_maxrows
              TABLES
                headerdata            = lt_product
                selparamproductid     = lt_filter_ranges_productid
                selparamsuppliernames = lt_filter_ranges_supplier
                selparamcategories    = lt_filter_ranges_category.


            IF io_request->is_total_numb_of_rec_requested( ).
              io_response->set_total_number_of_records( lines( lt_product ) ).
              io_response->set_data( lt_product ).
            ENDIF.

          ENDIF.

        CATCH cx_rfc_dest_provider_error INTO DATA(lx_dest).
          "get_filter_conditions( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).

          "@todo :
          " raise an exception that the filter that has been provided
          " cannot be converted into select options
          " here we just continue

      ENDTRY.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
