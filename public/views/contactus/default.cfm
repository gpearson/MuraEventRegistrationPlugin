<cfoutput>
	<cfif isDefined("URL.SentInquiry")>
		<cfif URL.SentInquiry EQ "true">
			<div class="panel panel-default">
				<div class="panel-heading"><h1>Inquiry Form Submitted</h1></div>
				<div class="panel-body">
					<div class="alert alert-success">
						You have successfully submitted the inquiry regarding this website. Please allow 24 - 48 hours for an inquiry back as we might need to perform some research inorder to give you the best possible answer. We will contact you at the Best Contact Method listed on your inquiry
					</div>
				</div>
			</div>
		</cfif>
	</cfif>
</cfoutput>