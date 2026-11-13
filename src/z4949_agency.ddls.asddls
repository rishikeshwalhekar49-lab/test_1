@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'ESE_Test1 T5 - Agency'
define view entity Z4949_AGENCY
  as select from /dmo/agency
{
  key agency_id     as AgencyId,
      name          as Name,
      street        as Street,
      postal_code   as PostalCode,
      city          as City,
      country_code  as CountryCode,
      phone_number  as PhoneNumber,
      email_address as EmailAddress,
      web_address   as WebAddress
}
