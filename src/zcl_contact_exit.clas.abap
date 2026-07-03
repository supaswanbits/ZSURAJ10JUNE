CLASS zcl_contact_exit DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_contact_exit IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.


    DATA: lt_original_calculate TYPE STANDARD TABLE OF zsuraj_c_entityview,
          ls_original_calculate LIKE LINE OF lt_original_calculate.

    lt_original_calculate = CORRESPONDING #(  it_original_data ).
    DATA(lv_count) = 0.
    LOOP AT lt_original_calculate ASSIGNING FIELD-SYMBOL(<fs_original>).

      <fs_original>-Message = COND #(  WHEN <fs_original>-Active = abap_false THEN 'Record can be edited'
                                       ELSE 'Record cannot be edited' ) .

      <fs_original>-MessageCriticality = COND #( WHEN <fs_original>-Active = abap_true THEN 1
                                                 ELSE 3 ).



      IF <fs_original>-firstname IS NOT INITIAL.
        lv_count = lv_count + 1.
      ENDIF.
      IF <fs_original>-lastname IS NOT INITIAL.
        lv_count = lv_count + 1.
      ENDIF.
      IF <fs_original>-email IS NOT INITIAL.
        lv_count = lv_count + 1.
      ENDIF.
      IF <fs_original>-ContactId IS NOT INITIAL.
        lv_count = lv_count + 1.
      ENDIF.
       IF <fs_original>-Dob IS NOT INITIAL.
        lv_count = lv_count + 1.
      ENDIF.
       IF <fs_original>-Gender IS NOT INITIAL.
        lv_count = lv_count + 1.
      ENDIF.
       IF <fs_original>-Telephone IS NOT INITIAL.
        lv_count = lv_count + 1.
      ENDIF.
      IF <fs_original>-Age IS NOT INITIAL.
        lv_count = lv_count + 1.
      ENDIF.


      <fs_original>-progress_bar = ( lv_count * 100 ) / 8.

       if <fs_original>-progress_bar = 100.
        <fs_original>-progresscriticality = 3.
      ELSEIF <fs_original>-progress_bar >= 50.
        <fs_original>-progresscriticality = 2.
      ELSE.
        <fs_original>-progresscriticality = 1.
      ENDIF.

      CLEAR lv_count.

    ENDLOOP.

    IF lt_original_calculate IS NOT INITIAL.
      ct_calculated_data = CORRESPONDING #( lt_original_calculate ).
    ENDIF.


  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
  ENDMETHOD.
ENDCLASS.
