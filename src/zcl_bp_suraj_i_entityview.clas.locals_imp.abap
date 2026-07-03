CLASS lhc_ZSURAJ_I_ENTITYVIEW DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zsuraj_i_entityview RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zsuraj_i_entityview RESULT result.

    METHODS validate_telephone FOR VALIDATE ON SAVE
      IMPORTING keys FOR zsuraj_i_entityview~validate_telephone.

    METHODS setstatus FOR DETERMINE ON SAVE
      IMPORTING keys FOR zsuraj_i_entityview~setstatus.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zsuraj_i_entityview RESULT result.

    METHODS claculateage FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zsuraj_i_entityview~claculateage.

ENDCLASS.

CLASS lhc_ZSURAJ_I_ENTITYVIEW IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD validate_telephone.

    "In validation  if something goes wrong fill FAILED and REPORTED framework tables.
    "How the framework tables will get filled?
    "Identifying the record = %tkey
    "which field causing validation failure = %element make it as on
    "Need to display the error msg = %msg

    READ ENTITIES OF zsuraj_i_entityview IN LOCAL MODE
    ENTITY zsuraj_i_entityview ALL FIELDS WITH
    CORRESPONDING #( keys )
    RESULT DATA(lt_i_entityview).

    IF lt_i_entityview IS NOT INITIAL.
      LOOP AT lt_i_entityview ASSIGNING FIELD-SYMBOL(<fs_i_entityview>).

        SHIFT <fs_i_entityview>-Telephone LEFT DELETING LEADING '0'.
        CONDENSE <fs_i_entityview>-Telephone.
        IF <fs_i_entityview>-Telephone IS INITIAL.

          APPEND VALUE #(  %tky = <fs_i_entityview>-%tky  ) TO failed-zsuraj_i_entityview.

          APPEND VALUE #( %tky = <fs_i_entityview>-%tky
                          %element-telephone = if_abap_behv=>mk-on
                          %state_area = 'Validate_telephone'
                          %msg = new_message_with_text(
                                   severity = if_abap_behv_message=>severity-error
                                   text     = 'Please provide 10 digit mobile number'
                                 ) ) TO reported-zsuraj_i_entityview.


        ELSE.
          DATA(lv_telephone_length) = strlen( <fs_i_entityview>-Telephone ).
          IF ( lv_telephone_length LT 10 ).
            APPEND VALUE #( %tky = <fs_i_entityview>-%tky ) TO failed-zsuraj_i_entityview.

            APPEND VALUE #( %tky = <fs_i_entityview>-%tky
                            %state_area = 'Validate_telephone'
                            %element-telephone = if_abap_behv=>mk-on
                            %msg = new_message_with_text(
                                     severity = if_abap_behv_message=>severity-error
                                     text     = 'Mobile Number should be 10 digits'
                                   ) ) TO reported-zsuraj_i_entityview.
          ENDIF.

        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.



  METHOD setStatus.
    "Determination is used to modify the fields of entity based on trigger conditions mentioned in behavior definition
    "Read entity
    "Identify the record for which status needs to be changed by %tky
    "provide the updated value to status
    "%control is used to tell the framework which field is getting changed
    "Modify the entity with updated table value

    DATA: lt_updatestatus TYPE TABLE FOR UPDATE zsuraj_i_entityview.

    READ ENTITIES OF zsuraj_i_entityview IN LOCAL MODE
    ENTITY zsuraj_i_entityview ALL FIELDS WITH
    CORRESPONDING #( keys )
    RESULT DATA(lt_surajview).

    LOOP AT lt_surajview INTO DATA(ls_surajview).

      IF ( ls_surajview-ContactId IS NOT INITIAL AND
           ls_surajview-FirstName IS NOT INITIAL AND
           ls_surajview-LastName IS NOT INITIAL AND
           ls_surajview-Dob IS NOT INITIAL AND
           ls_surajview-Email IS NOT INITIAL AND
           ls_surajview-Telephone IS NOT INITIAL AND
           ls_surajview-Gender IS NOT INITIAL
           ).

        APPEND VALUE #( %tky = ls_surajview-%tky
                        Active = abap_true
                        %control-Active = if_abap_behv=>mk-on ) TO lt_updatestatus.

       ELSE.

       APPEND VALUE #( %tky = ls_surajview-%tky
                       Active = abap_false
                       %control-Active = if_abap_behv=>mk-on ) to lt_updatestatus .

       ENDIF.

    ENDLOOP.

    MODIFY ENTITIES OF zsuraj_i_entityview IN LOCAL MODE
        ENTITY zsuraj_i_entityview
        UPDATE FIELDS ( Active  )
        WITH lt_updatestatus.


  ENDMETHOD.

  METHOD get_instance_features.


    READ ENTITIES OF zsuraj_i_entityview IN LOCAL MODE
    ENTITY zsuraj_i_entityview
    ALL FIELDS WITH
    CORRESPONDING #( keys )
    RESULT DATA(lt_contact) .

    IF lt_contact IS NOT INITIAL.
      result = VALUE #(
               FOR lwa_contact IN lt_contact (
                   %tky = lwa_contact-%tky
                   %features = VALUE #(
                               %field = VALUE #(
                                  Firstname = COND #( WHEN lwa_contact-Active = abap_true
                                              THEN if_abap_behv=>fc-f-read_only
                                              ELSE if_abap_behv=>fc-f-unrestricted )
                                  lastname  = COND #( WHEN lwa_contact-Active = abap_true
                                              THEN if_abap_behv=>fc-f-read_only
                                              ELSE if_abap_behv=>fc-f-unrestricted )
                                               )
                   %update =   COND #( WHEN lwa_contact-Active = abap_true
                                       THEN if_abap_behv=>fc-o-disabled
                                       ELSE if_abap_behv=>fc-o-enabled )

               )  ) ).




    ENDIF.







  ENDMETHOD.

  METHOD claculateAge.

      DATA: lt_updateage TYPE TABLE FOR UPDATE zsuraj_i_entityview.

    " Read entities where DOB might have changed
    READ ENTITIES OF zsuraj_i_entityview IN LOCAL MODE
      ENTITY zsuraj_i_entityview
        FIELDS ( Dob )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_contacts).

    " Calculate age for each contact
    LOOP AT lt_contacts INTO DATA(ls_contact).

      " Skip if DOB is empty
      IF ls_contact-Dob IS INITIAL.

        " Set Age to 0 if no DOB
        APPEND VALUE #(
          %tky = ls_contact-%tky
          Age = 0
          %control-Age = if_abap_behv=>mk-on
        ) TO lt_updateage.

      ELSE.

        " Calculate age based on DOB
        DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

        " Calculate years
        DATA(lv_age) = lv_today(4) - ls_contact-Dob(4).

        " Adjust if birthday hasn't occurred this year yet
        IF lv_today+4(4) < ls_contact-Dob+4(4).  " Compare MMDD
          lv_age = lv_age - 1.
        ENDIF.

        " Prevent negative age
        IF lv_age < 0.
          lv_age = 0.
        ENDIF.

        " Add to update table
        APPEND VALUE #(
          %tky = ls_contact-%tky
          Age = lv_age
          %control-Age = if_abap_behv=>mk-on
        ) TO lt_updateage.

      ENDIF.

    ENDLOOP.

    " Update all ages at once
    IF lt_updateage IS NOT INITIAL.
      MODIFY ENTITIES OF zsuraj_i_entityview IN LOCAL MODE
        ENTITY zsuraj_i_entityview
          UPDATE FIELDS ( Age )
          WITH lt_updateage.
    ENDIF.


  ENDMETHOD.

ENDCLASS.
