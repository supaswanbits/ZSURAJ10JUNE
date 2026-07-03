@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contact Projection view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZSURAJ_C_ENTITYVIEW 
provider contract transactional_query
as projection on ZSURAJ_I_ENTITYVIEW
{
    key ContactId,
    FirstName,
    LastName,
    Gender,
    Dob,
    age,
    Telephone,
    Email,
    Active,
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CONTACT_EXIT'
    @EndUserText.label: 'Message'
    virtual Message : abap.char(30),
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CONTACT_EXIT'
    virtual MessageCriticality : abap.char(1),
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CONTACT_EXIT'
    virtual progress_bar: abap.int2 ,
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CONTACT_EXIT'
    virtual progresscriticality: abap.char(1),
    CreatedBy,
    CreatedAt,
    Lastchangedby,
    Lastchangedat,
    _Address : redirected to composition child ZSURAJ_C_ADDR
}
