/*

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
<cfcomponent extends="controller" output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
	</cffunction>

	<cffunction name="GeoCodeAddress" ReturnType="Array" Output="False">
		<cfargument name="Address" type="String" required="True">
		<cfargument name="City" type="String" required="True">
		<cfargument name="State" type="String" required="True">
		<cfargument name="ZipCode" type="String" required="True">

		<cfset GeoCodeStreetAddress = #Replace(Trim(Arguments.Address), " ", "+", "ALL")#>
		<cfset GeoCodeCity = #Replace(Trim(Arguments.City), " ", "+", "ALL")#>
		<cfset GeoCodeState = #Replace(Trim(Arguments.State), " ", "+", "ALL")#>
		<cfset GeoCodeZipCode = #Trim(Arguments.ZipCode)#>

		<cfset GeoCodeAddress = ArrayNew(1)>
		<cfset Temp = StructNew()>

		<cfhttp URL="http://maps.google.com/maps/api/geocode/xml?address=#Variables.GeoCodeStreetAddress#,+#Variables.GeoCodeCity#,+#Variables.GeoCodeState#,+#Variables.GeoCodeZipCode#&sensor=false" method="Get" result="GetCodePageContent" resolveurl="true"></cfhttp>

		<cfif GetCodePageContent.FileContent Contains "REQUEST_DENIED">
			<cfset Temp.ErrorMessage = "Google Request Denied">
			<cfset Temp.AddressStreetNumber = "">
			<cfset Temp.AddressStreetName = "">
			<cfset Temp.AddressCityName = "">
			<cfset Temp.AddressStateNameLong = "">
			<cfset Temp.AddressStateNameShort = "">
			<cfset Temp.AddressZipCode = "">
			<cfset Temp.AddressTownshipName = "">
			<cfset Temp.AddressNeighborhoodName = "">
			<cfset Temp.AddressCountyName = "">
			<cfset Temp.AddressCountryNameLong = "">
			<cfset Temp.AddressCountryNameShort = "">
			<cfset Temp.AddressLatitude = "">
			<cfset Temp.AddressLongitude = "">
			<cfset #arrayAppend(GeoCodeAddress, Temp)#>
		</cfif>

		<cfset XMLDocument = #XMLParse(GetCodePageContent.FileContent)#>
		<cfset GeoCodeResponseStatus = #XMLSearch(Variables.XMLDocument, "/GeocodeResponse/status")#>
		<cfset GeoCodeResultFormattedAddressType = #XmlSearch(Variables.XMLDocument, "/GeocodeResponse/result/type")#>
		<cfset GeoCodeResultFormattedAddress = #XmlSearch(Variables.XMLDocument, "/GeocodeResponse/result/formatted_address")#>
		<cfset GeoCodeResultAddressComponent = #XMLSearch(Variables.XMLDocument, "/GeocodeResponse/result/address_component")#>
		<cfset GeoCodeResultGeometryComponent = #XMLSearch(XMLDocument, "/GeocodeResponse/result/geometry")#>

		<cfswitch expression="#GeoCodeResponseStatus[1].XMLText#">
			<cfcase value="ZERO_RESULTS">
				<!--- Indicates that the geocode was successful but returned no results. This may occur if the geocode was passed a non-existent address
						or latlng in a remote location --->
			</cfcase>
			<cfcase value="OVER_QUERY_LIMIT">
				<!--- Indicates that you are over your quota --->
			</cfcase>
			<cfcase value="REQUEST_DENIED">
				<!--- Indicates that your request was denied, generally becasue of lack of a sensor parameter --->
			</cfcase>
			<cfcase value="INVALID_REQUEST">
				<!--- generally indicates that the query (address or latlng) is missing --->
			</cfcase>
			<cfcase value="UNKNOWN_ERROR">
				<!--- Indicates that the request could not be processed do to a server error. The request may sicceed if you try again --->
			</cfcase>
			<cfcase value="OK">
				<cfswitch expression="#GeoCodeResultFormattedAddressType[1].XMLText#">
					<cfcase value="route">
						<cfset Temp.ErrorMessage = "Unable Locate Address">
						<cfset Temp.ErrorMessageText = "Unable to locate the address you entered as a valid address.">
						<cfset Temp.Address = #Arguments.Address#>
						<cfset Temp.City = #Arguments.City#>
						<cfset Temp.State = #Arguments.State#>
						<cfset Temp.ZipCode = #Arguments.ZipCode#>
						<cfset #arrayAppend(GeoCodeAddress, Temp)#>
						<cfreturn GeoCodeAddress>
					</cfcase>
					<cfcase value="street_address">
						<cfswitch expression="#ArrayLen(GeoCodeResultAddressComponent)#">
							<cfcase value="9">
								<!--- Address Example: 57405 Horseshoe Court, Goshen, IN 46528 --->
								<cfscript>
									GeoCodeResultStreetNumber = GeoCodeResultAddressComponent[1].XmlChildren;
									GeoCodeResultStreetName = GeoCodeResultAddressComponent[2].XmlChildren;
									GeoCodeResultNeighborhoodName = GeoCodeResultAddressComponent[3].XmlChildren;
									GeoCodeResultCityName = GeoCodeResultAddressComponent[4].XmlChildren;
									GeoCodeResultTownshipName = GeoCodeResultAddressComponent[5].XmlChildren;
									GeoCodeResultCountyName = GeoCodeResultAddressComponent[6].XmlChildren;
									GeoCodeResultStateName = GeoCodeResultAddressComponent[7].XmlChildren;
									GeoCodeResultCountryName = GeoCodeResultAddressComponent[8].XmlChildren;
									GeoCodeResultZipCode = GeoCodeResultAddressComponent[9].XmlChildren;
									GeoCodeAddressLocation = GeoCodeResultGeometryComponent[1].XmlChildren;
									GeoCodeFormattedAddress = GeoCodeResultFormattedAddress[1].XmlText;
								</cfscript>
								<cfset Temp.ErrorMessage = #GeoCodeResponseStatus[1].XMLText#>
								<cfset Temp.AddressStreetNumber = #GeoCodeResultStreetNumber[1].XMLText#>
								<cfset Temp.AddressStreetNameLong = #GeoCodeResultStreetName[1].XMLText#>
								<cfset Temp.AddressStreetNameShort = #GeoCodeResultStreetName[2].XMLText#>
								<cfset Temp.AddressStreetNameType = #GeoCodeResultStreetName[3].XMLText#>
								<cfset Temp.AddressCityName = #GeoCodeResultCityName[1].XMLText#>
								<cfset Temp.AddressCountyNameLong = #GeoCodeResultCountyName[1].XMLText#>
								<cfset Temp.AddressCountyNameShort = #GeoCodeResultCountyName[2].XMLText#>
								<cfset Temp.AddressStateNameLong = #GeoCodeResultStateName[1].XMLText#>
								<cfset Temp.AddressStateNameShort = #GeoCodeResultStateName[2].XMLText#>
								<cfset Temp.AddressCountryNameLong = #GeoCodeResultCountryName[1].XMLText#>
								<cfset Temp.AddressCountryNameShort = #GeoCodeResultCountryName[2].XMLText#>
								<cfset Temp.AddressZipCode = #GeoCodeResultZipCode[1].XMLText#>
								<cfset Temp.AddressLocation = #GeoCodeAddressLocation[1].XMLChildren#>
								<cfset Temp.AddressLatitude = #Temp.AddressLocation[1].XMLText#>
								<cfset Temp.AddressLongitude = #Temp.AddressLocation[2].XMLText#>
								<cfset Temp.AddressTownshipNameLong = #GeoCodeResultTownshipName[1].XMLText#>
								<cfset Temp.AddressTownshipNameShort = #GeoCodeResultTownshipName[1].XMLText#>
								<cfset Temp.NeighborhoodNameLong = #GeoCodeResultNeighborhoodName[1].XMLText#>
								<cfset Temp.NeighborhoodNameShort = #GeoCodeResultNeighborhoodName[2].XMLText#>
								<cfset #arrayAppend(GeoCodeAddress, Temp)#>
							</cfcase>
							<cfcase value="8">
								<!--- Address Example: 56535 Magnetic Drive, Mishwaka, IN 46545 --->
								<cfscript>
									GeoCodeResultStreetNumber = GeoCodeResultAddressComponent[1].XmlChildren;
									GeoCodeResultStreetName = GeoCodeResultAddressComponent[2].XmlChildren;
									GeoCodeResultCityName = GeoCodeResultAddressComponent[3].XmlChildren;
									GeoCodeResultTownshipName = GeoCodeResultAddressComponent[4].XmlChildren;
									GeoCodeResultCountyName = GeoCodeResultAddressComponent[5].XmlChildren;
									GeoCodeResultStateName = GeoCodeResultAddressComponent[6].XmlChildren;
									GeoCodeResultCountryName = GeoCodeResultAddressComponent[7].XmlChildren;
									GeoCodeResultZipCode = GeoCodeResultAddressComponent[8].XmlChildren;
									GeoCodeAddressLocation = GeoCodeResultGeometryComponent[1].XmlChildren;
									GeoCodeFormattedAddress = GeoCodeResultFormattedAddress[1].XmlText;
								</cfscript>

								<cfset Temp.ErrorMessage = #GeoCodeResponseStatus[1].XMLText#>
								<cfset Temp.AddressStreetNumber = #GeoCodeResultStreetNumber[1].XMLText#>
								<cfset Temp.AddressStreetNameLong = #GeoCodeResultStreetName[1].XMLText#>
								<cfset Temp.AddressStreetNameShort = #GeoCodeResultStreetName[2].XMLText#>
								<cfset Temp.AddressStreetNameType = #GeoCodeResultStreetName[3].XMLText#>
								<cfset Temp.AddressCityName = #GeoCodeResultCityName[1].XMLText#>
								<cfset Temp.AddressCountyNameLong = #GeoCodeResultCountyName[1].XMLText#>
								<cfset Temp.AddressCountyNameShort = #GeoCodeResultCountyName[2].XMLText#>
								<cfset Temp.AddressStateNameLong = #GeoCodeResultStateName[1].XMLText#>
								<cfset Temp.AddressStateNameShort = #GeoCodeResultStateName[2].XMLText#>
								<cfset Temp.AddressCountryNameLong = #GeoCodeResultCountryName[1].XMLText#>
								<cfset Temp.AddressCountryNameShort = #GeoCodeResultCountryName[2].XMLText#>
								<cfset Temp.AddressZipCode = #GeoCodeResultZipCode[1].XMLText#>
								<cfset Temp.AddressLocation = #GeoCodeAddressLocation[1].XMLChildren#>
								<cfset Temp.AddressLatitude = #Temp.AddressLocation[1].XMLText#>
								<cfset Temp.AddressLongitude = #Temp.AddressLocation[2].XMLText#>
								<cfset Temp.AddressTownshipNameLong = #GeoCodeResultTownshipName[1].XMLText#>
								<cfset Temp.AddressTownshipNameShort = #GeoCodeResultTownshipName[1].XMLText#>
								<cfset Temp.NeighborhoodNameLong = "">
								<cfset Temp.NeighborhoodNameShort = "">
								<cfset #arrayAppend(GeoCodeAddress, Temp)#>
							</cfcase>
							<cfdefaultcase>
								<!--- Address Example: 2307 Edison Road, South Bend, IN 46615 --->
								<cfscript>
									GeoCodeResultStreetNumber = GeoCodeResultAddressComponent[1].XmlChildren;
									GeoCodeResultStreetName = GeoCodeResultAddressComponent[2].XmlChildren;
									GeoCodeResultCityName = GeoCodeResultAddressComponent[3].XmlChildren;
									GeoCodeResultCountyName = GeoCodeResultAddressComponent[4].XmlChildren;
									GeoCodeResultStateName = GeoCodeResultAddressComponent[5].XmlChildren;
									GeoCodeResultCountryName = GeoCodeResultAddressComponent[6].XmlChildren;
									GeoCodeResultZipCode = GeoCodeResultAddressComponent[7].XmlChildren;
									GeoCodeAddressLocation = GeoCodeResultGeometryComponent[1].XmlChildren;
									GeoCodeFormattedAddress = GeoCodeResultFormattedAddress[1].XmlText;
								</cfscript>

								<cfset Temp.ErrorMessage = #GeoCodeResponseStatus[1].XMLText#>
								<cfset Temp.AddressStreetNumber = #GeoCodeResultStreetNumber[1].XMLText#>
								<cfset Temp.AddressStreetNameLong = #GeoCodeResultStreetName[1].XMLText#>
								<cfset Temp.AddressStreetNameShort = #GeoCodeResultStreetName[2].XMLText#>
								<cfset Temp.AddressStreetNameType = #GeoCodeResultStreetName[3].XMLText#>
								<cfset Temp.AddressCityName = #GeoCodeResultCityName[1].XMLText#>
								<cfset Temp.AddressCountyNameLong = #GeoCodeResultCountyName[1].XMLText#>
								<cfset Temp.AddressCountyNameShort = #GeoCodeResultCountyName[2].XMLText#>
								<cfset Temp.AddressStateNameLong = #GeoCodeResultStateName[1].XMLText#>
								<cfset Temp.AddressStateNameShort = #GeoCodeResultStateName[2].XMLText#>
								<cfset Temp.AddressCountryNameLong = #GeoCodeResultCountryName[1].XMLText#>
								<cfset Temp.AddressCountryNameShort = #GeoCodeResultCountryName[2].XMLText#>
								<cfset Temp.AddressZipCode = #GeoCodeResultZipCode[1].XMLText#>
								<cfset Temp.AddressLocation = #GeoCodeAddressLocation[1].XMLChildren#>
								<cfset Temp.AddressLatitude = #Temp.AddressLocation[1].XMLText#>
								<cfset Temp.AddressLongitude = #Temp.AddressLocation[2].XMLText#>
								<cfset Temp.AddressTownshipNameLong = "">
								<cfset Temp.AddressTownshipNameShort = "">
								<cfset Temp.NeighborhoodNameLong = "">
								<cfset Temp.NeighborhoodNameShort = "">
								<cfset #arrayAppend(GeoCodeAddress, Temp)#>
							</cfdefaultcase>
						</cfswitch>
					</cfcase>
					<cfcase value="postal_code">
						<cfset Temp.ErrorMessage = "Unable Locate Address">
						<cfset Temp.ErrorMessageText = "Unable to locate the address you entered as a valid address.">
						<cfset Temp.Address = #Arguments.Address#>
						<cfset Temp.City = #Arguments.City#>
						<cfset Temp.State = #Arguments.State#>
						<cfset Temp.ZipCode = #Arguments.ZipCode#>
						<cfset #arrayAppend(GeoCodeAddress, Temp)#>
						<cfreturn GeoCodeAddress>
					</cfcase>
					<cfdefaultcase>
						<cfoutput>#GeoCodeResultFormattedAddressType[1].XMLText#</cfoutput><hr>
						<cfdump var="#XMLDocument#">
						<cfdump var="#GeoCodeResponseStatus#">
						<cfdump var="#GeoCodeResultFormattedAddressType#">
						<cfdump var="#GeoCodeResultFormattedAddress#">
						<cfabort>
					</cfdefaultcase>
				</cfswitch>
			</cfcase>
		</cfswitch>
		<cfreturn GeoCodeAddress>
	</cffunction>

	<cffunction name="addfacility" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit") and not isDefined("FORM.ReSubmit")>
			<cflock timeout="60" scope="SESSION" type="Exclusive">
				<cfset Session.FormData = #StructCopy(FORM)#>
				<cfset Session.UserSuppliedInfo = StructNew()>
				<cfset Session.UserSuppliedInfo.NewRecNo = 0>
				<cfset Session.UserSuppliedInfo.FacilityName = #FORM.FacilityName#>
				<cfset Session.UserSuppliedInfo.PhysicalAddress = #FORM.PhysicalAddress#>
				<cfset Session.UserSuppliedInfo.PhysicalCity = #FORM.PhysicalCity#>
				<cfset Session.UserSuppliedInfo.PhysicalState = #FORM.PhysicalState#>
				<cfset Session.UserSuppliedInfo.PhysicalZipCode = #FORM.PhysicalZipCode#>
				<cfset Session.UserSuppliedInfo.PrimaryVoiceNumber = #FORM.PrimaryVoiceNumber#>
				<cfset Session.UserSuppliedInfo.BusinessWebsite = #FORM.BusinessWebsite#>
				<cfset Session.UserSuppliedInfo.FacilityType = #FORM.FacilityType#>
				<cfset Session.UserSuppliedInfo.ContactName = #FORM.ContactName#>
				<cfset Session.UserSuppliedInfo.ContactPhoneNumber = #FORM.ContactPhoneNumber#>
				<cfset Session.UserSuppliedInfo.ContactEmail = #FORM.ContactEmail#>
			</cflock>
			<cfset AddressGeoCoded = #GeoCodeAddress(Form.PhysicalAddress, FORM.PhysicalCity, FORM.PhysicalState, FORM.PhysicalZipCode)#>
			<cfif AddressGeoCoded[1].ErrorMessage NEQ "OK">
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						address = {property="BusinessAddress",message="#Variables.AddressGeoCoded[1].ErrorMessageText#"};
						arrayAppend(Session.FormErrors, address);
					</cfscript>
				</cflock>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:facilities.addfacility&PerformAction=ReEnterAddress&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false">
			<cfelse>
				<cfset CombinedPhysicalAddress = #AddressGeoCoded[1].AddressStreetNumber# & " " & #AddressGeoCoded[1].AddressStreetNameShort#>

				<cfquery name="insertNewFacility" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Insert into eFacility(FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, dateCreated, lastUpdated, lastUpdateBy, Site_ID, FacilityType)
					Values("#FORM.FacilityName#", "#Variables.CombinedPhysicalAddress#", "#Trim(Variables.AddressGeoCoded[1].AddressCityName)#", "#Trim(Variables.AddressGeoCoded[1].AddressStateNameShort)#", "#Trim(Variables.AddressGeoCoded[1].AddressZipCode)#", #Now()#, #Now()#, "#rc.$.currentUser('userName')#", "#rc.$.siteConfig('siteID')#", "#FORM.FacilityType#")
				</cfquery>

				<cfquery name="getLastInsertRecordID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID
					From eFacility
					Where FacilityName = <cfqueryparam value="#FORM.FacilityName#" cfsqltype="cf_sql_varchar"> and
						PhysicalAddress = <cfqueryparam value="#Variables.CombinedPhysicalAddress#" cfsqltype="cf_sql_varchar"> and
						PhysicalCity = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressCityName)#" cfsqltype="cf_sql_varchar"> and
						PhysicalState = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressStateNameShort)#" cfsqltype="cf_sql_varchar"> and
						PhysicalZipCode = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressZipCode)#" cfsqltype="cf_sql_varchar"> and
						Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				</cfquery>

				<cfquery name="updateFacilityGeoCode" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update eFacility
					Set GeoCode_Latitude = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressLatitude)#" cfsqltype="cf_sql_varchar">,
						GeoCode_Longitude = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressLongitude)#" cfsqltype="cf_sql_varchar">,
						GeoCode_Township = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressTownshipNameLong)#" cfsqltype="cf_sql_varchar">,
						GeoCode_StateLongName = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressStateNameLong)#" cfsqltype="cf_sql_varchar">,
						GeoCode_CountryShortName = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressCountryNameShort)#" cfsqltype="cf_sql_varchar">,
						isAddressVerified = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
						Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
						lastUpdated = #Now()#, lastUpdateBy = <cfqueryparam value="#rc.$.currentUser('userName')#" cfsqltype="cf_sql_varchar">
					Where TContent_ID = <cfqueryparam value="#getLastInsertRecordID.TContent_ID#" cfsqltype="cf_sql_integer"> and
						Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				</cfquery>

				<cfif LEN(FORM.PrimaryVoiceNumber)>
					<cfquery name="updateVendorPrimaryNumber" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eFacility
						Set PrimaryVoiceNumber = <cfqueryparam value="#FORM.PrimaryVoiceNumber#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#getLastInsertRecordID.TContent_ID#" cfsqltype="cf_sql_integer"> and Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
				<cfif LEN(FORM.BusinessWebsite)>
					<cfquery name="updateVendorBusinessWebsite" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eFacility
						Set BusinessWebsite = <cfqueryparam value="#FORM.BusinessWebsite#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#getLastInsertRecordID.TContent_ID#" cfsqltype="cf_sql_integer"> and Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
				<cfif LEN(FORM.ContactName)>
					<cfquery name="updateVendorContactName" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eFacility
						Set ContactName = <cfqueryparam value="#FORM.ContactName#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#getLastInsertRecordID.TContent_ID#" cfsqltype="cf_sql_integer"> and Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
				<cfif LEN(FORM.ContactPhoneNumber)>
					<cfquery name="updateVendorContactPhoneNumber" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eFacility
						Set ContactPhoneNumber = <cfqueryparam value="#FORM.ContactPhoneNumber#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#getLastInsertRecordID.TContent_ID#" cfsqltype="cf_sql_integer"> and Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
				<cfif LEN(FORM.ContactEmail)>
					<cfquery name="updateVendorContactEmail" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eFacility
						Set ContactEmail = <cfqueryparam value="#FORM.ContactEmail#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#getLastInsertRecordID.TContent_ID#" cfsqltype="cf_sql_integer"> and Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:facilities&UserAction=AddedFacility&SiteID=#rc.$.siteConfig('siteID')#&Successful=true" addtoken="false">
			</cfif>
		<cfelseif isDefined("FORM.formSubmit") and isDefined("FORM.ReSubmit")>
			<cflock timeout="60" scope="SESSION" type="Exclusive">
				<cfset Session.FormData = #StructCopy(FORM)#>
				<cfset Session.UserSuppliedInfo = StructNew()>
				<cfset Session.UserSuppliedInfo.NewRecNo = 0>
				<cfset Session.UserSuppliedInfo.FacilityName = #FORM.FacilityName#>
				<cfset Session.UserSuppliedInfo.PhysicalAddress = #FORM.PhysicalAddress#>
				<cfset Session.UserSuppliedInfo.PhysicalCity = #FORM.PhysicalCity#>
				<cfset Session.UserSuppliedInfo.PhysicalState = #FORM.PhysicalState#>
				<cfset Session.UserSuppliedInfo.PhysicalZipCode = #FORM.PhysicalZipCode#>
				<cfset Session.UserSuppliedInfo.PrimaryVoiceNumber = #FORM.PrimaryVoiceNumber#>
				<cfset Session.UserSuppliedInfo.BusinessWebsite = #FORM.BusinessWebsite#>
				<cfset Session.UserSuppliedInfo.FacilityType = #FORM.FacilityType#>
				<cfset Session.UserSuppliedInfo.ContactName = #FORM.ContactName#>
				<cfset Session.UserSuppliedInfo.ContactPhoneNumber = #FORM.ContactPhoneNumber#>
				<cfset Session.UserSuppliedInfo.ContactEmail = #FORM.ContactEmail#>
			</cflock>
			<cfset AddressGeoCoded = #GeoCodeAddress(Form.PhysicalAddress, FORM.PhysicalCity, FORM.PhysicalState, FORM.PhysicalZipCode)#>
			<cfif AddressGeoCoded[1].ErrorMessage NEQ "OK">
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						address = {property="BusinessAddress",message="#Variables.AddressGeoCoded[1].ErrorMessageText#"};
						arrayAppend(Session.FormErrors, address);
					</cfscript>
				</cflock>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:facilities.addfacility&PerformAction=ReEnterAddress&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false">
			<cfelse>
				<cfset CombinedPhysicalAddress = #AddressGeoCoded[1].AddressStreetNumber# & " " & #AddressGeoCoded[1].AddressStreetNameShort#>

				<cfquery name="insertNewFacility" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Insert into eFacility(FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, dateCreated, lastUpdated, lastUpdateBy, Site_ID, FacilityType)
					Values("#FORM.FacilityName#", "#Variables.CombinedPhysicalAddress#", "#Trim(Variables.AddressGeoCoded[1].AddressCityName)#", "#Trim(Variables.AddressGeoCoded[1].AddressStateNameShort)#", "#Trim(Variables.AddressGeoCoded[1].AddressZipCode)#", #Now()#, #Now()#, "#rc.$.currentUser('userName')#", "#rc.$.siteConfig('siteID')#", "#FORM.FacilityType#")
				</cfquery>

				<cfquery name="getLastInsertRecordID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID
					From eFacility
					Where FacilityName = <cfqueryparam value="#FORM.FacilityName#" cfsqltype="cf_sql_varchar"> and
						PhysicalAddress = <cfqueryparam value="#Variables.CombinedPhysicalAddress#" cfsqltype="cf_sql_varchar"> and
						PhysicalCity = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressCityName)#" cfsqltype="cf_sql_varchar"> and
						PhysicalState = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressStateNameShort)#" cfsqltype="cf_sql_varchar"> and
						PhysicalZipCode = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressZipCode)#" cfsqltype="cf_sql_varchar"> and
						Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				</cfquery>

				<cfquery name="updateFacilityGeoCode" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update eFacility
					Set GeoCode_Latitude = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressLatitude)#" cfsqltype="cf_sql_varchar">,
						GeoCode_Longitude = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressLongitude)#" cfsqltype="cf_sql_varchar">,
						GeoCode_Township = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressTownshipNameLong)#" cfsqltype="cf_sql_varchar">,
						GeoCode_StateLongName = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressStateNameLong)#" cfsqltype="cf_sql_varchar">,
						GeoCode_CountryShortName = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressCountryNameShort)#" cfsqltype="cf_sql_varchar">,
						lastUpdated = #Now()#, lastUpdateBy = <cfqueryparam value="#rc.$.currentUser('userName')#" cfsqltype="cf_sql_varchar">
					Where TContent_ID = <cfqueryparam value="#getLastInsertRecordID.TContent_ID#" cfsqltype="cf_sql_integer"> and
						Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				</cfquery>

				<cfif LEN(FORM.PrimaryVoiceNumber)>
					<cfquery name="updateVendorPrimaryNumber" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eFacility
						Set PrimaryVoiceNumber = <cfqueryparam value="#FORM.PrimaryVoiceNumber#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#getLastInsertRecordID.TContent_ID#" cfsqltype="cf_sql_integer"> and Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
				<cfif LEN(FORM.BusinessWebsite)>
					<cfquery name="updateVendorBusinessWebsite" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eFacility
						Set BusinessWebsite = <cfqueryparam value="#FORM.BusinessWebsite#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#getLastInsertRecordID.TContent_ID#" cfsqltype="cf_sql_integer"> and Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
				<cfif LEN(FORM.ContactName)>
					<cfquery name="updateVendorContactName" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eFacility
						Set ContactName = <cfqueryparam value="#FORM.ContactName#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#getLastInsertRecordID.TContent_ID#" cfsqltype="cf_sql_integer"> and Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
				<cfif LEN(FORM.ContactPhoneNumber)>
					<cfquery name="updateVendorContactPhoneNumber" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eFacility
						Set ContactPhoneNumber = <cfqueryparam value="#FORM.ContactPhoneNumber#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#getLastInsertRecordID.TContent_ID#" cfsqltype="cf_sql_integer"> and Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
				<cfif LEN(FORM.ContactEmail)>
					<cfquery name="updateVendorContactEmail" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eFacility
						Set ContactEmail = <cfqueryparam value="#FORM.ContactEmail#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#getLastInsertRecordID.TContent_ID#" cfsqltype="cf_sql_integer"> and Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:facilities&UserAction=AddedFacility&SiteID=#rc.$.siteConfig('siteID')#&Successful=true" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updatefacility" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit") and not isDefined("FORM.ReSubmit")>
			<cfif isDefined("URL.PerformAction")>
				<cfswitch expression="#URL.PerformAction#">
					<cfcase value="Edit">
						<cflock timeout="60" scope="SESSION" type="Exclusive">
							<cfset Session.FormData = #StructCopy(FORM)#>
							<cfset Session.UserSuppliedInfo = StructNew()>
							<cfset Session.UserSuppliedInfo.NewRecNo = #URL.RecNo#>
							<cfset Session.UserSuppliedInfo.FacilityName = #FORM.FacilityName#>
							<cfset Session.UserSuppliedInfo.PhysicalAddress = #FORM.PhysicalAddress#>
							<cfset Session.UserSuppliedInfo.PhysicalCity = #FORM.PhysicalCity#>
							<cfset Session.UserSuppliedInfo.PhysicalState = #FORM.PhysicalState#>
							<cfset Session.UserSuppliedInfo.PhysicalZipCode = #FORM.PhysicalZipCode#>
							<cfset Session.UserSuppliedInfo.PrimaryVoiceNumber = #FORM.PrimaryVoiceNumber#>
							<cfset Session.UserSuppliedInfo.BusinessWebsite = #FORM.BusinessWebsite#>
							<cfset Session.UserSuppliedInfo.FacilityType = #FORM.FacilityType#>
							<cfset Session.UserSuppliedInfo.ContactName = #FORM.ContactName#>
							<cfset Session.UserSuppliedInfo.ContactPhoneNumber = #FORM.ContactPhoneNumber#>
							<cfset Session.UserSuppliedInfo.ContactEmail = #FORM.ContactEmail#>
						</cflock>
						<cfset UpdateInfo = #StructNew()#>
						<cfquery name="getSelectedFacility" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, dateCreated, lastUpdated, lastUpdateBy, isAddressVerified, GeoCode_Latitude, GeoCode_Longitude, GeoCode_Township, GeoCode_StateLongName, GeoCode_CountryShortName, GeoCode_Neighborhood, USPS_CarrierRoute, USPS_CheckDigit, USPS_DeliveryPoint, PhysicalLocationCountry, PhysicalCountry, FacilityType
							From eFacility
							Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#URL.RecNo#" cfsqltype="cf_sql_integer">
							Order by FacilityName ASC
						</cfquery>

						<cfparam name="UpdateInfo.NameUpdated" type="boolean" default="0">
						<cfparam name="UpdateInfo.AddressUpdated" type="boolean" default="0">
						<cfparam name="UpdateInfo.CityUpdated" type="boolean" default="0">
						<cfparam name="UpdateInfo.StateUpdated" type="boolean" default="0">
						<cfparam name="UpdateInfo.ZipCodeUpdated" type="boolean" default="0">
						<cfparam name="UpdateInfo.VoiceNumberUpdated" type="boolean" default="0">
						<cfparam name="UpdateInfo.WebsiteUpdated" type="boolean" default="0">
						<cfparam name="UpdateInfo.ContactNameUpdated" type="boolean" default="0">
						<cfparam name="UpdateInfo.ContactPhoneUpdated" type="boolean" default="0">
						<cfparam name="UpdateInfo.ContactEmailUpdated" type="boolean" default="0">
						<cfparam name="UpdateInfo.FacilityType" type="boolean" default="0">

						<cfif getSelectedFacility.FacilityName NEQ Form.FacilityName><cfset UpdateInfo.NameUpdated = 1></cfif>
						<cfif getSelectedFacility.PrimaryVoiceNumber NEQ Form.PrimaryVoiceNumber><cfset UpdateInfo.VoiceNumberUpdated = 1></cfif>
						<cfif getSelectedFacility.BusinessWebsite NEQ Form.BusinessWebsite><cfset UpdateInfo.WebsiteUpdated = 1></cfif>
						<cfif getSelectedFacility.FacilityType NEQ Form.FacilityType><cfset UpdateInfo.FacilityType = 1></cfif>
						<cfif getSelectedFacility.ContactName NEQ Form.ContactName><cfset UpdateInfo.ContactNameUpdated = 1></cfif>
						<cfif getSelectedFacility.ContactPhoneNumber NEQ Form.ContactPhoneNumber><cfset UpdateInfo.ContactPhoneUpdated = 1></cfif>
						<cfif getSelectedFacility.ContactEmail NEQ Form.ContactEmail><cfset UpdateInfo.ContactEmailUpdated = 1></cfif>

						<cfset AddressGeoCoded = #GeoCodeAddress(Form.PhysicalAddress, FORM.PhysicalCity, FORM.PhysicalState, FORM.PhysicalZipCode)#>
						<cfif AddressGeoCoded[1].ErrorMessage NEQ "OK">
							<cflock timeout="60" scope="SESSION" type="Exclusive">
								<cfscript>
									address = {property="BusinessAddress",message="#Variables.AddressGeoCoded[1].ErrorMessageText#"};
									arrayAppend(Session.FormErrors, address);
								</cfscript>
							</cflock>
							<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:facilities.updatefacility&PerformAction=ReEnterAddress&SiteID=#rc.$.siteConfig('siteID')#&RecNo=#getSelectedFacility.TContent_ID#" addtoken="false">
						<cfelse>
							<cfset CombinedPhysicalAddress = #AddressGeoCoded[1].AddressStreetNumber# & " " & #AddressGeoCoded[1].AddressStreetNameShort#>
							<cfif Compare(getSelectedFacility.PhysicalAddress, Variables.CombinedPhysicalAddress) NEQ 0><cfset UpdateInfo.AddressUpdated = 1></cfif>
							<cfif getSelectedFacility.PhysicalCity NEQ AddressGeoCoded[1].AddressCityName><cfset UpdateInfo.CityUpdated = 1></cfif>
							<cfif getSelectedFacility.PhysicalState NEQ AddressGeoCoded[1].AddressStateNameShort><cfset UpdateInfo.StateUpdated = 1></cfif>
							<cfif getSelectedFacility.PhysicalZipCode NEQ AddressGeoCoded[1].AddressZipCode><cfset UpdateInfo.ZipCodeUpdated = 1></cfif>

							<cfif UpdateInfo.NameUpdated EQ 1 OR UpdateInfo.AddressUpdated EQ 1 OR UpdateInfo.CityUpdated EQ 1 OR UpdateInfo.StateUpdated EQ 1 OR UpdateInfo.ZipCodeUpdated EQ 1 OR UpdateInfo.VoiceNumberUpdated EQ 1 OR UpdateInfo.WebsiteUpdated EQ 1 OR UpdateInfo.ContactNameUpdated EQ 1 OR UpdateInfo.ContactPhoneUpdated EQ 1 OR UpdateInfo.ContactEmailUpdated EQ 1>
								<cfquery name="updateFacilityAddress" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update eFacility
									Set
										<cfif UpdateInfo.NameUpdated EQ 1>
											FacilityName = <cfqueryparam value="#Trim(Form.FacilityName)#" cfsqltype="cf_sql_varchar"> ,
										</cfif>

										<cfif UpdateInfo.AddressUpdated EQ 1>
											PhysicalAddress = <cfqueryparam value="#Trim(Variables.CombinedPhysicalAddress)#" cfsqltype="cf_sql_varchar"> ,
										</cfif>

										<cfif UpdateInfo.CityUpdated EQ 1>
											PhysicalCity = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressCityName)#" cfsqltype="cf_sql_varchar"> ,
										</cfif>

										<cfif UpdateInfo.StateUpdated EQ 1>
											PhysicalState = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressStateNameShort)#" cfsqltype="cf_sql_varchar"> ,
										</cfif>

										<cfif UpdateInfo.ZipCodeUpdated EQ 1>
											PhysicalZipCode = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressZipCode)#" cfsqltype="cf_sql_varchar"> ,
										</cfif>

										<cfif UpdateInfo.VoiceNumberUpdated EQ 1>
											PrimaryVoiceNumber = <cfqueryparam value="#Trim(Form.PrimaryVoiceNumber)#" cfsqltype="cf_sql_varchar"> ,
										</cfif>

										<cfif UpdateInfo.WebsiteUpdated EQ 1>
											BusinessWebsite = <cfqueryparam value="#Trim(Form.BusinessWebsite)#" cfsqltype="cf_sql_varchar"> ,
										</cfif>

										<cfif UpdateInfo.ContactNameUpdated EQ 1>
											ContactName = <cfqueryparam value="#Trim(Form.ContactName)#" cfsqltype="cf_sql_varchar"> ,
										</cfif>

										<cfif UpdateInfo.ContactPhoneUpdated EQ 1>
											ContactPhoneNumber = <cfqueryparam value="#Trim(Form.ContactPhoneNumber)#" cfsqltype="cf_sql_varchar"> ,
										</cfif>

										<cfif UpdateInfo.ContactEmailUpdated EQ 1>
											ContactEmail = <cfqueryparam value="#Trim(Form.ContactEmail)#" cfsqltype="cf_sql_varchar"> ,
										</cfif>

										<cfif UpdateInfo.FacilityType EQ 1>
											FacilityType = <cfqueryparam value="#Trim(Form.FacilityType)#" cfsqltype="cf_sql_varchar"> ,
										</cfif>

										 lastUpdated = #Now()#, lastUpdateBy = <cfqueryparam value="#rc.$.currentUser('userName')#" cfsqltype="cf_sql_varchar">
									Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#getSelectedFacility.TContent_ID#" cfsqltype="cf_sql_integer">
								</cfquery>

								<cfif AddressGeoCoded[1].ErrorMessage EQ "OK">
									<cfquery name="updateFacilityAddress" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update eFacility
										Set GeoCode_Latitude = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressLatitude)#" cfsqltype="cf_sql_varchar">,
											GeoCode_Longitude = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressLongitude)#" cfsqltype="cf_sql_varchar">,
											GeoCode_Township = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressTownshipNameLong)#" cfsqltype="cf_sql_varchar">,
											GeoCode_StateLongName = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressStateNameLong)#" cfsqltype="cf_sql_varchar">,
											GeoCode_CountryShortName = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressCountryNameShort)#" cfsqltype="cf_sql_varchar">,
											isAddressVerified = <cfqueryparam value="1" cfsqltype="cf_sql_varchar">,
											PhysicalLocationCountry = <cfqueryparam value="#Trim(AddressGeoCoded[1].AddressCountryNameLong)#" cfsqltype="cf_sql_varchar">
										Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#getSelectedFacility.TContent_ID#" cfsqltype="cf_sql_integer">
									</cfquery>
								</cfif>
								<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:facilities&UserAction=UpdatedFacility&SiteID=#rc.$.siteConfig('siteID')#&Successful=true" addtoken="false">
							</cfif>

							<cfquery name="updateFacilityActive" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update eFacility
								Set Active = <cfqueryparam value="#FORM.Active#" cfsqltype="cf_sql_bit">,
								lastUpdated = #Now()#, lastUpdateBy = <cfqueryparam value="#rc.$.currentUser('userName')#" cfsqltype="cf_sql_varchar">
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#getSelectedFacility.TContent_ID#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:facilities" addtoken="false">
						</cfif>
					</cfcase>
					<cfcase value="Delete">
					</cfcase>
				</cfswitch>
			</cfif>
		<cfelseif isDefined("FORM.formSubmit") and isDefined("FORM.ReSubmit")>
			<cfif isDefined("URL.PerformAction")>
				<cfswitch expression="#URL.PerformAction#">
					<cfcase value="ReEnterAddress">
						<cflock timeout="60" scope="SESSION" type="Exclusive">
							<cfset Session.FormData = #StructCopy(FORM)#>
							<cfset Session.UserSuppliedInfo = StructNew()>
							<cfset Session.UserSuppliedInfo.NewRecNo = #URL.RecNo#>
							<cfset Session.UserSuppliedInfo.FacilityName = #FORM.FacilityName#>
							<cfset Session.UserSuppliedInfo.PhysicalAddress = #FORM.PhysicalAddress#>
							<cfset Session.UserSuppliedInfo.PhysicalCity = #FORM.PhysicalCity#>
							<cfset Session.UserSuppliedInfo.PhysicalState = #FORM.PhysicalState#>
							<cfset Session.UserSuppliedInfo.PhysicalZipCode = #FORM.PhysicalZipCode#>
							<cfset Session.UserSuppliedInfo.PrimaryVoiceNumber = #FORM.PrimaryVoiceNumber#>
							<cfset Session.UserSuppliedInfo.BusinessWebsite = #FORM.BusinessWebsite#>
							<cfset Session.UserSuppliedInfo.FacilityType = #FORM.FacilityType#>
							<cfset Session.UserSuppliedInfo.ContactName = #FORM.ContactName#>
							<cfset Session.UserSuppliedInfo.ContactPhoneNumber = #FORM.ContactPhoneNumber#>
							<cfset Session.UserSuppliedInfo.ContactEmail = #FORM.ContactEmail#>
						</cflock>
						<cfset UpdateInfo = #StructNew()#>
						<cfquery name="getSelectedFacility" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, dateCreated, lastUpdated, lastUpdateBy, isAddressVerified, GeoCode_Latitude, GeoCode_Longitude, GeoCode_Township, GeoCode_StateLongName, GeoCode_CountryShortName, GeoCode_Neighborhood, USPS_CarrierRoute, USPS_CheckDigit, USPS_DeliveryPoint, PhysicalLocationCountry, PhysicalCountry, FacilityType
							From eFacility
							Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#URL.RecNo#" cfsqltype="cf_sql_integer">
							Order by FacilityName ASC
						</cfquery>

						<cfparam name="UpdateInfo.NameUpdated" type="boolean" default="0">
						<cfparam name="UpdateInfo.AddressUpdated" type="boolean" default="0">
						<cfparam name="UpdateInfo.CityUpdated" type="boolean" default="0">
						<cfparam name="UpdateInfo.StateUpdated" type="boolean" default="0">
						<cfparam name="UpdateInfo.ZipCodeUpdated" type="boolean" default="0">
						<cfparam name="UpdateInfo.VoiceNumberUpdated" type="boolean" default="0">
						<cfparam name="UpdateInfo.WebsiteUpdated" type="boolean" default="0">
						<cfparam name="UpdateInfo.ContactNameUpdated" type="boolean" default="0">
						<cfparam name="UpdateInfo.ContactPhoneUpdated" type="boolean" default="0">
						<cfparam name="UpdateInfo.ContactEmailUpdated" type="boolean" default="0">

						<cfif getSelectedFacility.FacilityName NEQ Form.FacilityName><cfset UpdateInfo.NameUpdated = 1></cfif>
						<cfif getSelectedFacility.PrimaryVoiceNumber NEQ Form.PrimaryVoiceNumber><cfset UpdateInfo.VoiceNumberUpdated = 1></cfif>
						<cfif getSelectedFacility.BusinessWebsite NEQ Form.BusinessWebsite><cfset UpdateInfo.WebsiteUpdated = 1></cfif>
						<cfif getSelectedFacility.ContactName NEQ Form.ContactName><cfset UpdateInfo.ContactNameUpdated = 1></cfif>
						<cfif getSelectedFacility.ContactPhoneNumber NEQ Form.ContactPhoneNumber><cfset UpdateInfo.ContactPhoneUpdated = 1></cfif>
						<cfif getSelectedFacility.ContactEmail NEQ Form.ContactEmail><cfset UpdateInfo.ContactEmailUpdated = 1></cfif>

						<cfset AddressGeoCoded = #GeoCodeAddress(Form.PhysicalAddress, FORM.PhysicalCity, FORM.PhysicalState, FORM.PhysicalZipCode)#>
						<cfif AddressGeoCoded[1].ErrorMessage NEQ "OK">
							<cflock timeout="60" scope="SESSION" type="Exclusive">
								<cfscript>
									address = {property="BusinessAddress",message="#Variables.AddressGeoCoded[1].ErrorMessageText#"};
									arrayAppend(Session.FormErrors, address);
								</cfscript>
							</cflock>
							<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:facilities.updatefacility&PerformAction=ReEnterAddress&SiteID=#rc.$.siteConfig('siteID')#&RecNo=#getSelectedFacility.TContent_ID#" addtoken="false">
						<cfelse>
							<cfset CombinedPhysicalAddress = #AddressGeoCoded[1].AddressStreetNumber# & " " & #AddressGeoCoded[1].AddressStreetNameShort#>
							<cfif Compare(getSelectedFacility.PhysicalAddress, Variables.CombinedPhysicalAddress) NEQ 0><cfset UpdateInfo.AddressUpdated = 1></cfif>
							<cfif getSelectedFacility.PhysicalCity NEQ AddressGeoCoded[1].AddressCityName><cfset UpdateInfo.CityUpdated = 1></cfif>
							<cfif getSelectedFacility.PhysicalState NEQ AddressGeoCoded[1].AddressStateNameShort><cfset UpdateInfo.StateUpdated = 1></cfif>
							<cfif getSelectedFacility.PhysicalZipCode NEQ AddressGeoCoded[1].AddressZipCode><cfset UpdateInfo.ZipCodeUpdated = 1></cfif>

							<cfif UpdateInfo.NameUpdated EQ 1 OR UpdateInfo.AddressUpdated EQ 1 OR UpdateInfo.CityUpdated EQ 1 OR UpdateInfo.StateUpdated EQ 1 OR UpdateInfo.ZipCodeUpdated EQ 1 OR UpdateInfo.VoiceNumberUpdated EQ 1 OR UpdateInfo.WebsiteUpdated EQ 1 OR UpdateInfo.ContactNameUpdated EQ 1 OR UpdateInfo.ContactPhoneUpdated EQ 1 OR UpdateInfo.ContactEmailUpdated EQ 1>
								<cfquery name="updateFacilityAddress" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update eFacility
									Set
										<cfif UpdateInfo.NameUpdated EQ 1>
											FacilityName = <cfqueryparam value="#Trim(Form.FacilityName)#" cfsqltype="cf_sql_varchar">
											<cfif UpdateInfo.AddressUpdated EQ 1 OR UpdateInfo.CityUpdated EQ 1 OR UpdateInfo.StateUpdated EQ 1 OR UpdateInfo.ZipCodeUpdated EQ 1 OR UpdateInfo.VoiceNumberUpdated EQ 1 OR UpdateInfo.WebsiteUpdated EQ 1 OR UpdateInfo.ContactNameUpdated EQ 1 OR UpdateInfo.ContactPhoneUpdated EQ 1 OR UpdateInfo.ContactEmailUpdated EQ 1>
												,
											</cfif>
										</cfif>

										<cfif UpdateInfo.AddressUpdated EQ 1>
											PhysicalAddress = <cfqueryparam value="#Trim(Variables.CombinedPhysicalAddress)#" cfsqltype="cf_sql_varchar">
											<cfif UpdateInfo.CityUpdated EQ 1 OR UpdateInfo.StateUpdated EQ 1 OR UpdateInfo.ZipCodeUpdated EQ 1 OR UpdateInfo.VoiceNumberUpdated EQ 1 OR UpdateInfo.WebsiteUpdated EQ 1 OR UpdateInfo.ContactNameUpdated EQ 1 OR UpdateInfo.ContactPhoneUpdated EQ 1 OR UpdateInfo.ContactEmailUpdated EQ 1>
												,
											</cfif>
										</cfif>

										<cfif UpdateInfo.CityUpdated EQ 1>
											PhysicalCity = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressCityName)#" cfsqltype="cf_sql_varchar">
											<cfif UpdateInfo.StateUpdated EQ 1 OR UpdateInfo.ZipCodeUpdated EQ 1 OR UpdateInfo.VoiceNumberUpdated EQ 1 OR UpdateInfo.WebsiteUpdated EQ 1 OR UpdateInfo.ContactNameUpdated EQ 1 OR UpdateInfo.ContactPhoneUpdated EQ 1 OR UpdateInfo.ContactEmailUpdated EQ 1>
												,
											</cfif>
										</cfif>

										<cfif UpdateInfo.StateUpdated EQ 1>
											PhysicalState = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressStateNameShort)#" cfsqltype="cf_sql_varchar">
											<cfif UpdateInfo.ZipCodeUpdated EQ 1 OR UpdateInfo.VoiceNumberUpdated EQ 1 OR UpdateInfo.WebsiteUpdated EQ 1 OR UpdateInfo.ContactNameUpdated EQ 1 OR UpdateInfo.ContactPhoneUpdated EQ 1 OR UpdateInfo.ContactEmailUpdated EQ 1>
												,
											</cfif>
										</cfif>

										<cfif UpdateInfo.ZipCodeUpdated EQ 1>
											PhysicalZipCode = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressZipCode)#" cfsqltype="cf_sql_varchar">
											<cfif UpdateInfo.VoiceNumberUpdated EQ 1 OR UpdateInfo.WebsiteUpdated EQ 1 OR UpdateInfo.ContactNameUpdated EQ 1 OR UpdateInfo.ContactPhoneUpdated EQ 1 OR UpdateInfo.ContactEmailUpdated EQ 1>
												,
											</cfif>
										</cfif>

										<cfif UpdateInfo.VoiceNumberUpdated EQ 1>
											PrimaryVoiceNumber = <cfqueryparam value="#Trim(Form.PrimaryVoiceNumber)#" cfsqltype="cf_sql_varchar">
											<cfif UpdateInfo.WebsiteUpdated EQ 1 OR UpdateInfo.ContactNameUpdated EQ 1 OR UpdateInfo.ContactPhoneUpdated EQ 1 OR UpdateInfo.ContactEmailUpdated EQ 1>
												,
											</cfif>
										</cfif>

										<cfif UpdateInfo.WebsiteUpdated EQ 1>
											BusinessWebsite = <cfqueryparam value="#Trim(Form.BusinessWebsite)#" cfsqltype="cf_sql_varchar">
											<cfif UpdateInfo.ContactNameUpdated EQ 1 OR UpdateInfo.ContactPhoneUpdated EQ 1 OR UpdateInfo.ContactEmailUpdated EQ 1>
												,
											</cfif>
										</cfif>

										<cfif UpdateInfo.ContactNameUpdated EQ 1>
											ContactName = <cfqueryparam value="#Trim(Form.ContactName)#" cfsqltype="cf_sql_varchar">
											<cfif UpdateInfo.ContactPhoneUpdated EQ 1 OR UpdateInfo.ContactEmailUpdated EQ 1>
												,
											</cfif>
										</cfif>

										<cfif UpdateInfo.ContactPhoneUpdated EQ 1>
											ContactPhoneNumber = <cfqueryparam value="#Trim(Form.ContactPhoneNumber)#" cfsqltype="cf_sql_varchar">
											<cfif UpdateInfo.ContactEmailUpdated EQ 1>
												,
											</cfif>
										</cfif>

										<cfif UpdateInfo.ContactEmailUpdated EQ 1>
											ContactEmail = <cfqueryparam value="#Trim(Form.ContactEmail)#" cfsqltype="cf_sql_varchar">
										</cfif>

										, lastUpdated = #Now()#, lastUpdateBy = <cfqueryparam value="#rc.$.currentUser('userName')#" cfsqltype="cf_sql_varchar">
									Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#getSelectedFacility.TContent_ID#" cfsqltype="cf_sql_integer">
								</cfquery>

								<cfif AddressGeoCoded[1].ErrorMessage EQ "OK">
									<cfquery name="updateFacilityAddress" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update eFacility
										Set GeoCode_Latitude = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressLatitude)#" cfsqltype="cf_sql_varchar">,
											GeoCode_Longitude = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressLongitude)#" cfsqltype="cf_sql_varchar">,
											GeoCode_Township = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressTownshipNameLong)#" cfsqltype="cf_sql_varchar">,
											GeoCode_StateLongName = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressStateNameLong)#" cfsqltype="cf_sql_varchar">,
											GeoCode_CountryShortName = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressCountryNameShort)#" cfsqltype="cf_sql_varchar">,
											isAddressVerified = <cfqueryparam value="1" cfsqltype="cf_sql_varchar">,
											PhysicalLocationCountry = <cfqueryparam value="#Trim(AddressGeoCoded[1].AddressCountryNameLong)#" cfsqltype="cf_sql_varchar">
										Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#getSelectedFacility.TContent_ID#" cfsqltype="cf_sql_integer">
									</cfquery>
								</cfif>
								<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:facilities&UserAction=UpdatedFacility&SiteID=#rc.$.siteConfig('siteID')#&Successful=true" addtoken="false">
							</cfif>
							<cfquery name="updateFacilityActive" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update eFacility
								Set Active = <cfqueryparam value="#FORM.Active#" cfsqltype="cf_sql_bit">,
								lastUpdated = #Now()#, lastUpdateBy = <cfqueryparam value="#rc.$.currentUser('userName')#" cfsqltype="cf_sql_varchar">
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#getSelectedFacility.TContent_ID#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:facilities" addtoken="false">
						</cfif>
					</cfcase>
				</cfswitch>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="managerooms" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfif isDefined("FORM.formSubmit")>
			<cfswitch expression="#URL.PerformAction#">
				<cfcase value="DeleteRoom">
					<cfif isDefined("FORM.DeleteConfirm")>
						<cfswitch expression="#FORM.DeleteConfirm#">
							<cfcase value="1">
								<cftry>
									<cfquery name="updateFacilityRoom" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update eFacilityRooms
										Set Active = <cfqueryparam value="0" cfsqltype="cf_sql_bit">,
											lastUpdated = #Now()#,
											lastUpdateBy = "#rc.$.currentUser('userName')#"
										Where Facility_ID = <cfqueryparam value="#FORM.FacilityID#" cfsqltype="cf_sql_integer"> and
											TContent_ID = <cfqueryparam value="#FORM.FacilityRoomID#" cfsqltype="cf_sql_integer">
									</cfquery>
									<cfcatch type="any">
										<cfset Session.ApplicationError = #cfcatch#>
										<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:facilities&UserAction=ErrorDatabase&SiteID=#rc.$.siteConfig('siteID')#&FacilityID=#Form.FacilityID#&Successful=false" addtoken="false">
									</cfcatch>
								</cftry>
								<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:facilities.managerooms&RecNo=#URL.RecNo#&Successful=true&UserAction=DeletedFacilityRoom" addtoken="false">
							</cfcase>
							<cfdefaultcase>
								<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:facilities.managerooms&RecNo=#URL.RecNo#&Successful=false&UserAction=DeletedFacilityRoom" addtoken="false">
							</cfdefaultcase>
						</cfswitch>
					</cfif>
				</cfcase>
				<cfcase value="EditRoom">
					<cfif not isNumeric(FORM.RoomCapacity)>
						<cfset Temp = #StructNew()#>
						<cfset Temp.property = "RoomCapacity">
						<cfset Temp.message = "The value in Room Capacity must be numeric">
						<cfset #ArrayAppend(Session.FormErrors, Temp)#>
					</cfif>
					<cfif not isNumeric(Val(FORM.RoomFees))>
						<cfset Temp = #StructNew()#>
						<cfset Temp.property = "RoomFees">
						<cfset Temp.message = "The value in Room Fees must be numeric">
						<cfset #ArrayAppend(Session.FormErrors, Temp)#>
					</cfif>
					<cfif isDefined("Variables.Temp")>
						<cfset Session.FormData.SiteID = #FORM.SiteID#>
						<cfset Session.FormData.FacilityID = #FORM.FacilityID#>
						<cfset Session.FormData.RoomName = #FORM.RoomName#>
						<cfset Session.FormData.RoomCapacity = #FORM.RoomCapacity#>
						<cfset Session.FormData.RoomFees = #FORM.RoomFees#>
						<cfset Session.FormData.Active = #FORM.Active#>
						<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:facilities.managerooms&PerformAction=CorrectUpdateErrors&FacilityID=#URL.FacilityID#&RoomID=#URL.RoomID#" addtoken="false">
					</cfif>
					<cftry>
						<cfquery name="updateFacilityRoom" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eFacilityRooms
							Set RoomName = <cfqueryparam value="#Trim(FORM.RoomName)#" cfsqltype="cf_sql_varchar">,
								Capacity = <cfqueryparam value="#Trim(FORM.RoomCapacity)#" cfsqltype="cf_sql_varchar">,
								RoomFees = <cfqueryparam value="#NumberFormat(FORM.RoomFees, '9999.99')#" cfsqltype="cf_sql_money">,
								Active = <cfqueryparam value="#Trim(FORM.Active)#" cfsqltype="cf_sql_bit">,
								lastUpdated = #Now()#,
								lastUpdateBy = "#rc.$.currentUser('userName')#"
							Where Facility_ID = <cfqueryparam value="#FORM.FacilityID#" cfsqltype="cf_sql_integer"> and
								TContent_ID = <cfqueryparam value="#FORM.FacilityRoomID#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfcatch type="any">
							<cfset Session.ApplicationError = #cfcatch#>
							<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:facilities&UserAction=ErrorDatabase&SiteID=#rc.$.siteConfig('siteID')#&FacilityID=#Form.FacilityID#&Successful=false" addtoken="false">
						</cfcatch>
					</cftry>
					<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:facilities.managerooms&RecNo=#URL.RecNo#&Successful=true&UserAction=UpdatedFacilityRoom" addtoken="false">
				</cfcase>
				<cfcase value="AddRoom">
					<cfif not isNumeric(FORM.RoomCapacity)>
						<cfset Temp = #StructNew()#>
						<cfset Temp.property = "RoomCapacity">
						<cfset Temp.message = "The value in Room Capacity must be numeric">
						<cfset #ArrayAppend(Session.FormErrors, Temp)#>
					</cfif>
					<cfif not isNumeric(Val(FORM.RoomFees))>
						<cfset Temp = #StructNew()#>
						<cfset Temp.property = "RoomFees">
						<cfset Temp.message = "The value in Room Fees must be numeric">
						<cfset #ArrayAppend(Session.FormErrors, Temp)#>
					</cfif>
					<cfif isDefined("Variables.Temp")>
						<cfset Session.FormData.SiteID = #FORM.SiteID#>
						<cfset Session.FormData.FacilityID = #FORM.FacilityID#>
						<cfset Session.FormData.RoomName = #FORM.RoomName#>
						<cfset Session.FormData.RoomCapacity = #FORM.RoomCapacity#>
						<cfset Session.FormData.RoomFees = #FORM.RoomFees#>
						<cfset Session.FormData.Active = #FORM.Active#>
						<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:facilities.managerooms&PerformAction=CorrectErrors&FacilityID=#URL.FacilityID#" addtoken="false">
					</cfif>
					<cftry>
						<cfquery name="insertNewFacilityRoom" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Insert into eFacilityRooms(Site_ID, Facility_ID, RoomName, Capacity, RoomFees, Active, dateCreated, lastUpdated, lastUpdateBy)
							Values('#FORM.SiteID#', #FORM.FacilityID#, '#FORM.RoomName#', #FORM.RoomCapacity#, '#NumberFormat(FORM.RoomFees, '9999.99')#', #FORM.Active#, #Now()#, #Now()#, "#rc.$.currentUser('userName')#")
						</cfquery>
						<cfcatch type="any">
							<cfset Session.ApplicationError = #cfcatch#>
							<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:facilities&UserAction=ErrorDatabase&SiteID=#rc.$.siteConfig('siteID')#&FacilityID=#Form.FacilityID#&Successful=false" addtoken="false">
						</cfcatch>
					</cftry>
					<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:facilities.managerooms&RecNo=#URL.RecNo#&Successful=true&UserAction=AddedFacilityRoom" addtoken="false">
				</cfcase>
				<cfcase value="CorrectErrors">
					<cfif not isNumeric(FORM.RoomCapacity)>
						<cfset Temp = #StructNew()#>
						<cfset Temp.property = "RoomCapacity">
						<cfset Temp.message = "The value in Room Capacity must be numeric">
						<cfset #ArrayAppend(Session.FormErrors, Temp)#>
					</cfif>
					<cfif not isNumeric(Val(FORM.RoomFees))>
						<cfset Temp = #StructNew()#>
						<cfset Temp.property = "RoomFees">
						<cfset Temp.message = "The value in Room Fees must be numeric">
						<cfset #ArrayAppend(Session.FormErrors, Temp)#>
					</cfif>
					<cfif isDefined("Variables.Temp")>
						<cfset Session.FormData.SiteID = #FORM.SiteID#>
						<cfset Session.FormData.FacilityID = #FORM.FacilityID#>
						<cfset Session.FormData.RoomName = #FORM.RoomName#>
						<cfset Session.FormData.RoomCapacity = #FORM.RoomCapacity#>
						<cfset Session.FormData.RoomFees = #FORM.RoomFees#>
						<cfset Session.FormData.Active = #FORM.Active#>
						<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:facilities.managerooms&PerformAction=CorrectErrors&SiteID=#rc.$.siteConfig('siteID')#&FacilityID=#Form.FacilityID#" addtoken="false">
					</cfif>
					<cftry>
						<cfquery name="insertNewFacilityRoom" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Insert into eFacilityRooms(Site_ID, Facility_ID, RoomName, Capacity, RoomFees, Active, dateCreated, lastUpdated, lastUpdateBy)
							Values('#FORM.SiteID#', #FORM.FacilityID#, '#FORM.RoomName#', #FORM.RoomCapacity#, '#NumberFormat(FORM.RoomFees, '9999.99')#', #FORM.Active#, #Now()#, #Now()#, "#rc.$.currentUser('userName')#")
						</cfquery>
						<cfcatch type="any">
							<cfset Session.ApplicationError = #cfcatch#>
							<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:facilities&UserAction=ErrorDatabase&Successful=false" addtoken="false">
						</cfcatch>
					</cftry>
					<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:facilities.managerooms&UserAction=AddedFacilityRoom&SiteID=#rc.$.siteConfig('siteID')#&FacilityID=#Form.FacilityID#&Successful=true" addtoken="false">
				</cfcase>

				<cfcase value="UpdateRoom">

				</cfcase>
				<cfcase value="CorrectUpdateErrors">
					<cfif not isNumeric(FORM.RoomCapacity)>
						<cfset Temp = #StructNew()#>
						<cfset Temp.property = "RoomCapacity">
						<cfset Temp.message = "The value in Room Capacity must be numeric">
						<cfset #ArrayAppend(Session.FormErrors, Temp)#>
					</cfif>
					<cfif not isNumeric(Val(FORM.RoomFees))>
						<cfset Temp = #StructNew()#>
						<cfset Temp.property = "RoomFees">
						<cfset Temp.message = "The value in Room Fees must be numeric">
						<cfset #ArrayAppend(Session.FormErrors, Temp)#>
					</cfif>
					<cfif isDefined("Variables.Temp")>
						<cfset Session.FormData.SiteID = #FORM.SiteID#>
						<cfset Session.FormData.FacilityID = #FORM.FacilityID#>
						<cfset Session.FormData.RoomName = #FORM.RoomName#>
						<cfset Session.FormData.RoomCapacity = #FORM.RoomCapacity#>
						<cfset Session.FormData.RoomFees = #FORM.RoomFees#>
						<cfset Session.FormData.Active = #FORM.Active#>
						<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:facilities.managerooms&PerformAction=CorrectUpdateErrors&FacilityID=#URL.FacilityID#&RoomID=#URL.RoomID#" addtoken="false">
					</cfif>
					<cftry>
						<cfquery name="updateFacilityRoom" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eFacilityRooms
							Set RoomName = <cfqueryparam value="#Trim(FORM.RoomName)#" cfsqltype="cf_sql_varchar">,
								Capacity = <cfqueryparam value="#Trim(FORM.RoomCapacity)#" cfsqltype="cf_sql_varchar">,
								RoomFees = <cfqueryparam value="#NumberFormat(FORM.RoomFees, '9999.99')#" cfsqltype="cf_sql_money">,
								Active = <cfqueryparam value="#Trim(FORM.Active)#" cfsqltype="cf_sql_bit">,
								lastUpdated = #Now()#,
								lastUpdateBy = "#rc.$.currentUser('userName')#"
							Where Facility_ID = <cfqueryparam value="#FORM.FacilityID#" cfsqltype="cf_sql_integer"> and
								TContent_ID = <cfqueryparam value="#FORM.RoomID#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfcatch type="any">
							<cfset Session.ApplicationError = #cfcatch#>
							<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:facilities&UserAction=ErrorDatabase&SiteID=#rc.$.siteConfig('siteID')#&FacilityID=#Form.FacilityID#&Successful=false" addtoken="false">
						</cfcatch>
					</cftry>
					<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:facilities.managerooms&PerformAction=Update&SiteID=#rc.$.siteConfig('siteID')#&FacilityID=#Form.FacilityID#&Successful=true" addtoken="false">
				</cfcase>

			</cfswitch>
		</cfif>
	</cffunction>
</cfcomponent>