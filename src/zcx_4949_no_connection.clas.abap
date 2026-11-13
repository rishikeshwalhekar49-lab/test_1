" ESE_Test1 | Task 2 | Exception: connection or plane type not found
CLASS zcx_4949_no_connection DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_t100_message.

    CONSTANTS:
      BEGIN OF no_connection,
        msgid TYPE symsgid VALUE 'Z4949_ESE_T1',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'CARRIER_ID',
        attr2 TYPE scx_attrname VALUE 'CONNECTION_ID',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF no_connection,
      BEGIN OF no_plane_type,
        msgid TYPE symsgid VALUE 'Z4949_ESE_T1',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE 'PLANE_TYPE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF no_plane_type.

    DATA carrier_id    TYPE /dmo/carrier_id READ-ONLY.
    DATA connection_id TYPE /dmo/connection_id READ-ONLY.
    DATA plane_type    TYPE /dmo/plane_type_id READ-ONLY.

    METHODS constructor
      IMPORTING
        textid        LIKE if_t100_message=>t100key OPTIONAL
        previous      LIKE previous OPTIONAL
        carrier_id    TYPE /dmo/carrier_id OPTIONAL
        connection_id TYPE /dmo/connection_id OPTIONAL
        plane_type    TYPE /dmo/plane_type_id OPTIONAL.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_4949_no_connection IMPLEMENTATION.

  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( previous = previous ).

    me->carrier_id    = carrier_id.
    me->connection_id = connection_id.
    me->plane_type    = plane_type.

    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = no_connection.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
