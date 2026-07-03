@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Address enitity'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZSURAJ_I_ADDR
 as select from zsuraj_address
 association to parent ZSURAJ_I_ENTITYVIEW as _Contact
 on $projection.ContactId = _Contact.ContactId
{
    key contact_id as ContactId,
    key address_id as AddressId,
    addr1 as Addr1,
    addr2 as Addr2,
    city as City,
    state as State,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    last_changed_at as LastChangedAt,
    _Contact
}
