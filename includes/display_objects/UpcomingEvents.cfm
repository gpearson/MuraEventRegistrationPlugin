<cfhttp url="http://events.niesc.k12.in.us/plugins/EventRegistration/library/components/EventServices.cfc?method=UpcomingEvents&DaysInFuture=21&SiteID=NIESCEvents">
<cfwddx action="wddx2cfml" input="#cfhttp.filecontent#" output="Results">
<cfloop query="Results">
	<ul>
		<li><cfoutput><A target="_blank" href="http://events.niesc.k12.in.us/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:events.eventinfo&EventID=#Results.TContent_ID#">#DateFormat(Results.EventDate, "mm-dd-yy")# - #Results.ShortTitle#</a></cfoutput></li>
	</ul>
</cfloop>