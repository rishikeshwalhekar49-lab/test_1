" ESE_Test1 | Task 6 | Exception: agency not found (message carries the agency ID)
CLASS zcx_4949_no_agency DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_t100_message.

    CONSTANTS:
      BEGIN OF no_agency,
        msgid TYPE symsgid VALUE 'Z4949_ESE_T1',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'AGENCY_ID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF no_agency.

    DATA agency_id TYPE /dmo/agency_id READ-ONLY.

    METHODS constructor
      IMPORTING
        textid    LIKE if_t100_message=>t100key OPTIONAL
        previous  LIKE previous OPTIONAL
        agency_id TYPE /dmo/agency_id OPTIONAL.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_4949_no_agency IMPLEMENTATION.

  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( previous = previous ).

    me->agency_id = agency_id.

    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = no_agency.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
