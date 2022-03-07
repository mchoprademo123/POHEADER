CLASS zcl_test_rfc_km DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

 PUBLIC SECTION.
   INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TEST_RFC_KM IMPLEMENTATION.


METHOD if_oo_adt_classrun~main.



CALL METHOD cl_cmis_client_factory=>get_instance
  EXPORTING
iv_user_header = 'CB0000000371'
  RECEIVING
ro_client      = DATA(lo_cmis_client).


CALL METHOD lo_cmis_client->get_repositories
IMPORTING
et_repository_infos = DATA(lt_repository_infos).

LOOP AT lt_repository_infos INTO DATA(ls_repository_info).
DATA(lv_repository_id) = ls_repository_info-id.
DATA(lv_repository_name) = ls_repository_info-name.
DATA(lv_root_folder) = ls_repository_info-root_folder_id.
ENDLOOP.


 out->write( lv_repository_id ).

 DATA:
      lt_properties  TYPE cmis_t_client_property,
      ls_property    LIKE LINE OF lt_properties,
      ls_value type cmis_s_property_value .

    ls_property-id        = cl_cmis_property_ids=>object_type_id.
    ls_value-string_value = cl_cmis_constants=>base_type_id-cmis_folder. "specify the type as cmis:folder
    APPEND ls_value TO ls_property-values.
    APPEND ls_property TO lt_properties.

    CLEAR: ls_property,  ls_value.

*    ls_property-id        = cl_cmis_property_ids=>name. "the name property
*    ls_value-string_value = 'TEST_KM'. "specify the name of the folder
*    APPEND ls_value TO ls_property-values.
*    APPEND ls_property TO lt_properties.
*
**    call create_folder
*    CALL METHOD lo_cmis_client->create_folder
*      EXPORTING
*        iv_repository_id = lv_repository_id
*        it_properties    = lt_properties
*        iv_folder_id     = lv_root_folder
*      IMPORTING
*        es_object        = DATA(ls_cmis_object).

        DATA:
      ls_cmis_object TYPE cmis_s_object,
      ls_content type cmis_s_content_raw,
      lv_print type string.

CLEAR: ls_property,  ls_value.

    ls_property-id        = cl_cmis_property_ids=>object_type_id.
    ls_value-string_value = cl_cmis_constants=>base_type_id-cmis_document. "specify the type as cmis:document
    APPEND ls_value TO ls_property-values.
    APPEND ls_property TO lt_properties.

    CLEAR: ls_property,  ls_value.

    ls_property-id        = cl_cmis_property_ids=>name. "the name property
    ls_value-string_value = 'kmfilename.txt'. "specify the file name
    APPEND ls_value TO ls_property-values.
    APPEND ls_property TO lt_properties.

    "specify the content-stream details
    ls_content-filename = 'kmfilename'. "specify the name of the content-stream
    ls_content-mime_type = 'text/plain'. "specify the mime-type

    lv_print = ' This is a test document by Kanika'.
    ls_content-stream = cl_abap_conv_codepage=>create_out(
                            codepage = 'UTF-8')->convert( source = lv_print ).


    "Call create_document
    CALL METHOD lo_cmis_client->create_document(
      EXPORTING
        iv_repository_id = lv_repository_id
        it_properties    = lt_properties
        is_content       = ls_content
        iv_folder_id     = lv_root_folder
      IMPORTING
        es_object        = ls_cmis_object ).

*out->write( ls_cmis_object ).

*    TRY.
*        DATA(lo_rfc_dest) = cl_rfc_destination_provider=>create_by_cloud_destination(
* i_name = |S4H_RFCKM| ).
**  i_service_instance_name = |ZSAP_COM_0276_MC| ).
*
*        DATA(lv_rfc_dest) = lo_rfc_dest->get_destination_name( ).
*        DATA msg TYPE c LENGTH 255.
*        "RFC Call
*        DATA lv_result TYPE c LENGTH 200.
*        CALL FUNCTION 'RFC_SYSTEM_INFO' DESTINATION lv_rfc_dest
*          IMPORTING
*            rfcsi_export          = lv_result
*          EXCEPTIONS
*            system_failure        = 1 MESSAGE msg
*            communication_failure = 2 MESSAGE msg
*            OTHERS                = 3.
*
*        CASE sy-subrc.
*          WHEN 0.
*            out->write( lv_result ).
*          WHEN 1.
*            out->write( |EXCEPTION SYSTEM_FAILURE | && msg ).
*          WHEN 2.
*            out->write( |EXCEPTION COMMUNICATION_FAILURE | && msg ).
*          WHEN 3.
*            out->write( |EXCEPTION OTHERS| ).
*        ENDCASE.
*
*      CATCH cx_root INTO DATA(lx_root).
*        out->write( lx_root->get_text( ) ).
*    ENDTRY.
  ENDMETHOD.
ENDCLASS.
