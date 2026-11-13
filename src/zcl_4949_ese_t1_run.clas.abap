" ESE_Test1 | Test runner | Run with F9 and screenshot the Console output
CLASS zcl_4949_ese_t1_run DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS test_flights      IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS test_connections  IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS test_agency       IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS test_dictionary   IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
ENDCLASS.



CLASS zcl_4949_ese_t1_run IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    test_flights( out ).
    test_connections( out ).
    test_agency( out ).
    test_dictionary( out ).
  ENDMETHOD.

  METHOD test_flights.
    out->write( |=== Task 2: flight class hierarchy ===| ).

    " Take a real flight from the demo data so the valid case always works
    SELECT SINGLE FROM /dmo/flight
      FIELDS carrier_id, connection_id, plane_type_id
      INTO @DATA(sample).
    IF sy-subrc <> 0.
      out->write( |No rows in /DMO/FLIGHT - generate the demo data first| ).
      RETURN.
    ENDIF.

    " 1) Valid connection and plane type
    TRY.
        DATA(flight) = NEW zcl_4949_passenger_flight(
          i_carrier_id    = sample-carrier_id
          i_connection_id = sample-connection_id
          i_plane_type    = sample-plane_type_id ).
        out->write( |Valid: { flight->carrier_id } { flight->connection_id } | &&
                    |{ flight->airport_from } -> { flight->airport_to }, | &&
                    |max seats { flight->get_seats_max( ) }| ).
      CATCH zcx_4949_no_connection INTO DATA(error).
        out->write( |Unexpected error: { error->get_text( ) }| ).
    ENDTRY.

    " 2) Connection that does not exist
    TRY.
        flight = NEW zcl_4949_passenger_flight(
          i_carrier_id    = 'ZZ'
          i_connection_id = '9999'
          i_plane_type    = sample-plane_type_id ).
        out->write( |ERROR: no exception for invalid connection| ).
      CATCH zcx_4949_no_connection INTO error.
        out->write( |Invalid connection -> { error->get_text( ) }| ).
    ENDTRY.

    " 3) Valid connection, unknown plane type
    TRY.
        flight = NEW zcl_4949_passenger_flight(
          i_carrier_id    = sample-carrier_id
          i_connection_id = sample-connection_id
          i_plane_type    = 'NOPLANE' ).
        out->write( |ERROR: no exception for invalid plane type| ).
      CATCH zcx_4949_no_connection INTO error.
        out->write( |Invalid plane type -> { error->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_connections.
    out->write( |=== Task 3: direct and one-stop connections ===| ).

    DATA departure TYPE /dmo/airport_from_id VALUE 'FRA'.
    DATA(connections) = NEW zcl_4949_connections( ).
    DATA(result) = connections->get_connections( departure ).
    out->write( |From { departure }: { lines( result ) } routes ("-" = direct)| ).
    out->write( result ).

    " Self-check: no route may end where it started
    LOOP AT result TRANSPORTING NO FIELDS WHERE airport_to_id = departure.
      out->write( |ERROR: return-to-origin route found| ).
      EXIT.
    ENDLOOP.
    IF sy-subrc <> 0.
      out->write( |Check passed: no return-to-origin routes| ).
    ENDIF.
  ENDMETHOD.

  METHOD test_agency.
    out->write( |=== Task 6: agency lookup ===| ).

    SELECT SINGLE FROM /dmo/agency FIELDS agency_id INTO @DATA(valid_id).
    DATA(model) = NEW zcl_4949_agency_model( ).

    TRY.
        DATA(agency) = model->get_agency( valid_id ).
        out->write( |Valid ID { valid_id }: { agency-name }, { agency-city }| ).
      CATCH zcx_4949_no_agency INTO DATA(error).
        out->write( |Unexpected error: { error->get_text( ) }| ).
    ENDTRY.

    TRY.
        agency = model->get_agency( '000000' ).
        out->write( |ERROR: no exception for invalid agency| ).
      CATCH zcx_4949_no_agency INTO error.
        out->write( |Invalid ID 000000 -> { error->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_dictionary.
    out->write( |=== Task 7: hashed table type Z4949_T_CUST ===| ).

    DATA customers TYPE z4949_t_cust.
    SELECT FROM /dmo/customer
      FIELDS customer_id, first_name, last_name, street, postal_code, city, country_code
      INTO CORRESPONDING FIELDS OF TABLE @customers
      UP TO 5 ROWS.

    out->write( |Loaded { lines( customers ) } customers| ).
    " Hashed tables have no index, so take any row's key with LOOP ... EXIT
    LOOP AT customers INTO DATA(any_customer).
      DATA(first_id) = any_customer-customer_id.
      EXIT.
    ENDLOOP.
    IF sy-subrc = 0.
      " Hashed key access by CUSTOMER_ID
      DATA(customer) = customers[ customer_id = first_id ].
      out->write( |Key read { first_id }: { customer-first_name } { customer-last_name }| ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
