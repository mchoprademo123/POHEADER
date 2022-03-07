@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS View for holiday text'
@ObjectModel.dataCategory: #TEXT
define view entity ZCAL_I_HOLIDAYTXT_345860
  as select from zcal_holt_345860
  association        to parent ZCAL_I_HOLIDAY_345860 as _Public_Holiday on $projection.HolidayId = _Public_Holiday.HolidayId
  association [0..*] to I_LanguageText               as _LanguageText   on $projection.Language = _LanguageText.LanguageCode

{

      @Semantics.language: true
  key spras            as Language,
  key holiday_id       as HolidayId,
      @Semantics.text: true
      fcal_description as HolidayDescription,
      _Public_Holiday,
      _LanguageText
}
