@EndUserText.label: 'Custom Entity for Product'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_CE_PO_HEADER'
@UI: {
  headerInfo: {
  typeName: 'Purchase Order',
  typeNamePlural: 'PurchaseOrders'
  }
}
define root custom entity ZCE_PO_Header
{
      @UI.facet     : [
           {
             id     :       'PurchaseOrder',
             purpose:  #STANDARD,
             type   :     #IDENTIFICATION_REFERENCE,
             label  :    'Purchase Order',
             position  : 10 }
         ]
         // DDL source code for custom entity

      @UI           : {
      lineItem      : [{position: 10, importance: #HIGH}],
      identification: [{position: 10}],
      selectionField: [{position: 10}]
      }
      @Consumption.filter: {  mandatory: false , multipleSelections: false, selectionType: #SINGLE}
      @EndUserText.label: 'Purchasing Document'
  key PurchaseOrder : abap.char( 10 );
      
      @UI           : {
      lineItem      : [{position: 20, importance: #HIGH}],
      identification: [{position: 20}],
      selectionField: [{position: 20}]
      }
      @Consumption.filter: { defaultValue: 'FO' , mandatory: true , multipleSelections: false, selectionType: #SINGLE}
      @EndUserText.label: 'Purchasing Type'
      Type          : abap.char( 4 );
      @UI           : {
      lineItem      : [{position: 30, importance: #HIGH}],
      identification: [{position: 30}],
      selectionField: [{position: 30}]
      }
      @Consumption.filter: {  mandatory: false , multipleSelections: false, selectionType: #SINGLE}
       @EndUserText.label: 'Purchasing Organization'
      Organization  : abap.char( 4 );

      @UI           : {
      lineItem      : [{position: 40, importance: #HIGH}],
      identification: [{position: 40}],
      selectionField: [{position: 40}]
      }
      @EndUserText.label: 'Purchasing Group'
      @Consumption.filter: {  mandatory: false , multipleSelections: false, selectionType: #SINGLE}
      PGroup        : abap.char( 4 );

      @UI           : {
      lineItem      : [{position: 40, importance: #HIGH}],
      identification: [{position: 40}]
      }
      @EndUserText.label: 'Purchasing Category'
      Category      : abap.char( 1 );
      @UI           : {
      lineItem      : [{position: 50, importance: #HIGH}],
      identification: [{position: 50}]
      }
       @EndUserText.label: 'Company Code'
      CompanyCode   : abap.char( 4 );
      @UI           : {
      lineItem      : [{position: 60, importance: #HIGH},
      { type        : #FOR_ACTION, dataAction: 'changeText', label: 'Change Text' } ],
      identification: [{position: 60}]
      }
       @EndUserText.label: 'Header Text'
      Text          : abap.string( 500 );

}
