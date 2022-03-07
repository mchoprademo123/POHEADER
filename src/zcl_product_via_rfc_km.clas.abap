CLASS zcl_product_via_rfc_km DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PRODUCT_VIA_RFC_KM IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    DATA lt_product TYPE STANDARD TABLE OF zce_product_km.

    DATA(lv_abap_trial) = abap_false.

    IF lv_abap_trial = abap_false.

      TRY.
          DATA(lo_rfc_dest) = cl_rfc_destination_provider=>create_by_cloud_destination(
                                      i_name                  = 'S4H_RFCKM' ).

*          i_service_instance_name = |ZSAP_COM_0276_MC| ).

          DATA(lv_rfc_dest_name) = lo_rfc_dest->get_destination_name( ).


          IF io_request->is_data_requested( ).
            DATA lv_maxrows TYPE int4.

            DATA(lv_skip) = io_request->get_paging( )->get_offset(  ).
            DATA(lv_top) = io_request->get_paging( )->get_page_size(  ).

            lv_maxrows = lv_skip + lv_top.

            CALL FUNCTION 'BAPI_EPM_PRODUCT_GET_LIST'
              DESTINATION lv_rfc_dest_name
              EXPORTING
                max_rows   = lv_maxrows
              TABLES
                headerdata = lt_product.

            IF io_request->is_total_numb_of_rec_requested( ).
              io_response->set_total_number_of_records( lines( lt_product ) ).
              io_response->set_data( lt_product ).
            ENDIF.

          ENDIF.

        CATCH cx_rfc_dest_provider_error INTO DATA(lx_dest).
      ENDTRY.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
