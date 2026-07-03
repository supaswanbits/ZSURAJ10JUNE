@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contact interface View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZSURAJ_I_ENTITYVIEW 
as select from zsuraj_contact
composition[0..*] of ZSURAJ_I_ADDR as _Address

{
    key contact_id as ContactId,
    first_name as FirstName,
    last_name as LastName,
    gender as Gender,
    dob as Dob,
    age as age,
    telephone as Telephone,
    email as Email,
    active as Active,
    created_by as CreatedBy,
    created_at as CreatedAt,
    lastchangedby as Lastchangedby,
    lastchangedat as Lastchangedat,
    _Address
    
}
