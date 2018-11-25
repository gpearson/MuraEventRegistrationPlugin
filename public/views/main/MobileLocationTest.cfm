<!--- 
		#HTMLEditFormat(rc.pc.getPackage())# = EventRegistration
		/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/images/NIESC_Logo.png
	--->

<cfset Facility_Lat = "41.6729735">	
<cfset Facility_Lon = "-86.1288432">
<cfset EventServicesComponent = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EventServices")>	

<cfoutput>
		<script src="/plugins/EventRegistration/public/views/main/js/geo-min.js" type="text/javascript" charset="utf-8"></script>
		<script>
			if(geo_position_js.init()){
				geo_position_js.getCurrentPosition(success_callback,error_callback,{enableHighAccuracy:true});
			} else{
				alert("Functionality not available");
			}
				
			function success_callback(p) {
				alert('lat='+p.coords.latitude.toFixed(7)+';lon='+p.coords.longitude.toFixed(7));
			}
				
			function error_callback(p) {
				alert('error='+p.message);
			}		
		</script>
		<cfdump var="#Variables#">
</cfoutput>

<!---
 Distance (10016 - 10011):
        #EventServicesComponent.GetLatitudeLongitudeProximity(
            Variables.Facility_Lat,
            Variables.Facility_Lon,
            Location10011.Latitude,
            Location10011.Longitude
            )#
        miles

 --->