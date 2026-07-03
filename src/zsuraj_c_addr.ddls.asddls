@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for address'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZSURAJ_C_ADDR as projection on ZSURAJ_I_ADDR
{
    key ContactId,
    key AddressId,
    Addr1,
    Addr2,
    City,
    State,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    /* Associations */
    _Contact: redirected to parent ZSURAJ_C_ENTITYVIEW
}
