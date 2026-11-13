" ESE_Test1 | Task 2 | Superclass: general flight
CLASS zcl_4949_flight DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    DATA carrier_id    TYPE /dmo/carrier_id READ-ONLY.
    DATA connection_id TYPE /dmo/connection_id READ-ONLY.
    DATA airport_from  TYPE /dmo/airport_from_id READ-ONLY.
    DATA airport_to    TYPE /dmo/airport_to_id READ-ONLY.

    METHODS constructor
      IMPORTING
        i_carrier_id    TYPE /dmo/carrier_id
        i_connection_id TYPE /dmo/connection_id
        i_plane_type    TYPE /dmo/plane_type_id
      RAISING
        zcx_4949_no_connection.

  PROTECTED SECTION.
    " Visible to subclasses, hidden from consumers
    DATA plane_type TYPE /dmo/plane_type_id.

  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_4949_flight IMPLEMENTATION.

  METHOD constructor.
    carrier_id    = i_carrier_id.
    connection_id = i_connection_id.
    plane_type    = i_plane_type.

    SELECT SINGLE FROM /dmo/connection
      FIELDS airport_from_id, airport_to_id
      WHERE carrier_id    = @i_carrier_id
        AND connection_id = @i_connection_id
      INTO ( @airport_from, @airport_to ).

    IF sy-subrc <> 0.
      RAISE EXCEPTION NEW zcx_4949_no_connection(
        textid        = zcx_4949_no_connection=>no_connection
        carrier_id    = i_carrier_id
        connection_id = i_connection_id ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
