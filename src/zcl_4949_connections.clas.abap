" ESE_Test1 | Task 3 | Direct and one-stop connections from an airport
CLASS zcl_4949_connections DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    " If your instructor provides ZCERT_CONNECTIONS, type R_CONNECTIONS with it instead
    TYPES:
      BEGIN OF ty_connection,
        carrier_id      TYPE /dmo/carrier_id,
        airport_from_id TYPE /dmo/airport_from_id,
        airport_to_id   TYPE /dmo/airport_to_id,
        airport_via     TYPE /dmo/airport_id,
      END OF ty_connection,
      tt_connections TYPE STANDARD TABLE OF ty_connection WITH EMPTY KEY.

    METHODS get_connections
      IMPORTING
        i_departure          TYPE /dmo/airport_from_id
      RETURNING
        VALUE(r_connections) TYPE tt_connections.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_4949_connections IMPLEMENTATION.

  METHOD get_connections.
    " Direct flights: via airport is '-'
    SELECT DISTINCT FROM /dmo/connection
      FIELDS carrier_id,
             airport_from_id,
             airport_to_id,
             '-' AS airport_via
      WHERE airport_from_id = @i_departure
      INTO CORRESPONDING FIELDS OF TABLE @r_connections.

    " One stop, same carrier: first leg lands where the second leg departs.
    " Excluding a final destination equal to the departure airport removes
    " return-to-origin routes, so a reverse flight never counts as onward.
    SELECT DISTINCT FROM /dmo/connection AS first_leg
      INNER JOIN /dmo/connection AS second_leg
        ON  second_leg~carrier_id      = first_leg~carrier_id
        AND second_leg~airport_from_id = first_leg~airport_to_id
      FIELDS first_leg~carrier_id,
             first_leg~airport_from_id,
             second_leg~airport_to_id,
             first_leg~airport_to_id AS airport_via
      WHERE first_leg~airport_from_id  =  @i_departure
        AND second_leg~airport_to_id   <> @i_departure
      APPENDING CORRESPONDING FIELDS OF TABLE @r_connections.

    SORT r_connections BY carrier_id airport_to_id airport_via.
  ENDMETHOD.

ENDCLASS.
