@EndUserText.label: 'Projection view for public holidays'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZCAL_C_HOLIDAY_345860
  provider contract transactional_query
  as projection on ZCAL_I_HOLIDAY_345860
{
  key HolidayId,
      MonthOfHoliday,
      DayOfHoliday,
        _HolidayTxt.HolidayDescription as HolidayDescription : localized,
      LastChangedAt,
      LocalLastChangedAt,
      _HolidayTxt : redirected to composition child ZCAL_C_HOLIDAYTXT_345860
}
