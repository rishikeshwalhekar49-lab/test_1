" ESE_Test1 | Task 2 | Subclass: passenger flight with maximum seats
CLASS zcl_4949_passenger_flight DEFINITION
  PUBLIC
  INHERITING FROM zcl_4949_flight
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        i_carrier_id    TYPE /dmo/carrier_id
        i_connection_id TYPE /dmo/connection_id
        i_plane_type    TYPE /dmo/plane_type_id
      RAISING
        zcx_4949_no_connection.

    " SEATS_MAX is private; consumers read it only through this getter
    METHODS get_seats_max
      RETURNING VALUE(r_seats_max) TYPE /dmo/plane_seats_max.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA seats_max TYPE /dmo/plane_seats_max.
ENDCLASS.



CLASS zcl_4949_passenger_flight IMPLEMENTATION.

  METHOD constructor.
    super->constructor(
      i_carrier_id    = i_carrier_id
      i_connection_id = i_connection_id
      i_plane_type    = i_plane_type ).

    " PLANE_TYPE is the protected attribute inherited from ZCL_4949_FLIGHT
    SELECT SINGLE FROM /dmo/flight
      FIELDS seats_max
      WHERE plane_type_id = @plane_type
      INTO @seats_max.

    IF sy-subrc <> 0.
      RAISE EXCEPTION NEW zcx_4949_no_connection(
        textid     = zcx_4949_no_connection=>no_plane_type
        plane_type = plane_type ).
    ENDIF.
  ENDMETHOD.

  METHOD get_seats_max.
    r_seats_max = seats_max.
  ENDMETHOD.

ENDCLASS.
