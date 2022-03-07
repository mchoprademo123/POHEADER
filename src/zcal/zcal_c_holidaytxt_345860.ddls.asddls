@EndUserText.label: 'Projection view for holiday text'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZCAL_C_HOLIDAYTXT_345860 as projection on ZCAL_I_HOLIDAYTXT_345860 {

@Consumption.valueHelpDefinition: [ {entity: {name: 'I_Language', element: 'Language' }} ]
 @ObjectModel.text.element:['LanguageDescription']
    key Language,
    key HolidayId,
    HolidayDescription,
    /* Associations */
     _LanguageText.LanguageName as LanguageDescription : localized,
    _Public_Holiday: redirected to parent ZCAL_C_HOLIDAY_345860
}
