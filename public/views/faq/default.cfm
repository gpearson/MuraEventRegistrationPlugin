<cfoutput>
	<div class="panel-group" id="accordion">
		<div class="faqHeader"><h1>Have Questions, Get Answers</h1></div>
		<div class="panel panel-default">
			<div class="panel-heading"><h4 class="panel-title"><a class="accordion-toggle" data-toggle="collapse" data-parent="##accordion" href="##collapseOne">Is account registration required?</a></h4></div>
			<div id="collapseOne" class="panel-collapse collapse in">
				<div class="panel-body">Account registration is required to register for an event or workshop posted on this website. The account information is used to generate electronic communications, workshop certifications, or any other information the presenter would like you to be informed about.</div>
			</div>
		</div>
		<!---
		<div class="panel panel-default">
			<div class="panel-heading"><h4 class="panel-title"><a class="accordion-toggle" data-toggle="collapse" data-parent="##accordion" href="##collapseTwo">I won auction, Now What?</a></h4></div>
			<div id="collapseTwo" class="panel-collapse collapse in">
				<div class="panel-body">Once the auction has closed or a subscriber has used the Buy Now option, the user will receive an email message notifying them of the win. In this email will be a link to complete the payment process for this item. Upon a successfull payment process the user will receive the final email with a document attached. The subscriber will take this document and a government issued picture identification card to the pickup location to acquire the item. The information on the auction pickup document and the government issed picture identification card must match.</div>
			</div>
		</div>
		--->
	</div>
	<style>
		.faqHeader {
			font-size: 27px;
			margin: 20px;
		}

		.panel-heading [data-toggle="collapse"]:after {
			font-family: 'Glyphicons Halflings';
			content: "e072"; /* "play" icon */
			float: right;
			color: ##F58723;
			font-size: 18px;
			line-height: 22px;
			/* rotate "play" icon from > (right arrow) to down arrow */
			-webkit-transform: rotate(-90deg);
			-moz-transform: rotate(-90deg);
			-ms-transform: rotate(-90deg);
			-o-transform: rotate(-90deg);
			transform: rotate(-90deg);
		}

		.panel-heading [data-toggle="collapse"].collapsed:after {
			/* rotate "play" icon from > (right arrow) to ^ (up arrow) */
			-webkit-transform: rotate(90deg);
			-moz-transform: rotate(90deg);
			-ms-transform: rotate(90deg);
			-o-transform: rotate(90deg);
			transform: rotate(90deg);
			color: ##454444;
		}
	</style>
</cfoutput>