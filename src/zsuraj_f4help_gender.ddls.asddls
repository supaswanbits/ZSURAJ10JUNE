@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4heph'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.resultSet.sizeCategory: #XXS
define view entity ZSURAJ_F4HELP_GENDER as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZSURAJ_DOM_GENDER' )
{

@UI.hidden: true
   key domain_name,
@UI.hidden: true
   key value_position,
@UI.hidden: true
   key language,
   value_low as GenderCode,
   text as GenderText
} where language = $session.system_language
