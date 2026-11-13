" ESE_Test1 | Task 6 | Agency model with typed exception
" If your instructor gave you ZCL_AGENCY_MODEL to copy, keep their class and
" only add the RAISING clause and the IF sy-subrc block from GET_AGENCY below.
CLASS zcl_4949_agency_model DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_agency,
        agency_id    TYPE /dmo/agency_id,
        name         TYPE /dmo/agency_name,
        street       TYPE /dmo/street,
        postal_code  TYPE /dmo/postal_code,
        city         TYPE /dmo/city,
        country_code TYPE land1,
      END OF ty_agency.

    METHODS get_agency
      IMPORTING
        i_agency_id     TYPE /dmo/agency_id
      RETURNING
        VALUE(r_agency) TYPE ty_agency
      RAISING
        zcx_4949_no_agency.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_4949_agency_model IMPLEMENTATION.

  METHOD get_agency.
    SELECT SINGLE FROM /dmo/agency
      FIELDS agency_id, name, street, postal_code, city, country_code
      WHERE agency_id = @i_agency_id
      INTO CORRESPONDING FIELDS OF @r_agency.

    IF sy-subrc <> 0.
      RAISE EXCEPTION NEW zcx_4949_no_agency(
        textid    = zcx_4949_no_agency=>no_agency
        agency_id = i_agency_id ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
