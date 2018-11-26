<cfcomponent displayName="Google Geocoder Routine">
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
						<cfscript>
							GeoCodeResultStreetNumber = GeoCodeResultAddressComponent[1].XmlChildren;
							GeoCodeResultStreetName = GeoCodeResultAddressComponent[2].XmlChildren;
							GeoCodeResultCityName = GeoCodeResultAddressComponent[3].XmlChildren;
							GeoCodeResultTownshipName = GeoCodeResultAddressComponent[4].XmlChildren;
							GeoCodeResultCountyName = GeoCodeResultAddressComponent[4].XmlChildren;
							GeoCodeResultStateName = GeoCodeResultAddressComponent[5].XmlChildren;
							GeoCodeResultCountryName = GeoCodeResultAddressComponent[6].XmlChildren;
							GeoCodeResultZipCode = GeoCodeResultAddressComponent[7].XmlChildren;
							GeoCodeResultZipCodeSuffix = GeoCodeResultAddressComponent[8].XmlChildren;
							GeoCodeAddressLocation = GeoCodeResultGeometryComponent[1].XmlChildren;
							GeoCodeFormattedAddress = GeoCodeResultFormattedAddress[1].XmlText;
						</cfscript>

						<cfswitch expression="#ArrayLen(GeoCodeResultAddressComponent)#">
							<cfcase value="8">
								<cfset Temp.RawInformation = StructNew()>
								<cfset Temp.RawInformation.XMLDocument = #Variables.XMLDocument#>
								<cfset Temp.RawInformation.ResponseStatus = #Variables.GeoCodeResponseStatus#>
								<cfset Temp.RawInformation.GeoCodeResultFormattedAddressType = #Variables.GeoCodeResultFormattedAddressType#>
								<cfset Temp.RawInformation.GeoCodeResultFormattedAddress = #Variables.GeoCodeResultFormattedAddress#>
								<cfset Temp.RawInformation.GeoCodeResultAddressComponent = #Variables.GeoCodeResultAddressComponent#>
								<cfset Temp.RawInformation.GeoCodeResultGeometryComponent = #Variables.GeoCodeResultGeometryComponent#>
								<cfset Temp.ErrorMessage = #GeoCodeResponseStatus[1].XMLText#>
								<cfset Temp.AddressStreetNumber = #GeoCodeResultStreetNumber[1].XMLText#>
								<cfset Temp.AddressStreetNameLong = #GeoCodeResultStreetName[1].XMLText#>
								<cfset Temp.AddressStreetNameShort = #GeoCodeResultStreetName[2].XMLText#>
								<cfset Temp.AddressStreetNameType = #GeoCodeResultStreetName[3].XMLText#>
								<cfset Temp.AddressCityName = #GeoCodeResultCityName[1].XMLText#>
								<cfset Temp.AddressTownshipNameLong = #GeoCodeResultTownshipName[1].XMLText#>
								<cfset Temp.AddressTownshipNameShort = #GeoCodeResultTownshipName[1].XMLText#>
								<cfset Temp.AddressCountryNameLong = #GeoCodeResultCountryName[1].XMLText#>
								<cfset Temp.AddressCountryNameShort = #GeoCodeResultCountryName[2].XMLText#>
								<cfset Temp.AddressZipCode = #GeoCodeResultZipCode[1].XMLText#>
								<cfset Temp.AddressZipCodeFour = #GeoCodeResultZipCodeSuffix[1].XMLText#>
								<cfset Temp.AddressLocation = #GeoCodeAddressLocation[1].XMLChildren#>
								<cfset Temp.AddressLatitude = #Temp.AddressLocation[1].XMLText#>
								<cfset Temp.AddressLongitude = #Temp.AddressLocation[2].XMLText#>
								<cfset Temp.AddressCountyNameLong = #GeoCodeResultCountyName[1].XMLText#>
								<cfset Temp.AddressCountyNameShort = #GeoCodeResultCountyName[2].XMLText#>
								<cfset Temp.AddressStateNameLong = #GeoCodeResultStateName[1].XMLText#>
								<cfset Temp.AddressStateNameShort = #GeoCodeResultStateName[2].XMLText#>
								<cfset Temp.NeighborhoodNameLong = "">
								<cfset Temp.NeighborhoodNameShort = "">
								<cfset #arrayAppend(GeoCodeAddress, Temp)#>
								<cfreturn GeoCodeAddress>
							</cfcase>
							<cfdefaultcase>
								<cfset Temp.RawInformation = StructNew()>
								<cfset Temp.RawInformation.XMLDocument = #Variables.XMLDocument#>
								<cfset Temp.RawInformation.ResponseStatus = #Variables.GeoCodeResponseStatus#>
								<cfset Temp.RawInformation.GeoCodeResultFormattedAddressType = #Variables.GeoCodeResultFormattedAddressType#>
								<cfset Temp.RawInformation.GeoCodeResultFormattedAddress = #Variables.GeoCodeResultFormattedAddress#>
								<cfset Temp.RawInformation.GeoCodeResultAddressComponent = #Variables.GeoCodeResultAddressComponent#>
								<cfset Temp.RawInformation.GeoCodeResultGeometryComponent = #Variables.GeoCodeResultGeometryComponent#>
								<cfset Temp.ErrorMessage = #GeoCodeResponseStatus[1].XMLText#>
								<cfset Temp.AddressStreetNumber = #GeoCodeResultStreetNumber[1].XMLText#>
								<cfset Temp.AddressStreetNameLong = #GeoCodeResultStreetName[1].XMLText#>
								<cfset Temp.AddressStreetNameShort = #GeoCodeResultStreetName[2].XMLText#>
								<cfset Temp.AddressStreetNameType = #GeoCodeResultStreetName[3].XMLText#>
								<cfset Temp.AddressCityName = #GeoCodeResultCityName[1].XMLText#>
								<cfset Temp.AddressTownshipNameLong = #GeoCodeResultTownshipName[1].XMLText#>
								<cfset Temp.AddressTownshipNameShort = #GeoCodeResultTownshipName[1].XMLText#>
								<cfset Temp.AddressCountryNameLong = #GeoCodeResultCountryName[1].XMLText#>
								<cfset Temp.AddressCountryNameShort = #GeoCodeResultCountryName[2].XMLText#>
								<cfset Temp.AddressZipCode = #GeoCodeResultZipCode[1].XMLText#>
								<cfset Temp.AddressLocation = #GeoCodeAddressLocation[1].XMLChildren#>
								<cfset Temp.AddressLatitude = #Temp.AddressLocation[1].XMLText#>
								<cfset Temp.AddressLongitude = #Temp.AddressLocation[2].XMLText#>
								<cfset Temp.AddressCountyNameLong = #GeoCodeResultCountyName[1].XMLText#>
								<cfset Temp.AddressCountyNameShort = #GeoCodeResultCountyName[2].XMLText#>
								<cfset Temp.AddressStateNameLong = #GeoCodeResultStateName[1].XMLText#>
								<cfset Temp.AddressStateNameShort = #GeoCodeResultStateName[2].XMLText#>
								<cfset Temp.NeighborhoodNameLong = "">
								<cfset Temp.NeighborhoodNameShort = "">
								<cfset #arrayAppend(GeoCodeAddress, Temp)#>
								<cfreturn GeoCodeAddress>
							</cfdefaultcase>
						</cfswitch>


					</cfcase>
					<cfcase value="street_address">
						<cfswitch expression="#ArrayLen(GeoCodeResultAddressComponent)#">
							<cfcase value="10">
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
									GeoCodeResultZipCodeSuffix = GeoCodeResultAddressComponent[10].XmlChildren;
									GeoCodeAddressLocation = GeoCodeResultGeometryComponent[1].XmlChildren;
									GeoCodeFormattedAddress = GeoCodeResultFormattedAddress[1].XmlText;
								</cfscript>
								<cfset Temp.RawInformation = StructNew()>
								<cfset Temp.RawInformation.XMLDocument = #Variables.XMLDocument#>
								<cfset Temp.RawInformation.ResponseStatus = #Variables.GeoCodeResponseStatus#>
								<cfset Temp.RawInformation.GeoCodeResultFormattedAddressType = #Variables.GeoCodeResultFormattedAddressType#>
								<cfset Temp.RawInformation.GeoCodeResultFormattedAddress = #Variables.GeoCodeResultFormattedAddress#>
								<cfset Temp.RawInformation.GeoCodeResultAddressComponent = #Variables.GeoCodeResultAddressComponent#>
								<cfset Temp.RawInformation.GeoCodeResultGeometryComponent = #Variables.GeoCodeResultGeometryComponent#>
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
								<cfset Temp.AddressZipCodeFour = #GeoCodeResultZipCodeSuffix[1].XMLText#>
								<cfset Temp.AddressLocation = #GeoCodeAddressLocation[1].XMLChildren#>
								<cfset Temp.AddressLatitude = #Temp.AddressLocation[1].XMLText#>
								<cfset Temp.AddressLongitude = #Temp.AddressLocation[2].XMLText#>
								<cfset Temp.AddressTownshipNameLong = #GeoCodeResultTownshipName[1].XMLText#>
								<cfset Temp.AddressTownshipNameShort = #GeoCodeResultTownshipName[1].XMLText#>
								<cfset Temp.NeighborhoodNameLong = #GeoCodeResultNeighborhoodName[1].XMLText#>
								<cfset Temp.NeighborhoodNameShort = #GeoCodeResultNeighborhoodName[2].XMLText#>
								<cfset #arrayAppend(GeoCodeAddress, Temp)#>
							</cfcase>
							<cfcase value="9">
								<!--- Address Example: 56535 Magnetic Drive, Mishwaka, IN 46545 --->
								<!--- Address Example: 2307 Edison Road, South Bend, IN 46615 --->
								<cfscript>
									GeoCodeResultStreetNumber = GeoCodeResultAddressComponent[1].XmlChildren;
									GeoCodeResultStreetName = GeoCodeResultAddressComponent[2].XmlChildren;
									GeoCodeResultCityName = GeoCodeResultAddressComponent[3].XmlChildren;
									GeoCodeResultTownshipName = GeoCodeResultAddressComponent[4].XmlChildren;
									GeoCodeResultCountyName = GeoCodeResultAddressComponent[5].XmlChildren;
									GeoCodeResultStateName = GeoCodeResultAddressComponent[6].XmlChildren;
									GeoCodeResultCountryName = GeoCodeResultAddressComponent[7].XmlChildren;
									GeoCodeResultZipCode = GeoCodeResultAddressComponent[8].XmlChildren;
									GeoCodeResultZipCodeSuffix = GeoCodeResultAddressComponent[9].XmlChildren;
									GeoCodeAddressLocation = GeoCodeResultGeometryComponent[1].XmlChildren;
									GeoCodeFormattedAddress = GeoCodeResultFormattedAddress[1].XmlText;
								</cfscript>

								<cfset Temp.RawInformation = StructNew()>
								<cfset Temp.RawInformation.XMLDocument = #Variables.XMLDocument#>
								<cfset Temp.RawInformation.ResponseStatus = #Variables.GeoCodeResponseStatus#>
								<cfset Temp.RawInformation.GeoCodeResultFormattedAddressType = #Variables.GeoCodeResultFormattedAddressType#>
								<cfset Temp.RawInformation.GeoCodeResultFormattedAddress = #Variables.GeoCodeResultFormattedAddress#>
								<cfset Temp.RawInformation.GeoCodeResultAddressComponent = #Variables.GeoCodeResultAddressComponent#>
								<cfset Temp.RawInformation.GeoCodeResultGeometryComponent = #Variables.GeoCodeResultGeometryComponent#>
								<cfset Temp.ErrorMessage = #GeoCodeResponseStatus[1].XMLText#>
								<cfset Temp.AddressStreetNumber = #GeoCodeResultStreetNumber[1].XMLText#>
								<cfset Temp.AddressStreetNameLong = #GeoCodeResultStreetName[1].XMLText#>
								<cfset Temp.AddressStreetNameShort = #GeoCodeResultStreetName[2].XMLText#>
								<cfset Temp.AddressStreetNameType = #GeoCodeResultStreetName[3].XMLText#>
								<cfset Temp.AddressCityName = #GeoCodeResultCityName[1].XMLText#>
								<cfset Temp.AddressTownshipNameLong = #GeoCodeResultTownshipName[1].XMLText#>
								<cfset Temp.AddressTownshipNameShort = #GeoCodeResultTownshipName[2].XMLText#>
								<cfset Temp.AddressCountyNameLong = #GeoCodeResultCountyName[1].XMLText#>
								<cfset Temp.AddressCountyNameShort = #GeoCodeResultCountyName[2].XMLText#>
								<cfset Temp.AddressStateNameLong = #GeoCodeResultStateName[1].XMLText#>
								<cfset Temp.AddressStateNameShort = #GeoCodeResultStateName[2].XMLText#>
								<cfset Temp.AddressCountryNameLong = #GeoCodeResultCountryName[1].XMLText#>
								<cfset Temp.AddressCountryNameShort = #GeoCodeResultCountryName[2].XMLText#>
								<cfset Temp.AddressZipCode = #GeoCodeResultZipCode[1].XMLText#>
								<cfset Temp.AddressZipCodeFour = #GeoCodeResultZipCodeSuffix[1].XMLText#>
								<cfset Temp.AddressLocation = #GeoCodeAddressLocation[1].XMLChildren#>
								<cfset Temp.AddressLatitude = #Temp.AddressLocation[1].XMLText#>
								<cfset Temp.AddressLongitude = #Temp.AddressLocation[2].XMLText#>
								<cfset #arrayAppend(GeoCodeAddress, Temp)#>
							</cfcase>
							<cfcase value="8">
								<!--- Address Example: 410 N First St, Argos IN 46501 --->
								<cfscript>
									GeoCodeResultStreetNumber = GeoCodeResultAddressComponent[1].XmlChildren;
									GeoCodeResultStreetName = GeoCodeResultAddressComponent[2].XmlChildren;
									GeoCodeResultCityName = GeoCodeResultAddressComponent[3].XmlChildren;
									GeoCodeResultTownshipName = GeoCodeResultAddressComponent[4].XmlChildren;
									GeoCodeResultCountyName = GeoCodeResultAddressComponent[4].XmlChildren;
									GeoCodeResultStateName = GeoCodeResultAddressComponent[5].XmlChildren;
									GeoCodeResultCountryName = GeoCodeResultAddressComponent[6].XmlChildren;
									GeoCodeResultZipCode = GeoCodeResultAddressComponent[7].XmlChildren;
									GeoCodeResultZipCodeSuffix = GeoCodeResultAddressComponent[8].XmlChildren;
									GeoCodeAddressLocation = GeoCodeResultGeometryComponent[1].XmlChildren;
									GeoCodeFormattedAddress = GeoCodeResultFormattedAddress[1].XmlText;
								</cfscript>
								<cfset Temp.RawInformation = StructNew()>
								<cfset Temp.RawInformation.XMLDocument = #Variables.XMLDocument#>
								<cfset Temp.RawInformation.ResponseStatus = #Variables.GeoCodeResponseStatus#>
								<cfset Temp.RawInformation.GeoCodeResultFormattedAddressType = #Variables.GeoCodeResultFormattedAddressType#>
								<cfset Temp.RawInformation.GeoCodeResultFormattedAddress = #Variables.GeoCodeResultFormattedAddress#>
								<cfset Temp.RawInformation.GeoCodeResultAddressComponent = #Variables.GeoCodeResultAddressComponent#>
								<cfset Temp.RawInformation.GeoCodeResultGeometryComponent = #Variables.GeoCodeResultGeometryComponent#>
								<cfset Temp.ErrorMessage = #GeoCodeResponseStatus[1].XMLText#>
								<cfset Temp.AddressStreetNumber = #GeoCodeResultStreetNumber[1].XMLText#>
								<cfset Temp.AddressStreetNameLong = #GeoCodeResultStreetName[1].XMLText#>
								<cfset Temp.AddressStreetNameShort = #GeoCodeResultStreetName[2].XMLText#>
								<cfset Temp.AddressStreetNameType = #GeoCodeResultStreetName[3].XMLText#>
								<cfset Temp.AddressCityName = #GeoCodeResultCityName[1].XMLText#>
								<cfset Temp.AddressTownshipNameLong = #GeoCodeResultTownshipName[1].XMLText#>
								<cfset Temp.AddressTownshipNameShort = #GeoCodeResultTownshipName[2].XMLText#>
								<cfset Temp.AddressCountyNameLong = #GeoCodeResultCountyName[1].XMLText#>
								<cfset Temp.AddressCountyNameShort = #GeoCodeResultCountyName[2].XMLText#>
								<cfset Temp.AddressStateNameLong = #GeoCodeResultStateName[1].XMLText#>
								<cfset Temp.AddressStateNameShort = #GeoCodeResultStateName[2].XMLText#>
								<cfset Temp.AddressCountryNameLong = #GeoCodeResultCountryName[1].XMLText#>
								<cfset Temp.AddressCountryNameShort = #GeoCodeResultCountryName[2].XMLText#>
								<cfset Temp.AddressZipCode = #GeoCodeResultZipCode[1].XMLText#>
								<cfset Temp.AddressZipCodeFour = #GeoCodeResultZipCodeSuffix[1].XMLText#>
								<cfset Temp.AddressLocation = #GeoCodeAddressLocation[1].XMLChildren#>
								<cfset Temp.AddressLatitude = #Temp.AddressLocation[1].XMLText#>
								<cfset Temp.AddressLongitude = #Temp.AddressLocation[2].XMLText#>
								<cfset #arrayAppend(GeoCodeAddress, Temp)#>
							</cfcase>
							<cfdefaultcase>
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

								<cfset Temp.RawInformation = StructNew()>
								<cfset Temp.RawInformation.XMLDocument = #Variables.XMLDocument#>
								<cfset Temp.RawInformation.ResponseStatus = #Variables.GeoCodeResponseStatus#>
								<cfset Temp.RawInformation.GeoCodeResultFormattedAddressType = #Variables.GeoCodeResultFormattedAddressType#>
								<cfset Temp.RawInformation.GeoCodeResultFormattedAddress = #Variables.GeoCodeResultFormattedAddress#>
								<cfset Temp.RawInformation.GeoCodeResultAddressComponent = #Variables.GeoCodeResultAddressComponent#>
								<cfset Temp.RawInformation.GeoCodeResultGeometryComponent = #Variables.GeoCodeResultGeometryComponent#>
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
					<cfcase value="premise">
						<!--- Address Example: 29125 Co Rd 22, Elkhart, IN 46517, USA --->
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

						<cfset Temp.RawInformation = StructNew()>
						<cfset Temp.RawInformation.XMLDocument = #Variables.XMLDocument#>
						<cfset Temp.RawInformation.ResponseStatus = #Variables.GeoCodeResponseStatus#>
						<cfset Temp.RawInformation.GeoCodeResultFormattedAddressType = #Variables.GeoCodeResultFormattedAddressType#>
						<cfset Temp.RawInformation.GeoCodeResultFormattedAddress = #Variables.GeoCodeResultFormattedAddress#>
						<cfset Temp.RawInformation.GeoCodeResultAddressComponent = #Variables.GeoCodeResultAddressComponent#>
						<cfset Temp.RawInformation.GeoCodeResultGeometryComponent = #Variables.GeoCodeResultGeometryComponent#>
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
						<cfset Temp.AddressTownshipNameShort = #GeoCodeResultTownshipName[2].XMLText#>
						<cfset Temp.NeighborhoodNameLong = "">
						<cfset Temp.NeighborhoodNameShort = "">
						<cfset #arrayAppend(GeoCodeAddress, Temp)#>
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
</cfcomponent>